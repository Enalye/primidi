module primidi.workstation.piano.panel;

import grimoire;

import primidi.workstation.piano.pianoview;

class PianoPanel: WidgetGroup {
	private {
		Sprite _backgroundSprite;
		PianoContainer _pianoView;
	}

	this() {
		_position = centerScreen;
		_size = screenSize;

		_backgroundSprite = fetch!Sprite("gui.background");
		
		_pianoView = new PianoContainer;
		addChild(_pianoView);
	}

	override void draw() {
		_backgroundSprite.draw(centerScreen);
		super.draw();
	}
}