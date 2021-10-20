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

    library.addPrimitive(&_drawPoint, "drawPoint", [
            grFloat, grFloat, colorType, grFloat
            ]);
    library.addPrimitive(&_drawPointDefault, "drawPoint", [grFloat, grFloat]);
    library.addPrimitive(&_drawLine, "drawLine", [
            grFloat, grFloat, grFloat, grFloat, colorType, grFloat
            ]);
    library.addPrimitive(&_drawLineDefault, "drawLine", [
            grFloat, grFloat, grFloat, grFloat
            ]);
    library.addPrimitive(&_drawRect, "drawRect", [
            grFloat, grFloat, grFloat, grFloat, colorType, grFloat
            ]);
    library.addPrimitive(&_drawRectDefault, "drawRect", [
            grFloat, grFloat, grFloat, grFloat
            ]);
    library.addPrimitive(&_fillRect, "fillRect", [
            grFloat, grFloat, grFloat, grFloat, colorType, grFloat
            ]);
    library.addPrimitive(&_fillRectDefault, "fillRect", [
            grFloat, grFloat, grFloat, grFloat
            ]);
    library.addPrimitive(&_drawPixel, "drawPixel", [
            grFloat, grFloat, colorType, grFloat
            ]);
    library.addPrimitive(&_drawPixelDefault, "drawPixel", [grFloat, grFloat]);

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

private void _drawPoint(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    auto c = call.getObject(2);
    Color color = Color(c.getFloat("r"), c.getFloat("g"), c.getFloat("b"));
    drawPoint(pos, color, call.getFloat(3));
}

private void _drawPointDefault(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    drawPoint(pos, getScriptColor(), getScriptAlpha());
}

private void _drawLine(GrCall call) {
    Vec2f startPos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f endPos = Vec2f(call.getFloat(2), call.getFloat(3));
    auto c = call.getObject(4);
    Color color = Color(c.getFloat("r"), c.getFloat("g"), c.getFloat("b"));
    drawLine(startPos, endPos, color, call.getFloat(5));
}

private void _drawLineDefault(GrCall call) {
    Vec2f startPos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f endPos = Vec2f(call.getFloat(2), call.getFloat(3));
    drawLine(startPos, endPos, getScriptColor(), getScriptAlpha());
}

private void _drawRect(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f size = Vec2f(call.getFloat(2), call.getFloat(3));
    auto c = call.getObject(4);
    Color color = Color(c.getFloat("r"), c.getFloat("g"), c.getFloat("b"));
    drawRect(pos, size, color, call.getFloat(5));
}

private void _drawRectDefault(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f size = Vec2f(call.getFloat(2), call.getFloat(3));
    drawRect(pos, size, getScriptColor(), getScriptAlpha());
}

private void _fillRect(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f size = Vec2f(call.getFloat(2), call.getFloat(3));
    auto c = call.getObject(4);
    Color color = Color(c.getFloat("r"), c.getFloat("g"), c.getFloat("b"));
    drawFilledRect(pos, size, color, call.getFloat(5));
}

private void _fillRectDefault(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f size = Vec2f(call.getFloat(2), call.getFloat(3));
    drawFilledRect(pos, size, getScriptColor(), getScriptAlpha());
}

private void _drawPixel(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    auto c = call.getObject(2);
    Color color = Color(c.getFloat("r"), c.getFloat("g"), c.getFloat("b"));
    drawPixel(pos, color, call.getFloat(3));
}

private void _drawPixelDefault(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
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
