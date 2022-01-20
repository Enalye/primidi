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
    const GrType fontType = grGetForeignType("Font");
    const GrType colorType = grGetClassType("Color");

    library.addPrimitive(&_print0, "print", [grString, grReal, grReal]);
    library.addPrimitive(&_print1, "print", [
            grString, grReal, grReal, colorType
        ]);
    library.addPrimitive(&_print2, "print", [
            grString, grReal, grReal, grReal
        ]);
    library.addPrimitive(&_print3, "print", [
            grString, grReal, grReal, colorType, grReal
        ]);
    library.addPrimitive(&_print4, "print", [
            grString, grReal, grReal, fontType
        ]);
    library.addPrimitive(&_print5, "print", [
            grString, grReal, grReal, fontType, colorType
        ]);
    library.addPrimitive(&_print6, "print", [
            grString, grReal, grReal, fontType, grReal
        ]);
    library.addPrimitive(&_print7, "print", [
            grString, grReal, grReal, fontType, colorType, grReal
        ]);

    library.addPrimitive(&_getTextSize1, "getTextSize", [grString], [
            grReal, grReal
        ]);
    library.addPrimitive(&_getTextWidth1, "getTextWidth", [grString], [grReal]);
    library.addPrimitive(&_getTextHeight1, "getTextHeight", [grString], [
            grReal
        ]);

    library.addPrimitive(&_getTextSize2, "getTextSize", [grString, fontType], [
            grReal, grReal
        ]);
    library.addPrimitive(&_getTextWidth2, "getTextWidth", [grString, fontType], [
            grReal
        ]);
    library.addPrimitive(&_getTextHeight2, "getTextHeight", [grString, fontType], [
            grReal
        ]);
}

private void _print0(GrCall call) {
    _drawText(call.getString(0), call.getReal(1), call.getReal(2));
}

private void _print1(GrCall call) {
    GrObject obj = call.getObject(3);
    if (!obj) {
        call.raise("Null parameter");
        return;
    }
    Color color = Color(obj.getReal("r"), obj.getReal("g"), obj.getReal("b"));
    setScriptColor(color);
    _drawText(call.getString(0), call.getReal(1), call.getReal(2));
}

private void _print2(GrCall call) {
    setScriptAlpha(call.getReal(3));
    _drawText(call.getString(0), call.getReal(1), call.getReal(2));
}

private void _print3(GrCall call) {
    GrObject obj = call.getObject(3);
    if (!obj) {
        call.raise("Null parameter");
        return;
    }
    Color color = Color(obj.getReal("r"), obj.getReal("g"), obj.getReal("b"));
    setScriptColor(color);
    setScriptAlpha(call.getReal(4));
    _drawText(call.getString(0), call.getReal(1), call.getReal(2));
}

private void _print4(GrCall call) {
    setScriptFont(call.getForeign!Font(3));
    _drawText(call.getString(0), call.getReal(1), call.getReal(2));
}

private void _print5(GrCall call) {
    setScriptFont(call.getForeign!Font(3));
    GrObject obj = call.getObject(4);
    if (!obj) {
        call.raise("Null parameter");
        return;
    }
    Color color = Color(obj.getReal("r"), obj.getReal("g"), obj.getReal("b"));
    setScriptColor(color);
    _drawText(call.getString(0), call.getReal(1), call.getReal(2));
}

private void _print6(GrCall call) {
    setScriptFont(call.getForeign!Font(3));
    setScriptAlpha(call.getReal(4));
    _drawText(call.getString(0), call.getReal(1), call.getReal(2));
}

private void _print7(GrCall call) {
    setScriptFont(call.getForeign!Font(3));
    GrObject obj = call.getObject(4);
    if (!obj) {
        call.raise("Null parameter");
        return;
    }
    Color color = Color(obj.getReal("r"), obj.getReal("g"), obj.getReal("b"));
    setScriptColor(color);
    setScriptAlpha(call.getReal(5));
    _drawText(call.getString(0), call.getReal(1), call.getReal(2));
}

private void _getTextSize1(GrCall call) {
    const Vec2f size = _getTextSize(call.getString(0));
    call.setReal(size.x);
    call.setReal(size.y);
}

private void _getTextWidth1(GrCall call) {
    const Vec2f size = _getTextSize(call.getString(0));
    call.setReal(size.x);
}

private void _getTextHeight1(GrCall call) {
    const Vec2f size = _getTextSize(call.getString(0));
    call.setReal(size.y);
}

private void _getTextSize2(GrCall call) {
    setScriptFont(call.getForeign!Font(1));
    const Vec2f size = _getTextSize(call.getString(0));
    call.setReal(size.x);
    call.setReal(size.y);
}

private void _getTextWidth2(GrCall call) {
    setScriptFont(call.getForeign!Font(1));
    const Vec2f size = _getTextSize(call.getString(0));
    call.setReal(size.x);
}

private void _getTextHeight2(GrCall call) {
    setScriptFont(call.getForeign!Font(1));
    const Vec2f size = _getTextSize(call.getString(0));
    call.setReal(size.y);
}

/// Render text on screen
private void _drawText(string text, float x, float y) {
    Font font = getScriptFont();
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
private Vec2f _getTextSize(string text) {
    Font font = getScriptFont();
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
