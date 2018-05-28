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

module primidi.workstation.pianoroll.scene;

import derelict.sdl2.sdl;

import primidi.common.all;
import primidi.workstation.pianoroll.settings;
import primidi.ui.all;
import primidi.render.all;
import primidi.core.all;
import primidi.workstation.pianoroll.pianoroll;
import primidi.workstation.common.all;
import primidi.workstation.pianoroll.background;
import primidi.workstation.pianoroll.loader;

class Scene : Widget {
	private {
		View _view;
		Playlist _playlist;
		Background _backgroundWidget;
		Loader _loaderWidget;
		PianoRoll _pianoRollWidget;
		Sprite _foregroundSprite;
		bool _isGuiLocked = false;
		bool _hasForegroundSprite = false;
	}

	this(string[] args) {
		_position = Vec2f(screenWidth / 2.0f, screenHeight / 2.0f);
		
		_playlist = new Playlist;
		loadSettings(args, _playlist);

		_pianoRollWidget = new PianoRoll;
		_loaderWidget = new Loader;
		_backgroundWidget = new Background;

		_loaderWidget.pianoRoll = _pianoRollWidget;
		_loaderWidget.playlist = _playlist;
		_backgroundWidget.pianoRoll = _pianoRollWidget;

		_view = new View(Vec2u(screenWidth, screenHeight));
		_view.position = Vec2f(0f, screenHeight / 2f);

		if(canFetch!Sprite("foreground")) {
			_hasForegroundSprite = true;
			_foregroundSprite = fetch!Sprite("foreground");
			_foregroundSprite.size = screenSize;
		}
	}

	override void onEvent(Event event) {
		if(event.type == EventType.FlushMusic)
			_playlist.flush();
		_backgroundWidget.onEvent(event);
		_loaderWidget.onEvent(event);
		_pianoRollWidget.onEvent(event);
		if(isAutoplayingNewMusics && event.type == EventType.AddMusic) {
			Event ev;
			ev.type = EventType.EndMusic;
			sendEvent(ev);
		}
	}

	override void update(float deltaTime) {
		pushView(_view, false);

		_backgroundWidget.update(deltaTime);
		_loaderWidget.update(deltaTime);
		_pianoRollWidget.update(deltaTime);

		if(isKeyDown("lock")) {
			_isGuiLocked = !_isGuiLocked;
			Event lockEvent;
			lockEvent.type = EventType.LockGUI;
			lockEvent.b = _isGuiLocked;
			sendEvent(lockEvent);
			showWindowCursor(!_isGuiLocked);
		}
		popView();
	}

	override void draw() {
		pushView(_view, true);
		_backgroundWidget.draw();
		_pianoRollWidget.draw();

		if(_hasForegroundSprite)
			_foregroundSprite.draw(Vec2f(0f, screenHeight / 2f));

		_loaderWidget.draw();

		popView();
		_view.draw(_position);
	}
}