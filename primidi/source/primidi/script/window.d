module primidi.script.window;

import std.conv;
import grimoire, atelier;

package void loadWindow() {
    auto defColor = grGetTupleType("Color");

    grAddPrimitive(&_setRenderColor, "setRenderColor", ["color"], [defColor]);
    grAddPrimitive(&_drawPoint, "drawPoint", ["x", "y", "color"], [grFloat, grFloat, defColor]);
    grAddPrimitive(&_drawLine, "drawLine", ["x1", "y1", "x2", "y2", "color"], [grFloat, grFloat, grFloat, grFloat, defColor]);
    grAddPrimitive(&_drawRect, "drawRect", ["x", "y", "w", "h", "color"], [grFloat, grFloat, grFloat, grFloat, defColor]);
    grAddPrimitive(&_drawFilledRect, "fillRect", ["x", "y", "w", "h", "color"], [grFloat, grFloat, grFloat, grFloat, defColor]);
    grAddPrimitive(&_drawPixel, "drawPixel", ["x", "y", "color"], [grFloat, grFloat, defColor]);
    
    grAddPrimitive(&_screenWidth, "screenWidth", [], [], [grFloat]);
    grAddPrimitive(&_screenHeight, "screenHeight", [], [], [grFloat]);
    grAddPrimitive(&_screenSize, "screenSize", [], [], [grFloat, grFloat]);
    grAddPrimitive(&_screenCenter, "screenCenter", [], [], [grFloat, grFloat]);
}

private void _setRenderColor(GrCall call) {
    Color color = Color(
        call.getFloat("color:r"),
        call.getFloat("color:g"),
        call.getFloat("color:b"),
        call.getFloat("color:a"));
    setRenderColor(color);
}

private void _drawPoint(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("x"), call.getFloat("y"));
    Color color = Color(
        call.getFloat("color:r"),
        call.getFloat("color:g"),
        call.getFloat("color:b"),
        call.getFloat("color:a"));
    drawPoint(pos, color);
}

private void _drawLine(GrCall call) {
    Vec2f startPos = Vec2f(call.getFloat("x1"), call.getFloat("y1"));
    Vec2f endPos = Vec2f(call.getFloat("x2"), call.getFloat("y2"));
    Color color = Color(
        call.getFloat("color:r"),
        call.getFloat("color:g"),
        call.getFloat("color:b"),
        call.getFloat("color:a"));
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
    Color color = Color(
        call.getFloat("color:r"),
        call.getFloat("color:g"),
        call.getFloat("color:b"),
        call.getFloat("color:a"));
    drawFilledRect(pos, size, color);
}

private void _drawPixel(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("x"), call.getFloat("y"));
    Color color = Color(
        call.getFloat("color:r"),
        call.getFloat("color:g"),
        call.getFloat("color:b"),
        call.getFloat("color:a"));
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