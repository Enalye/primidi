module primidi.ui.widget;

import primidi.render.window;
import primidi.core.all;
import primidi.common.all;

import primidi.ui.overlay;
import primidi.ui.modal;

interface IMainWidget {
	void onEvent(Event event);
}

class Widget {
	protected {
		Hint _hint;
		bool _isLocked = false, _isMovable = false, _isHovered = false, _isSelected = false, _isValidated = false, _hasFocus = false, _isInteractable = true;
		Vec2f _position = Vec2f.zero, _size = Vec2f.zero;
		float _angle = 0f;
		Widget _callbackWidget;
		string _callbackId;
	}

	@property {
		bool isLocked() const { return _isLocked; }
		bool isLocked(bool newIsLocked) { return _isLocked = newIsLocked; }

		bool isMovable() const { return _isMovable; }
		bool isMovable(bool newIsMovable) { return _isMovable = newIsMovable; }

		bool isHovered() const { return _isHovered; }
		bool isHovered(bool newIsHovered) { return _isHovered = newIsHovered; }

		bool isSelected() const { return _isSelected; }
		bool isSelected(bool newIsSelected) { return _isSelected = newIsSelected; }

		bool hasFocus() const { return _hasFocus; }
		bool hasFocus(bool newHasFocus) { return _hasFocus = newHasFocus; }

		bool isInteractable() const { return _isInteractable; }
		bool isInteractable(bool newIsSelectable) { return _isInteractable = newIsSelectable; }

		bool isValidated() const { return _isValidated; }
		bool isValidated(bool newIsValidated) { return _isValidated = newIsValidated; }

		ref Vec2f position() { return _position; }
		ref Vec2f position(Vec2f newPosition) { return _position = newPosition; }

		Vec2f size() const { return _size; }
		Vec2f size(Vec2f newSize) { return _size = newSize; }

		float angle() const { return _angle; }
		float angle(float newAngle) { return _angle = newAngle; }
	}

	this() {}

	bool isInside(const Vec2f pos) const {
		Vec2f halfSize = size * 0.5f;
		return (_position - pos).isBetween(-halfSize, halfSize);
	}

	bool isOnInteractableWidget(Vec2f pos) const {
		if(isInside(pos))
			return _isInteractable;
		return false;
	}

	void setHint(string title, string text = "") {
		_hint = makeHint(title, text);
	}

	void drawOverlay() {
		if(_isHovered && _hint !is null)
			openHintWindow(_hint);

		if(isDebug)
			drawRect(_position - _size / 2f, _size, Color.green);
	}

	void setCallback(string callbackId, Widget widget) {
		_callbackWidget = widget;
		_callbackId = callbackId;
	}

	protected void triggerCallback() {
		if(_callbackWidget !is null) {
			Event ev = EventType.Callback;
			ev.id = _callbackId;
			ev.widget = this;
			_callbackWidget.onEvent(ev);
		}
	}

	abstract void update(float deltaTime);
	abstract void onEvent(Event event);
	abstract void draw();
}

class WidgetGroup: Widget {
	protected {
		Vec2f _lastMousePos;
		bool _isGrabbed = false, _isChildGrabbed = false, _isChildHovered = false;
		uint _idChildGrabbed;
		bool _isFrame = false;
	}
		Widget[] _children;

	@property {
		alias isHovered = super.isHovered;
		override bool isHovered(bool hovered) {
			if(!hovered)
				foreach(Widget widget; _children)
					widget.isHovered = false;
			return _isHovered = hovered;
		}

		alias position = super.position;
		override ref Vec2f position(Vec2f newPosition) {
			if(!_isFrame) {
				Vec2f deltaPosition = newPosition - _position;
				foreach(widget; _children)
					widget.position += deltaPosition;
			}
			_position = newPosition;
			return _position;
		}

		const(Widget[]) children() const { return _children; }
		Widget[] children() { return _children; }
	}

	override void update(float deltaTime) {
		foreach(Widget widget; _children)
			widget.update(deltaTime);
	}
	
	override void onEvent(Event event) {
		switch (event.type) with(EventType) {
		case MouseDown:
			bool hasClickedWidget = false;
			foreach(uint id, Widget widget; _children) {
				widget.hasFocus = false;
				if(!widget.isInteractable)
					continue;

				if(!hasClickedWidget && widget.isInside(_isFrame ? getViewVirtualPos(event.position, _position) : event.position)) {
					widget.hasFocus = true;
					widget.isSelected = true;
					widget.isHovered = true;
					_isChildGrabbed = true;
					_idChildGrabbed = id;

					if(_isFrame)
						event.position = getViewVirtualPos(event.position, _position);
					widget.onEvent(event);
					hasClickedWidget = true;
				}
			}

			if(!_isChildGrabbed && _isMovable) {
				_isGrabbed = true;
				_lastMousePos = event.position;
			}
			break;
		case MouseUp:
			if(_isChildGrabbed) {
				_isChildGrabbed = false;
				_children[_idChildGrabbed].isSelected = false;

				if(_isFrame)
					event.position = getViewVirtualPos(event.position, _position);
				_children[_idChildGrabbed].onEvent(event);
			}
			else {
				_isGrabbed = false;
			}
			break;
		case MouseUpdate:
			Vec2f mousePosition = event.position;
			if(_isFrame)
				event.position = getViewVirtualPos(event.position, _position);

			_isChildHovered = false;
			foreach(uint id, Widget widget; _children) {
				if(isHovered) {
					widget.isHovered = widget.isInside(event.position);
					if(widget.isHovered && widget.isInteractable) {
						_isChildHovered = true;
						widget.onEvent(event);
					}
				}
				else
					widget.isHovered = false;
			}

			if(_isChildGrabbed && !_children[_idChildGrabbed].isHovered)
				_children[_idChildGrabbed].onEvent(event);
			else if(_isGrabbed && _isMovable) {
				Vec2f deltaPosition = (mousePosition - _lastMousePos);
				if(!_isFrame) {
					//Clamp the window in the screen
					if(isModal()) {
						Vec2f halfSize = _size / 2f;
						Vec2f clampedPosition = _position.clamp(halfSize, screenSize - halfSize);
						deltaPosition += (clampedPosition - _position);
					}
					_position += deltaPosition;

					foreach(widget; _children)
						widget.position = widget.position + deltaPosition;
				}
				else
					_position += deltaPosition;
				_lastMousePos = mousePosition;
			}
			break;
		case MouseWheel:
			foreach(uint id, Widget widget; _children) {
				if(widget.isHovered)
					widget.onEvent(event);
			}

			if(_isChildGrabbed && !_children[_idChildGrabbed].isHovered)
				_children[_idChildGrabbed].onEvent(event);
			break;
		case Callback:
			//We musn't propagate the callback further, so it's catched here.
			break;
		default:
			foreach(Widget widget; _children)
				widget.onEvent(event);
			break;
		}
	}

	override void draw() {
		foreach_reverse(Widget widget; _children)
			widget.draw();
	}

	override bool isOnInteractableWidget(Vec2f pos) const {
		if(!isInside(pos))
			return false;

		if(_isFrame)
			pos = getViewVirtualPos(pos, _position);
		
		foreach(const Widget widget; _children) {
			if(widget.isOnInteractableWidget(pos))
				return true;
		}
		return false;
	}

	void addChild(Widget widget) {
		_children ~= widget;
	}

	void removeChildren() {
		_children.length = 0uL;
	}

	void removeChild(uint id) {
		if(!_children.length)
			return;
		if(id + 1u == _children.length)
			_children.length --;
		else if(id == 0u)
			_children = _children[1..$];
		else
			_children = _children[0..id]  ~ _children[id + 1..$];
	}

	override void drawOverlay() {
		if(isDebug)
			drawRect(_position - _size / 2f, _size, Color.cyan);

		if(!_isHovered)
			return;

		if(_hint !is null)
			openHintWindow(_hint);

		foreach(widget; _children)
			widget.drawOverlay();
	}
}