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

module primidi.editor.pluginscript;

import std.stdio;
import core.thread;

import atelier;
import grimoire;

private class PluginScript {
    private class TimeoutThread: Thread {
        private {
            __gshared PluginScript _script;
        }
        shared bool isRunning = true;

        this(PluginScript script) {
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
        _engine = new GrEngine(bytecode);
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