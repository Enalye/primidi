module primidi.ui.button;

import std.conv: to;

import primidi.core.all;
import primidi.render.all;
import primidi.common.all;

import primidi.ui.widget;
import primidi.ui.label;

class Button: Widget {
	private bool _isPressed = false;
	void function() onClick;

	@property {
		bool isPressed() const { return _isPressed; }
	}

	override void update(float deltaTime) {
		if (!_isLocked) {
			if (!isButtonDown(1U))
				_isPressed = false;
		}
	}

	override void onEvent(Event event) {
		if (!_isLocked) {
			if (event.type == EventType.MouseDown)
				_isPressed = true;
			else if(event.type == EventType.MouseUp) {
				if(_isPressed) {
					if(onClick !is null)
						onClick();
					triggerCallback();
				}
				_isPressed = false;
			}
		}
	}
}

class ListButton: Button {
	private Sprite _sprite;
	Label label;

	@property {
		alias color = label.color;
		alias text = label.text;

		alias position = super.position;
		override ref Vec2f position(Vec2f newPosition) {
			_position = newPosition;
			reload();
			return _position;
		}

		alias size = super.size;
		override Vec2f size(Vec2f newSize) {
			_size = newSize;
			reload();
			return _position;
		}

		Sprite sprite() { return _sprite; }
		Sprite sprite(Sprite newSprite) {
			_sprite = newSprite;
			reload();
			return _sprite;
		}
	}

	this(string text) {
		label = new Label;
		label.text = text;
		_size = label.size;
	}

	this(Sprite newSprite) {
		label = new Label;
		_sprite = newSprite;
		reload();
	}

	this(string text, Sprite newSprite) {
		label = new Label;
		label.text = text;
		_size = label.size;
		_sprite = newSprite;
		reload();
	}

	override void update(float deltaTime) {
		super.update(deltaTime);
		label.position = _position;
	}

	override void draw() {
		if(_isValidated)
			drawFilledRect(_position - _size / 2f, _size, Color.white * 0.8f);
		else if(_isHovered)
			drawFilledRect(_position - _size / 2f, _size, Color.white * 0.25f);
		else
			drawFilledRect(_position - _size / 2f, _size, Color.white * 0.15f);

		if(sprite !is null)
			sprite.draw(_position);

		if(label.isLoaded)
			label.draw();
	}

	private void reload() {
		label.position = _position;
		if(_sprite !is null) {
			_sprite.fit(_size);
		}
	}
}

class TextButton: Button {
	Label label;

	@property {
		alias color = label.color;
		alias text = label.text;

		alias position = super.position;
		override ref Vec2f position(Vec2f newPosition) {
			_position = newPosition;
			label.position = _position;
			return _position;
		}
	}

	this(string text) {
		label = new Label;
		label.text = text;
		_size = label.size;
	}

	override void update(float deltaTime) {
		super.update(deltaTime);
		label.position = _position;
	}

	override void draw() {
		if(_isLocked)
			drawFilledRect(_position - _size / 2f, _size, Color.white * 0.055f);
		else if(_isPressed)
			drawFilledRect(_position - _size / 2f + (_isPressed ? 1f : 0f), _size, Color.white * 0.4f);
		else if(_isHovered)
			drawFilledRect(_position - _size / 2f + (_isPressed ? 1f : 0f), _size, Color.white * 0.25f);
		else
			drawFilledRect(_position - _size / 2f + (_isPressed ? 1f : 0f), _size, Color.white * 0.15f);
		if(label.isLoaded)
			label.draw();
	}
}

class ImgButton: Button {
	Label label;

	private {
		bool _isFixedSize, _isScaleLocked;
		Sprite _idleSprite, _hoveredSprite, _clickedSprite, _lockedSprite;
	}

	@property {
		alias color = label.color;
		alias text = label.text;

		alias size = super.size;
		override Vec2f size(Vec2f newSize) {
			_isFixedSize = true;
			_size = newSize;
			if(_idleSprite !is null)
				setToSize(_idleSprite);
			if(_hoveredSprite !is null)
				setToSize(_hoveredSprite);
			if(_clickedSprite !is null)
				setToSize(_clickedSprite);
			if(_lockedSprite !is null)
				setToSize(_lockedSprite);
			return _size;
		}

		bool isScaleLocked() { return _isScaleLocked; }
		bool isScaleLocked(bool newIsScaleLocked) {
			_isScaleLocked = newIsScaleLocked;
			if(_idleSprite !is null)
				setToSize(_idleSprite);
			if(_hoveredSprite !is null)
				setToSize(_hoveredSprite);
			if(_clickedSprite !is null)
				setToSize(_clickedSprite);
			if(_lockedSprite !is null)
				setToSize(_lockedSprite);
			return _isScaleLocked;
		}

		Sprite idleSprite() { return _idleSprite; }
		Sprite idleSprite(Sprite newSprite) {
			if(_isFixedSize)
				setToSize(newSprite);
			else
				_size = newSprite.size;
			return _idleSprite = newSprite;
		}

		Sprite hoveredSprite() { return _hoveredSprite; }
		Sprite hoveredSprite(Sprite newSprite) {
			if(_isFixedSize)
				setToSize(newSprite);
			else {
				if(_idleSprite is null)
					_size = newSprite.size;
			}
			return _hoveredSprite = newSprite;
		}

		Sprite clickedSprite() { return _clickedSprite; }
		Sprite clickedSprite(Sprite newSprite) {
			if(_isFixedSize)
				setToSize(newSprite);
			else {
				if(_idleSprite is null)
					_size = newSprite.size;
			}
			return _clickedSprite = newSprite;
		}

		Sprite lockedSprite() { return _lockedSprite; }
		Sprite lockedSprite(Sprite newSprite) {
			if(_isFixedSize)
				setToSize(newSprite);
			else {
				if(_idleSprite is null)
					_size = newSprite.size;
			}
			return _lockedSprite = newSprite;
		}
	}

	this() {
		label = new Label;
	}

	this(string text) {
		label = new Label;
		label.text = text;
		_size = label.size;
	}

	private void setToSize(Sprite sprite) {
		if(!_isFixedSize) 
			return;

		if(_isScaleLocked) {
			Vec2f clip = to!Vec2f(sprite.clip.zw);
			float scale;
			if(_size.x / _size.y > clip.x / clip.y)
				scale = _size.y / clip.y;
			else
				scale = _size.x / clip.x;
			sprite.size = clip * scale;
		}
		else
			sprite.size = _size;
	}

	override void update(float deltaTime) {
		super.update(deltaTime);
		label.position = _position;
	}

	override void draw() {
		if(_isLocked) {
			if(_lockedSprite !is null)
				_lockedSprite.drawUnchecked(_position);
			else if(_idleSprite !is null)
				_idleSprite.drawUnchecked(_position);
			else
				drawFilledRect(_position - _size / 2f, _size, Color.gray);
		}
		else if(_isPressed) {
			if(_clickedSprite !is null)
				_clickedSprite.drawUnchecked(_position);
			else if(_idleSprite !is null)
				_idleSprite.drawUnchecked(_position + Vec2f.one);
			else
				drawFilledRect(_position - _size / 2f + Vec2f.one, _size, Color.blue);
		}
		else if(_isHovered) {
			if(_hoveredSprite !is null)
				_hoveredSprite.drawUnchecked(_position);
			else if(_idleSprite !is null)
				_idleSprite.drawUnchecked(_position);
			else
				drawFilledRect(_position - _size / 2f, _size, Color.green);
		}
		else {
			if(_idleSprite !is null)
				_idleSprite.drawUnchecked(_position);
			else
				drawFilledRect(_position - _size / 2f, _size, Color.red);
		}
		if(label.isLoaded)
			label.draw();
	}
}

class MenuButton: ImgButton {
	float maxHoveredTime = 10f;
	
	private {
		float _hoveredTime = 0f;
		Vec2f _offset;
		Texture _texture;
	}

	this(string text) {
		super(text);

		idleSprite = fetch!Sprite("gui_menu_btn_idle");
		hoveredSprite = fetch!Sprite("gui_menu_btn_hovered");
		lockedSprite = fetch!Sprite("gui_menu_btn_locked");

		if(_idleSprite is null || _lockedSprite is null || _hoveredSprite is null)
			throw new Exception("Cannot create menu buttons: missing texture");

		_texture = _idleSprite.texture;
	}

	override void update(float deltaTime) {
		super.update(deltaTime);

		if(!_isLocked) {
			_hoveredTime += _isHovered ? deltaTime : -deltaTime;

			if(_hoveredTime > maxHoveredTime)
				_hoveredTime = maxHoveredTime;
			else if(_hoveredTime < 0f)
				_hoveredTime = 0f;
		}
		
		_offset = Vec2f(lerp(0f, 15f, _hoveredTime / maxHoveredTime), 0f);
		if(label.isLoaded)
			label.position = _position + _offset;
	}

	override void draw() {
		_texture.setAlpha(1f);
		if(_isLocked)
			_lockedSprite.drawUnchecked(_position);
		else {
			_idleSprite.drawUnchecked(_position + _offset);
			_texture.setAlpha(lerp(0f, 1f, _hoveredTime / maxHoveredTime));
			_hoveredSprite.drawUnchecked(_position + _offset);
		}
		if(label.isLoaded)
			label.draw();
	}
}