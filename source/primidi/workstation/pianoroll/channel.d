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

module primidi.workstation.pianoroll.channel;

import std.random;
import std.conv: to;
import std.math;
import std.stdio;
import std.algorithm.comparison;

import atelier;


import primidi.workstation.pianoroll.settings;
import primidi.workstation.pianoroll.pianoroll;

class Channel {
	Vec2f stepSize;
	Vec2u interval;
	Color color;
	bool isInstrument, hasSprite = false;
	float bounciness, speed;

	struct Note {
		uint tick;
		uint step;

		uint note;
		uint velocity;
	}

	Note[] notes;
	ubyte id;
	double tick;
	float noteOffset, noteCoef;
	float channelActivity = 0f;

	PianoRoll pianoRoll;
	Sprite noteSprite;
	ChannelParams params;

	void setInterval(int minNote, int maxNote) {
		params = channelsParams[id];
		int deltaNote;
		if(params.useAbsolutePos)
			deltaNote = 128;
		else {
			deltaNote = maxNote - minNote;
			if(deltaNote < 2)
				deltaNote = 2;
		}
		
		float minScreen = params.minPos, maxScreen = params.maxPos;
		noteCoef = (maxScreen - minScreen) / deltaNote;
		noteOffset = (maxNote * maxScreen - minNote * minScreen) / deltaNote;

		if(params.size != 0)
			stepSize = Vec2f(1f, params.size);
		else
			stepSize = Vec2f(1f, noteCoef);

		color = params.color;
		isInstrument = params.isInstrument;
		speed = params.speed;
		bounciness = params.bounciness;

		string spriteName = "chan" ~ to!string(id + 1) ~ "_note";
		if(canFetch!Sprite(spriteName)) {
			hasSprite = true;
			noteSprite = fetch!Sprite(spriteName);
		}
	}

	void update(double _tick) {
		tick = _tick;
	}

	void draw() {
		uint simultaneousNotes = 0u;
		float totalFactor = 0f;

		if(!notes.length || !params.isDisplayed)
			return;

		if(isInstrument) {
			foreach(Note note; notes) {
				float pitch = note.note * -noteCoef + noteOffset;

				if(tick > note.tick && tick < note.tick + note.step) {
					double factor = (tick - note.tick) / note.step;
					float sizeFactor = 1f + sin(factor * 2f * PI) * (0.00001f * (10f + note.step)) * bounciness;
					Vec2f position = Vec2f((note.tick - tick) / 8f * speed, pitch) * sizeFactor;
					Vec2f size = Vec2f(note.step * speed / 8f, 1f) * stepSize * sizeFactor;

					if(hasSprite) {
						noteSprite.size = size;
						noteSprite.color = lerp(Color.white, color, factor);
						noteSprite.draw(position + size / 2f);
					}
					else
						drawFilledRect(position, size, lerp(Color.white, color, factor));
					
					if(enableParticles)
						pianoRoll.addNoteParticle(pitch * sizeFactor, factor, lerp(Color.white, color, factor));

					channelActivity += (1f - factor / 1.5f) * note.velocity;
					totalFactor += factor;
					simultaneousNotes += 1u;
				}
				else {
					Vec2f position = Vec2f((note.tick - tick) / 8f * speed, pitch);
					Vec2f size = Vec2f(note.step * speed / 8f, 1f) * stepSize;

					if(hasSprite) {
						noteSprite.size = size;
						noteSprite.color = color;
						noteSprite.draw(position + size / 2f);
					}
					else
						drawFilledRect(position, size, color);
				}
			}
		}
		else {
			foreach(Note note; notes) {
				float pitch = note.note * -noteCoef + noteOffset;
				Vec2f position = Vec2f((note.tick - tick) / 8f * speed, pitch);

				if(hasSprite)
					noteSprite.scale = Vec2f.one * 0.4f;

				if(tick > (note.tick - 2) && tick < note.tick + 64) {
					double factor = lerp(0.8f, 0.4f, ((tick + 2f) - note.tick) / 64f);

					if(hasSprite) {
						noteSprite.scale = Vec2f.one * factor;
						noteSprite.color = lerp(color, Color.white, factor);
						noteSprite.draw(position);
					}
					else {
						drawFilledRect(position, Vec2f(10f, 1f) * stepSize, lerp(color, Color.white, factor));
					}

					if(enableParticles)
						pianoRoll.addNoteParticle(pitch, factor, lerp(color, Color.white, factor));

					channelActivity += (1f - factor / 1.5f) * note.velocity;
					totalFactor += factor;
					simultaneousNotes += 1u;
				}
				else {
					if(hasSprite) {
						noteSprite.color = color;
						noteSprite.draw(position);
					}
					else
						drawFilledRect(position, Vec2f(10f, 1f) * stepSize, color);
				}
			}
		}
		
		//Channel activity
		if(showChannelsIntensity) {
			if(simultaneousNotes)
				totalFactor /= simultaneousNotes;
			else
				totalFactor = 1f;

			float channelActivityWidth = screenWidth / 16f;
			float channelActivityHeight = min((channelActivity / 128f) + 15f, screenHeight / 4f);
			drawFilledRect(Vec2f(channelActivityWidth * id + channelActivityWidth / 2f - screenWidth / 2f, screenHeight - channelActivityHeight), Vec2f(channelActivityWidth / 15f, channelActivityHeight), lerp(Color.white, color, totalFactor));

			channelActivity /= 1.025f;
		}
	}
}