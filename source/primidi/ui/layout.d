module primidi.ui.layout;

import std.conv: to;
import std.algorithm.comparison: max;

import primidi.render.window;
import primidi.core.all;
import primidi.ui.widget;

import primidi.common.all;

class VLayout: WidgetGroup {
	private {
		Vec2f _padding = Vec2f.zero;
		uint _capacity;
	}

	@property {
		alias size = super.size;
		override Vec2f size(Vec2f newSize) {
			_size = newSize;
			resize();
			return _size;
		}

		Vec2f padding() const { return _padding; }
		Vec2f padding(Vec2f newPadding) { _padding = newPadding; resize(); return _padding; }

		uint capacity() const { return _capacity; }
		uint capacity(uint newCapacity) { _capacity = newCapacity; resize(); return _capacity; }
	}

	this() {}

	this(Vec2f newSize) {
		size = newSize;
	}

	override void addChild(Widget widget) {
		super.addChild(widget);
		resize();
	}

	protected void resize() {
		if(!_children.length)
			return;
		Vec2f childSize = Vec2f(_size.x, _size.y / (_capacity != 0u ? _capacity : _children.length));
		Vec2f origin = (_isFrame ? Vec2f.zero : _position) - _size / 2 + childSize / 2f;
		foreach(uint id, Widget widget; _children) {
			widget.position = origin + Vec2f(0f, childSize.y * to!float(id));
			widget.size = childSize - _padding;
		}
	}
}

class HLayout: WidgetGroup {
	private {
		Vec2f _padding = Vec2f.zero;
		uint _capacity;
	}

	@property {
		alias size = super.size;
		override Vec2f size(Vec2f newSize) {
			_size = newSize;
			resize();
			return _size;
		}

		Vec2f padding() const { return _padding; }
		Vec2f padding(Vec2f newPadding) { _padding = newPadding; resize(); return _padding; }

		uint capacity() const { return _capacity; }
		uint capacity(uint newCapacity) { _capacity = newCapacity; resize(); return _capacity; }
	}

	this() {}

	this(Vec2f newSize) {
		size = newSize;
	}

	override void addChild(Widget widget) {
		super.addChild(widget);
		resize();
	}

	protected void resize() {
		if(!_children.length)
			return;
		Vec2f childSize = Vec2f(_size.x / (_capacity != 0u ? _capacity : _children.length), _size.y);
		Vec2f origin = (_isFrame ? Vec2f.zero : _position) - _size / 2 + childSize / 2f;
		foreach(uint id, Widget widget; _children) {
			widget.position = origin + Vec2f(childSize.x * to!float(id), 0f);
			widget.size = childSize - _padding;
		}
	}
}

class GridLayout: WidgetGroup {
	private {
		Vec2f _padding = Vec2f.zero;
		Vec2u _capacity;
	}

	@property {
		alias size = super.size;
		override Vec2f size(Vec2f newSize) {
			_size = newSize;
			resize();
			return _size;
		}

		Vec2f padding() const { return _padding; }
		Vec2f padding(Vec2f newPadding) { _padding = newPadding; resize(); return _padding; }

		Vec2u capacity() const { return _capacity; }
		Vec2u capacity(Vec2u newCapacity) { _capacity = newCapacity; resize(); return _capacity; }
	}

	this() {}

	this(Vec2f newSize) {
		size = newSize;
	}

	override void addChild(Widget widget) {
		super.addChild(widget);
		resize();
	}

	protected void resize() {
		if(!_children.length || _capacity.x == 0u)
			return;

		int yCapacity = _capacity.y;
		if(yCapacity == 0u)
			yCapacity = (to!int(_children.length) / _capacity.x) + 1;

		Vec2f childSize = Vec2f(_size.x / _capacity.x, _size.y / yCapacity);
		Vec2f origin = (_isFrame ? Vec2f.zero : _position) - _size / 2 + childSize / 2f;
		foreach(uint id, Widget widget; _children) {
			Vec2u coords = Vec2u(id % _capacity.x, id / _capacity.x);
			widget.position = origin + Vec2f(childSize.x * coords.x, childSize.y * coords.y);
			widget.size = childSize - _padding;
		}
	}
}

class VContainer: WidgetGroup {
	protected {
		Vec2f _padding = Vec2f.zero;
	}

	@property {
		alias size = super.size;
		override Vec2f size(Vec2f newSize) {
			resize();
			return _size;
		}

		alias position = super.position;
		override ref Vec2f position(Vec2f newPosition) {
			_position = newPosition;
			resize();
			return _position;
		}


		Vec2f padding() const { return _padding; }
		Vec2f padding(Vec2f newPadding) { _padding = newPadding; resize(); return _padding; }
	}

	this() {}

	override void addChild(Widget widget) {
		super.addChild(widget);
		resize();
	}

	protected void resize() {
		if(!_children.length) {
			_size = Vec2f.zero;
			return;
		}

		Vec2f totalSize = Vec2f.zero;
		foreach(Widget widget; _children) {
			totalSize.y += widget.size.y + _padding.y;
			totalSize.x = max(totalSize.x, widget.size.x);
		}
		_size = totalSize + Vec2f(_padding.x * 2f, _padding.y);
		Vec2f currentPosition = _position - _size / 2f + _padding;
		foreach(Widget widget; _children) {
			widget.position = currentPosition + widget.size / 2f;
			currentPosition = currentPosition + Vec2f(0f, widget.size.y + _padding.y);
		}
	}
}

class HContainer: WidgetGroup {
	protected {
		Vec2f _padding = Vec2f.zero;
	}

	@property {
		alias size = super.size;
		override Vec2f size(Vec2f newSize) {
			resize();
			return _size;
		}

		alias position = super.position;
		override ref Vec2f position(Vec2f newPosition) {
			_position = newPosition;
			resize();
			return _position;
		}


		Vec2f padding() const { return _padding; }
		Vec2f padding(Vec2f newPadding) { _padding = newPadding; resize(); return _padding; }
	}

	this() {}

	override void addChild(Widget widget) {
		super.addChild(widget);
		resize();
	}

	protected void resize() {
		if(!_children.length) {
			_size = Vec2f.zero;
			return;
		}

		Vec2f totalSize = Vec2f.zero;
		foreach(Widget widget; _children) {
			totalSize.y = max(totalSize.y, widget.size.y);
			totalSize.x += widget.size.x + _padding.x;
		}
		_size = totalSize + Vec2f(_padding.x, _padding.y * 2f);
		Vec2f currentPosition = _position - _size / 2f + _padding;
		foreach(Widget widget; _children) {
			widget.position = currentPosition + widget.size / 2f;
			currentPosition = currentPosition + Vec2f(widget.size.x + _padding.x, 0f);
		}
	}
}

class AnchoredLayout: WidgetGroup {
	private {
		Vec2f[] _childrenPositions, _childrenSizes;
	}

	@property {
		alias position = super.position;
		override ref Vec2f position(Vec2f newPosition) {
			_position = newPosition;
			resize();
			return _position;
		}

		alias size = super.size;
		override Vec2f size(Vec2f newSize) {
			_size = newSize;
			resize();
			return _size;
		}
	}

	this() {}

	this(Vec2f newSize) {
		size = newSize;
	}

	override void addChild(Widget widget) {
		super.addChild(widget);
		_childrenPositions ~= Vec2f.half;
		_childrenSizes ~= Vec2f.one;
		resize();
	}

	void addChild(Widget widget, Vec2f position, Vec2f size) {
		super.addChild(widget);
		_childrenPositions ~= position;
		_childrenSizes ~= size;
		resize();
	}

	override void removeChildren() {
		super.removeChildren();
		_childrenPositions.length = 0L;
		_childrenSizes.length = 0L;
	}

	protected void resize() {
		if(!_children.length)
			return;
		Vec2f origin = (_isFrame ? Vec2f.zero : _position) - _size / 2;
		foreach(uint id, Widget widget; _children) {
			widget.position = origin + _size * _childrenPositions[id];
			widget.size = _size * _childrenSizes[id];
		}
	}
}

class LogLayout: WidgetGroup {
	@property {
		alias size = super.size;
		override Vec2f size(Vec2f newSize) {
			resize();
			return _size;
		}
	}

	this() {}

	override void addChild(Widget widget) {
		super.addChild(widget);
		resize();
	}

	protected void resize() {
		if(!_children.length)
			return;

		Vec2f totalSize = Vec2f.zero;
		foreach(Widget widget; _children) {
			totalSize.y += widget.size.y;
			totalSize.x = max(totalSize.x, widget.size.x);
		}
		_size = totalSize;
		Vec2f currentPosition = _position - _size / 2f;
		foreach(Widget widget; _children) {
			widget.position = currentPosition + widget.size / 2f;
			currentPosition = currentPosition + Vec2f(0f, widget.size.y);
		}
	}
}