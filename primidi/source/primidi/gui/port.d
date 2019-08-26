module primidi.gui.port;

import atelier, minuit;
import primidi.midi;

final class OutPortGui: DropDownList {
	private {
		MnOutDevice[] _devices;
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
		_devices ~= mnFetchOutDevices();
		foreach(device; _devices)
            add(device is null ? "No Output" : device.name);
	}
}

final class InPortGui: DropDownList {
	private {
		MnInDevice[] _devices;
	}

	this() {
		super(Vec2f(200f, 25f));
		setCallback(this, "select");
		reload();
	}

    override void onCallback(string id) {
        super.onCallback(id);
        if(id == "select") {
            selectMidiInDevice(_devices[selected()]);
        }
    }

	private void reload() {
		removeChildrenGuis();
        _devices.length = 0uL;
        _devices = [null];
		_devices ~= mnFetchInDevices();
		foreach(device; _devices)
            add(device is null ? "No Input" : device.name);
	}
}