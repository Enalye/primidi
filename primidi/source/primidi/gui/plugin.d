/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.plugin;

import std.path, std.file, std.string;
import atelier;
import primidi.config;

final class SelectPluginModal: GuiElement {
	private {
        PluginList _pluginList;
        PluginItem _currentItem;
        Label _nameLabel, _infoLabel, _authorLabel;
        string _scriptPath;
	}

	this() {
		setAlign(GuiAlignX.center, GuiAlignY.center);
        size(Vec2f(600f, 600f));

		{ //Port
			_pluginList = new PluginList;
            _pluginList.position(Vec2f(15f, 0f));
			_pluginList.setAlign(GuiAlignX.left, GuiAlignY.center);
            _pluginList.setCallback(this, "list");
			addChildGui(_pluginList);

            reload();
		}

        {
            auto box = new VContainer;
            box.position(Vec2f(10f, 25f));
            box.setAlign(GuiAlignX.right, GuiAlignY.top);
            addChildGui(box);

            _nameLabel = new Label("HELLO WORLD-------");
            box.addChildGui(_nameLabel);
            _infoLabel = new Label;
            box.addChildGui(_infoLabel);
            _authorLabel = new Label;
            box.addChildGui(_authorLabel);
        }

		{ //Title
            auto title = new Label("Plugin selection:");
            title.setAlign(GuiAlignX.left, GuiAlignY.top);
            title.position = Vec2f(20f, 10f);
            addChildGui(title);
        }

		{ //Close
            auto box = new HContainer;
            box.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            addChildGui(box);

            auto closeBtn = new TextButton(getDefaultFont(), "Close");
            closeBtn.size = Vec2f(80f, 35f);
            closeBtn.setCallback(this, "close");
            box.addChildGui(closeBtn);

            auto applyBtn = new TextButton(getDefaultFont(), "Apply");
            applyBtn.size = Vec2f(80f, 35f);
            applyBtn.setCallback(this, "apply");
            box.addChildGui(applyBtn);
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
        case "list":
            _currentItem = _pluginList._selectedItem;
            if(_currentItem) {
                _nameLabel.text = _pluginList._selectedItem._name;
                _infoLabel.text = _pluginList._selectedItem._description;
                _authorLabel.text = _pluginList._selectedItem._authorName;
            }
            break;
		case "close":
            stopModalGui();
            break;
        case "apply":
            if(_currentItem)
                setPlugin(_currentItem._pluginPath);
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

    void reload() {
        string path = buildNormalizedPath(dirName(thisExePath()), "plugin");
        if(!exists(path)) {
            throw new Exception("No plugin folder found");
        }
        foreach(file; dirEntries(path, SpanMode.depth)) {
            const string filePath = absolutePath(buildNormalizedPath(file));
            if(extension(filePath).toLower() != ".json")
                continue;
            JSONValue json = parseJSON(readText(filePath));
            _pluginList.addChildGui(new PluginItem(
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
            auto list = cast(PluginItem[]) _pluginList.getList();
            for(size_t i = 0u; i < list.length; ++ i) {
				if(list[i]._pluginPath == pluginPath) {
					_pluginList.selected(cast(uint) i);
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
        drawFilledRect(origin, size, Color.blue);
        _cover.draw(center + (isClicked ? Vec2f(1f, 2f) : Vec2f.zero));
        if(isSelected)
            drawRect(origin, size, Color.blue);
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
            _selectedItem = cast(PluginItem) getList()[selected()];
            if(!_selectedItem)
                throw new Exception("Plugin grid null item");
            triggerCallback();
        }
    }

    override void draw() {
        drawFilledRect(origin, size, Color(.08f, .09f, .11f));
    }
}