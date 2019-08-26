module primidi.gui.main_gui;

import std.path, std.string;
import atelier;
import primidi.gui.taskbar_gui, primidi.gui.plugin, primidi.gui.options_gui;
import primidi.player;

final class MainGui: GuiElement {
    private {
        TaskbarGui _taskbarGui;
        PluginGui _pluginGui;
        OptionsGui _optionsGui;
    }

    this() {
        position(Vec2f.zero);
        size(screenSize);
        setAlign(GuiAlignX.Left, GuiAlignY.Top);

        _optionsGui = new OptionsGui;

        _pluginGui = new PluginGui;
        addChildGui(_pluginGui);

        _taskbarGui = new TaskbarGui(_optionsGui);
        addChildGui(_taskbarGui);

        addChildGui(_optionsGui);

        startMidi();
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