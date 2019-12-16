/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.port;

import atelier, minuit;
import primidi.midi, primidi.locale;

final class OutPortModal: GuiElement {
	private {
		OutPortGui _outPort;
	}

	this() {
		setAlign(GuiAlignX.center, GuiAlignY.center);
        size(Vec2f(250f, 150f));

		{ //Port
			_outPort = new OutPortGui;
			_outPort.setAlign(GuiAlignX.center, GuiAlignY.center);
			addChildGui(_outPort);
		}

		{ //Title
            auto title = new Label(getLocalizedText("select_output") ~ ":");
            title.setAlign(GuiAlignX.left, GuiAlignY.top);
            title.position = Vec2f(20f, 10f);
            addChildGui(title);
        }

		{ //Close
            auto closeBtn = new TextButton(getDefaultFont(), getLocalizedText("close"));
            closeBtn.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            closeBtn.size = Vec2f(80f, 35f);
            closeBtn.setCallback(this, "close");
            addChildGui(closeBtn);
        }

		GuiState hiddenState = {
            offset: Vec2f(0f, -50f),
            color: Color.clear
        };
        addState("hidden", hiddenState);

        GuiState defaultState = {
            time: .5f,
            easingFunction: getEasingFunction(EasingAlgorithm.sineOut)
        };
        addState("default", defaultState);

        setState("hidden");
        doTransitionState("default");
	}

	override void onCallback(string id) {
		switch(id) {
		case "close":
            stopModalGui();
            break;
        default:
            break;
        }
	}

	override void draw() {
        drawFilledRect(origin, size, Color(.11f, .08f, .15f));
    }

    override void drawOverlay() {
        drawRect(origin, size, Color.gray);
    }
}

final class InPortModal: GuiElement {
	private {
		InPortGui _inPort;
	}

	this() {
		setAlign(GuiAlignX.center, GuiAlignY.center);
        size(Vec2f(250f, 150f));

		{ //Port
			_inPort = new InPortGui;
			_inPort.setAlign(GuiAlignX.center, GuiAlignY.center);
			addChildGui(_inPort);
		}

		{ //Title
            auto title = new Label(getLocalizedText("select_input") ~ ":");
            title.setAlign(GuiAlignX.left, GuiAlignY.top);
            title.position = Vec2f(20f, 10f);
            addChildGui(title);
        }

		{ //Close
            auto closeBtn = new TextButton(getDefaultFont(), getLocalizedText("close"));
            closeBtn.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            closeBtn.size = Vec2f(80f, 35f);
            closeBtn.setCallback(this, "close");
            addChildGui(closeBtn);
        }

		GuiState hiddenState = {
            offset: Vec2f(0f, -50f),
            color: Color.clear
        };
        addState("hidden", hiddenState);

        GuiState defaultState = {
            time: .5f,
            easingFunction: getEasingFunction(EasingAlgorithm.sineOut)
        };
        addState("default", defaultState);

        setState("hidden");
        doTransitionState("default");
	}

	override void onCallback(string id) {
		switch(id) {
		case "close":
            stopModalGui();
            break;
        default:
            break;
        }
	}

	override void draw() {
        drawFilledRect(origin, size, Color(.11f, .08f, .15f));
    }

    override void drawOverlay() {
        drawRect(origin, size, Color.gray);
    }
}

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
            add(device is null ? getLocalizedText("no_output") : device.name);

		const auto oldDevice = getMidiOut().port;
		if(oldDevice !is null) {
			for(size_t i = 0u; i < _ports.length; ++ i) {
				if(!_ports[i])
					continue;
				if(_ports[i].name == oldDevice.name) {
					selected(cast(uint) i);
					break;
				}
			}
		}
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
            add(device is null ? getLocalizedText("no_input") : device.name);

		const auto oldDevice = getMidiIn().port;
		if(oldDevice !is null) {
			for(size_t i = 0u; i < _ports.length; ++ i) {
				if(!_ports[i])
					continue;
				if(_ports[i].name == oldDevice.name) {
					selected(cast(uint) i);
					break;
				}
			}
		}
	}
}