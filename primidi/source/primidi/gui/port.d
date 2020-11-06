/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.port;

import atelier, minuit;
import primidi.midi, primidi.locale;
import primidi.gui.buttons;

final class OutPortModal: GuiElement {
	private {
		OutPortGui _outPort;
	}

	this() {
		setAlign(GuiAlignX.center, GuiAlignY.center);
        size(Vec2f(250f, 150f));
        isMovable(true);

		{ //Port
			_outPort = new OutPortGui;
			_outPort.setAlign(GuiAlignX.center, GuiAlignY.center);
			addChildGui(_outPort);
		}

		{ //Title
            auto title = new Label(getLocalizedText("select_output") ~ ":");
            title.color = Color(20, 20, 20);
			title.setAlign(GuiAlignX.left, GuiAlignY.top);
            title.position = Vec2f(20f, 10f);
            addChildGui(title);
        }

		{ //Close
            auto closeBtn = new ConfirmationButton(getLocalizedText("close"));
            closeBtn.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            closeBtn.position = Vec2f(10f, 10f);
            closeBtn.size = Vec2f(70f, 20f);
            closeBtn.setCallback(this, "close");
            addChildGui(closeBtn);
        }

		{ //Exit
            auto exitBtn = new ExitButton;
            exitBtn.setAlign(GuiAlignX.right, GuiAlignY.top);
            exitBtn.position = Vec2f(10f, 10f);
            exitBtn.setCallback(this, "close");
            addChildGui(exitBtn);
        }

		GuiState hiddenState = {
            offset: Vec2f(0f, -50f),
            alpha: 0f
        };
        addState("hidden", hiddenState);

        GuiState defaultState = {
            time: .5f,
            easing: getEasingFunction(Ease.sineOut)
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

	override void update(float deltaTime) {
        if(getButtonDown(KeyButton.escape) || getButtonDown(KeyButton.enter) || getButtonDown(KeyButton.enter2))
            onCallback("close");
    }

	override void draw() {
        drawFilledRect(origin, size, Color(240, 240, 240));
    }

    override void drawOverlay() {
        drawRect(origin, size, Color(20, 20, 20));
    }
}

final class InPortModal: GuiElement {
	private {
		InPortGui _inPort;
	}

	this() {
		setAlign(GuiAlignX.center, GuiAlignY.center);
        size(Vec2f(250f, 150f));
        isMovable(true);

		{ //Port
			_inPort = new InPortGui;
			_inPort.setAlign(GuiAlignX.center, GuiAlignY.center);
			addChildGui(_inPort);
		}

		{ //Title
            auto title = new Label(getLocalizedText("select_input") ~ ":");
			title.color = Color(20, 20, 20);
            title.setAlign(GuiAlignX.left, GuiAlignY.top);
            title.position = Vec2f(20f, 10f);
            addChildGui(title);
        }

		{ //Close
            auto closeBtn = new ConfirmationButton(getLocalizedText("close"));
            closeBtn.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            closeBtn.position = Vec2f(10f, 10f);
            closeBtn.size = Vec2f(70f, 20f);
            closeBtn.setCallback(this, "close");
            addChildGui(closeBtn);
        }

		{ //Exit
            auto exitBtn = new ExitButton;
            exitBtn.setAlign(GuiAlignX.right, GuiAlignY.top);
            exitBtn.position = Vec2f(10f, 10f);
            exitBtn.setCallback(this, "close");
            addChildGui(exitBtn);
        }

		GuiState hiddenState = {
            offset: Vec2f(0f, -50f),
            alpha: 0f
        };
        addState("hidden", hiddenState);

        GuiState defaultState = {
            time: .5f,
            easing: getEasingFunction(Ease.sineOut)
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

	override void update(float deltaTime) {
        if(getButtonDown(KeyButton.escape) || getButtonDown(KeyButton.enter) || getButtonDown(KeyButton.enter2))
            onCallback("close");
    }

	override void draw() {
        drawFilledRect(origin, size, Color(240, 240, 240));
    }

    override void drawOverlay() {
        drawRect(origin, size, Color(20, 20, 20));
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