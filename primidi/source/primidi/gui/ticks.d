/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.ticks;

import std.conv: to;
import atelier;
import primidi.locale, primidi.midi;

final class SelectTicksIntervalModal: GuiElement {
	private {
		HSlider _slider;
        int _defaultValue;
        Label _ticksLabel;
	}

	this() {
		setAlign(GuiAlignX.center, GuiAlignY.center);
        size(Vec2f(400f, 200f));

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
            box.addChildGui(_ticksLabel);
		}

		{ //Title
            auto title = new Label(getLocalizedText("select_ticks") ~ ":");
            title.setAlign(GuiAlignX.left, GuiAlignY.top);
            title.position = Vec2f(20f, 10f);
            addChildGui(title);
        }

		{ //Validation
            auto box = new HContainer;
            box.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            box.spacing = Vec2f(25f, 15f);
            addChildGui(box);

            Font font = getDefaultFont();
            auto applyBtn = new TextButton(font, getLocalizedText("apply"));
            applyBtn.size = Vec2f(80f, 35f);
            applyBtn.setCallback(this, "apply");
            box.addChildGui(applyBtn);

            auto cancelBtn = new TextButton(font, getLocalizedText("cancel"));
            cancelBtn.size = Vec2f(80f, 35f);
            cancelBtn.setCallback(this, "cancel");
            box.addChildGui(cancelBtn);
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

	override void draw() {
        drawFilledRect(origin, size, Color(.11f, .08f, .15f));
    }

    override void drawOverlay() {
        drawRect(origin, size, Color.gray);
    }
}