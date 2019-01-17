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

module primidi.editor.editor;

import std.file;
import std.path;

import atelier;
import primidi.editor.taskbar;
import primidi.editor.pluginlist;
import primidi.editor.properties;
import primidi.editor.scene;
import primidi.plugin.all;

private {
    Editor _editor;
}

void createEditor() {
    _editor = new Editor;
}

void destroyEditor() {
    _editor = null;
}

final class Editor: WidgetGroup {
    this() {
        _position = centerScreen;
        _size = screenSize;

        auto taskbar = createEditorTaskbar();
        auto pluginList = createEditorPluginList();
        auto properties = createEditorProperties();
        auto scene = createEditorScene();

        auto container = new HContainer;
        auto addPluginBtn = new TextButton("Add");
        addPluginBtn.setCallback(this, "plugin.add");
        auto removePluginBtn = new TextButton("Remove");
        removePluginBtn.setCallback(this, "plugin.remove");
        auto reloadPluginBtn = new TextButton("Reload");
        reloadPluginBtn.setCallback(this, "plugin.reload");
        auto moveUpPluginBtn = new TextButton("Up");
        moveUpPluginBtn.setCallback(this, "plugin.up");
        auto moveDownPluginBtn = new TextButton("Down");
        moveDownPluginBtn.setCallback(this, "plugin.down");
        container.addChild(addPluginBtn);
        container.addChild(removePluginBtn);
        container.addChild(reloadPluginBtn);
        container.addChild(moveUpPluginBtn);
        container.addChild(moveDownPluginBtn);
        container.position = Vec2f(0f, screenSize.y);
        container.anchor = Vec2f(0f, 1f);

        addChild(taskbar);
        addChild(pluginList);
        addChild(properties);
        addChild(container);
        addChild(scene);
    }

    ~this() {
        destroyEditorTaskbar();
        destroyEditorPluginList();
        destroyEditorProperties();
        destroyEditorScene();
    }

    override void onEvent(Event event) {
        super.onEvent(event);
        switch(event.type) with(EventType) {
        case Callback:
            switch(event.id) {
            case "plugin.add":
                auto modal = new AddPluginModal;
                modal.setCallback(this, "modal.add");
                setModalWindow(modal);
                break;
            case "plugin.remove":
                removePlugin();
                break;
            case "plugin.reload":
                reloadPlugin();
                break;
            case "plugin.up":
                moveUpPlugin();
                break;
            case "plugin.down":
                moveDownPlugin();
                break;
            case "modal.add":
                auto modal = getModal!AddPluginModal;
                addPlugin(modal.getFilePath());
                break;
            default:
                break;
            }
            break;
        default:
            break;
        }
    }
}

class AddPluginModal: ModalWindow {
    private {
		string[] _files;
		VList _list;
        string _file;
	}

    this() {
        super("Add Plugin", Vec2f(200f, 300f));

        _list = new VList(layout.size);
		foreach(file; dirEntries("./plugins", "*.json", SpanMode.depth)) {
			_files ~= file;
			string relativeFileName = stripExtension(baseName(file));
			auto btn = new TextButton(relativeFileName);
			_list.addChild(btn);
		}
		layout.addChild(_list);
    }

	override void onEvent(Event event) {
		super.onEvent(event);

        switch(event.type) with(EventType) {
        case Callback:
            if(event.id == "apply") {
                if(_list.selected < _files.length) {
                    string fileName = _files[_list.selected];
                    if(!exists(fileName))
                        throw new Exception("Error loading file: invalid path \'" ~ fileName ~ "\'");
                    _file = fileName;
                    triggerCallback();
                }
            }
            break;
        default:
            break;
        }
	}

	override void update(float deltaTime) {
		super.update(deltaTime);
		applyBtn.isLocked = (_files.length == 0L);
	}

    string getFilePath() {
        return _file;
    }
}