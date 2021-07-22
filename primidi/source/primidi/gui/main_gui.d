/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.main_gui;

import std.path, std.string;
import atelier;
import primidi.gui.menubar, primidi.gui.controlbar, primidi.gui.visualizer, primidi.gui.logger;
import primidi.player, primidi.midi, primidi.config;

final class MainGui: GuiElement {
    private {
        MenuBar _menuBar;
        ControlBar _controlBar;
        Visualizer _visualizer;
        Logger _logger;
    }

    this(string startingFilePath) {
        position(Vec2f.zero);
        size(getWindowSize());
        setAlign(GuiAlignX.left, GuiAlignY.top);
        _logger = new Logger;
        setScriptLogger(_logger);

        initializeScript();
        startMidi();
        loadConfig();

        _visualizer = new Visualizer;
        appendChild(_visualizer);

        appendChild(_logger);

        _controlBar = new ControlBar;
        appendChild(_controlBar);

        _menuBar = new MenuBar;
        appendChild(_menuBar);

        if(startingFilePath.length)
            playMidi(startingFilePath);
    }

    override void update(float deltaTime) {
        import primidi.menu: receiveFilePath;
        string receivedFilePath = receiveFilePath();
        if(receivedFilePath.length)
            playMidi(receivedFilePath);
        updateMidi();
    }

    override void onEvent(Event event) {
        super.onEvent(event);

		switch(event.type) with(Event.Type) {
        case dropFile:
            const string ext = extension(event.drop.filePath).toLower;
            if(ext == ".mid" || ext == ".midi")
                playMidi(event.drop.filePath);
            else if(ext == ".gr")
                loadScript(event.drop.filePath);
            else {
                notifyFileDrop(event.drop.filePath);
            }
            break;
        case resize:
            size = cast(Vec2f) event.window.size;
            break;
        default:
            break;
        }
    }
}