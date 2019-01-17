module primidi.gui.port;

import atelier, minuit;
import primidi.midi;

final class PortGui: DropDownList {
	private {
		MidiOutDevice[] _devices;
	}

	this() {
		super(Vec2f(200f, 25f));
		setCallback(this, "select");
		reload();
	}

    override void onCallback(string id) {
        super.onCallback(id);
        if(id == "select") {
            selectMidiOutDevice(_devices[selected()]);
        }
    }

	private void reload() {
		removeChildrenGuis();
        _devices.length = 0uL;
        _devices = [null];
		_devices ~= fetchMidiOutDevices();
		foreach(device; _devices)
            add(device is null ? "No Output" : device.name);
	}
}