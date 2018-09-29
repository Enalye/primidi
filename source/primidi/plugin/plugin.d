/**
Primidi
Copyright (c) 2016 Enalye

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising
from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute
it freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented;
	   you must not claim that you wrote the original software.
	   If you use this software in a product, an acknowledgment
	   in the product documentation would be appreciated but
	   is not required.

	2. Altered source versions must be plainly marked as such,
	   and must not be misrepresented as being the original software.

	3. This notice may not be removed or altered from any source distribution.
*/

module primidi.plugin.plugin;

import std.file;
import std.path;
import std.conv: to;

import atelier;
import grimoire;

import primidi.pianoroll.channel;

import primidi.plugin.primitives;

class Plugin: WidgetGroup {
    private {
        View _view;
        GrVM _vm;
        bool _isVisible = true;
        Widget[] _propertyWidgets;

        Slider[dstring] _sliders;
        Checkbox[dstring] _checkboxes;
    }

    @property {
        bool isVisible(bool newIsVisible) { return _isVisible = newIsVisible; }
    
        Widget[] propertyWidgets() { return _propertyWidgets; }
    }

    this(string path) {
        _isMovable = true;
        _isFrame = true;
        _size = screenSize;
        _position = Vec2f.zero;
        _view = new View(_size);

        load(path);
    }

    void load(string path) {
        auto json = parseJSON(readText(path));
        string scriptPath = getJsonStr(json, "script");

        auto bytecode = grCompiler_compileFile(scriptPath);
        _vm = new GrVM(bytecode);

        _propertyWidgets.length = 0;
        if(hasJson(json, "properties")) {
            auto variablesJson = getJson(json, "properties");
            foreach(string tag, JSONValue value; variablesJson.object) { 
                switch(getJsonStr(value, "type", "null")) {
                case "checkbox":
                    Checkbox checkbox;
                    if(hasJson(value, "label"))
                        checkbox = new TextCheckbox(getJsonStr(value, "label"));
                    else
                        checkbox = new Checkbox;
                    checkbox.isChecked = getJsonBool(value, "default", false);
                    _propertyWidgets ~= checkbox;
                    setBool(tag, checkbox);
                    break;
                case "slider":
                    if(hasJson(value, "label")) {
                        _propertyWidgets ~= new Label(getJsonStr(value, "label"));
                    }
                    auto slider = new HSlider;
                    slider.min = getJsonFloat(value, "min");
                    slider.max = getJsonFloat(value, "max");
                    slider.fvalue = getJsonFloat(value, "default", slider.min);
                    slider.step = getJsonInt(value, "step");
                    slider.padding = Vec2f(10f, 10f);
                    _propertyWidgets ~= slider;
                    setFloat(tag, slider);
                    break;
                case "null":
                    break;
                default: //Error
                    break;    
                }
            }
        }
    }

    override void onEvent(Event event) {
        pushView(_view, false);
        super.onEvent(event);
        popView();

        if(event.type == EventType.Quit) {
            //_script.cleanup();
        }
    }

    override void update(float deltaTime) {
        pushView(_view, false);
        super.update(deltaTime);
        setCurrentPlugin(this);
        _vm.process();
        popView();
    }

    override void draw() {
        if(!_isVisible)
            return;
        pushView(_view, true);
        //drawFilledRect(Vec2f.zero, _size, Color.red);
        super.draw();
        popView();
        _view.draw(_position + _size / 2f - _size * _anchor);
    }

    override void drawOverlay() {}

    void reload() {
        //Todo: Recompile
    }

    void setFloat(string name, Slider slider) {
        dstring dname = to!dstring(name);
        _sliders[dname] = slider;
    }

    float getFloat(dstring name) {
        auto ptr = name in _sliders;
        if(ptr !is null)
            return (*ptr).fvalue;
        return 0f;
    }

    void setBool(string name, Checkbox checkbox) {
        dstring dname = to!dstring(name);
        _checkboxes[dname] = checkbox;
    }

    bool getBool(dstring name) {
        auto ptr = name in _checkboxes;
        if(ptr !is null)
            return (*ptr).isValidated;
        return false;
    }
}