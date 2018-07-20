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

module primidi.editor.element;

import grimoire;

import primidi.pianoroll.channel;
import primidi.editor.plugin;

class EditorElement: WidgetGroup {
    private {
        View _view;
        Plugin _plugin;
    }

    this() {
        _isMovable = true;
        _isFrame = true;
        _size = screenSize;
        _position = Vec2f.zero;
        _view = new View(_size);
        _plugin = new Plugin("Test");
    }

    override void onEvent(Event event) {
        pushView(_view, false);
        super.onEvent(event);
        popView();

        if(event.type == EventType.Quit) {
            _plugin.cleanup();
        }
    }

    override void update(float deltaTime) {
        pushView(_view, false);
        super.update(deltaTime);
        popView();
    }

    override void draw() {
        pushView(_view, true);
        drawFilledRect(-_size / 2f, _size, Color.black);
        super.draw();
        _plugin.run();
        popView();
        _view.draw(_position + _size / 2f - _size * _anchor);
    }

    override void drawOverlay() {}
}