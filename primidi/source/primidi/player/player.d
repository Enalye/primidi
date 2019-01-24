module primidi.player.player;

import atelier, minuit;
import primidi.midi;

void playMidi(string path) {
    initMidiClock();

    auto midiFile = new MidiFile(path);
    stopMidiOutSequencer();
    setupInternalSequencer(midiFile);
    setupMidiOutSequencer(midiFile);
    startMidiOutSequencer();
    startInternalSequencer();

    startMidiClock();
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