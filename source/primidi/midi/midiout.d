/**
Primidi
Copyright (c) 2016 Enalye

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising
from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute
it freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented;
	   you must not claim that you wrote the original software.
	   If you use this software in a product, an acknowledgment
	   in the product documentation would be appreciated but
	   is not required.

	2. Altered source versions must be plainly marked as such,
	   and must not be misrepresented as being the original software.

	3. This notice may not be removed or altered from any source distribution.
*/

module primidi.midi.midiout;

version(linux) {
	import core.sys.posix.sys.ioctl;
	import core.sys.posix.unistd;
	import core.sys.posix.fcntl;
	import primidi.midi.alsa;
}
version(Windows) {
	pragma(lib, "winmm");
	import core.sys.windows.mmsystem;
}

import std.exception;
import std.string;
import std.stdio;
import std.conv;

import derelict.sdl2.sdl;

struct MidiDevice {
	int card = 0, device = 0, sub = 0;
	string deviceName, displayName;
}

private {
	MidiDevice[] _midiOutDevices;
	MidiDevice _currentOutDevice;
	__gshared MidiOut _midiOut;
}

void initializeMidiOut() {
	_midiOut = new MidiOut;
}

void destroyMidiOut() {
	_midiOut.close();
}

void flushMidiDevices() {
	_midiOutDevices.length = 0;
}

void addMidiDevice(MidiDevice device) {
	writeln("MidiOut Device: ", device);
	_midiOutDevices ~= device;
}

string[] getMidiOutDeviceNames() {
	string[] deviceNames;
	foreach(ref device; _midiOutDevices) {
		deviceNames ~= device.displayName;
	}
	return deviceNames;
}

void selectMidiOutDevice(uint id) {
	if(id >= _midiOutDevices.length)
		throw new Exception("Device id out of bounds");
	_currentOutDevice = _midiOutDevices[id];
	_midiOut.close();
	_midiOut.open();
}

MidiOut getMidiOut() {
	return _midiOut;
}

version(Windows) {
	void scanMidiPorts() {
		int midiPort = 0;
		int maxDevs = midiOutGetNumDevs();
		for(; midiPort < maxDevs; midiPort++) {
			MidiDevice midiDevice;
			midiDevice.card = midiPort;
			midiDevice.device = 0;
			midiDevice.sub = 0;
			midiDevice.deviceName = to!string(card);
			midiDevice.displayName = "Port " ~ to!string(card);
			addMidiDevice(midiDevice);
		}
	}
}

class MidiOut {
	private {
		version(linux) snd_rawmidi_t* _deviceHandle;
		version(Windows) {
			HMIDIOUT _deviceHandle;

			union MidiWord {
				uint word;
				ubyte[4] bytes;
			}
		}
		bool _isOpen = false;
	}

	@property bool isOpen() const { return _isOpen; }

	this() {}

	/+version(linux)
	this(string name) {
		open(name);
	}+/

	~this() {
		close();
	}

	version(linux)
	bool open() {
		if(_isOpen)
			throw new Exception("The midi device is already open");

/*
		_deviceHandle = core.sys.posix.fcntl.open(toStringz(deviceName), O_WRONLY, 0);
		if(_deviceHandle < 0)
			throw new Exception("Cannot open the midi device");

		writeln("Opened midi device \'", deviceName, "\'");
*/

		if(snd_rawmidi_open(null, &_deviceHandle, toStringz(_currentOutDevice.deviceName), 0))
			throw new Exception("Cannot open the midi device");

		_isOpen = true;

		return _isOpen;
	}

	version(Windows)
	bool open() {
		if(_isOpen)
			throw new Exception("The midi device is already open");

		//Todo: update to use _currentMidiOutDevice instead
		int midiPort = 0;
		int maxDevs = midiOutGetNumDevs();
		for(; midiPort < maxDevs; midiPort++) {
			int flag = midiOutOpen(&_deviceHandle, midiPort, 0, 0, CALLBACK_NULL);
			if(flag == MMSYSERR_NOERROR)
				break;
		}

		if(maxDevs == 0 || midiPort == maxDevs)
			throw new Exception("No midi device available");

		writeln("Opened midi device \'", midiPort, "\'");

		_isOpen = true;

		return _isOpen;
	}

	version(linux)
	bool close() {
		if(_isOpen) {
			snd_rawmidi_close(_deviceHandle);
			_isOpen = false;
		}

		return !_isOpen;
	}

	version(Windows)
	bool close() {
		if(_isOpen) {
			midiOutClose(_deviceHandle);
			_isOpen = false;
		}

		return !_isOpen;
	}

	version(linux)
	void send(ubyte a) {
		ubyte[1] data;
		data[0] = a;
		send(data);
	}

	version(Windows)
	void send(ubyte a) {
		if(!_isOpen)
			return;
		MidiWord midiWord;
		midiWord.bytes[0] = a;
		midiOutShortMsg(_deviceHandle, midiWord.word);
	}

	version(linux)
	void send(ubyte a, ubyte b) {
		ubyte[2] data;
		data[0] = a;
		data[1] = b;
		send(data);
	}

	version(Windows)
	void send(ubyte a, ubyte b) {
		MidiWord midiWord;
		midiWord.bytes[0] = a;
		midiWord.bytes[1] = b;
		midiOutShortMsg(_deviceHandle, midiWord.word);
	}

	version(linux)
	void send(ubyte a, ubyte b, ubyte c) {
		ubyte[3] data;
		data[0] = a;
		data[1] = b;
		data[2] = c;
		send(data);
	}

	version(Windows)
	void send(ubyte a, ubyte b, ubyte c) {
		if(!_isOpen)
			return;
		MidiWord midiWord;
		midiWord.bytes[0] = a;
		midiWord.bytes[1] = b;
		midiWord.bytes[2] = c;
		midiOutShortMsg(_deviceHandle, midiWord.word);
	}

	version(linux)
	void send(const(ubyte)[] data) {
		if(!_isOpen)
			return;
		while(data.length) {
			size_t size = snd_rawmidi_write(_deviceHandle, data.ptr, data.length);
			if(size < 0)
				throw new Exception("Error writting to midi port");
			data = data[size .. $];
		}
		//core.sys.posix.unistd.write(_deviceHandle, cast(const void*)data, data.length);
	}

	version(Windows)
	void send(immutable(ubyte[]) data) {
		if(!_isOpen)
			return;
		ubyte[] ndata = data.dup;
		MIDIHDR midiHeader;
		midiHeader.lpData = cast(char*)ndata;
		midiHeader.dwBufferLength = data.length;
		midiHeader.dwFlags = 0;
		midiOutPrepareHeader(_deviceHandle, &midiHeader, midiHeader.sizeof);
		midiOutLongMsg(_deviceHandle, &midiHeader, midiHeader.sizeof);
		midiOutUnprepareHeader(_deviceHandle, &midiHeader, midiHeader.sizeof);
	}
}