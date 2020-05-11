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
    import primidi.config: saveConfig;
    if(!_midiOut)
        return;
    if(!port) {
        _midiOut.close();
        _midiOut.port = null;
        saveConfig();
        return;
    }
    _midiOut.close();
    _midiOut.port = port;
    if(port)
        _midiOut.open(port);
    saveConfig();
}

void selectMidiInDevice(MnInputPort port) {
    import primidi.config: saveConfig;
    if(!_midiIn)
        return;
    if(!port) {
        _midiIn.close();
        _midiIn.port = null;
        saveConfig();
        return;
    }
    _midiIn.close();
    _midiIn.port = port;
    if(port)
        _midiIn.open();
    saveConfig();
}

MnOutput getMidiOut() {
	return _midiOut;
}

MnInput getMidiIn() {
	return _midiIn;
}