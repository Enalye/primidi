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

module primidi.editor.properties;

import grimoire;

private {
    EditorProperties _properties;
}

EditorProperties createEditorProperties() {
    _properties = new EditorProperties;
    return _properties;  
}

void destroyEditorProperties() {
    _properties = null;
}

private final class EditorProperties: VList {
    this() {
        super(Vec2f(250f, 500f));
        anchor = Vec2f(1f, .5f);
        position = Vec2f(screenWidth, centerScreen.y);
    }
}