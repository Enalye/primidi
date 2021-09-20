/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
import std.stdio, std.exception;

import primidi.menu, primidi.midi;

/// GC Configuration
extern (C) __gshared string[] rt_options = [
	"gcopt=initReserve:128 minPoolSize:256 parallel:2 profile:1"
];

void main(string[] args) {
	try {
		setupApplication(args);
	}
	catch (Exception e) {
		writeln(e.msg);
		foreach (trace; e.info) {
			writeln("at: ", trace);
		}
	}
}
