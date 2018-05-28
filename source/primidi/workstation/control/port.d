module primidi.workstation.control.port;

import primidi.common.all;
import primidi.core.all;
import primidi.render.all;
import primidi.ui.all;
import primidi.midi.all;

class PortSection: VContainer {
	private {
		DropDownList _list;
	}

	this() {
		_position = Vec2f(screenWidth - _size.x / 2f - 50f, 200f + _size.y / 2f);
		_list = new DropDownList(Vec2f(200f, 25f));
		_list.setCallback("output.select", this);
		addChild(_list);
		scanMidiPorts();
		reload();
	}

	override void onEvent(Event event) {
		super.onEvent(event);

		switch(event.type) with(EventType) {
		case MouseDown:
			scanMidiPorts();
			reload();
			break;
		case Quit:
			destroyMidiOut();
			break;
		case Callback:
			switch(event.id) {
			case "output.select":
				selectMidiOutDevice(_list.selected);
				break;
			default:
				break;
			}
			break;
		default:
			break;
		}
	}

	override void update(float deltaTime) {
		super.update(deltaTime);
		position(Vec2f(screenWidth - _size.x / 2f - 50f, 200f + _size.y / 2f));
	}

	override void draw() {
		super.draw();
	}

	void reload() {
		_list.removeChildren();
		foreach(deviceName; getMidiOutDeviceNames())
			_list.addChild(new TextButton(deviceName));
	}
}