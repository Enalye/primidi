module primidi.render.tileset;

import std.conv;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

import primidi.core.all;
import primidi.render.window;
import primidi.render.texture;
import primidi.render.sprite;
import primidi.render.drawable;

class Tileset {
	private {
		Texture _texture;
		Vec2i _grid, _tileSize;
		int _nbTiles;
	}

	@property {
		Texture texture() const { return cast(Texture)_texture; }
		bool isLoaded() const { return _texture.isLoaded; }
		Color color(const Color newColor) { _texture.setColorMod(newColor); return newColor; };
		Vec2f tileSize() const { return cast(Vec2f)_tileSize; }
	}

	Vec2f scale = Vec2f.one;
	float angle = 0f;
	Flip flip = Flip.NoFlip;
	Vec2f anchor = Vec2f.half;

	this(Texture newTexture, Vec2i grid, Vec2i tileSize) {
		_texture = newTexture;
		_grid = grid;
		_tileSize = tileSize;
		_nbTiles = _grid.x * _grid.y;
	}

	Sprite[] asSprites() {
		Sprite[] sprites;
		foreach(id; 0.. _nbTiles) {
			Vec2i coord = Vec2i(id % _grid.x, id / _grid.x);
			Vec4i clip = Vec4i(coord.x * _tileSize.x, coord.y * _tileSize.y, _tileSize.x, _tileSize.y);
			auto sprite = new Sprite(_texture, clip);
			sprites ~= sprite;
		}
		return sprites;
	}

	void drawRotated(Timer timer, const Vec2f position) const {
		float id = floor(lerp(0f, to!float(_nbTiles), timer.time));
		drawRotated(to!uint(id), position);
	}

	void drawRotated(uint id, const Vec2f position) const {
		if(id >= _nbTiles)
			return;

		Vec2i coord = Vec2i(id % _grid.x, id / _grid.x);
		if(coord.y > _grid.y)
			throw new Exception("Tileset id out of bounds");

		Vec2f finalSize = scale * cast(Vec2f)(_tileSize) * getViewScale();
		Vec2f dist = (anchor - Vec2f.half).rotated(angle) * cast(Vec2f)(_tileSize) * scale;

		Vec4i clip = Vec4i(coord.x * _tileSize.x, coord.y * _tileSize.y, _tileSize.x, _tileSize.y);
		if (isVisible(position, finalSize)) {
			_texture.draw(getViewRenderPos(position - dist), finalSize, clip, angle, flip);
		}
	}

	void draw(Timer timer, const Vec2f position) const {
		float id = floor(lerp(0f, to!float(_nbTiles), timer.time));
		draw(to!uint(id), position);
	}

	void draw(uint id, const Vec2f position) const {
		if(id >= _nbTiles)
			return;

		Vec2f finalSize = scale * to!Vec2f(_tileSize) * getViewScale();
		Vec2i coord = Vec2i(id % _grid.x, id / _grid.x);
		if(coord.y > _grid.y)
			throw new Exception("Tileset id out of bounds");
		Vec4i clip = Vec4i(coord.x * _tileSize.x, coord.y * _tileSize.y, _tileSize.x, _tileSize.y);
		if (isVisible(position, finalSize)) {
			_texture.draw(getViewRenderPos(position), finalSize, clip, angle, flip, anchor);
		}
	}
}