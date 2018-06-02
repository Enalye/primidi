module primidi.pianoroll.panel;


import grimoire;

import primidi.workstation.common.all;
import primidi.pianoroll.channel;

class PianoRollPanel: WidgetGroup {
	private {
		Sprite _backgroundSprite, _rectSprite;
		Channel[16] _channels;
	}

	this() {
		_position = centerScreen;
		_size = screenSize;

		_backgroundSprite = fetch!Sprite("gui.background");
        _rectSprite = fetch!Sprite("note_rect");
		
        foreach(ubyte i; 0u.. 16u) {
            auto channel = new Channel(i);
            _channels[i] = channel;
            addChild(channel);
        }
	}

	override void draw() {
		//_backgroundSprite.draw(centerScreen);
		super.draw();

        _rectSprite.size = Vec2f(5f, screenHeight);
        _rectSprite.texture.setColorMod(Color(1f, 1f, 1f, .4f));
        pushSfx();
        _rectSprite.draw(centerScreen);
        popView();   
	}
}