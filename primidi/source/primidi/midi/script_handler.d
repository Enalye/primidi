module primidi.midi.script_handler;

import std.stdio, core.thread;
import minuit, grimoire, atelier;
import primidi.midi.internal_sequencer;
import primidi.script;

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
                        if(_script._isProcessing) {
                            _script._engine.isRunning = false;
                            //writeln("Plugin script timeout: ", currentCycle, ", ", _script._isLoaded);
                            isRunning = false;
                        }
                    }
                    //writeln("Thread: ", isRunning, ", prev cycle: ", currentCycle,
                    //", next cycle: ", _script._cycle, ", loaded ? ", _script._isLoaded);
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
        shared bool _isProcessing = false;
        TimeoutThread _timeout;
    }

    this() {
        _timeout = new TimeoutThread(this);      
    }

    void cleanup() {
        _isProcessing = false;
        _engine.isRunning = false;
        _isLoaded = false;
        _timeout.isRunning = false;
        _timeout = null;
    }

    void load(string name) {
        try {
            GrData data = new GrData;
            grLoadStdLibrary(data);
            loadScriptDefinitions(data);
            auto bytecode = grCompileFile(data, name);
            _engine = new GrEngine;
            _engine.load(data, bytecode);
            _engine.spawn();
            _timeout.start();
        }
        catch(Exception e) {
            writeln("ScriptHandler caught an exception:\n" ~ e.msg);
            cleanup();
        }
        catch(Error e) {
            writeln("ScriptHandler caught an unrecoverable error:\n" ~ e.msg);
            //We need to atleast kill the hanging thread.
            cleanup();
            throw e;
        }
    }

    void run() {
        try {
            _isLoaded = true;
            _isProcessing = true;
            _engine.process();
            _isProcessing = false;
            _cycle = _cycle + 1;
            if(!_engine.hasCoroutines) {
                _timeout.isRunning = false;
            }
        }
        catch(Exception e) {
            writeln("ScriptHandler caught an exception:\n" ~ e.msg);
            cleanup();
        }
        catch(Error e) {
            writeln("ScriptHandler caught an unrecoverable error:\n" ~ e.msg);
            //We need to atleast kill the hanging thread.
            cleanup();
            throw e;
        }
    }

    void kill() {
        cleanup();
    }
} 

private {
    ScriptHandler _handler;
    dstring _onNoteEventName;
}

///Compile and load the script.
void initializeScript() {
    _handler = new ScriptHandler;
    _handler.load("plugin/test.gr");

    _onNoteEventName = grMangleNamedFunction("onNote", [grGetUserType("Note")]);

    if(_handler._engine.hasEvent(_onNoteEventName)) {
        setSequencerNoteCallback(&onNote);
    }
}

///Process a single pass of the VM.
void runScript() {
    _handler.run();
}

///Call upon quitting the program.
void killScript() {
    _handler.kill();
}

///Event callback when a note appears in the tick window.
private void onNote(Note note) {
    auto context = _handler._engine.spawnEvent(_onNoteEventName);
    context.setUserData(note);
}

