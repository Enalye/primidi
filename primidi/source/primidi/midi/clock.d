module primidi.midi.clock;

import std.datetime;
import std.datetime.stopwatch: StopWatch, AutoStart;

__gshared StopWatch midiClock;

void initMidiClock() {
    midiClock = StopWatch(AutoStart.no);
}

void startMidiClock() {
    midiClock.start();
}

void stopMidiClock() {
    midiClock.stop();
    midiClock.reset();
}

long getMidiTime() {
    return midiClock.peek.total!"msecs";
}