module primidi.player.player;

import atelier, minuit;
import primidi.midi;

private {
    MidiFile _midiFile;
    bool _isMidiFilePlaying;
    string _midiFilePath;
}

void startMidi() {
    initMidiClock();
    startMidiClock();
    setupInternalSequencer();
    startInternalSequencer();
}

void playMidi(string path) {
    _midiFilePath = path;
    stopMidiClock();
    _midiFile = new MidiFile(path);
    stopMidiOutSequencer();
    stopInternalSequencer();
    setupInternalSequencer();
    playInternalSequencer(_midiFile);
    setupMidiOutSequencer(_midiFile);
    startMidiOutSequencer();
    startInternalSequencer();
    startMidiClock();
    _isMidiFilePlaying = true;
}

void stopMidi() {
    stopMidiClock();
	stopMidiOutSequencer();
    _isMidiFilePlaying = false;
}

bool isMidiPlaying() {
    return _isMidiFilePlaying;
}

string getMidiFilePath() {
    return _midiFilePath;
}

void setMidiPosition(long position) {
    //All notes off.
    MnOutput midiOut = getMidiOut();
    foreach(ubyte c; 0 .. 16) {
        midiOut.send(0xB0 | c, 0x7B, 0x0);
    }
    if(position < getMidiTime())
        rewindMidi();
    setMidiTime(position);
}

void rewindMidi() {
    if(!_midiFile)
        return;
    stopMidiClock();
    stopMidiOutSequencer();
    stopInternalSequencer();
    setupInternalSequencer();
    playInternalSequencer(_midiFile);
    setupMidiOutSequencer(_midiFile);
    startMidiOutSequencer();
    startInternalSequencer();
    startMidiClock();
}

void pauseMidi() {
    if(isMidiClockRunning())
        pauseMidiClock();
    else
        startMidiClock();
}

void updateMidi() {
    updateInternalSequencer();
}

double getMidiDuration() {
    if(!_midiFile)
        return 0;
    return _midiFile.duration;
}