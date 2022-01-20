/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.window;

import std.conv;
import grimoire, atelier;
import primidi.gui, primidi.locale;
import primidi.script.util;

package void loadWindowLibrary(GrLibrary library) {
    auto colorType = grGetClassType("Color");

    library.addPrimitive(&_getLocale, "getLocale", [], [grString]);

    library.addPrimitive(&_setColor, "setColor", [colorType]);
    library.addPrimitive(&_getColor, "getColor", [], [colorType]);
    library.addPrimitive(&_setAlpha, "setAlpha", [grReal]);
    library.addPrimitive(&_getAlpha, "getAlpha", [], [grReal]);

    library.addPrimitive(&_point0, "point", [grReal, grReal]);
    library.addPrimitive(&_point1, "point", [grReal, grReal, colorType]);
    library.addPrimitive(&_point2, "point", [grReal, grReal, grReal]);
    library.addPrimitive(&_point3, "point", [
            grReal, grReal, colorType, grReal
        ]);

    library.addPrimitive(&_line0, "line", [
            grReal, grReal, grReal, grReal
        ]);
    library.addPrimitive(&_line1, "line", [
            grReal, grReal, grReal, grReal, colorType
        ]);
    library.addPrimitive(&_line2, "line", [
            grReal, grReal, grReal, grReal, grReal
        ]);
    library.addPrimitive(&_line3, "line", [
            grReal, grReal, grReal, grReal, colorType, grReal
        ]);

    library.addPrimitive(&_rectangle0, "rectangle", [
            grReal, grReal, grReal, grReal, grBool
        ]);
    library.addPrimitive(&_rectangle1, "rectangle", [
            grReal, grReal, grReal, grReal, grBool, colorType
        ]);
    library.addPrimitive(&_rectangle2, "rectangle", [
            grReal, grReal, grReal, grReal, grBool, grReal
        ]);
    library.addPrimitive(&_rectangle3, "rectangle", [
            grReal, grReal, grReal, grReal, grBool, colorType, grReal
        ]);

    library.addPrimitive(&_pixel0, "pixel", [grReal, grReal]);
    library.addPrimitive(&_pixel1, "pixel", [
            grReal, grReal, colorType
        ]);
    library.addPrimitive(&_pixel2, "pixel", [
            grReal, grReal, grReal
        ]);
    library.addPrimitive(&_pixel3, "pixel", [
            grReal, grReal, colorType, grReal
        ]);

    library.addPrimitive(&_getWidth, "getWidth", [], [grReal]);
    library.addPrimitive(&_getHeight, "getHeight", [], [grReal]);
    library.addPrimitive(&_getSize, "getSize", [], [grReal, grReal]);
    library.addPrimitive(&_getCenterX, "getCenterX", [], [grReal]);
    library.addPrimitive(&_getCenterY, "getCenterY", [], [grReal]);
    library.addPrimitive(&_getCenter, "getCenter", [], [grReal, grReal]);
}

private void _getLocale(GrCall call) {
    call.setString(getLocaleKey());
}

private void _setColor(GrCall call) {
    GrObject obj = call.getObject(0);
    Color color = Color(obj.getReal("r"), obj.getReal("g"), obj.getReal("b"));
    setScriptColor(color);
}

private void _getColor(GrCall call) {
    Color color = getScriptColor();
    GrObject obj = call.createObject("Color");
    obj.setReal("r", color.r);
    obj.setReal("g", color.g);
    obj.setReal("b", color.b);
    call.setObject(obj);
}

private void _setAlpha(GrCall call) {
    setScriptAlpha(call.getReal(0));
}

private void _getAlpha(GrCall call) {
    call.setReal(getScriptAlpha());
}

private void _point0(GrCall call) {
    Vec2f pos = Vec2f(call.getReal(0), call.getReal(1));
    drawPoint(pos, getScriptColor(), getScriptAlpha());
}

private void _point1(GrCall call) {
    GrObject c = call.getObject(2);
    if (!c) {
        call.raise("Null parameter");
        return;
    }
    Vec2f pos = Vec2f(call.getReal(0), call.getReal(1));
    setScriptColor(Color(c.getReal("r"), c.getReal("g"), c.getReal("b")));
    drawPoint(pos, getScriptColor(), getScriptAlpha());
}

private void _point2(GrCall call) {
    Vec2f pos = Vec2f(call.getReal(0), call.getReal(1));
    setScriptAlpha(call.getReal(2));
    drawPoint(pos, getScriptColor(), getScriptAlpha());
}

private void _point3(GrCall call) {
    GrObject c = call.getObject(2);
    if (!c) {
        call.raise("Null parameter");
        return;
    }
    Vec2f pos = Vec2f(call.getReal(0), call.getReal(1));
    setScriptColor(Color(c.getReal("r"), c.getReal("g"), c.getReal("b")));
    setScriptAlpha(call.getReal(3));
    drawPoint(pos, getScriptColor(), getScriptAlpha());
}

private void _line0(GrCall call) {
    Vec2f startPos = Vec2f(call.getReal(0), call.getReal(1));
    Vec2f endPos = Vec2f(call.getReal(2), call.getReal(3));
    drawLine(startPos, endPos, getScriptColor(), getScriptAlpha());
}

private void _line1(GrCall call) {
    Vec2f startPos = Vec2f(call.getReal(0), call.getReal(1));
    Vec2f endPos = Vec2f(call.getReal(2), call.getReal(3));
    GrObject c = call.getObject(4);
    setScriptColor(Color(c.getReal("r"), c.getReal("g"), c.getReal("b")));
    drawLine(startPos, endPos, getScriptColor(), getScriptAlpha());
}

private void _line2(GrCall call) {
    Vec2f startPos = Vec2f(call.getReal(0), call.getReal(1));
    Vec2f endPos = Vec2f(call.getReal(2), call.getReal(3));
    setScriptAlpha(call.getReal(4));
    drawLine(startPos, endPos, getScriptColor(), getScriptAlpha());
}

private void _line3(GrCall call) {
    GrObject c = call.getObject(4);
    if (!c) {
        call.raise("Null parameter");
        return;
    }
    Vec2f startPos = Vec2f(call.getReal(0), call.getReal(1));
    Vec2f endPos = Vec2f(call.getReal(2), call.getReal(3));
    setScriptColor(Color(c.getReal("r"), c.getReal("g"), c.getReal("b")));
    setScriptAlpha(call.getReal(5));
    drawLine(startPos, endPos, getScriptColor(), getScriptAlpha());
}

private void _rectangle0(GrCall call) {
    Vec2f pos = Vec2f(call.getReal(0), call.getReal(1));
    Vec2f size = Vec2f(call.getReal(2), call.getReal(3));
    if (call.getBool(4))
        drawFilledRect(pos, size, getScriptColor(), getScriptAlpha());
    else
        drawRect(pos, size, getScriptColor(), getScriptAlpha());
}

private void _rectangle1(GrCall call) {
    GrObject c = call.getObject(5);
    if (!c) {
        call.raise("Null parameter");
        return;
    }
    Vec2f pos = Vec2f(call.getReal(0), call.getReal(1));
    Vec2f size = Vec2f(call.getReal(2), call.getReal(3));
    setScriptColor(Color(c.getReal("r"), c.getReal("g"), c.getReal("b")));
    if (call.getBool(4))
        drawFilledRect(pos, size, getScriptColor(), getScriptAlpha());
    else
        drawRect(pos, size, getScriptColor(), getScriptAlpha());
}

private void _rectangle2(GrCall call) {
    Vec2f pos = Vec2f(call.getReal(0), call.getReal(1));
    Vec2f size = Vec2f(call.getReal(2), call.getReal(3));
    setScriptAlpha(call.getReal(5));
    if (call.getBool(4))
        drawFilledRect(pos, size, getScriptColor(), getScriptAlpha());
    else
        drawRect(pos, size, getScriptColor(), getScriptAlpha());
}

private void _rectangle3(GrCall call) {
    GrObject c = call.getObject(5);
    if (!c) {
        call.raise("Null parameter");
        return;
    }
    Vec2f pos = Vec2f(call.getReal(0), call.getReal(1));
    Vec2f size = Vec2f(call.getReal(2), call.getReal(3));
    setScriptColor(Color(c.getReal("r"), c.getReal("g"), c.getReal("b")));
    setScriptAlpha(call.getReal(6));
    if (call.getBool(4))
        drawFilledRect(pos, size, getScriptColor(), getScriptAlpha());
    else
        drawRect(pos, size, getScriptColor(), getScriptAlpha());
}

private void _pixel0(GrCall call) {
    Vec2f pos = Vec2f(call.getReal(0), call.getReal(1));
    drawPixel(pos, getScriptColor(), getScriptAlpha());
}

private void _pixel1(GrCall call) {
    GrObject c = call.getObject(2);
    if (!c) {
        call.raise("Null parameter");
        return;
    }
    Vec2f pos = Vec2f(call.getReal(0), call.getReal(1));
    setScriptColor(Color(c.getReal("r"), c.getReal("g"), c.getReal("b")));
    drawPixel(pos, getScriptColor(), getScriptAlpha());
}

private void _pixel2(GrCall call) {
    Vec2f pos = Vec2f(call.getReal(0), call.getReal(1));
    setScriptAlpha(call.getReal(2));
    drawPixel(pos, getScriptColor(), getScriptAlpha());
}

private void _pixel3(GrCall call) {
    GrObject c = call.getObject(2);
    if (!c) {
        call.raise("Null parameter");
        return;
    }
    Vec2f pos = Vec2f(call.getReal(0), call.getReal(1));
    setScriptColor(Color(c.getReal("r"), c.getReal("g"), c.getReal("b")));
    setScriptAlpha(call.getReal(3));
    drawPixel(pos, getScriptColor(), getScriptAlpha());
}

private void _getWidth(GrCall call) {
    call.setReal(getLayersSize().x);
}

private void _getHeight(GrCall call) {
    call.setReal(getLayersSize().y);
}

private void _getSize(GrCall call) {
    Vec2i size = getLayersSize();
    call.setReal(size.x);
    call.setReal(size.y);
}

private void _getCenterX(GrCall call) {
    call.setReal(getLayersSize().x / 2);
}

private void _getCenterY(GrCall call) {
    call.setReal(getLayersSize().y / 2);
}

private void _getCenter(GrCall call) {
    Vec2i size = getLayersSize() / 2;
    call.setReal(size.x);
    call.setReal(size.y);
}
