module primidi.common.settings;

import primidi.core.all;

import primidi.common.application;
import primidi.common.resource;

uint screenWidth = 1280;
uint screenHeight = 720;
bool isDevBuild = true;
bool isDebug = false;
enum nominalFps = 60;

Vec2f screenSize, centerScreen;

void initializeSettings() {
	screenSize = Vec2f(screenWidth, screenHeight);
	centerScreen = screenSize / 2f;

	if(isDevBuild)
		loadResources("./");
	else
		loadResources("./");
}
