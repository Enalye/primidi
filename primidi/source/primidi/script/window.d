/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.window;

import std.conv;
import grimoire, atelier;

package void loadWindow(GrLibrary library) {
    auto defColor = grGetClassType("Color");

    library.addPrimitive(&_setRenderColor, "setRenderColor", [defColor, grFloat]);
    library.addPrimitive(&_drawPoint, "drawPoint", [grFloat, grFloat, defColor, grFloat]);
    library.addPrimitive(&_drawLine, "drawLine", [grFloat, grFloat, grFloat, grFloat, defColor, grFloat]);
    library.addPrimitive(&_drawRect, "drawRect", [grFloat, grFloat, grFloat, grFloat, defColor, grFloat]);
    library.addPrimitive(&_drawFilledRect, "fillRect", [grFloat, grFloat, grFloat, grFloat, defColor, grFloat]);
    library.addPrimitive(&_drawPixel, "drawPixel", [grFloat, grFloat, defColor, grFloat]);
    
    library.addPrimitive(&_screenWidth, "screenWidth", [], [grFloat]);
    library.addPrimitive(&_screenHeight, "screenHeight", [], [grFloat]);
    library.addPrimitive(&_screenSize, "screenSize", [], [grFloat, grFloat]);
    library.addPrimitive(&_screenCenter, "screenCenter", [], [grFloat, grFloat]);
}

private void _setRenderColor(GrCall call) {
    auto c = call.getObject(0);
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"));
    setRenderColor(color, call.getFloat(1));
}

private void _drawPoint(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    auto c = call.getObject(2);
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"));
    drawPoint(pos, color, call.getFloat(3));
}

private void _drawLine(GrCall call) {
    Vec2f startPos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f endPos = Vec2f(call.getFloat(2), call.getFloat(3));
    auto c = call.getObject(4);
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"));
    drawLine(startPos, endPos, color, call.getFloat(5));
}

private void _drawRect(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f size = Vec2f(call.getFloat(2), call.getFloat(3));
    auto c = call.getObject(4);
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"));
    drawRect(pos, size, color, call.getFloat(5));
}

private void _drawFilledRect(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    Vec2f size = Vec2f(call.getFloat(2), call.getFloat(3));
    auto c = call.getObject(4);
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"));
    drawFilledRect(pos, size, color, call.getFloat(5));
}

private void _drawPixel(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat(0), call.getFloat(1));
    auto c = call.getObject(2);
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"));
    drawPixel(pos, color, call.getFloat(3));
}

private void _screenWidth(GrCall call) {
    call.setFloat(getWindowWidth());
}

private void _screenHeight(GrCall call) {
    call.setFloat(getWindowHeight());
}

private void _screenSize(GrCall call) {
    call.setFloat(getWindowWidth());
    call.setFloat(getWindowHeight());
}

private void _screenCenter(GrCall call) {
    const center = getWindowCenter();
    call.setFloat(cast(int)center.x);
    call.setFloat(cast(int)center.y);
}