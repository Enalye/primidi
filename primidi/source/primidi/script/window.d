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

    data.addPrimitive(&_setRenderColor, "setRenderColor", ["color"], [defColor]);
    data.addPrimitive(&_drawPoint, "drawPoint", ["x", "y", "color"], [grFloat, grFloat, defColor]);
    data.addPrimitive(&_drawLine, "drawLine", ["x1", "y1", "x2", "y2", "color"], [grFloat, grFloat, grFloat, grFloat, defColor]);
    data.addPrimitive(&_drawRect, "drawRect", ["x", "y", "w", "h", "color"], [grFloat, grFloat, grFloat, grFloat, defColor]);
    data.addPrimitive(&_drawFilledRect, "fillRect", ["x", "y", "w", "h", "color"], [grFloat, grFloat, grFloat, grFloat, defColor]);
    data.addPrimitive(&_drawPixel, "drawPixel", ["x", "y", "color"], [grFloat, grFloat, defColor]);
    
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
        c.getFloat("b"),
        c.getFloat("a"));
    setRenderColor(color);
}

private void _drawPoint(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("x"), call.getFloat("y"));
    auto c = call.getObject("color");
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"),
        c.getFloat("a"));
    drawPoint(pos, color);
}

private void _drawLine(GrCall call) {
    Vec2f startPos = Vec2f(call.getFloat("x1"), call.getFloat("y1"));
    Vec2f endPos = Vec2f(call.getFloat("x2"), call.getFloat("y2"));
    auto c = call.getObject("color");
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"),
        c.getFloat("a"));
    drawLine(startPos, endPos, color);
}

private void _drawRect(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("x"), call.getFloat("y"));
    Vec2f size = Vec2f(call.getFloat("w"), call.getFloat("h"));
    Color color = Color(
        call.getFloat("color:r"),
        call.getFloat("color:g"),
        call.getFloat("color:b"),
        call.getFloat("color:a"));
    drawRect(pos, size, color);
}

private void _drawFilledRect(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("x"), call.getFloat("y"));
    Vec2f size = Vec2f(call.getFloat("w"), call.getFloat("h"));
    auto c = call.getObject("color");
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"),
        c.getFloat("a"));
    drawFilledRect(pos, size, color);
}

private void _drawPixel(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("x"), call.getFloat("y"));
    auto c = call.getObject("color");
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"),
        c.getFloat("a"));
    drawPixel(pos, color);
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