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

module primidi.workstation.pianoroll.loader;

import std.path;
import std.conv: to;
import std.stdio: writeln;

import derelict.sdl2.sdl;
import grimoire;

import primidi.workstation.pianoroll.settings;

import primidi.workstation.pianoroll.pianoroll;
import primidi.workstation.common.all;

class Loader : Widget {
	private {
		enum State {
			FadeIn, FadeOut, NoFade
		}

		Label _titleLabel;
		Sprite _backgroundSpriteLeft, _backgroundSpriteRight;
		ulong _startTime;
		Vec2f _positionLeft, _positionRight;
		State _state = State.NoFade;
		bool _isPlaying = false, _isRestarting = false, _hasLoadingSprite = false;
		string _lastMusicPlayed;
	}

	PianoRoll pianoRoll;
	Playlist playlist;
	
	this() {
		_position = Vec2f(screenWidth / 2.0f, screenHeight / 2.0f);

		if(canFetch!Sprite("loading_left")) {
			_hasLoadingSprite = true;
			_backgroundSpriteLeft = fetch!Sprite("loading_left");
			/+_backgroundSpriteLeft.clip.z = _backgroundSpriteLeft.clip.z >> 1u;
			_backgroundSpriteLeft.size = to!Vec2f(_backgroundSpriteLeft.clip.zw);+/
			_backgroundSpriteRight = fetch!Sprite("loading_right");
			/+_backgroundSpriteRight.clip.x = _backgroundSpriteRight.clip.z >> 1u;
			_backgroundSpriteRight.clip.z = _backgroundSpriteRight.clip.z >> 1u;
			_backgroundSpriteRight.size = to!Vec2f(_backgroundSpriteRight.clip.zw);+/
		}

		_titleLabel = new Label;
		_titleLabel.font = fetch!Font("font");
		_titleLabel.position = Vec2f(0f, screenHeight / 3f);
		_titleLabel.sprite.texture.setColorMod(Color.white, Blend.AdditiveBlending);
		_titleLabel.text = "Primidi";

		version(Windows)
			_titleLabel.text = "Primidi";

		_positionLeft = Vec2f(screenWidth * -0.25f, screenHeight / 2f);
		_positionRight = Vec2f(screenWidth * 0.25f, screenHeight / 2f);
	}

	void startFadeIn() {
		if(_state == State.FadeIn)
			return;

		_startTime = SDL_GetTicks();
		_state = State.FadeIn;
	}

	void startFadeOut() {
		if(_state == State.FadeOut)
			return;

		_startTime = SDL_GetTicks();
		_state = State.FadeOut;
	}

	override void onEvent(Event event) {
		/+switch(event.type) with(EventType) {
		case RestartMusic:
			if(_isPlaying) {
				_isPlaying = false;
				_isRestarting = true;
				startFadeOut();
			}
			break;
		case AddMusic:
			writeln("Added ", event.str);
			playlist.add(event.str);
			break;
		case EndMusic:
			if(_isPlaying) {
				_isPlaying = false;
				startFadeOut();
			}
			break;
		case StartMusic:
			writeln("Now playing ", event.str);
			setWindowTitle("Primidi - " ~ baseName(event.str, ".mid"));
			startFadeIn();
			break;
		default:
			break;
		}+/
	}

	override void update(float deltaTime) {
		ulong time = SDL_GetTicks() - _startTime;

		final switch(_state) with(State) {
		case FadeIn:
			if(time > 1000f) {
				if(!_hasLoadingSprite)
					return;
				_titleLabel.position = Vec2f(-screenWidth, -screenHeight);
				_positionLeft = Vec2f(screenWidth * -1f, screenHeight / 2f);
				_positionRight = Vec2f(screenWidth * 1f, screenHeight / 2f);
				return;
			}
			if(_hasLoadingSprite && time > 500f) {
				float factor = (time - 500f) / 500f;
				_positionLeft = Vec2f(screenWidth * -0.25f, screenHeight / 2f).lerp(Vec2f(screenWidth * -1f, screenHeight / 2f), factor);
				_positionRight = Vec2f(screenWidth * 0.25f, screenHeight / 2f).lerp(Vec2f(screenWidth * 1f, screenHeight / 2f), factor);
				_titleLabel.sprite.texture.setColorMod(lerp(Color.white, Color.black, factor), Blend.AdditiveBlending);
			}
			if(_hasLoadingSprite && time > 900f)
				_titleLabel.position = Vec2f(-screenWidth, -screenHeight);
			break;
		case FadeOut:
			if(time > 2000f) {
				_state = State.NoFade;
				return;
			}

			if(_hasLoadingSprite && time > 1000f) {
				_positionLeft = Vec2f(screenWidth * -0.25f, screenHeight / 2f);
				_positionRight = Vec2f(screenWidth * 0.25f, screenHeight / 2f);
			}
			else if(_hasLoadingSprite && time > 500f) {
				float factor = (time - 500f) / 500f;
				_positionLeft = Vec2f(screenWidth * -1f, screenHeight / 2f).lerp(Vec2f(screenWidth * -0.25f, screenHeight / 2f), factor);
				_positionRight = Vec2f(screenWidth * 1f, screenHeight / 2f).lerp(Vec2f(screenWidth * 0.25f, screenHeight / 2f), factor);
			}
			break;
		case NoFade:
			if(_hasLoadingSprite) {
				_positionLeft = Vec2f(screenWidth * -0.25f, screenHeight / 2f);
				_positionRight = Vec2f(screenWidth * 0.25f, screenHeight / 2f);
			}

			/+if(!_isPlaying && _isRestarting) {
				Event event;
				event.type = EventType.LoadMusic;
				_isRestarting = false;
				event.str = _lastMusicPlayed;
				_isPlaying = true;
				sendEvent(event);
			}
			else if(!_isPlaying && playlist.isReady()) {
				Event event;
				event.type = EventType.LoadMusic;
				_lastMusicPlayed = playlist.getNext();
				event.str = _lastMusicPlayed;
				_isPlaying = true;
				sendEvent(event);
			}+/
			break;
		}
	}

	override void draw() {
		if(!_hasLoadingSprite)
			return;
		_backgroundSpriteLeft.draw(_positionLeft);
		_backgroundSpriteRight.draw(_positionRight);
		_titleLabel.draw();
	}
}