module primidi.midi.script_handler;

import std.stdio, core.thread;
import minuit, grimoire, atelier;
import primidi.midi.internal_sequencer;

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

private {
    ScriptHandler _handler;
}

dstring onNoteEventName;
void initializeScript() {
    _handler = new ScriptHandler;
    _handler.load("plugin/test.gr");

    onNoteEventName = grMangleNamedFunction("onNote", [grGetUserType("Note")]);

    if(_handler._engine.hasEvent(onNoteEventName)) {
        setSequencerNoteCallback(&onNote);
    }
}

void runScript() {
    _handler.run();
}

void onNote(Note note) {
    auto context = _handler._engine.spawnEvent(onNoteEventName);
    context.setUserData(note);
}

