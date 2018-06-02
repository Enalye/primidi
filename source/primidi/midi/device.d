module primidi.midi.device;

import minuit;

private {
	__gshared MidiOut _midiOut;
}
import std.stdio;

void initializeMidiOut() {
	_midiOut = new MidiOut;
}

void destroyMidiOut() {
    if(_midiOut)
        _midiOut.close();
	_midiOut = null;
}

void selectMidiOutDevice(MidiOutDevice device) {
    if(!_midiOut)
        return;
    _midiOut.close();
    _midiOut.device = device;
    if(device)
        _midiOut.open();
}

MidiOut getMidiOut() {
	return _midiOut;
}