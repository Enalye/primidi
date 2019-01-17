module primidi.workstation.piano.pianoview;

import atelier;

import primidi.workstation.common.all;

class PianoContainer: VContainer {
	Piano[16] _pianos;

	this() {
		_position = centerScreen + Vec2f(225f, 25f);

		foreach(ubyte channelId; 0u.. 16u) {
			auto piano = new Piano(channelId);
			_pianos[channelId] = piano;
			addChild(piano);
		}
	}
}