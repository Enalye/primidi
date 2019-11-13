module primidi.player.player;

import atelier, minuit;
import primidi.midi;

private {
    MidiFile _midiFile;
}

void startMidi() {
    initMidiClock();
    startMidiClock();
    setupInternalSequencer();
    startInternalSequencer();
}

void playMidi(string path) {
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
}

void stopMidi() {
    stopMidiClock();
	stopMidiOutSequencer();    
}

void setMidiPosition() {
    rewindMidi();
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