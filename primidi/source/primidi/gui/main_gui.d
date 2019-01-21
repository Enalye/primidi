module primidi.gui.main_gui;

import std.path, std.string;
import atelier;
import primidi.gui.taskbar_gui, primidi.gui.plugin;
import primidi.player;

final class MainGui: GuiElement {
    private {
        TaskbarGui _taskbarGui;
        PluginGui _pluginGui;
    }

    this() {
        position(Vec2f.zero);
        size(screenSize);
        setAlign(GuiAlignX.Left, GuiAlignY.Top);

        _pluginGui = new PluginGui;
        addChildGui(_pluginGui);

        _taskbarGui = new TaskbarGui;
        addChildGui(_taskbarGui);
    }

    override void update(float deltaTime) {
        updateMidi();
    }

    override void onEvent(Event event) {
        super.onEvent(event);

		switch(event.type) with(EventType) {
        case DropFile:
            if(extension(event.str).toLower == ".mid")
                playMidi(event.str);
            else {
                //Modal window
            }
            break;
        default:
            break;
        }
    }

    override void onQuit() {
        stopMidi();
    }
}