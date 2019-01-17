module primidi.workstation.control.panel;

import atelier;

import primidi.midi.all;

import primidi.workstation.control.port;

class ControlPanel: GuiElement {
	private {
		PortSection _portSection;
		Sprite _backgroundSprite, _knobBase127Sprite;
		Knob _knob;
	}

	this(string[] args) {
		windowClearColor = Color(0.111f, 0.1125f, 0.123f);
		_position = centerScreen;
		_size = screenSize;

		_portSection = new PortSection;
		addChild(_portSection);

		_knob = new Knob;
		_knob.position = Vec2f(100f, 150f);
		_knob.step = 100;
		_knob.setAngles(-225f, 45f);
		_knob.setCallback(this, "");
		addChild(_knob);

		_backgroundSprite = fetch!Sprite("gui.background");
		_knobBase127Sprite = fetch!Sprite("gui.knob.base.0_127");
	}

	override void onEvent(Event event) {
		super.onEvent(event);
	}

	override void update(float deltaTime) {
		super.update(deltaTime);
	}

	override void draw() {
		_backgroundSprite.draw(centerScreen);
		_knobBase127Sprite.draw(_knob.position);
		super.draw();
	}
}