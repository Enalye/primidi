module primidi.player.player;

import atelier, minuit;
import primidi.midi;

void playMidi(string path) {
    auto midiFile = new MidiFile(path);
    stopMidiOutSequencer();
    setupInternalSequencer(midiFile);
    setupMidiOutSequencer(midiFile);
    startMidiOutSequencer();
    startInternalSequencer();
}

void stopMidi() {
	stopMidiOutSequencer();    
}

void pauseMidi() {

}

void updateMidi() {
    updateInternalSequencer();
}