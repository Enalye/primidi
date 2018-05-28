module primidi.ui.checkbox;

import std.conv: to;

import primidi.core.all;
import primidi.common.all;
import primidi.render.sprite;

import primidi.ui.widget;

class Checkbox: Widget {
	bool isChecked = false;

	private {
		Sprite _uncheckedSprite, _checkedSprite;
	}

	@property {
		Sprite uncheckedSprite() { return _uncheckedSprite; }
		Sprite uncheckedSprite(Sprite newSprite) {
			_uncheckedSprite = newSprite;
			_uncheckedSprite.fit(_size);
			return _uncheckedSprite;
		}

		Sprite checkedSprite() { return _checkedSprite; }
		Sprite checkedSprite(Sprite newSprite) {
			_checkedSprite = newSprite;
			_checkedSprite.fit(_size);
			return _checkedSprite;
		}
	}

	this() {
		uncheckedSprite(fetch!Sprite("gui_unchecked"));
		checkedSprite(fetch!Sprite("gui_checked"));
	}

	@property {
		alias size = super.size;
		override Vec2f size(Vec2f newSize) {
			_size = newSize;
			_uncheckedSprite.fit(_size);
			_checkedSprite.fit(_size);
			return _size;
		}
	}

	override void update(float deltaTime) {}
	
	override void onEvent(Event event) {
		if(!isLocked) {
			if(event.type == EventType.MouseUp)
				isChecked = !isChecked;
		}
	}

	override void draw() {
		if(isChecked)
			_checkedSprite.draw(_position);
		else
			_uncheckedSprite.draw(_position);
	}
}