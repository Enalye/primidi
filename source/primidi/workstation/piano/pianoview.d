module primidi.workstation.piano.pianoview;

import primidi.common.all;
import primidi.core.all;
import primidi.render.all;
import primidi.ui.all;

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