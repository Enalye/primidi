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

module primidi.workstation.common.playlist;

import std.file;

enum PlayOrder {
	Shuffled,
	Normal,
	Inverted
}

class Playlist {
	private string[] files;
	PlayOrder playOrder = PlayOrder.Normal;

	string getNext() {
		import std.random;

		version(linux) ulong index;
		version(Windows) uint index;
		final switch(playOrder) with(PlayOrder) {
		case Shuffled:
			index = uniform(0, files.length - 1);
			break;
		case Normal:
			index = 0;
			break;
		case Inverted:
			index = files.length - 1;
			break;
		}

		string fileName = files[index];
		if(index == files.length - 1) {
			files.length --;
		}
		else if(index == 0) {
			files = files[1 .. $];
		}
		else {
			files = files[0 .. index] ~ files[index + 1 .. $];
		}
		return fileName;
	}

	void add(string midiFile) {
		if(!exists(midiFile))
			return;
		files ~= midiFile;
	}

	bool isReady() const {
		return files.length != 0;
	}

	void flush() {
		files.length = 0uL;
	}
}