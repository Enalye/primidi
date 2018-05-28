module primidi.ui.list.gridlist;

import std.conv: to;

import primidi.core.all;
import primidi.render.all;
import primidi.common.all;

import primidi.ui.widget;
import primidi.ui.layout;
import primidi.ui.slider;

private class GridContainer: WidgetGroup {
	public {
		View view;
		GridLayout layout;
	}

	this(Vec2f size) {
		createGui(size);
	}

	override void onEvent(Event event) {
		pushView(view, false);
		super.onEvent(event);
		popView();
	}

	override void update(float deltaTime) {
		pushView(view, false);
		super.update(deltaTime);
		popView();
	}

	override void draw() {
		pushView(view, true);
		super.draw();
		popView();
		view.draw(_position);
	}

	protected void createGui(Vec2f newSize) {
		_isFrame = true;
		isLocked = true;
		layout = new GridLayout;
		view = new View(to!Vec2u(newSize));
		view.position = Vec2f.zero;
		size(newSize);
		addChild(layout);
	}
}

class GridList: WidgetGroup {
	protected {
		GridContainer _container;
		Slider _slider;
		Vec2f _lastMousePos = Vec2f.zero;
		float _layoutLength = 74f;
		uint _nbElements = 0u;
		uint _idElementSelected = 0u;
		uint _nbElementsPerLine = 4u;
	}

	@property {
		alias position = super.position;
		override ref Vec2f position(Vec2f newPosition) {
			_position = newPosition;
			_slider.position = _position - Vec2f((_size.x - _slider.size.x) / 2f, 0f);
			_container.position = _position + Vec2f(_slider.size.x / 2f, 0f);
			return _position;
		}

		alias size = super.size;
		override Vec2f size(Vec2f newSize) {
			_size = newSize;
			_slider.size = Vec2f(10f, _size.y);
			_container.layout.capacity = Vec2u(_nbElementsPerLine, 0u);
			_container.layout.size = Vec2f(_size.x, _layoutLength * (_nbElements / _nbElementsPerLine));
			_container.size = Vec2f(_size.x - _slider.size.x, _size.y);
			_container.view.renderSize = _container.size.to!Vec2u;
			position(_position);
			return _size;
		}

		uint selected() const { return _idElementSelected; }
		uint selected(uint id) {
			if(id > _nbElements)
				throw new Exception("GridList: index out of bounds");
			_idElementSelected = id;
			return _idElementSelected;
		}
	}

	this(Vec2f size) {
		createGui(size);
	}

	override void onEvent(Event event) {
		super.onEvent(event);
		if(event.type == EventType.MouseDown || event.type == EventType.MouseUp || event.type == EventType.MouseUpdate) {
			if(_slider.isInside(event.position))
				_slider.onEvent(event);
			else if(event.type == EventType.MouseDown) {

				auto widgets = _container.layout.children;
				foreach(uint id, ref Widget widget; _container.layout.children) {
					widget.isValidated = false;
					if(widget.isHovered)
						_idElementSelected = id;
				}
				if(_idElementSelected < widgets.length)
					widgets[_idElementSelected].isValidated = true;
			}
		}

		if(!isOnInteractableWidget(_lastMousePos) && event.type == EventType.MouseWheel)
			_slider.onEvent(event);
	}

	override void update(float deltaTime) {
		super.update(deltaTime);
		float min = _container.view.size.y / 2f;
		float max = _container.layout.size.y - _container.view.size.y / 2f;
		float exceedingHeight = _container.layout.size.y - _container.view.size.y;

		if(exceedingHeight < 0f) {
			_slider.max = 0;
			_slider.step = 0;
		}
		else {
			_slider.max = exceedingHeight / _layoutLength;
			_slider.step = to!uint(_slider.max);
		}
		_container.view.position = Vec2f(0f, lerp(min, max, _slider.offset));
	}

	override void addChild(Widget widget) {
		widget.isValidated = (_nbElements == 0u);

		_nbElements ++;
		_container.layout.size = Vec2f(_size.x, _layoutLength * (_nbElements / _nbElementsPerLine));
		_container.layout.position = Vec2f(0f, _container.layout.size.y / 2f);
		_container.layout.addChild(widget);
	}

	void clear() {
		_nbElements = 0u;
		_idElementSelected = 0u;
		_container.layout.size = Vec2f(size.x, 0f);
		_container.layout.position = Vec2f.zero;
		_container.layout.removeChildren();
	}

	Widget[] getList() {
		return _container.layout.children;
	}

	protected void createGui(Vec2f newSize) {
		isLocked = true;
		_slider = new VScrollbar;
		_container = new GridContainer(newSize);

		super.addChild(_slider);
		super.addChild(_container);

		size(newSize);
		position(Vec2f.zero);
	}
}

