/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
import std.stdio;

import primidi.menu, primidi.midi;

void main(string[] args) {
	try {
		setupApplication(args);
	}
	catch(Exception e) {
		writeln(e.msg);
	}
    catch(Error e) {
        //We need to clean up the remaining threads.
        stopMidiClock();
        stopMidiOutSequencer();
		closeMidiDevices();
        throw e;
    }
}
