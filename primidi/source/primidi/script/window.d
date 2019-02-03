module primidi.script.window;

import std.conv;
import grimoire, atelier;

package void loadWindow() {
    auto defColor = grGetStructureType("Color");
    auto defVec2f = grGetStructureType("Vec2f");

    grAddPrimitive(&_setRenderColor, "setRenderColor", ["color"], [defColor]);
    grAddPrimitive(&_drawPoint, "drawPoint", ["pos", "color"], [defVec2f, defColor]);
    grAddPrimitive(&_drawLine, "drawLine", ["startPos", "endPos", "color"], [defVec2f, defVec2f, defColor]);
    grAddPrimitive(&_drawRect, "drawRect", ["pos", "size", "color"], [defVec2f, defVec2f, defColor]);
    grAddPrimitive(&_drawFilledRect, "fillRect", ["pos", "size", "color"], [defVec2f, defVec2f, defColor]);
    grAddPrimitive(&_drawPixel, "drawPixel", ["pos", "color"], [defVec2f, defColor]);
    
    grAddPrimitive(&_screenWidth, "screenWidth", [], [], grInt);
    grAddPrimitive(&_screenHeight, "screenHeight", [], [], grInt);
    grAddPrimitive(&_screenSize, "screenSize", [], [], defVec2f);
    grAddPrimitive(&_screenCenter, "screenCenter", [], [], defVec2f);
}

private void _setRenderColor(GrCall call) {
    Color color = Color(
        call.getFloat("color.r"),
        call.getFloat("color.g"),
        call.getFloat("color.b"),
        call.getFloat("color.a"));
    setRenderColor(color);
}

private void _drawPoint(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("pos.x"), call.getFloat("pos.y"));
    Color color = Color(
        call.getFloat("color.r"),
        call.getFloat("color.g"),
        call.getFloat("color.b"),
        call.getFloat("color.a"));
    drawPoint(pos, color);
}

private void _drawLine(GrCall call) {
    Vec2f startPos = Vec2f(call.getFloat("startPos.x"), call.getFloat("startPos.y"));
    Vec2f endPos = Vec2f(call.getFloat("endPos.x"), call.getFloat("endPos.y"));
    Color color = Color(
        call.getFloat("color.r"),
        call.getFloat("color.g"),
        call.getFloat("color.b"),
        call.getFloat("color.a"));
    drawLine(startPos, endPos, color);
}

private void _drawRect(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("pos.x"), call.getFloat("pos.y"));
    Vec2f size = Vec2f(call.getFloat("size.x"), call.getFloat("size.y"));
    Color color = Color(
        call.getFloat("color.r"),
        call.getFloat("color.g"),
        call.getFloat("color.b"),
        call.getFloat("color.a"));
    drawRect(pos, size, color);
}

private void _drawFilledRect(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("pos.x"), call.getFloat("pos.y"));
    Vec2f size = Vec2f(call.getFloat("size.x"), call.getFloat("size.y"));
    Color color = Color(
        call.getFloat("color.r"),
        call.getFloat("color.g"),
        call.getFloat("color.b"),
        call.getFloat("color.a"));
    drawFilledRect(pos, size, color);
}

private void _drawPixel(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("pos.x"), call.getFloat("pos.y"));
    Color color = Color(
        call.getFloat("color.r"),
        call.getFloat("color.g"),
        call.getFloat("color.b"),
        call.getFloat("color.a"));
    drawPixel(pos, color);
}

private void _screenWidth(GrCall call) {
    call.setInt(screenWidth());
}

private void _screenHeight(GrCall call) {
    call.setInt(screenHeight());
}

private void _screenSize(GrCall call) {
    const size = screenSize();
    call.setFloat(size.x);
    call.setFloat(size.y);
}

private void _screenCenter(GrCall call) {
    const center = centerScreen();
    call.setFloat(center.x);
    call.setFloat(center.y);
}