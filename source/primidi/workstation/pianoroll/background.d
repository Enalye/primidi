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

module primidi.workstation.pianoroll.background;

import std.stdio;
import std.algorithm.comparison;


import grimoire;

import primidi.workstation.pianoroll.settings;
import primidi.workstation.pianoroll.pianoroll;

class Background: Widget {
	Sprite backgroundSprite;
	float lastBpm = 0f, currentBpm = 0f, bpmFactor = 0f;
	ulong lastTime = 0uL;
	PianoRoll pianoRoll;
	bool hasBackgroundSprite = false;

	this() {
		_position = Vec2f(screenWidth / 2.0f, screenHeight / 2.0f);

		if(canFetch!Sprite("background")) {
			hasBackgroundSprite = true;
			backgroundSprite = fetch!Sprite("background");
		}
	}

	override void onEvent(Event event) {}

	override void update(float deltaTime) {
		if(!hasBackgroundSprite)
			return;

		currentBpm = pianoRoll.currentBpm;
		lastBpm = lerp(lastBpm, currentBpm, deltaTime * 0.15f);
		if(currentBpm > (lastBpm + 0.1f))
			bpmFactor = lerp(bpmFactor, 1f, deltaTime * 0.01f);
		else if(currentBpm < (lastBpm - 0.1f))
			bpmFactor = lerp(bpmFactor, -1f, deltaTime * 0.01f);
		else
			bpmFactor = lerp(bpmFactor, 0f, deltaTime * 0.001f);

		if(bpmFactor > 0f)
			backgroundSprite.texture.setColorMod(lerp(Color.silver, Color.gray, clamp(bpmFactor, 0f, 1f)));
		else
			backgroundSprite.texture.setColorMod(lerp(Color.silver, Color.white, clamp(-bpmFactor, 0f, 1f)));
	}

	override void draw() {
		if(!hasBackgroundSprite)
			return;
		backgroundSprite.draw(Vec2f(0f, screenHeight / 2));
	}
}