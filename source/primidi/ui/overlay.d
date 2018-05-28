module primidi.ui.overlay;

import std.algorithm.comparison: max;

import primidi.core.all;
import primidi.render.all;
import primidi.common.all;

import primidi.ui.widget;
import primidi.ui.label;
import primidi.ui.text;

private {
	HintWindow _hintWindow;
	Hint _displayedHint;
	Widget[] _widgetsBackup;
	Widget[] _overlayWidgets;
	bool _isOverlay = false;
}

Hint makeHint(string title, string text) {
	return new Hint(title, text);
}

class Hint {
	string title, text;

	this(string newTitle, string newText) {
		title = newTitle;
		text = newText;
	}
}

void openHintWindow(Hint hint) {
	_displayedHint = hint;
}

void initializeOverlay() {
	_hintWindow = new HintWindow;
	_displayedHint = null;
}

bool isOverlay() {
	return _isOverlay;
}

void setOverlay(Widget widget) {
	if(!_isOverlay) {
		_isOverlay = true;
		_widgetsBackup = getWidgets();
		removeWidgets();
	}

	_overlayWidgets ~= widget;
	addWidget(widget);
}

void stopOverlay() {
	if(!_isOverlay)
		throw new Exception("No overlay to stop");
	_isOverlay = false;
	setWidgets(_widgetsBackup);
	_widgetsBackup.length = 0L;
	_overlayWidgets.length = 0L;
}

void processOverlayEvent(Event event) {
	foreach(widget; _overlayWidgets)
		widget.onEvent(event);
}

void processOverlayBack(float deltaTime) {
	foreach(widget; _widgetsBackup) {
		widget.update(deltaTime);	
		widget.draw();
	}
}

void processOverlayFront(float deltaTime) {
	_hintWindow.hint = _displayedHint;
	_hintWindow.update(deltaTime);
	_hintWindow.draw();
}

void endOverlay() {
	_displayedHint = null;
}

private class HintWindow: Widget {
	private {
		bool _isRendered;
	}
	Label title;
	Text text;

	@property void hint(Hint hint) {
		_isRendered = hint !is null;
		if(_isRendered) {
			title.text = hint.title;
			text.text = hint.text;
		}
	}

	this() {
		title = new Label;
		text = new Text;
	}

	override void onEvent(Event event) {}

	override void update(float deltaTime) {
		if(!_isRendered)
			return;
		_size = Vec2f(max(title.size.x, text.size.x) + 25f, title.size.y + text.size.y);
		_position = getMousePos() + _size / 2f + Vec2f(20f, 10f);
		title.position = _position + Vec2f(0f, (title.size.y - _size.y) / 2f);
		text.position = _position + Vec2f(0f, title.size.y + (text.size.y - _size.y) / 2f);
	}

	override void draw() {
		if(!_isRendered)
			return;
		drawFilledRect(_position - _size / 2f, _size, Color.white * .21f);
		drawFilledRect(_position - _size / 2f, Vec2f(_size.x, title.size.y), Color.white * .11f);
		title.draw();
		text.draw();
	}
}