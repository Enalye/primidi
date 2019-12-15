/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
import std.stdio, std.exception;

import primidi.menu, primidi.midi;

void main(string[] args) {
	try {
		setupApplication(args);
	}
	catch(Exception e) {
		writeln(e.msg);
		foreach(trace; e.info) {
			writeln("at: ", trace);
		}
	}
}
