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

module primidi.editor.plugin;

import std.stdio;
import core.thread;

import grimoire;


class Plugin {
    private class TimeoutThread: Thread {
        private {
            __gshared Plugin _plugin;
        }
        shared bool isRunning = true;

        this(Plugin plugin) {
            _plugin = plugin;
            super(&run);
        }

        void run() {
            try {
                while(isRunning) {
                    auto currentCycle = _plugin._cycle;
                    sleep(dur!("msecs")(1000));
                    if(currentCycle == _plugin._cycle && _plugin._isLoaded) {
                        _plugin._vm.isRunning = false;
                        writeln("Plugin script timeout: ", currentCycle, ", ", _plugin._isLoaded);
                        isRunning = false;
                    }
                    writeln("Thread: ", isRunning, ", prev cycle: ", currentCycle,
                    ", next cycle: ", _plugin._cycle, ", loaded ? ", _plugin._isLoaded);
                }
            }
            catch(Exception e) {
                writeln("Plugin timeout error: ", e.msg);
            }
        }
    }

    private {
        Vm _vm;
        shared int _cycle;
        shared bool _isLoaded = false;
        TimeoutThread _timeout;
    }

    this(string name) {
        _timeout = new TimeoutThread(this);      
        _timeout.start();
        load(name);
    }

    void cleanup() {
        _vm.isRunning = false;
        _isLoaded = false;
        _timeout.isRunning = false;
        _timeout = null;
    }

    void load(string name) {
        auto bytecode = compileFile("plugin/pianoroll/pianoroll.gs");
        _vm = new Vm(bytecode);
    }

    void run() {
        _isLoaded = true;
        _vm.process();
        _cycle = _cycle + 1;
        if(!_vm.hasCoroutines) {
            _timeout.isRunning = false;
        }
    }
}