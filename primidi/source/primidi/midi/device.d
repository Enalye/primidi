module primidi.midi.device;

import minuit;

private {
	__gshared MnMidiOut _midiOut;
	__gshared MnMidiIn _midiIn;
}
import std.stdio;

void initializeMidiDevices() {
	_midiOut = new MnMidiOut;
	_midiIn = new MnMidiIn;
}

void closeMidiDevices() {
    if(_midiOut)
        _midiOut.close();
	_midiOut = null;

    if(_midiIn)
        _midiIn.close();
	_midiIn = null;
}

void selectMidiOutDevice(MnOutDevice device) {
    if(!_midiOut)
        return;
    _midiOut.close();
    _midiOut.device = device;
    if(device)
        _midiOut.open();
}

void selectMidiInDevice(MnInDevice device) {
    if(!_midiIn)
        return;
    _midiIn.close();
    _midiIn.device = device;
    if(device)
        _midiIn.open();
}

MnMidiOut getMidiOut() {
	return _midiOut;
}

MnMidiIn getMidiIn() {
	return _midiIn;
}