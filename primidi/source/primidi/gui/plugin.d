/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.plugin;

import std.path, std.file, std.string;
import atelier;
import primidi.config, primidi.locale;
import primidi.gui.buttons;

final class SelectPluginModal: GuiElement {
	private {
        PluginList _pluginList;
        PluginItem _currentItem;
        Label _nameLabel, _infoLabel, _authorLabel;
        string _scriptPath;
        Sprite _cover;
	}

	this() {
		setAlign(GuiAlignX.center, GuiAlignY.center);
        size(Vec2f(800f, 600f));
        isMovable(true);

		{ //Port
			_pluginList = new PluginList;
            _pluginList.position(Vec2f(15f, 0f));
			_pluginList.setAlign(GuiAlignX.left, GuiAlignY.center);
            _pluginList.setCallback(this, "list");
			appendChild(_pluginList);
		}

        {
            auto box = new VContainer;
            box.position(Vec2f(384f + 25f + 5f, 250f));
            box.setChildAlign(GuiAlignX.left);
            box.setAlign(GuiAlignX.left, GuiAlignY.top);
            appendChild(box);

            _nameLabel = new Label;
            _nameLabel.color = Color(20, 20, 20);
            box.appendChild(_nameLabel);
            _infoLabel = new Label;
            _infoLabel.color = Color(20, 20, 20);
            box.appendChild(_infoLabel);
            _authorLabel = new Label;
            _authorLabel.color = Color(20, 20, 20);
            box.appendChild(_authorLabel);
        }

		{ //Title
            auto title = new Label(getLocalizedText("select_plugin") ~ ":");
            title.color = Color(20, 20, 20);
            title.setAlign(GuiAlignX.left, GuiAlignY.top);
            title.position = Vec2f(20f, 10f);
            appendChild(title);
        }

		{ //Validation
            auto box = new HContainer;
            box.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            box.position = Vec2f(10f, 10f);
            box.spacing = Vec2f(8f, 0f);
            appendChild(box);

            auto applyBtn = new ConfirmationButton(getLocalizedText("apply"));
            applyBtn.size = Vec2f(70f, 20f);
            applyBtn.setCallback(this, "apply");
            box.appendChild(applyBtn);

            auto cancelBtn = new ConfirmationButton(getLocalizedText("cancel"));
            cancelBtn.size = Vec2f(70f, 20f);
            cancelBtn.setCallback(this, "close");
            box.appendChild(cancelBtn);
        }

        { //Exit
            auto exitBtn = new ExitButton;
            exitBtn.setAlign(GuiAlignX.right, GuiAlignY.top);
            exitBtn.position = Vec2f(10f, 10f);
            exitBtn.setCallback(this, "close");
            appendChild(exitBtn);
        }
        reload();

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

    private void setCurrentPlugin(PluginItem item) {
        _currentItem = item;
        if(_currentItem) {
            _nameLabel.text = getLocalizedText("name") ~ ": " ~ _currentItem._name;
            _infoLabel.text = getLocalizedText("info") ~ ": " ~ _currentItem._description;
            _authorLabel.text = getLocalizedText("author") ~ ": " ~ _currentItem._authorName;
            _cover = _currentItem._cover;
        }
    }

	override void onCallback(string id) {
		switch(id) {
        case "list":
            setCurrentPlugin(_pluginList._selectedItem);
            break;
		case "close":
            stopModal();
            break;
        case "apply":
            if(_currentItem)
                setPlugin(_currentItem._pluginPath);
            stopModal();
            break;
        default:
            break;
        }
	}

    override void update(float deltaTime) {
        if(getButtonDown(KeyButton.escape))
            onCallback("close");
        else if(getButtonDown(KeyButton.enter) || getButtonDown(KeyButton.enter2))
            onCallback("apply");
    }

	override void draw() {
        drawFilledRect(origin, size, Color(240, 240, 240));
        if(_cover)
            _cover.draw(origin + Vec2f(size.x - (_cover.size.x / 2f + 80f), 40f + _cover.size.y / 2f));
    }

    override void drawOverlay() {
        drawRect(origin, size, Color(20, 20, 20));
    }

    void reload() {
        string path = buildNormalizedPath(getBasePath(), "plugin");
        if(!exists(path)) {
            throw new Exception("No plugin folder found");
        }
        foreach(file; dirEntries(path, SpanMode.depth)) {
            const string filePath = absolutePath(buildNormalizedPath(file));
            if(extension(filePath).toLower() != ".json")
                continue;
            JSONValue json = parseJSON(readText(filePath));
            _pluginList.appendChild(new PluginItem(
                filePath,
                getJsonStr(json, "cover", ""),
                getJsonStr(json, "name", "Untitled"),
                getJsonStr(json, "info", "..."),
                getJsonStr(json, "author", "anonymous"),
                getJsonStr(json, "script", "")
                ));
        }
        
        const string pluginPath = getPluginPath();
        if(exists(pluginPath)) {
            auto list = cast(PluginItem[]) _pluginList.children;
            for(size_t i = 0u; i < list.length; ++ i) {
				if(list[i]._pluginPath == pluginPath) {
					_pluginList.selected(cast(uint) i);
                    setCurrentPlugin(list[i]);
					break;
				}
			}
        }
    }
}

private final class PluginItem: Button {
    private {
        Sprite _cover;
        string _name, _description, _authorName, _scriptPath, _pluginPath;
    }

    this(string pluginPath, string coverPath, string name, string description, string authorName, string scriptPath) {
        string basePath = dirName(pluginPath);
        _pluginPath = pluginPath;
        _name = name;
        _description = description;
        _authorName = authorName;

        size(Vec2f(128f, 128f));

        if(coverPath.length) {
            coverPath = buildNormalizedPath(basePath, coverPath);
            if(exists(coverPath)) {
                auto tex = new Texture(coverPath);
                _cover = new Sprite(tex);
            }
            else {
                _cover = fetch!Sprite("default_cover");
            }
        }
        else {
            _cover = fetch!Sprite("default_cover");
        }
        _cover.fit(size);

        if(!scriptPath.length)
            throw new Exception("No script specified for plugin");
        _scriptPath = buildNormalizedPath(basePath, scriptPath);
    }

    override void draw() {
        drawFilledRect(origin, size, Color(20, 20, 20));
        _cover.draw(center + (isClicked ? Vec2f(1f, 2f) : Vec2f.zero));
        if(isSelected)
            drawRect(origin, size, Color.cyan);
    }
}

private final class PluginList: GridList {
	private {
        PluginItem _selectedItem;
	}

	this() {
		super(Vec2f(384f, 512f));
        maxElementsPerLine(3u);
	}

    override void onCallback(string id) {
        super.onCallback(id);
        if(id == "list") {
            _selectedItem = cast(PluginItem) children[selected()];
            if(!_selectedItem)
                throw new Exception("Plugin grid null item");
            triggerCallback();
        }
    }

    override void draw() {
        drawFilledRect(origin, size, Color(204, 204, 204));
    }
}