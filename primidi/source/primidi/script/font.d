/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.font;

import std.conv;
import atelier, grimoire;
import primidi.script.util;

package void loadFontLibrary(GrLibrary library) {
    GrType fontType = library.addForeign("Font");
    GrType trueTypeFontType = library.addForeign("TrueTypeFont", [], "Font");
    GrType bitmapFontType = library.addForeign("BitmapFont", [], "Font");

    library.addPrimitive(&_setFont1, "setFont", []);
    library.addPrimitive(&_setFont2, "setFont", [fontType]);
    library.addPrimitive(&_getFont, "getFont", [], [fontType]);

    library.addPrimitive(&_trueTypeFont, "TrueTypeFont", [grString, grInt], [
            trueTypeFontType
            ]);
    library.addPrimitive(&_trueTypeFontOutline, "TrueTypeFont", [
            grString, grInt, grInt
            ], [trueTypeFontType]);
}

private void _setFont1(GrCall call) {
    setScriptFont(null);
}

private void _setFont2(GrCall call) {
    setScriptFont(call.getForeign!Font(0));
}

private void _getFont(GrCall call) {
    call.setForeign(getScriptFont());
}

private void _trueTypeFont(GrCall call) {
    TrueTypeFont font = new TrueTypeFont(getResourcePath(call.getString(0)), call.getInt(1));
    call.setForeign!TrueTypeFont(font);
}

private void _trueTypeFontOutline(GrCall call) {
    TrueTypeFont font = new TrueTypeFont(getResourcePath(call.getString(0)),
            call.getInt(1), call.getInt(2));
    call.setForeign!TrueTypeFont(font);
}
