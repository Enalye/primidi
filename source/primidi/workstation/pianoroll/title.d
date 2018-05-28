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


module primidi.workstation.pianoroll.title;

import derelict.sdl2.sdl;

import primidi.common.all;
import primidi.core.all;
import primidi.render.all;
import primidi.ui.all;
import primidi.workstation.pianoroll.settings;

import std.stdio;

class Title {
	Sprite overlaySprite;
	Label titleLabel;
	Vec2f position;
	long startTime, currentTime;
	bool hasOverlaySprite = false;

	this(string name) {
		position = Vec2f(screenWidth, screenHeight / 2f);

		if(canFetch!Sprite("overlay")) {
			hasOverlaySprite = true;
			overlaySprite = fetch!Sprite("overlay");
			overlaySprite.texture.setColorMod(Color.black);
		}

		titleLabel = new Label;
		titleLabel.font = fetch!Font("font");
		titleLabel.position = position + Vec2f(0f, -150f);
		titleLabel.text = name;
		titleLabel.sprite.texture.setColorMod(Color.black, Blend.AdditiveBlending);

		startTime = SDL_GetTicks() + 1000;
	}

	void update(float deltaTime) {
		currentTime = SDL_GetTicks() - startTime;

		if(currentTime > 6000 || currentTime < 0)
			return;

		if(deltaTime > 1.1f)
			deltaTime = 1.1f;

		if(currentTime < 1500){
			//float factor = 0.5f * sin((currentTime / 2500f) * PI * sin((currentTime / 2500f) * PI));
			float factor = (currentTime / 3000f);
			position = Vec2f(screenWidth, screenHeight / 2f).lerp(Vec2f(screenWidth * -1f, screenHeight / 2f), factor);
			titleLabel.sprite.texture.setColorMod(lerp(Color.black, Color.white, factor * 2f), Blend.AdditiveBlending);
			titleLabel.position = Vec2f.zero.lerp(Vec2f(0f, 200f), factor * 2f);
		}
		else if(currentTime < 3000) {
			float factor = 0.5f * sin(0.5f * PI * sin(0.5f * PI));
			position = position.lerp(Vec2f(screenWidth * -1f, screenHeight / 2f).lerp(Vec2f(screenWidth, screenHeight / 2f), factor), deltaTime);
			titleLabel.sprite.texture.setColorMod(Color.white, Blend.AdditiveBlending);
			titleLabel.position = titleLabel.position + Vec2f(0f, deltaTime * 0.2f);
		}
		else {
			float factor = 0.5f * sin((currentTime / 6000f) * PI * sin((currentTime / 6000f) * PI));
			position = Vec2f(screenWidth * -1f, screenHeight / 2f).lerp(Vec2f(screenWidth, screenHeight / 2f), factor);
			titleLabel.sprite.texture.setColorMod(lerp(Color.white, Color.black, (currentTime - 3000) / 3000f), Blend.AdditiveBlending);
			titleLabel.position = titleLabel.position + Vec2f(0f, deltaTime * 0.1f);
		}
	}

	void draw() {
		if(currentTime > 6000 || currentTime < 0)
			return;

		if(hasOverlaySprite)
			overlaySprite.draw(position);
		if(showTitle)
			titleLabel.draw();
	}
}