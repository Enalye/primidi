/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.player.player;

import std.path: baseName;
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
    initializeMidiState();
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
    if(_isMidiFilePlaying)
        notifyEndInternalSequencer();
    _isMidiFilePlaying = true;
    setWindowTitle("Primidi - " ~ baseName(_midiFilePath));
}

void replayMidi() {
    import std.file: exists;
    if(!exists(_midiFilePath))
        return;
    playMidi(_midiFilePath);
}

void stopMidi() {
	stopMidiOutSequencer();
    stopInternalSequencer();
    _midiFile = null;
    if(_isMidiFilePlaying)
        notifyEndInternalSequencer();
    _isMidiFilePlaying = false;
    setWindowTitle("Primidi");
    startMidi();
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
    bool wasClockRunning = isMidiClockRunning();
    stopMidiClock();
    stopMidiOutSequencer();
    stopInternalSequencer();
    setupInternalSequencer();
    playInternalSequencer(_midiFile);
    setupMidiOutSequencer(_midiFile);
    startMidiOutSequencer();
    startInternalSequencer();
    if(wasClockRunning)
        startMidiClock();
    if(_isMidiFilePlaying)
        notifyEndInternalSequencer();
}

void pauseMidi() {
    //All notes off.
    MnOutput midiOut = getMidiOut();
    if(midiOut && midiOut.isOpen) {
        foreach(ubyte c; 0 .. 16) {
            midiOut.send(0xB0 | c, 0x7B, 0x0);
        }
    }
    if(isMidiClockRunning())
        pauseMidiClock();
    else
        startMidiClock();
}

void updateMidi() {
    updateInternalSequencer();
    if(_isMidiFilePlaying) {
        if(getMidiTime() > getMidiDuration()) {
            setWindowTitle("Primidi");
            stopMidiOutSequencer();
            notifyEndInternalSequencer();
            _midiFile = null;
            _isMidiFilePlaying = false;
        }
    }
}

double getMidiDuration() {
    if(!_midiFile)
        return 0;
    return _midiFile.duration;
}