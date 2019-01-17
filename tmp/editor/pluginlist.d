/**
Primidi
Copyright (c) 2016 Enalye

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising
from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute
it freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented;
	   you must not claim that you wrote the original software.
	   If you use this software in a product, an acknowledgment
	   in the product documentation would be appreciated but
	   is not required.

	2. Altered source versions must be plainly marked as such,
	   and must not be misrepresented as being the original software.

	3. This notice may not be removed or altered from any source distribution.
*/

module primidi.editor.pluginlist;


import primidi.editor.scene;
import primidi.editor.properties;

import primidi.plugin.all;

import atelier;

private {
    EditorPluginList _pluginList;
}

EditorPluginList createEditorPluginList() {
    _pluginList = new EditorPluginList;
    return _pluginList;
}

void destroyEditorPluginList() {
    _pluginList = null;
}

void addPlugin(string path) {
	_pluginList.add(path);
}

void removePlugin() {
	_pluginList.remove();
}

void reloadPlugin() {
	_pluginList.reload();
}

void moveUpPlugin() {
	_pluginList.moveUp();
}

void moveDownPlugin() {
	_pluginList.moveDown();
}

private final class EditorPluginList: VList {
	private {
		string _path;
	}

    this() {
        super(Vec2f(250f, 500f));
        anchor = Vec2f(0f, .5f);
        position = Vec2f(0f, centerScreen.y);
    }

	void moveUp() {
		auto position = selected();
		auto list = getList();
		if(position == 0u)
			return;
		else if(position + 1u == list.length)
			list = list[0..$-2] ~ [list[$-1], list[$-2]];
		else
			list = list[0..position-1] ~ [list[position], list[position-1]] ~ list[position+1..$];
		removeChildren();
		foreach(widget; list)
			addChild(widget);
		selected = position - 1;
		updateList();
	}

	void moveDown() {
		auto position = selected();
		auto list = getList();
		if(position + 1u == list.length)
			return;
		else if(position == 0u)
			list = [list[1], list[0]] ~ list[2..$];
		else
			list = list[0..position] ~ [list[position+1], list[position]] ~ list[position+2..$];
		removeChildren();
		foreach(widget; list)
			addChild(widget);
		selected = position + 1;
		updateList();
	}

	void add(string path) {
		_path = path;
		Plugin plugin = new Plugin(_path);
		addChild(new EditorPluginListElement(plugin));
		updateList();
	}

	void remove() {
		if(getChildrenCount()) {
    		auto children = getList();
		    (cast(EditorPluginListElement)children[selected]).unload();            
			removeChild(_pluginList.selected);
			updateList();
		}
	}

	void reload() {
		auto children = getList();
		if(!getChildrenCount())
			return;
		(cast(EditorPluginListElement)children[selected]).reload();
	}

	void updateList() {
		auto list = getList();
		Plugin[] plugins;
		foreach(widget; list) {
			plugins ~= (cast(EditorPluginListElement)widget).plugin;
		}
		setSceneList(plugins);
		auto pos = selected();
		if(pos < getChildrenCount())
			setEditorProperties(plugins[pos]);
		else
			setEditorProperties(null);
	}
}

private final class EditorPluginListElement: AnchoredLayout {
	private {
		ListButton _button;
		Checkbox _checkVisible;
        Plugin _plugin;
	}

	@property {
		bool isVisible() const { return _checkVisible.isValidated; }

		string text() const { return _button.label.text; }
		string text(string newText) { return _button.label.text = newText; }

		Plugin plugin() { return _plugin; }
	}

	this(Plugin newPlugin) {
        _plugin = newPlugin;
		_button = new ListButton("Plugin");
		_checkVisible = new Checkbox;
		_checkVisible.uncheckedSprite = fetch!Sprite("gui_editor_hidden");
		_checkVisible.checkedSprite = fetch!Sprite("gui_editor_visible");
		_checkVisible.isValidated = true;

		addChild(_button, Vec2f(.4f, .5f), Vec2f(.8f, 1f));
		addChild(_checkVisible, Vec2f(.9f, .5f), Vec2f(.1f, 1f));
	}

	override void update(float deltaTime) {
		super.update(deltaTime);
		_button.isValidated = _isValidated;
        _isHovered = _button.isHovered;
	}

	override void onEvent(Event event) {
		super.onEvent(event);
		_plugin.isVisible = _checkVisible.isValidated;
	}

	override void onValidate() {
		super.onValidate();
		setEditorProperties(_plugin);
	}

	void reload() {
		_plugin.reload();
	}

    void unload() {
        _plugin.unload();
    }
}
