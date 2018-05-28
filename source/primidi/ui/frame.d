module primidi.ui.frame;

import std.conv;

import primidi.core.all;
import primidi.common.all;
import primidi.render.sprite;
import primidi.render.view;
import primidi.render.window;

import primidi.ui.widget;

class Frame: WidgetGroup {
	protected View _view;
	bool clearRenderer = true;
	
	@property {
		alias position = super.position;
		override ref Vec2f position(Vec2f newPosition) {
			_position = newPosition;
			_view.position = _position;
			return _position;
		}

		alias size = super.size;
		override Vec2f size(Vec2f newSize) {
			_size = newSize;
			_view.position = _position;
			return _position;
		}

		View view() { return _view; }
		View view(View newView) { return _view = newView; }
	}

	this(Vec2u newSize) {
		_view = new View(newSize);
		_size = to!Vec2f(newSize);
		_isFrame = true;
	}

	this(View newView) {
		_view = newView;
		_isFrame = true;
	}
	
	override void onEvent(Event event) {
		pushView(_view, false);
		super.onEvent(event);
		popView();
	}

	override void draw() {
		pushView(_view, clearRenderer);
		super.draw();
		popView();
		_view.draw(_position);
	}
}