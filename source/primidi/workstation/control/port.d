module primidi.workstation.control.port;

import grimoire;
import minuit;

import primidi.midi.all;

class PortSection: VContainer {
	private {
		DropDownList _list;
		MidiOutDevice[] _devices;
	}

	this() {
		_position = Vec2f(screenWidth - _size.x / 2f - 50f, 200f + _size.y / 2f);
		_list = new DropDownList(Vec2f(200f, 25f));
		_list.setCallback("output.select", this);
		addChild(_list);
		reload();
	}

	override void onEvent(Event event) {
		super.onEvent(event);

		switch(event.type) with(EventType) {
		case MouseDown:
			reload();
			break;
		case Quit:
			destroyMidiOut();
			break;
		case Callback:
			switch(event.id) {
			case "output.select":
				selectMidiOutDevice(_devices[_list.selected]);
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
        _devices.length = 0uL;
        _devices = [null];
		_devices ~= fetchMidiOutDevices();
		foreach(device; _devices)
            _list.addChild(new TextButton(device is null ? "No Output" : device.name));
	}
}