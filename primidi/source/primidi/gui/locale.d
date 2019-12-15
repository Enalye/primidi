/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.locale;

import std.path, std.file, std.string;
import atelier;
import primidi.locale;

final class SelectLocaleModal: GuiElement {
	private {
        SelectLocaleGui _localeSelector;
	}

	this() {
		setAlign(GuiAlignX.center, GuiAlignY.center);
        size(Vec2f(250f, 150f));

		{ //Port
			_localeSelector = new SelectLocaleGui;
			_localeSelector.setAlign(GuiAlignX.center, GuiAlignY.center);
			addChildGui(_localeSelector);
		}

		{ //Title
            auto title = new Label("Language selection:");
            title.setAlign(GuiAlignX.left, GuiAlignY.top);
            title.position = Vec2f(20f, 10f);
            addChildGui(title);
        }

		{ //Close
            auto closeBtn = new TextButton(getDefaultFont(), "Close");
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
            sendCustomEvent("locale");
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

private final class SelectLocaleGui: DropDownList {
	private {
		string[] _locales;
	}

	this() {
		super(Vec2f(200f, 25f));
		setCallback(this, "select");
		reload();
	}

    override void onCallback(string id) {
        super.onCallback(id);
        if(id == "select") {
            setLocale(_locales[selected()]);
        }
    }

	private void reload() {
		removeChildrenGuis();
        _locales.length = 0uL;
        foreach(file; dirEntries(buildNormalizedPath(dirName(thisExePath()), "data", "locale"), SpanMode.shallow)) {
            const string filePath = absolutePath(buildNormalizedPath(file));
            if(extension(filePath).toLower() != ".json")
                continue;
            JSONValue json = parseJSON(readText(filePath));
            _locales ~= filePath;
            add(getJsonStr(json, "locale", baseName(filePath)));
        }

        for(size_t i = 0u; i < _locales.length; ++ i) {
            if(_locales[i] == getLocale()) {
                selected(cast(uint) i);
                break;
            }
        }
	}
}