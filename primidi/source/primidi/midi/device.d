/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
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
    if(!_midiOut || !port)
        return;
    _midiOut.close();
    _midiOut.port = port;
    if(port)
        _midiOut.open(port);

    import primidi.config: saveConfig;
    saveConfig();
}

void selectMidiInDevice(MnInputPort port) {
    if(!_midiIn || !port)
        return;
    _midiIn.close();
    _midiIn.port = port;
    if(port)
        _midiIn.open();

    import primidi.config: saveConfig;
    saveConfig();
}

MnOutput getMidiOut() {
	return _midiOut;
}

MnInput getMidiIn() {
	return _midiIn;
}