/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.ticks;

import std.conv: to;
import atelier;
import primidi.locale, primidi.midi;
import primidi.gui.buttons;

final class SelectTicksIntervalModal: GuiElement {
	private {
		HSlider _slider;
        int _defaultValue;
        Label _ticksLabel;
	}

	this() {
		setAlign(GuiAlignX.center, GuiAlignY.center);
        size(Vec2f(400f, 200f));
        isMovable(true);

		{ //Slider
            auto box = new VContainer;
            box.setAlign(GuiAlignX.center, GuiAlignY.center);
            box.spacing = Vec2f(0f, 15f);
            addChildGui(box);

            _slider = new HSlider;
            _slider.size = Vec2f(380f, 15f);
            _slider.setAlign(GuiAlignX.center, GuiAlignY.center);
            _slider.min = 100;
            _slider.max = 20_000;
            _slider.step = (20_000 - 100) / 100;
            _slider.setCallback(this, "slider");
            _defaultValue = getInternalSequencerInterval();
            _slider.ivalue = _defaultValue;
			box.addChildGui(_slider);

            _ticksLabel = new Label(getLocalizedText("range_ticks") ~ ": " ~ to!string(_defaultValue));
            _ticksLabel.color = Color(20, 20, 20);
            box.addChildGui(_ticksLabel);
		}

		{ //Title
            auto title = new Label(getLocalizedText("select_ticks") ~ ":");
            title.color = Color(20, 20, 20);
            title.setAlign(GuiAlignX.left, GuiAlignY.top);
            title.position = Vec2f(20f, 10f);
            addChildGui(title);
        }

		{ //Validation
            auto box = new HContainer;
            box.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            box.position = Vec2f(10f, 10f);
            box.spacing = Vec2f(8f, 0f);
            addChildGui(box);

            auto applyBtn = new ConfirmationButton(getLocalizedText("apply"));
            applyBtn.size = Vec2f(70f, 20f);
            applyBtn.setCallback(this, "apply");
            box.addChildGui(applyBtn);

            auto cancelBtn = new ConfirmationButton(getLocalizedText("cancel"));
            cancelBtn.size = Vec2f(70f, 20f);
            cancelBtn.setCallback(this, "cancel");
            box.addChildGui(cancelBtn);
        }

        { //Exit
            auto exitBtn = new ExitButton;
            exitBtn.setAlign(GuiAlignX.right, GuiAlignY.top);
            exitBtn.position = Vec2f(10f, 10f);
            exitBtn.setCallback(this, "cancel");
            addChildGui(exitBtn);
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
        if(!isModalGui())
            return;
		switch(id) {
        case "slider":
            _ticksLabel.text = getLocalizedText("range_ticks") ~ ": " ~ to!string(_slider.ivalue);
            setInternalSequencerInterval(_slider.ivalue);
            break;
        case "apply":
            setInternalSequencerInterval(_slider.ivalue);
            stopModalGui();
            break;
		case "cancel":
            setInternalSequencerInterval(_defaultValue);
            stopModalGui();
            break;
        default:
            break;
        }
	}

    override void update(float deltaTime) {
        if(getButtonDown(KeyButton.escape))
            onCallback("cancel");
        else if(getButtonDown(KeyButton.enter) || getButtonDown(KeyButton.enter2))
            onCallback("apply");
    }

	override void draw() {
        drawFilledRect(origin, size, Color(240, 240, 240));
    }

    override void drawOverlay() {
        drawRect(origin, size, Color(20, 20, 20));
    }
}