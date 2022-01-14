/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.midi.sequencer;

import std.stdio;
import std.file;
import std.algorithm;
import core.thread;

import bindbc.sdl;
import minuit;

import primidi.midi.file;
import primidi.midi.device;
import primidi.midi.clock;
import primidi.midi.state;

auto speedFactor = 1f;
auto initialBpm = 120;

struct TempoEvent {
    uint tick, usPerQuarter;
}

private MidiSequencer _midiSequencer;

void setupMidiOutSequencer(MidiFile midiFile) {
    _midiSequencer = new MidiSequencer(midiFile);
}

void startMidiOutSequencer() {
    if (_midiSequencer)
        _midiSequencer.start();
}

void stopMidiOutSequencer() {
    if (_midiSequencer)
        _midiSequencer.isRunning = false;
}

private final class MidiSequencer : Thread {
    MidiEvent[] events;
    uint eventsTop;

    TempoEvent[] tempoEvents;
    uint tempoEventsTop;

    long ticksPerQuarter;
    long tickAtLastChange = -1000;
    double ticksElapsedSinceLastChange, tickPerMs, msPerTick, timeAtLastChange;

    shared bool isRunning;

    this(MidiFile midiFile) {
        initializeMidiState();
        speedFactor = 1f;
        initialBpm = 120;

        ticksPerQuarter = midiFile.ticksPerBeat;

        foreach (uint t; 0 .. cast(uint) midiFile.tracks.length) {
            foreach (MidiEvent event; midiFile.tracks[t]) {
                //Fill in the tempo track.
                if (event.subType == MidiEvents.Tempo) {
                    //writeln("Tempo: ", event.type);
                    TempoEvent tempoEvent;
                    tempoEvent.tick = event.tick;
                    tempoEvent.usPerQuarter = event.tempo.microsecondsPerBeat;
                    tempoEvents ~= tempoEvent;
                    continue;
                }

                if (event.type == 0xFF) {
                    //if(event.text)
                    //	writeln("Text: ", event.text);
                    continue;
                }
                events ~= event;
            }
        }

        sort!(
            (a, b) => (a.tick == b.tick) ?
                (a.type == MidiEventType.NoteOn && b.type == MidiEventType.NoteOff) : (
                    a.tick < b.tick),
                SwapStrategy.stable
        )(events);

        //Set initial time step (120 BPM).
        tickPerMs = (initialBpm * ticksPerQuarter * speedFactor) / 60_000f;
        msPerTick = 60_000f / (initialBpm * ticksPerQuarter * speedFactor);

        super(&run);
    }

    private void run() {
        try {
            auto midiOut = getMidiOut();

            //Set initial time step (120 BPM).
            tickAtLastChange = 0;
            tickPerMs = (initialBpm * ticksPerQuarter * speedFactor) / 60_000f;
            msPerTick = 60_000f / (initialBpm * ticksPerQuarter * speedFactor);
            timeAtLastChange = 0;
            MidiEvent[ubyte] skippedEvents;
            MidiEvent[] ccEvents;

            isRunning = true;
            while (isRunning) {
                //Time handling.
                double currentTime = getMidiTime();

            checkTempo:
                double msDeltaTime = currentTime - timeAtLastChange; //The time since last tempo change.
                ticksElapsedSinceLastChange = msDeltaTime * tickPerMs;

                double totalTicksElapsed = tickAtLastChange + ticksElapsedSinceLastChange;

                if (tempoEvents.length > tempoEventsTop) {
                    long tickThreshold = tempoEvents[tempoEventsTop].tick;
                    if (totalTicksElapsed > tickThreshold) {
                        long tickDelta = tickThreshold - tickAtLastChange;
                        double finalDeltaTime = tickDelta * msPerTick;

                        long usPerQuarter = tempoEvents[tempoEventsTop].usPerQuarter;
                        tempoEventsTop++;

                        ticksElapsedSinceLastChange = 0;
                        tickAtLastChange = tickThreshold;
                        timeAtLastChange += finalDeltaTime;
                        tickPerMs = (1000f * ticksPerQuarter * speedFactor) / usPerQuarter;
                        msPerTick = usPerQuarter / (ticksPerQuarter * 1000f * speedFactor);

                        if (isRunning)
                            goto checkTempo;
                    }
                }

                //Events handling.
            checkTick:
                if (events.length > eventsTop) {
                    uint tickThreshold = events[eventsTop].tick;
                    if (totalTicksElapsed > tickThreshold) {
                        MidiEvent ev = events[eventsTop];
                        if (totalTicksElapsed > (tickThreshold + 10)) {
                            switch (ev.type) with (MidiEventType) {
                            case SystemExclusive:
                                sendEvent(midiOut, ev);
                                break;
                            case ProgramChange:
                            case ChannelAfterTouch:
                            case PitchWheel:
                            case KeyAfterTouch:
                                skippedEvents[cast(ubyte) ev.type | cast(ubyte) ev.note.channel] = ev;
                                break;
                            case ControlChange:
                                if (ev.note.note < 32) {
                                    long i = (cast(long) ccEvents.length) - 1;
                                    while (i >= 0) {
                                        if (ccEvents[i].note.channel == ev.note.channel && (
                                                ccEvents[i].note.note == ev.note.note
                                                || ccEvents[i].note.note == (ev.note.note + 32))) {
                                            ccEvents = ccEvents.remove(i);
                                        }
                                        i--;
                                    }
                                }
                                ccEvents ~= ev;
                                break;
                            case NoteOn:
                            case NoteOff:
                                break;
                            default:
                                break;
                            }
                        }
                        else {
                            if (skippedEvents.length > 0 || ccEvents.length > 0) {
                                foreach (ccEvent; ccEvents) {
                                    sendEvent(midiOut, ccEvent);
                                }
                                foreach (skippedEvent; skippedEvents) {
                                    sendEvent(midiOut, skippedEvent);
                                }
                                ccEvents.length = 0;
                                skippedEvents.clear();
                            }
                            sendEvent(midiOut, ev);
                        }

                        eventsTop++;

                        if (isRunning)
                            goto checkTick;
                    }
                }

                Thread.sleep(dur!("msecs")(1));
            }

            //All notes off.
            foreach (ubyte c; 0 .. 16) {
                midiOut.send(0xB0 | c, 0x7B, 0x0);
            }
        }
        catch (Exception e) {
            import std.stdio : writeln;

            writeln(e.msg);
        }
    }

    private void sendEvent(MnOutput midiOut, MidiEvent ev) {
        switch (ev.type) with (MidiEventType) {
        case SystemExclusive:
            midiOut.send(ev.data);
            break;
        case ProgramChange:
        case ChannelAfterTouch:
            midiOut.send(cast(ubyte) ev.type | cast(ubyte) ev.note.channel, cast(ubyte) ev
                    .note.note);
            break;
        case PitchWheel:
            setPitchBend(ev.note.channel, ((ev.note.velocity & 0x7F) << 7) | (ev.note.note & 0x7F));
            goto case NoteOn;
        case ControlChange:
        case KeyAfterTouch:
            midiOut.send(cast(ubyte) ev.type | cast(ubyte) ev.note.channel, cast(ubyte) ev.note.note, cast(
                    ubyte) ev.note.velocity);
            break;
        case NoteOn:
        case NoteOff:
            midiOut.send(cast(ubyte) ev.type | cast(ubyte) ev.note.channel, cast(ubyte) ev.note.note, cast(
                    ubyte) ev.note.velocity);
            break;
        default:
            break;
        }
    }
}
