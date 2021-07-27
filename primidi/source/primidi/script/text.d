/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.text;

import std.conv;
import atelier, grimoire;
import primidi.script.util;

package void loadTextLibrary(GrLibrary library) {
    const fontType = grGetForeignType("Font");

    library.addPrimitive(&_print1, "print", [grString, grFloat, grFloat]);
    library.addPrimitive(&_print2, "print", [
            grString, grFloat, grFloat, fontType
            ]);
}

private void _print1(GrCall call) {
    drawText(call.getString(0), call.getFloat(1), call.getFloat(2));
}

private void _print2(GrCall call) {
    drawText(call.getString(0), call.getFloat(1), call.getFloat(2), call.getForeign!Font(3));
}

/// Render text on screen
void drawText(string text, float x, float y, Font font = null) {
    if (!font)
        font = getScriptFont();
    const _charScale = 1;
    Color color = getScriptColor();
    const alpha = getScriptAlpha();
    const _charSpacing = 0;
    Vec2f pos = Vec2f(x, y);
    dchar prevChar;
    foreach (dchar ch; to!dstring(text)) {
        if (ch == '\n') {
            pos.x = x;
            pos.y += font.lineSkip * _charScale;
            prevChar = 0;
        }
        else {
            Glyph metrics = font.getMetrics(ch);
            pos.x += font.getKerning(prevChar, ch) * _charScale;
            Vec2f drawPos = Vec2f(pos.x + metrics.offsetX * _charScale,
                    pos.y - metrics.offsetY * _charScale);
            metrics.draw(drawPos, _charScale, color, alpha);
            pos.x += (metrics.advance + _charSpacing) * _charScale;
            prevChar = ch;
        }
    }
}
