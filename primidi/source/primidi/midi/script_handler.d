/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.midi.script_handler;

import std.stdio, core.thread;
import minuit, grimoire, atelier;
import primidi.midi.internal_sequencer;
import primidi.script, primidi.gui.logger, primidi.gui, primidi.particles;

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
                logMessage("Script timeout error: " ~ e.msg);
            }
        }
    }

    private {
        GrEngine _engine;
        shared int _cycle;
        shared bool _isLoaded = false;
        shared bool _isProcessing = false;
        TimeoutThread _timeout;
        GrData _data;
        GrBytecode _bytecode;
        string _filePath;
        GrError _error;
    }

    this() {}

    void cleanup() {
        resetParticles();
        _isProcessing = false;
        if(_engine)
            _engine.isRunning = false;
        _isLoaded = false;
        if(_timeout)
            _timeout.isRunning = false;
        _timeout = null;
    }

    void load(string filePath) {
        try {
            _filePath = filePath;
            _data = new GrData;
            grLoadStdLibrary(_data);
            loadScriptDefinitions(_data);
            GrCompiler compiler = new GrCompiler(_data);
            if(!compiler.compileFile(_bytecode, filePath)) {
                _isLoaded = false;
                _error = compiler.getError();
                cleanup();
                return;
            }
            _engine = new GrEngine;
            _engine.load(_data, _bytecode);
            _engine.spawn();
            _timeout = new TimeoutThread(this);      
            _timeout.start();
            _isLoaded = true;

            // Events
            _onNoteEnterEventName = grMangleNamedFunction("onNoteEnter", [grGetUserType("Note")]);
            setNoteEnterCallback(_handler._engine.hasEvent(_onNoteEnterEventName) ? &onNoteEnter : null);

            _onNoteHitEventName = grMangleNamedFunction("onNoteHit", [grGetUserType("Note")]);
            setNoteHitCallback(_handler._engine.hasEvent(_onNoteHitEventName) ? &onNoteHit : null);

            _onNoteExitEventName = grMangleNamedFunction("onNoteExit", [grGetUserType("Note")]);
            setNoteExitCallback(_handler._engine.hasEvent(_onNoteExitEventName) ? &onNoteExit : null);

            _onStartEventName = grMangleNamedFunction("onStart", []);
            setStartCallback(_handler._engine.hasEvent(_onStartEventName) ? &onStart : null);
        }
        catch(Exception e) {
            logMessage(e.msg);
            cleanup();
        }
        catch(Error e) {
            logMessage(e.msg);
            //We need to atleast kill the hanging thread.
            cleanup();
            throw e;
        }
    }

    void reload() {
        import std.file: exists;
        if(!_filePath.length)
            return;
        if(!exists(_filePath))
            return;
        cleanup();
        load(_filePath);
    }

    void restart() {
        if(!_isLoaded)
            return;
        try {
            _isLoaded = false;
            _engine = new GrEngine;
            _engine.load(_data, _bytecode);
            _engine.spawn();
            _isLoaded = true;
        }
        catch(Exception e) {
            logMessage(e.msg);
            cleanup();
        }
        catch(Error e) {
            logMessage(e.msg);
            //We need to atleast kill the hanging thread.
            cleanup();
            throw e;
        }
    }

    void run() {
        import std.conv: to;
        if(_error) {
            setModalGui(new ScriptErrorModal(_error));
            _error = null;
        }
        if(!_isLoaded)
            return;
        try {
            _isProcessing = true;
            _engine.process();
            _isProcessing = false;
            _cycle = _cycle + 1;
            if(_engine.isPanicking) {
                _timeout.isRunning = false;
                throw new Exception("Panic: " ~ to!string(_engine.panicMessage));
            }
            else if(!_engine.hasCoroutines) {
                _timeout.isRunning = false;
            }
        }
        catch(Exception e) {
            logMessage(e.msg);
            cleanup();
        }
        catch(Error e) {
            logMessage(e.msg);
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
    dstring _onNoteEnterEventName, _onNoteHitEventName, _onNoteExitEventName, _onStartEventName;
    Logger _logger;
}

///Setup the script handler.
void initializeScript() {
    _handler = new ScriptHandler;
}

void setScriptLogger(Logger logger) {
    _logger = logger;
}

private void logMessage(string msg) {
    if(!_logger)
        return;
    _logger.add(msg);
}

///Compile and load the script.
void loadScript(string filePath) {
    if(!_handler)
        return;
    _handler.load(filePath);
    import primidi.config: saveConfig;
    saveConfig();
}

///Process a single pass of the VM.
void runScript() {
    if(!_handler)
        return;
    _handler.run();
}

///Recompile the file.
void reloadScript() {
    if(!_handler)
        return;
    _handler.reload();
}

///Relaunch the VM without recompiling.
void restartScript() {
    if(!_handler)
        return;
    _handler.restart();
}

///Call upon quitting the program.
void killScript() {
    if(!_handler)
        return;
    _handler.kill();
}

string getScriptFilePath() {
    return _handler ? _handler._filePath : "";
}

///Event callback when a note appears in the tick window.
private void onNoteEnter(Note note) {
    auto context = _handler._engine.spawnEvent(_onNoteEnterEventName);
    context.setUserData(note);
}

///Event callback when a note is played.
private void onNoteHit(Note note) {
    auto context = _handler._engine.spawnEvent(_onNoteHitEventName);
    context.setUserData(note);
}

///Event callback when a note disappears in the tick window.
private void onNoteExit(Note note) {
    auto context = _handler._engine.spawnEvent(_onNoteExitEventName);
    context.setUserData(note);
}

///Called when a midi file is starting.
private void onStart() {
    _handler._engine.spawnEvent(_onStartEventName);
}