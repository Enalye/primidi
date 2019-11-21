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

module primidi.menu;

import std.stdio, std.conv;
import atelier, grimoire, minuit;
import primidi.loader, primidi.midi, primidi.gui, primidi.script;

enum versionNumber = 0;
bool processArguments(string[] args) {
	if(args.length == 1)
		return false;
	string arg = args[1];
	if(arg.length == 0 || arg[0] != '-')
		return false;

	string legalString = "Primidi version #" ~ to!string(versionNumber) ~ " (C) 2016~2019 Enalye <enalyen@gmail.com>\nPrimidi is a free software and comes with ABSOLUTELY NO WARRANTY."
	;
	switch(arg) {
	case "-v":
	case "--version":
		writeln(legalString, "\n\nPrimidi build #", versionNumber);
		break;
	case "-h":
	case "--help":
		writeln(legalString, "

Usage:
 primidi [option]
 primidi filename [filename...]

Options:
 -h or --help		Display this help
 -v or --versions 	Display the version number"
 		);
		break;
	default:
		writeln(legalString, "\n\nInvalid option. Try \'primidi -h\' or \'primidi --help\' for additional help.");
		break;
	}
	return true;
}

void setupApplication(string[] args) {
	enableAudio(false);
	initializeMidiDevices();
	createApplication(Vec2u(1280u, 720u), "Primidi");

	setWindowMinSize(Vec2u(500, 200));
    setWindowClearColor(Color.white);

    if(processArguments(args))
		return;
    onStartupLoad(&onLoadComplete);

	runApplication();
    destroyApplication();
}

private MainGui _mainGui;
void onLoadComplete() {
    setDefaultFont(fetch!TrueTypeFont("VeraMono"));
	_mainGui = new MainGui;
	onMainMenu();
}

void onMainMenu() {
	removeRootGuis();
	addRootGui(_mainGui);
}