/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
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
    setWindowClearColor(Color.black);

    if(processArguments(args))
		return;
    onStartupLoad(&onLoadComplete);

	runApplication();
    destroyApplication();
}

private MainGui _mainGui;
void onLoadComplete() {
    setDefaultFont(fetch!TrueTypeFont("Cascadia"));
	_mainGui = new MainGui;
	onMainMenu();
}

void onMainMenu() {
	removeRootGuis();
	addRootGui(_mainGui);
}