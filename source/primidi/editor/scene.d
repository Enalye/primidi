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

module primidi.editor.scene;

import grimoire;
import primidi.editor.element;

private {
    EditorScene _scene;
}

EditorScene createEditorScene() {
    _scene = new EditorScene;
    return _scene;  
}

void destroyEditorScene() {
    _scene = null;
}

private final class EditorScene: WidgetGroup {
    private {
        View _view;
		float _scale = 1f;
    }

    this() {
        _isFrame = true;
        _size = Vec2f(720f, 405f);
        _position = centerScreen;
        _view = new View(_size);
        addChild(new EditorElement);
    }

    override void onEvent(Event event) {
		pushView(_view, false);
		super.onEvent(event);
		if(!_isChildGrabbed) {
			switch(event.type) with(EventType) {
			case MouseDown:
                if(isButtonDown(3u)) {
				    _isGrabbed = true;
				    _lastMousePos = event.position;
                }
				break;
			case MouseUp:
				_isGrabbed = false;
				break;
			case MouseUpdate:
				if(_isGrabbed) {
					_view.position += (_lastMousePos - event.position) * _scale;
					_lastMousePos = event.position;
				}
				break;
			case MouseWheel:
				Vec2f delta = (getViewVirtualPos(getMousePos(), _position) - _view.position) / (_view.size);
				if(event.position.y > 0f) {
					if(_scale > 0.1f)
						_scale *= 0.9f;
				}
				else {
					if(_scale < 10f)
						_scale /= 0.9f;
				}
				_view.size = _size * _scale;
				Vec2f delta2 = (getViewVirtualPos(getMousePos(), _position) - _view.position) / (_view.size);
				_view.position += (delta2 - delta) * _view.size;
				break;
			default:
				break;
			}
		}
		popView();
	}

    override void draw() {
        Color baseColor = Color(0.111f, 0.1125f, 0.123f);
		windowClearColor = baseColor;
        _view.clearColor = baseColor;
        pushView(_view, true);
        {
            //Draw grid
            void drawLineEveryStep(Vec2f origin, Vec2f dest, float step, float size, Color color) {
                Vec2f windowSize = dest - origin;
                float pos;

                //Horizontal
                pos = ceil(origin.x / step) * step;
                while(pos < dest.x) {
                    drawFilledRect(Vec2f(pos - size / 2f, origin.y), Vec2f(size, windowSize.y), color);
                    pos += step;
                }

                //Vertical
                pos = ceil(origin.y / step) * step;
                while(pos < dest.y) {
                    drawFilledRect(Vec2f(origin.x, pos - size / 2f), Vec2f(windowSize.x, size), color);
                    pos += step;
                }
            }

            Vec2f origin = _view.position - (_view.size / 2f);
            Vec2f dest = _view.position + (_view.size / 2f);

            if(_scale < 0.5f) {
                drawLineEveryStep(origin, dest, 62.5f, 2f * _scale, Color.white * 0.22f);
                drawLineEveryStep(origin, dest, 250f, 4f * _scale, Color.white * 0.4f);
                drawLineEveryStep(origin, dest, 1000f, 4f * _scale, Color.white * 0.6f);
            }
            else if(_scale < 2f) {
                drawLineEveryStep(origin, dest, 250f, 2f * _scale, Color.white * 0.4f);
                drawLineEveryStep(origin, dest, 1000f, 4f * _scale, Color.white * 0.6f);
            }
            else
                drawLineEveryStep(origin, dest, 1000f, 2f * _scale, Color.white * 0.6f);

            //(0;0)
            if(_view.position.x > -(_view.size.x / 2f) && _view.position.x < _view.size.x / 2f)
                drawFilledRect(Vec2f(-(2f * _scale), origin.y), Vec2f(4f * _scale, _view.size.y), Color.white);

            if(_view.position.y > -(_view.size.y / 2f) && _view.position.y < _view.size.y / 2f)
                drawFilledRect(Vec2f(origin.x, -(2f * _scale)), Vec2f(_view.size.x, 4f * _scale), Color.white);

            //Widgets
            super.draw();
        }
        popView();
        _view.draw(_position);
    }
}