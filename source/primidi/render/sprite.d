module primidi.render.sprite;

import std.conv;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

import primidi.core.all;
import primidi.render.window;
import primidi.render.texture;
import primidi.render.drawable;

class Sprite: IDrawable {
	private {
		Texture _texture;
	}

	@property {
		Texture texture() const { return cast(Texture)_texture; }
		bool isLoaded() const { return _texture.isLoaded; }
		Color color(const Color newColor) { _texture.setColorMod(newColor); return newColor; };
		Vec2f center() const { return anchor * size * scale; }
	}

	Flip flip = Flip.NoFlip;
	Vec2f scale = Vec2f.one, size = Vec2f.zero, anchor = Vec2f.half;
	Vec4i clip;
	float angle = 0f;

	this() {}

	this(Texture newTexture, Flip newFlip = Flip.NoFlip) {
		_texture = newTexture;
		clip = Vec4i(0, 0, _texture.width, _texture.height);
		size = to!Vec2f(clip.zw);
		flip = newFlip;
	}

	this(Texture newTexture, Vec4i newClip, Flip newFlip = Flip.NoFlip) {
		_texture = newTexture;
		clip = newClip;
		size = to!Vec2f(clip.zw);
		flip = newFlip;
	}
	
	this(const Sprite sprite) {
		_texture = sprite.texture;
		clip = sprite.clip;
		size = sprite.size;
		angle = sprite.angle;
		scale = sprite.scale;
		anchor = sprite.anchor;
		flip = sprite.flip;
	}

	Sprite opAssign(Texture texture) {
		_texture = texture;
		clip = Vec4i(0, 0, _texture.width, _texture.height);
		size = to!Vec2f(clip.zw);
		return this;
	}

	void fit(Vec2f newSize) {
		size = to!Vec2f(clip.zw).fit(newSize);
	}

	void draw(const Vec2f position) const {
		Vec2f finalSize = size * scale * getViewScale();
		if (isVisible(position, finalSize)) {
			_texture.draw(getViewRenderPos(position), finalSize, clip, angle, flip, anchor);
		}
	}

	void drawUnchecked(const Vec2f position) const {
		Vec2f finalSize = size * scale * getViewScale();
		_texture.draw(getViewRenderPos(position), finalSize, clip, angle, flip, anchor);
	}
	
	void drawRotated(const Vec2f position) const {
		Vec2f finalSize = size * scale * getViewScale();
		Vec2f dist = (anchor - Vec2f.half) * size * scale;
		dist.rotate(angle);
		_texture.draw(getViewRenderPos(position - dist), finalSize, clip, angle, flip);
	}

	void draw(const Vec2f pivot, float pivotDistance, float pivotAngle) const {
		Vec2f finalSize = size * scale * getViewScale();
		_texture.draw(getViewRenderPos(pivot + Vec2f.angled(pivotAngle) * pivotDistance), finalSize, clip, angle, flip, anchor);
	}

	void draw(const Vec2f pivot, const Vec2f pivotOffset, float pivotAngle) const {
		Vec2f finalSize = size * scale * getViewScale();
		_texture.draw(getViewRenderPos(pivot + pivotOffset.rotated(pivotAngle)), finalSize, clip, angle, flip, anchor);
	}

	bool isInside(const Vec2f position) const {
		Vec2f halfSize = size * scale * getViewScale() * 0.5f;
		return position.isBetween(-halfSize, halfSize);
	}
}