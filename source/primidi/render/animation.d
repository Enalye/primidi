module primidi.render.animation;

import std.conv;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

import primidi.common.all;
import primidi.core.all;

import primidi.render.window;
import primidi.render.texture;
import primidi.render.drawable;
import primidi.render.tileset;

class Animation: IDrawable {
	private {
		Tileset _tileset;
		Timer _timer;
	}

	@property {
		Vec2f scale() const { return _tileset.scale; }
		Vec2f scale(Vec2f newScale) { return _tileset.scale = newScale; }

		float angle() const { return _tileset.angle; }
		float angle(float newAngle) { return _tileset.angle = newAngle; }

		Flip flip() const { return _tileset.flip; }
		Flip flip(Flip newFlip) { return _tileset.flip = newFlip; }

		Vec2f anchor() const { return _tileset.anchor; }
		Vec2f anchor(Vec2f newAnchor) { return _tileset.anchor = newAnchor; }

		Vec2f tileSize() const { return _tileset.tileSize; }

		bool isRunning() const { return _timer.isRunning; }
		float time() const { return _timer.time; }

		alias duration = _timer.duration;
		alias mode = _timer.mode;
	}

	this(string tilesetName, TimeMode newMode = TimeMode.Once) {
		_tileset = fetch!Tileset(tilesetName);
		_timer.mode = newMode;
	}

	void update(float deltaTime) {
		_timer.update(deltaTime);
	}
	
	void draw(const Vec2f position) const {
		_tileset.drawRotated(_timer, position);
	}
}