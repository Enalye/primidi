module primidi.ui.image;

import primidi.core.vec2;
import primidi.render.sprite;
import primidi.common.all;

import primidi.ui.widget;

class Image: Widget {
	Sprite sprite;

	@property {
		alias angle = super.angle;
		override float angle(float newAngle) {
			sprite.angle = newAngle;
			return _angle = newAngle;
		}

		alias size = super.size;
		override Vec2f size(Vec2f newSize) {
			sprite.size = newSize;
			return _size = newSize;
		}
	}

	this(Sprite newSprite) {
		sprite = newSprite;
		_size = sprite.size;
		_angle = sprite.angle;
	}

	override void onEvent(Event event) {

	}

	override void update(float deltaTime) {

	}

	override void draw() {
		sprite.drawUnchecked(_position);
	}
}