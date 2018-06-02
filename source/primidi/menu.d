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

import std.stdio: writeln;
import std.conv: to;

import grimoire;
import primidi.midi.all;
import primidi.workstation.all;

bool processArguments(string[] args) {
	if(args.length == 1)
		return false;
	string arg = args[1];
	if(arg.length == 0 || arg[0] != '-')
		return false;

	string legalString = "Primidi version #" ~ to!string(versionNumber) ~ " (C) 2016~2018 Enalye <enalyen@gmail.com>\nPrimidi is a free software and comes with ABSOLUTELY NO WARRANTY."
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
	initializeMidiOut();
	createApplication(Vec2u(1280u, 720u), "Primidi");
	onMainMenu(args);
	runApplication();
}

void onMainMenu(string[] args) {
	if(processArguments(args))
		return;

	addWidget(new MainPanel(args));

	/+auto scene = new Scene(args);
	auto taskBar = new TaskBar(Vec2f(screenWidth, 60f));
	taskBar.padding = Vec2f(11f, 0f);
	taskBar.capacity = 10;
	taskBar.position = Vec2f(screenWidth / 2f, -40f);
	auto btnStop = new ImgButton;
	auto btnNext = new ImgButton;
	auto btnRestart = new ImgButton;
	auto btnFullscreen = new ImgButton;

	btnStop.idleSprite = fetch!Sprite("stop");
	btnNext.idleSprite = fetch!Sprite("next");
	btnRestart.idleSprite = fetch!Sprite("restart");
	btnFullscreen.idleSprite = fetch!Sprite("fullscreen");

	btnStop.onClick = {
		Event event;
		event.type = EventType.FlushMusic;
		sendEvent(event);
		event.type = EventType.EndMusic;
		sendEvent(event);
	};

	btnNext.onClick = {
		Event event;
		event.type = EventType.EndMusic;
		sendEvent(event);
	};

	btnRestart.onClick = {
		Event event;
		event.type = EventType.RestartMusic;
		sendEvent(event);
	};

	btnFullscreen.onClick = {
		static bool isFullscreen = false;
		if(isFullscreen)
			setWindowFullscreen(Fullscreen.NoFullscreen);
		else			
			setWindowFullscreen(Fullscreen.DesktopFullscreen);
		isFullscreen = !isFullscreen;
	};

	taskBar.addChild(btnStop);
	taskBar.addChild(btnNext);
	taskBar.addChild(btnRestart);
	taskBar.addChild(btnFullscreen);
	
	windowClearColor = Color.black;
	addWidget(scene);
	addWidget(taskBar);+/
}

private class TaskBar: HLayout {
	Sprite barSprite;
	bool hideGui = false;

	this(Vec2f newSize) {
		super(newSize);
		barSprite = fetch!Sprite("taskbar");
		isLocked = true;
	}

	override void onEvent(Event event) {
		super.onEvent(event);
		//if(event.type == EventType.LockGUI)
		//	hideGui = event.b;
	}

	override void update(float deltaTime) {
		super.update(deltaTime);
		if(hideGui) {
			_position = Vec2f(screenWidth / 2f, -40f);
			resize();
			return;
		}
		if(deltaTime > 2f)
			deltaTime = 2f;
		deltaTime = (deltaTime * 60f) / nominalFps;
		if(getMousePos().y < 64f) {
			if(_position.y < 29f)
			_position = _position.lerp(Vec2f(screenWidth / 2f, 32f), deltaTime * 0.1f);
		}
		else if(_position.y > -39f) {
			_position = _position.lerp(Vec2f(screenWidth / 2f, -40f), deltaTime * 0.1f);	
		}
		resize();
	}

	override void draw() {
		barSprite.draw(_position);
		super.draw();
	}
}