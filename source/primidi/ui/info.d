module primidi.ui.info;

import primidi.core.all;

import primidi.ui.modal;
import primidi.ui.label;

void setInfoWindow(string title, string information) {
	setModalWindow("ui_info", new InfoWindow(title, information));
}

void setInfoWindow(string information) {
	setModalWindow("ui_info", new InfoWindow(information));
}


class InfoWindow: ModalWindow {
	this(string title, string information) {
		super(title, Vec2f.zero);
		auto label = new Label(information);
		size = label.size;
		layout.addChild(label);
	}

	this(string information) {
		this("Information", information);
	}
}