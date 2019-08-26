/**
Primidi
Copyright (c) 2016 Enalye

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising
from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute
it freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented;
	   you must not claim that you wrote the original software.
	   If you use this software in a product, an acknowledgment
	   in the product documentation would be appreciated but
	   is not required.

	2. Altered source versions must be plainly marked as such,
	   and must not be misrepresented as being the original software.

	3. This notice may not be removed or altered from any source distribution.
*/

module primidi.midi.sequencer;

import std.stdio;
import std.file;
import std.algorithm;
import core.thread;

import derelict.sdl2.sdl;
import minuit;

import primidi.midi.file;
import primidi.midi.device;
import primidi.midi.clock;

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
	if(_midiSequencer)
		_midiSequencer.start();
}

void stopMidiOutSequencer() {
	if(_midiSequencer)
		_midiSequencer.isRunning = false;
}

private final class MidiSequencer: Thread {
	MidiEvent[] events;
	uint eventsTop;

	TempoEvent[] tempoEvents;
	uint tempoEventsTop;

	long ticksPerQuarter;
	long tickAtLastChange = -1000;
	double ticksElapsedSinceLastChange, tickPerMs, msPerTick, timeAtLastChange;

	shared bool isRunning;

	this(MidiFile midiFile) {
		speedFactor = 1f;
		initialBpm = 120;

		ticksPerQuarter = midiFile.ticksPerBeat;

		foreach(uint t; 0 .. cast(uint)midiFile.tracks.length) {
			foreach(MidiEvent event; midiFile.tracks[t]) {
				//Fill in the tempo track.
				if(event.subType == MidiEvents.Tempo) {
					//writeln("Tempo: ", event.type);
					TempoEvent tempoEvent;
					tempoEvent.tick = event.tick;
					tempoEvent.usPerQuarter = event.tempo.microsecondsPerBeat;
					tempoEvents ~= tempoEvent;
					continue;
				}

				if(event.type == 0xFF) {
					//if(event.text)
					//	writeln("Text: ", event.text);
					continue;
				}

				events ~= event;
			}
		}

		sort!(
			(a, b) => (a.tick == b.tick) ?
			(a.type != MidiEventType.NoteOn && b.type == MidiEventType.NoteOn) :
			(a.tick < b.tick)
			)(events);

		//Set initial time step (120 BPM).
		tickPerMs = (initialBpm * ticksPerQuarter * speedFactor) / 60000f;
		msPerTick = 60000f / (initialBpm * ticksPerQuarter * speedFactor);

		super(&run);
	}

	private void run() {
		try {
			auto midiOut = getMidiOut();

			//Set initial time step (120 BPM).
			tickAtLastChange = 0;
			tickPerMs = (initialBpm * ticksPerQuarter * speedFactor) / 60_000f;
			msPerTick = 60_000f / (initialBpm * ticksPerQuarter * speedFactor);
			timeAtLastChange = getMidiTime();

			isRunning = true;
					writeln("tempo: ", tempoEvents.length, ", ", tempoEventsTop);

			while(isRunning) {
				//Time handling.
				double currentTime = getMidiTime();
				double msDeltaTime = currentTime - timeAtLastChange; //The time since last tempo change.
				ticksElapsedSinceLastChange = msDeltaTime * tickPerMs;

				double totalTicksElapsed = tickAtLastChange + ticksElapsedSinceLastChange;

				if(tempoEvents.length > tempoEventsTop) {
					long tickThreshold = tempoEvents[tempoEventsTop].tick;
					if(totalTicksElapsed > tickThreshold) {
						long tickDelta = tickThreshold - tickAtLastChange;
						double finalDeltaTime = tickDelta * msPerTick;

						long usPerQuarter = tempoEvents[tempoEventsTop].usPerQuarter;
						tempoEventsTop ++;

						ticksElapsedSinceLastChange = 0;
						tickAtLastChange = tickThreshold;
						timeAtLastChange += finalDeltaTime;
						tickPerMs = (1000f * ticksPerQuarter * speedFactor) / usPerQuarter;
						msPerTick = usPerQuarter / (ticksPerQuarter * 1000f * speedFactor);
					}
				}
				
				//Events handling.
				checkTick: if(events.length > eventsTop) {
					uint tickThreshold = events[eventsTop].tick;
					if(totalTicksElapsed > tickThreshold) {
						MidiEvent ev = events[eventsTop];
						switch(ev.type) with(MidiEventType) {
							case SystemExclusive:
								midiOut.send(ev.data);
								break;
							case ProgramChange:
							case ChannelAfterTouch:
								midiOut.send(cast(ubyte)ev.type | cast(ubyte)ev.note.channel, cast(ubyte)ev.note.note);
								break;
							case PitchWheel:
							case ControlChange:
							case KeyAfterTouch:
							case NoteOn:
							case NoteOff:
								midiOut.send(cast(ubyte)ev.type | cast(ubyte)ev.note.channel, cast(ubyte)ev.note.note, cast(ubyte)ev.note.velocity);
								break;
							default:
								break;
						}

						eventsTop ++;

						if(isRunning)
							goto checkTick;
					}
				}
                Thread.sleep(dur!("msecs")(1));
			}

			//All notes off.
			foreach(ubyte c; 0 .. 16) {
				midiOut.send(0xB0 | c, 0x7B, 0x0);
			}
		}
		catch(Exception e) {
			import std.stdio: writeln;
			writeln(e.msg);
		}
	}
}