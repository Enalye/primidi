module primidi.midi.device;

import minuit;

private {
	__gshared MnOutput _midiOut;
	__gshared MnInput _midiIn;
}
import std.stdio;

void initializeMidiDevices() {
	_midiOut = new MnOutput;
	_midiIn = new MnInput;
}

void closeMidiDevices() {
    if(_midiOut)
        _midiOut.close();
	_midiOut = null;

    if(_midiIn)
        _midiIn.close();
	_midiIn = null;
}

void selectMidiOutDevice(MnOutputPort port) {
    if(!_midiOut)
        return;
    _midiOut.close();
    _midiOut.port = port;
    if(port)
        _midiOut.open(port);
}

void selectMidiInDevice(MnInputPort port) {
    if(!_midiIn)
        return;
    _midiIn.close();
    _midiIn.port = port;
    if(port)
        _midiIn.open();
}

MnOutput getMidiOut() {
	return _midiOut;
}

MnInput getMidiIn() {
	return _midiIn;
}