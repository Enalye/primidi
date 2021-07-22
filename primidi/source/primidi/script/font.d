/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.font;

import std.conv;
import atelier, grimoire;
import primidi.script.util;

package void loadFont(GrLibrary library) {
    const defFont = library.addForeign("Font");

    library.addPrimitive(&_makeFont, "Font", [grString, grInt], [defFont]);
}

private void _makeFont(GrCall call) {
    Font font = new TrueTypeFont(getResourcePath(call.getString(0)), call.getInt(1));
    call.setForeign!Font(font);
}