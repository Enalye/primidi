module primidi.gui.plugin;

import std.stdio, core.thread;
import atelier, grimoire;

/// Load and run the plugin's script
final class PluginGui: GuiElement {
    private {
        Canvas _canvas;
        ScriptHandler _handler;
    }

    this() {
        position(Vec2f.zero);
        size(screenSize);
        setAlign(GuiAlignX.Left, GuiAlignY.Top);

        _canvas = new Canvas(screenSize);
        _canvas.position = screenSize / 2f;
        _handler = new ScriptHandler;
        _handler.load("plugin/test.gr");
    }

    void reload() {}

    override void update(float deltaTime) {
        pushCanvas(_canvas);
        _handler.run();
        popCanvas();
    }

    override void draw() {
        _canvas.draw(center);
    }
}

private final class ScriptHandler {
    private final class TimeoutThread: Thread {
        private {
            __gshared ScriptHandler _script;
        }
        shared bool isRunning = true;

        this(ScriptHandler script) {
            _script = script;
            super(&run);
        }

        void run() {
            try {
                while(isRunning) {
                    auto currentCycle = _script._cycle;
                    sleep(dur!("msecs")(1000));
                    if(currentCycle == _script._cycle && _script._isLoaded) {
                        _script._engine.isRunning = false;
                        writeln("Plugin script timeout: ", currentCycle, ", ", _script._isLoaded);
                        isRunning = false;
                    }
                    writeln("Thread: ", isRunning, ", prev cycle: ", currentCycle,
                    ", next cycle: ", _script._cycle, ", loaded ? ", _script._isLoaded);
                }
            }
            catch(Exception e) {
                writeln("Plugin timeout error: ", e.msg);
            }
        }
    }

    private {
        GrEngine _engine;
        shared int _cycle;
        shared bool _isLoaded = false;
        TimeoutThread _timeout;
    }

    this() {
        _timeout = new TimeoutThread(this);      
    }

    void cleanup() {
        _engine.isRunning = false;
        _isLoaded = false;
        _timeout.isRunning = false;
        _timeout = null;
    }

    void load(string name) {
        auto bytecode = grCompileFile(name);
        _engine = new GrEngine;
        _engine.load(bytecode);
        _engine.spawn();
        _timeout.start();
    }

    void run() {
        _isLoaded = true;
        _engine.process();
        _cycle = _cycle + 1;
        if(!_engine.hasCoroutines) {
            _timeout.isRunning = false;
        }
    }
} 