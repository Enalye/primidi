/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.font;

import std.conv;
import atelier, grimoire;
import primidi.script.util;

package void loadFont(GrData data) {
    const defFont = data.addForeign("Font");

    data.addPrimitive(&_makeFont, "Font", ["path", "size"], [grString, grInt], [defFont]);
}

private void _makeFont(GrCall call) {
    Font font = new TrueTypeFont(getResourcePath(call.getString!string("path")), call.getInt("size"));
    call.setUserData!Font(font);
}