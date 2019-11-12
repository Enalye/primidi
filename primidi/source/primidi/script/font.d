module primidi.script.font;

import std.conv;
import atelier, grimoire;

package void loadFont(GrData data) {
    const defFont = data.addUserType("Font");

    data.addPrimitive(&_makeFont, "Font", ["path", "size"], [grString, grInt], [defFont]);
}

private void _makeFont(GrCall call) {
    Font font = new TrueTypeFont(to!string(call.getString("path")), call.getInt("size"));
    call.setUserData!Font(font);
}