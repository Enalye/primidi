module primidi.gui.port;

import atelier, minuit;
import primidi.midi;

final class OutPortGui: DropDownList {
	private {
		MnOutputPort[] _ports;
	}

	this() {
		super(Vec2f(200f, 25f));
		setCallback(this, "select");
		reload();
	}

    override void onCallback(string id) {
        super.onCallback(id);
        if(id == "select") {
            selectMidiOutDevice(_ports[selected()]);
        }
    }

	private void reload() {
		removeChildrenGuis();
        _ports.length = 0uL;
        _ports = [null];
		_ports ~= mnFetchOutputs();
		foreach(device; _ports)
            add(device is null ? "No Output" : device.name);
	}
}

final class InPortGui: DropDownList {
	private {
		MnInputPort[] _ports;
	}

	this() {
		super(Vec2f(200f, 25f));
		setCallback(this, "select");
		reload();
	}

    override void onCallback(string id) {
        super.onCallback(id);
        if(id == "select") {
            selectMidiInDevice(_ports[selected()]);
        }
    }

	private void reload() {
		removeChildrenGuis();
        _ports.length = 0uL;
        _ports = [null];
		_ports ~= mnFetchInputs();
		foreach(device; _ports)
            add(device is null ? "No Input" : device.name);
	}
}