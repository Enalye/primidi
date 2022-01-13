/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.window;

import std.conv;
import grimoire, atelier;
import primidi.gui;
import primidi.script.util;

package void loadWindowLibrary(GrLibrary library) {
    auto colorType = grGetClassType("Color");

    library.addPrimitive(&_setColor, "setColor", [colorType]);
    library.addPrimitive(&_getColor, "getColor", [], [colorType]);
    library.addPrimitive(&_setAlpha, "setAlpha", [grFloat]);
    library.addPrimitive(&_getAlpha, "getAlpha", [], [grFloat]);

    library.addPrimitive(&_point0, "point", [grFloat, grFloat]);
    library.addPrimitive(&_point1, "point", [grFloat, grFloat, colorType]);
    library.addPrimitive(&_point2, "point", [grFloat, grFloat, grFloat]);
    library.addPrimitive(&_point3, "point", [
            grFloat, grFloat, colorType, grFloat
        ]);

    library.addPrimitive(&_line0, "line", [
            grFloat, grFloat, grFloat, grFloat
        ]);
    library.addPrimitive(&_line1, "line", [
            grFloat, grFloat, grFloat, grFloat, colorType
        ]);
    library.addPrimitive(&_line2, "line", [
            grFloat, grFloat, grFloat, grFloat, grFloat
        ]);
    library.addPrimitive(&_line3, "line", [
            grFloat, grFloat, grFloat, grFloat, colorType, grFloat
        ]);

    library.addPrimitive(&_rectangle0, "rectangle", [
            grFloat, grFloat, grFloat, grFloat, grBool
        ]);
    library.addPrimitive(&_rectangle1, "rectangle", [
            grFloat, grFloat, grFloat, grFloat, grBool, colorType
        ]);
    library.addPrimitive(&_rectangle2, "rectangle", [
            grFloat, grFloat, grFloat, grFloat, grBool, grFloat
        ]);
    library.addPrimitive(&_rectangle3, "rectangle", [
            grFloat, grFloat, grFloat, grFloat, grBool, colorType, grFloat
        ]);

    library.addPrimitive(&_pixel0, "pixel", [grFloat, grFloat]);
    library.addPrimitive(&_pixel1, "pixel", [
            grFloat, grFloat, colorType
        ]);
    library.addPrimitive(&_pixel2, "pixel", [
            grFloat, grFloat, grFloat
        ]);
    library.addPrimitive(&_pixel3, "pixel", [
            grFloat, grFloat, colorType, grFloat
        ]);

    library.addPrimitive(&_getWidth, "getWidth", [], [grFloat]);
    library.addPrimitive(&_getHeight, "getHeight", [], [grFloat]);
    library.addPrimitive(&_getSize, "getSize", [], [grFloat, grFloat]);
    library.addPrimitive(&_getCenterX, "getCenterX", [], [grFloat]);
    library.addPrimitive(&_getCenterY, "getCenterY", [], [grFloat]);
    library.addPrimitive(&_getCenter, "getCenter", [], [grFloat, grFloat]);
}

private void _setColor(GrCall call) {
    GrObject obj = call.getObject(0);
    Color color = Color(obj.getFloat("r"), obj.getFloat("g"), obj.getFloat("b"));
    setScriptColor(color);
}

private void _getColor(GrCall call) {
    Color color = getScriptColor();
    GrObject obj = call.createObject("Color");
    obj.setFloat("r", color.r);
    obj.setFloat("g", color.g);
    obj.setFloat("b", color.b);
    call.setObject(obj);
}

private void _setAlpha(GrCall call) {
    setScriptAlpha(call.getFloat(0));
}

private void _getAlpha(GrCall call) {
    call.setFloat(getScriptAlpha());
}

private void _point0(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    drawPoint(pos, getScriptColor(), getScriptAlpha());
}

private void _point1(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    auto c = call.getObject(2);
    setScriptColor(Color(c.getFloat("r"), c.getFloat("g"), c.getFloat("b")));
    drawPoint(pos, getScriptColor(), getScriptAlpha());
}

private void _point2(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    setScriptAlpha(call.getFloat(2));
    drawPoint(pos, getScriptColor(), getScriptAlpha());
}

private void _point3(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    auto c = call.getObject(2);
    setScriptColor(Color(c.getFloat("r"), c.getFloat("g"), c.getFloat("b")));
    setScriptAlpha(call.getFloat(3));
    drawPoint(pos, getScriptColor(), getScriptAlpha());
}

private void _line0(GrCall call) {
    Vec2f startPos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f endPos = Vec2f(call.getFloat(2), call.getFloat(3));
    drawLine(startPos, endPos, getScriptColor(), getScriptAlpha());
}

private void _line1(GrCall call) {
    Vec2f startPos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f endPos = Vec2f(call.getFloat(2), call.getFloat(3));
    auto c = call.getObject(4);
    setScriptColor(Color(c.getFloat("r"), c.getFloat("g"), c.getFloat("b")));
    drawLine(startPos, endPos, getScriptColor(), getScriptAlpha());
}

private void _line2(GrCall call) {
    Vec2f startPos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f endPos = Vec2f(call.getFloat(2), call.getFloat(3));
    setScriptAlpha(call.getFloat(4));
    drawLine(startPos, endPos, getScriptColor(), getScriptAlpha());
}

private void _line3(GrCall call) {
    Vec2f startPos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f endPos = Vec2f(call.getFloat(2), call.getFloat(3));
    auto c = call.getObject(4);
    setScriptColor(Color(c.getFloat("r"), c.getFloat("g"), c.getFloat("b")));
    setScriptAlpha(call.getFloat(5));
    drawLine(startPos, endPos, getScriptColor(), getScriptAlpha());
}

private void _rectangle0(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f size = Vec2f(call.getFloat(2), call.getFloat(3));
    if (call.getBool(4))
        drawFilledRect(pos, size, getScriptColor(), getScriptAlpha());
    else
        drawRect(pos, size, getScriptColor(), getScriptAlpha());
}

private void _rectangle1(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f size = Vec2f(call.getFloat(2), call.getFloat(3));
    auto c = call.getObject(5);
    setScriptColor(Color(c.getFloat("r"), c.getFloat("g"), c.getFloat("b")));
    if (call.getBool(4))
        drawFilledRect(pos, size, getScriptColor(), getScriptAlpha());
    else
        drawRect(pos, size, getScriptColor(), getScriptAlpha());
}

private void _rectangle2(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f size = Vec2f(call.getFloat(2), call.getFloat(3));
    setScriptAlpha(call.getFloat(5));
    if (call.getBool(4))
        drawFilledRect(pos, size, getScriptColor(), getScriptAlpha());
    else
        drawRect(pos, size, getScriptColor(), getScriptAlpha());
}

private void _rectangle3(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f size = Vec2f(call.getFloat(2), call.getFloat(3));
    auto c = call.getObject(5);
    setScriptColor(Color(c.getFloat("r"), c.getFloat("g"), c.getFloat("b")));
    setScriptAlpha(call.getFloat(6));
    if (call.getBool(4))
        drawFilledRect(pos, size, getScriptColor(), getScriptAlpha());
    else
        drawRect(pos, size, getScriptColor(), getScriptAlpha());
}

private void _pixel0(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    drawPixel(pos, getScriptColor(), getScriptAlpha());
}

private void _pixel1(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    auto c = call.getObject(2);
    setScriptColor(Color(c.getFloat("r"), c.getFloat("g"), c.getFloat("b")));
    drawPixel(pos, getScriptColor(), getScriptAlpha());
}

private void _pixel2(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    setScriptAlpha(call.getFloat(2));
    drawPixel(pos, getScriptColor(), getScriptAlpha());
}

private void _pixel3(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    auto c = call.getObject(2);
    setScriptColor(Color(c.getFloat("r"), c.getFloat("g"), c.getFloat("b")));
    setScriptAlpha(call.getFloat(3));
    drawPixel(pos, getScriptColor(), getScriptAlpha());
}

private void _getWidth(GrCall call) {
    call.setFloat(getLayersSize().x);
}

private void _getHeight(GrCall call) {
    call.setFloat(getLayersSize().y);
}

private void _getSize(GrCall call) {
    Vec2i size = getLayersSize();
    call.setFloat(size.x);
    call.setFloat(size.y);
}

private void _getCenterX(GrCall call) {
    call.setFloat(getLayersSize().x / 2);
}

private void _getCenterY(GrCall call) {
    call.setFloat(getLayersSize().y / 2);
}

private void _getCenter(GrCall call) {
    Vec2i size = getLayersSize() / 2;
    call.setFloat(size.x);
    call.setFloat(size.y);
}
