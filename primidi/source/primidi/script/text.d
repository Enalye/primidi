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

    library.addPrimitive(&_getTextSize1, "getTextSize", [grString], [
            grFloat, grFloat
            ]);
    library.addPrimitive(&_getTextWidth1, "getTextWidth", [grString], [grFloat]);
    library.addPrimitive(&_getTextHeight1, "getTextHeight", [grString], [
            grFloat
            ]);

    library.addPrimitive(&_getTextSize2, "getTextSize", [grString, fontType], [
            grFloat, grFloat
            ]);
    library.addPrimitive(&_getTextWidth2, "getTextWidth", [grString, fontType], [
            grFloat
            ]);
    library.addPrimitive(&_getTextHeight2, "getTextHeight", [grString, fontType], [
            grFloat
            ]);
}

private void _print1(GrCall call) {
    _drawText(call.getString(0), call.getFloat(1), call.getFloat(2));
}

private void _print2(GrCall call) {
    _drawText(call.getString(0), call.getFloat(1), call.getFloat(2), call.getForeign!Font(3));
}

private void _getTextSize1(GrCall call) {
    const Vec2f size = _getTextSize(call.getString(0));
    call.setFloat(size.x);
    call.setFloat(size.y);
}

private void _getTextWidth1(GrCall call) {
    const Vec2f size = _getTextSize(call.getString(0));
    call.setFloat(size.x);
}

private void _getTextHeight1(GrCall call) {
    const Vec2f size = _getTextSize(call.getString(0));
    call.setFloat(size.y);
}

private void _getTextSize2(GrCall call) {
    const Vec2f size = _getTextSize(call.getString(0), call.getForeign!Font(1));
    call.setFloat(size.x);
    call.setFloat(size.y);
}

private void _getTextWidth2(GrCall call) {
    const Vec2f size = _getTextSize(call.getString(0), call.getForeign!Font(1));
    call.setFloat(size.x);
}

private void _getTextHeight2(GrCall call) {
    const Vec2f size = _getTextSize(call.getString(0), call.getForeign!Font(1));
    call.setFloat(size.y);
}

/// Render text on screen
private void _drawText(string text, float x, float y, Font font = null) {
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

/// Returns the size of the text if it was rendered on screen
private Vec2f _getTextSize(string text, Font font = null) {
    if (!font)
        font = getScriptFont();
    const _charScale = 1;
    const _charSpacing = 0;
    Vec2f size = Vec2f.zero;
    float pos = 0f;
    dchar prevChar;
    foreach (dchar ch; to!dstring(text)) {
        if (ch == '\n') {
            pos = 0;
            size.y += font.lineSkip * _charScale;
            prevChar = 0;
        }
        else {
            Glyph metrics = font.getMetrics(ch);
            pos += font.getKerning(prevChar, ch) * _charScale;
            pos += (metrics.advance + _charSpacing) * _charScale;
            if (pos > size.x)
                size.x = pos;
            prevChar = ch;
        }
    }
    return size;
}
