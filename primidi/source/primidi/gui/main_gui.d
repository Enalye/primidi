module primidi.gui.main_gui;

import std.path, std.string;
import atelier;
import primidi.gui.menubar, primidi.gui.taskbar_gui, primidi.gui.plugin, primidi.gui.options, primidi.gui.logger;
import primidi.player, primidi.midi;

final class MainGui: GuiElement {
    private {
        MenuBar _menuBar;
        TaskbarGui _taskbarGui;
        PluginGui _pluginGui;
        LoggerGui _loggerGui;
    }

    this() {
        position(Vec2f.zero);
        size(screenSize);
        setAlign(GuiAlignX.left, GuiAlignY.top);

        _pluginGui = new PluginGui;
        addChildGui(_pluginGui);

        _loggerGui = new LoggerGui;
        addChildGui(_loggerGui);

        _taskbarGui = new TaskbarGui;
        addChildGui(_taskbarGui);

        _menuBar = new MenuBar;
        addChildGui(_menuBar);

        startMidi();
    }

    override void update(float deltaTime) {
        updateMidi();
    }

    override void onEvent(Event event) {
        super.onEvent(event);

		switch(event.type) with(EventType) {
        case dropFile:
            const string ext = extension(event.drop.filePath).toLower;
            if(ext == ".mid" || ext == ".midi")
                playMidi(event.drop.filePath);
            else {
                //Modal window
            }
            break;
        case resize:
            size = cast(Vec2f) event.window.size;
            break;
        default:
            break;
        }
    }

    override void onQuit() {
        stopMidi();
		closeMidiDevices();
    }
}