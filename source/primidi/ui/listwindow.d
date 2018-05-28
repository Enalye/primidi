module primidi.ui.listwindow;

import primidi.core.all;
import primidi.common.all;

import primidi.ui.modal;
import primidi.ui.button;
import primidi.ui.list.vlist;
import primidi.ui.inputfield;

void setListWindow(string id, string title, string[] list) {
	auto modal = new ListWindow(title, list);
	setModalWindow(id, modal);
}

class ListWindow: ModalWindow {
	private {
		InStream _stream;
		string[] _elements;
		VList _list;
	}

	@property {
		string selected() const {
			if(!_elements.length)
				return "";
			return _elements[_list.selected];
		}
	}

	this(string title, string[] newElements) {
		super(title, Vec2f(250f, 200f));
		_elements = newElements;
		_list = new VList(layout.size);
		foreach(element; _elements) {
			auto btn = new TextButton(element);
			_list.addChild(btn);
		}
		layout.addChild(_list);
	}
}