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

module primidi.workstation.pianoroll.settings;

import std.path;
import std.json;
import std.file;
import std.conv;
import std.random;
import std.math;
import std.algorithm.comparison;
import std.algorithm: canFind;

import atelier;

import primidi.menu;
import primidi.workstation.common.all;

uint versionNumber = 2;

shared {
	string[] devices;
	float speedFactor, initialBpm;
	int tickOffset;
}

struct ChannelParams {
	Color color;
	float speed, size, minPos, maxPos, bounciness;
	bool isInstrument, isDisplayed, useAbsolutePos;
	string spriteName;
}

ChannelParams[16] channelsParams;

bool isSendingMidiEvents, showChannelsIntensity, showCentralBar,
	showTitle, isAutoplayingNewMusics, enableParticles;

void loadSettings(string[] args, Playlist playlist) {
	string dataDir = dirName(args[0]) ~ dirSeparator;
	loadData(dataDir);

	foreach(string fileName; args[1 .. $])
		playlist.add(fileName);
}

void loadData(string dataDir) {
	setWindowIcon(dataDir ~ "icon.bmp");

	string configFile = dataDir ~ "config.json";

	if(!exists(configFile))
		throw new Exception("The config file does not exist");

	//config.json
	auto configJson = parseJSON(readText(configFile));
	setWindowSize(Vec2u(getJsonInt(configJson, "width", screenWidth), getJsonInt(configJson, "height", screenHeight)));
	devices = cast(shared(string[]))getJsonArrayStr(configJson, "midi-devices", []);
	isSendingMidiEvents = getJsonBool(configJson, "send-midi-events", true);
	isAutoplayingNewMusics = getJsonBool(configJson, "autoplay-new-musics", false);
	//app.fps = getJsonInt(configJson, "fps", 60);
	speedFactor = getJsonFloat(configJson, "speed", 1f);
	initialBpm = getJsonFloat(configJson, "start-bpm", 120f);
	tickOffset = getJsonInt(configJson, "start-offset", 1000);

	string skinFolder = dataDir  ~ "data" /+~ dirSeparator ~ getJsonStr(configJson, "skin")+/ ~ dirSeparator;
	string skinFile = skinFolder ~ "skin.json";

	if(!exists(skinFile))
		throw new Exception("The skin file does not exist");

	//skin.json
	auto skinJson = parseJSON(readText(skinFile));
	//archive = new Archive;
	//archive.fontSize = getJsonInt(skinJson, "font-size", 50);
	enableParticles = getJsonBool(skinJson, "enable-particles", true);
	showCentralBar = getJsonBool(skinJson, "show-central-bar", true);
	showTitle = getJsonBool(skinJson, "show-title", true);
	showChannelsIntensity = getJsonBool(skinJson, "show-channels-intensity", true);

	//Load the required skin files
	/+archive.load(skinFolder);

	//Sprites
	foreach(string spriteName; ["background", "foreground", "loading", "overlay",
		"taskbar", "stop", "next", "restart", "fullscreen", "cursor"]) {
		if((spriteName in skinJson.object) is null) {
			if(["background", "foreground", "loading", "overlay", "cursor"].canFind(spriteName))
				continue;
			throw new Exception("No definition for \"" ~ spriteName ~ "\" in skin.json");
		}
		JSONValue spriteObject = skinJson.object[spriteName];
		Sprite sprite = new Sprite(archive.getTexture(getJsonStr(spriteObject, "texture")));
		sprite.clip.x = getJsonInt(spriteObject, "x", sprite.clip.x);
		sprite.clip.y = getJsonInt(spriteObject, "y", sprite.clip.y);
		sprite.clip.w = getJsonInt(spriteObject, "w", sprite.clip.w);
		sprite.clip.h = getJsonInt(spriteObject, "h", sprite.clip.h);
		sprite.size = to!Vec2f(sprite.clip.wh);
		archive.loadSprite(spriteName, sprite);
	}+/

	//cursor
	/+if(archive.hasSprite("cursor")) {
		Sprite cursorSprite = archive.getSprite("cursor");
		cursorSprite.size = Vec2f(32f, 32f);
		setWindowCursor(cursorSprite);
	}+/

	//Per channels settings
	foreach(ushort id; 0 .. 16) {
		ChannelParams params;
		string channelName = "chan" ~ to!string(id + 1u);
		bool isDisplayed;
		bool isIntrument;
		int[] color;
		float speed;
		float bounciness;
		int size, minPos, maxPos;
		bool useAbsolutePos;

		//If the channel is defined
		if(channelName in skinJson.object) {
			JSONValue channelObject = skinJson.object[channelName];
			if(channelObject.type() != JSON_TYPE.OBJECT)
				continue;

			isDisplayed = getJsonBool(channelObject, "is-displayed", true);
			isIntrument = getJsonBool(channelObject, "is-instrument", id != 9);
			color = getJsonArrayInt(channelObject, "color", []);
			speed = getJsonFloat(channelObject, "speed", 1f);
			bounciness = getJsonFloat(channelObject, "bounciness", 1f);
			size = getJsonInt(channelObject, "size", 0);
			minPos = getJsonInt(channelObject, "min-pos", 0);
			maxPos = getJsonInt(channelObject, "max-pos", screenHeight);
			useAbsolutePos = getJsonBool(channelObject, "use-absolute-pos", false);

			/+if("sprite" in channelObject.object) {
				JSONValue spriteObject = channelObject.object["sprite"];
				if(spriteObject.type() == JSON_TYPE.OBJECT) {
					Sprite sprite = new Sprite(archive.getTexture(getJsonStr(spriteObject, "texture")));
					sprite.clip.x = getJsonInt(spriteObject, "x", sprite.clip.x);
					sprite.clip.y = getJsonInt(spriteObject, "y", sprite.clip.y);
					sprite.clip.w = getJsonInt(spriteObject, "w", sprite.clip.w);
					sprite.clip.h = getJsonInt(spriteObject, "h", sprite.clip.h);
					sprite.size = to!Vec2f(sprite.clip.wh);
					archive.loadSprite(channelName ~ "_note", sprite);
				}
			}+/
		}
		if(!color.length)
			params.color = Color(uniform(0.25f, 0.8f), uniform(0.25f, 0.8f), uniform(0.25f, 0.8f));
		else
			params.color = Color(min(color[0], 255) / 255f, min(color[1], 255) / 255f, min(color[2], 255) / 255f);

		params.speed = speed;
		params.bounciness = bounciness;
		params.isInstrument = isIntrument;
		params.isDisplayed = isDisplayed;
		params.size = size;
		params.minPos = minPos;
		params.maxPos = maxPos;
		params.useAbsolutePos = useAbsolutePos;
		channelsParams[id] = params;
	}
}