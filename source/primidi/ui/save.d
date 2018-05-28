module primidi.ui.save;

import std.file;
import std.path;
import std.conv: to;

import primidi.core.all;
import primidi.common.all;

import primidi.ui.modal;
import primidi.ui.button;
import primidi.ui.list.vlist;
import primidi.ui.inputfield;

private {
	InStream _loadedStream = null;
}

void setSaveWindow(OutStream stream, string path, string extension) {
	path = buildNormalizedPath(absolutePath(path));
	if(!extension.length)
		throw new Exception("Cannot save without a file extension");
	auto modal = new SaveWindow(stream, path, extension);
	setModalWindow("ui_save", modal);
}

void setLoadWindow(string path, string extension) {
	InStream stream = new InStream;
	path = buildNormalizedPath(absolutePath(path));
	if(!extension.length)
		throw new Exception("Cannot save without a file extension");
	auto modal = new LoadWindow(stream, path, extension);
	_loadedStream = null;
	setModalWindow("ui_load", modal);
}

InStream getLoadedStream() {
	return _loadedStream;
}

class SaveWindow: ModalWindow {
	private {
		OutStream _stream;
		string _path, _extension;
		InputField _inputField;
	}

	this(OutStream stream, string path, string extension) {
		super("Enregistrer sous...", Vec2f(250f, 25f));
		_stream = stream;
		_path = path;
		_extension = extension;
		_inputField = new InputField(layout.size, "Sans Titre", true);
		layout.addChild(_inputField);
	}

	override void onEvent(Event event) {
		super.onEvent(event);
		if(event.type == EventType.ModalApply) {
			if(event.id != "ui_save")
				throw new Exception("Invalid window identifier \'" ~ event.id ~ "\' instead of \'ui_save\'");
			
			string fullPath = buildPath(_path, setExtension(_inputField.text, _extension));
			if(!isValidPath(fullPath))
				throw new Exception("Error saving file: invalid path \'" ~ fullPath ~ "\'");
			write(fullPath, _stream.data);
		}
	}

	override void update(float deltaTime) {
		super.update(deltaTime);
		applyBtn.isLocked = (_inputField.text.length == 0L);
	}
}

class LoadWindow: ModalWindow {
	private {
		InStream _stream;
		string[] _files;
		VList _list;
	}

	this(InStream stream, string path, string extension) {
		super("Charger...", Vec2f(250f, 200f));
		_stream = stream;
		_list = new VList(layout.size);
		foreach(file; dirEntries(path, "*." ~ extension, SpanMode.depth)) {
			_files ~= file;
			string relativeFileName = stripExtension(baseName(file));
			auto btn = new TextButton(relativeFileName);
			_list.addChild(btn);
		}
		layout.addChild(_list);
	}

	override void onEvent(Event event) {
		super.onEvent(event);

		if(event.type == EventType.ModalApply) {
			if(event.id != "ui_load")
				throw new Exception("Invalid window identifier \'" ~ event.id ~ "\' instead of \'ui_load\'");
			
			if(_list.selected < _files.length) {
				string fileName = _files[_list.selected];
				if(!exists(fileName))
					throw new Exception("Error saving file: invalid path \'" ~ fileName ~ "\'");
				_stream.set(cast(ubyte[])(read(fileName)));
				if(_stream.length)
					_loadedStream = _stream;
				else
					_loadedStream = null;
			}
		}
	}

	override void update(float deltaTime) {
		super.update(deltaTime);
		applyBtn.isLocked = (_files.length == 0L);
	}
}