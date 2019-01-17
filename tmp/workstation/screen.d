module primidi.workstation.screen;

import atelier;

//Temp
import primidi.workstation.common.all;
import primidi.workstation.pianoroll.settings;
import primidi.workstation.pianoroll.pianoroll;
import primidi.workstation.pianoroll.background;
import primidi.workstation.pianoroll.loader;

class MidiScreen: Widget {
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

	this(string[] args, Playlist playlist) {
		position(Vec2f(screenWidth / 2.0f, screenHeight / 2.0f));
		size(screenSize / 2f);
		
		_playlist = playlist;
		loadSettings(args, _playlist);

		_pianoRollWidget = new PianoRoll;
		_loaderWidget = new Loader;
		_backgroundWidget = new Background;

		_loaderWidget.pianoRoll = _pianoRollWidget;
		_loaderWidget.playlist = _playlist;
		_backgroundWidget.pianoRoll = _pianoRollWidget;

		_view = new View(_size);
		_view.position = Vec2f(0f, screenHeight / 2f);
		_view.size = screenSize;

		if(canFetch!Sprite("foreground")) {
			_hasForegroundSprite = true;
			_foregroundSprite = fetch!Sprite("foreground");
			_foregroundSprite.size = screenSize;
		}
	}

	override void onEvent(Event event) {
		/+if(event.type == EventType.FlushMusic)
			_playlist.flush();
		_backgroundWidget.onEvent(event);
		_loaderWidget.onEvent(event);
		_pianoRollWidget.onEvent(event);
		if(isAutoplayingNewMusics && event.type == EventType.AddMusic) {
			Event ev;
			ev.type = EventType.EndMusic;
			sendEvent(ev);
		}+/
	}

	override void update(float deltaTime) {
		pushView(_view, false);

		_backgroundWidget.update(deltaTime);
		_loaderWidget.update(deltaTime);
		_pianoRollWidget.update(deltaTime);

		if(isKeyDown("lock")) {
			_isGuiLocked = !_isGuiLocked;
			/+Event lockEvent;
			lockEvent.type = EventType.LockGUI;
			lockEvent.b = _isGuiLocked;
			sendEvent(lockEvent);+/
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