module primidi.player.player;

import atelier, minuit;
import primidi.midi;

void startMidi() {
    initMidiClock();
    startMidiClock();
    setupInternalSequencer();
    startInternalSequencer();
}

void playMidi(string path) {
    auto midiFile = new MidiFile(path);
    stopMidiOutSequencer();
    stopInternalSequencer();
    setupInternalSequencer();
    playInternalSequencer(midiFile);
    setupMidiOutSequencer(midiFile);
    startMidiOutSequencer();
    startInternalSequencer();

}

void stopMidi() {
    stopMidiClock();
	stopMidiOutSequencer();    
}

void pauseMidi() {

}

void updateMidi() {
    updateInternalSequencer();
}