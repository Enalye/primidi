/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.window;

import std.conv;
import grimoire, atelier;

package void loadWindow(GrData data) {
    auto defColor = grGetClassType("Color");

    data.addPrimitive(&_setRenderColor, "setRenderColor", ["color", "a"], [defColor, grFloat]);
    data.addPrimitive(&_drawPoint, "drawPoint", ["x", "y", "color", "a"], [grFloat, grFloat, defColor, grFloat]);
    data.addPrimitive(&_drawLine, "drawLine", ["x1", "y1", "x2", "y2", "color", "a"], [grFloat, grFloat, grFloat, grFloat, defColor, grFloat]);
    data.addPrimitive(&_drawRect, "drawRect", ["x", "y", "w", "h", "color", "a"], [grFloat, grFloat, grFloat, grFloat, defColor, grFloat]);
    data.addPrimitive(&_drawFilledRect, "fillRect", ["x", "y", "w", "h", "color", "a"], [grFloat, grFloat, grFloat, grFloat, defColor, grFloat]);
    data.addPrimitive(&_drawPixel, "drawPixel", ["x", "y", "color", "a"], [grFloat, grFloat, defColor, grFloat]);
    
    data.addPrimitive(&_screenWidth, "screenWidth", [], [], [grFloat]);
    data.addPrimitive(&_screenHeight, "screenHeight", [], [], [grFloat]);
    data.addPrimitive(&_screenSize, "screenSize", [], [], [grFloat, grFloat]);
    data.addPrimitive(&_screenCenter, "screenCenter", [], [], [grFloat, grFloat]);
}

private void _setRenderColor(GrCall call) {
    auto c = call.getObject("color");
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"));
    setRenderColor(color, call.getFloat("a"));
}

private void _drawPoint(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("x"), call.getFloat("y"));
    auto c = call.getObject("color");
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"));
    drawPoint(pos, color, call.getFloat("a"));
}

private void _drawLine(GrCall call) {
    Vec2f startPos = Vec2f(call.getFloat("x1"), call.getFloat("y1"));
    Vec2f endPos = Vec2f(call.getFloat("x2"), call.getFloat("y2"));
    auto c = call.getObject("color");
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"));
    drawLine(startPos, endPos, color, call.getFloat("a"));
}

private void _drawRect(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("x"), call.getFloat("y"));
    Vec2f size = Vec2f(call.getFloat("w"), call.getFloat("h"));
    auto c = call.getObject("color");
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"));
    drawRect(pos, size, color, call.getFloat("a"));
}

private void _drawFilledRect(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("x"), call.getFloat("y"));
    Vec2f size = Vec2f(call.getFloat("w"), call.getFloat("h"));
    auto c = call.getObject("color");
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"));
    drawFilledRect(pos, size, color, call.getFloat("a"));
}

private void _drawPixel(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("x"), call.getFloat("y"));
    auto c = call.getObject("color");
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"));
    drawPixel(pos, color, call.getFloat("a"));
}

private void _screenWidth(GrCall call) {
    call.setFloat(screenWidth());
}

private void _screenHeight(GrCall call) {
    call.setFloat(screenHeight());
}

private void _screenSize(GrCall call) {
    call.setFloat(screenWidth());
    call.setFloat(screenHeight());
}

private void _screenCenter(GrCall call) {
    const center = centerScreen();
    call.setFloat(cast(int)center.x);
    call.setFloat(cast(int)center.y);
}