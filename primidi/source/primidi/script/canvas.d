module primidi.script.canvas;

import grimoire, atelier;

package void loadCanvas(GrData data) {
    const defCanvas = data.addUserType("Canvas");
    const defColor = grGetTupleType("Color");

    data.addPrimitive(&_makeCanvasf, "Canvas", ["w", "h"], [grFloat, grFloat], [defCanvas]);
    data.addPrimitive(&_makeCanvasi, "Canvas", ["w", "h"], [grInt, grInt], [defCanvas]);
    data.addPrimitive(&_pushCanvas, "pushCanvas", ["canvas"], [defCanvas]);
    data.addPrimitive(&_popCanvas, "popCanvas", [], []);
    data.addPrimitive(&_clearCanvas, "clear", ["canvas"], [defCanvas]);
    data.addPrimitive(&_renderCanvas, "draw", ["canvas", "x", "y"], [defCanvas, grFloat, grFloat]);
    
    data.addPrimitive(&_setColorMod, "setColorMod", ["canvas", "color", "blend"], [defCanvas, defColor, grInt]);
    data.addPrimitive(&_setAlpha, "setAlpha", ["canvas", "alpha"], [defCanvas, grInt]);
    data.addPrimitive(&_setPosition, "setPosition", ["canvas", "x", "y"], [defCanvas, grFloat, grFloat]);
}

private void _makeCanvasf(GrCall call) {
    call.setUserData!Canvas(new Canvas(Vec2f(call.getFloat("w"), call.getFloat("h"))));
}

private void _makeCanvasi(GrCall call) {
    call.setUserData!Canvas(new Canvas(Vec2i(call.getInt("w"), call.getInt("h"))));
}

private void _pushCanvas(GrCall call) {
    pushCanvas(call.getUserData!Canvas("canvas"), false);
}

private void _popCanvas(GrCall call) {
    popCanvas();
}

private void _clearCanvas(GrCall call) {
    pushCanvas(call.getUserData!Canvas("canvas"), true);
    popCanvas();
}

private void _renderCanvas(GrCall call) {
    Canvas canvas = call.getUserData!Canvas("canvas");
    canvas.draw(Vec2f(call.getFloat("x"), call.getFloat("y")));
}

private void _setColorMod(GrCall call) {
    Canvas canvas = call.getUserData!Canvas("canvas");
    Color color = Color(
        call.getFloat("color:r"),
        call.getFloat("color:g"),
        call.getFloat("color:b"),
        call.getFloat("color:a"));
    const Blend blend = cast(Blend)call.getInt("blend");
    canvas.setColorMod(color, blend);
}

private void _setAlpha(GrCall call) {
    Canvas canvas = call.getUserData!Canvas("canvas");
    const float alpha = call.getInt("alpha");
    canvas.setAlpha(alpha);
}

private void _setPosition(GrCall call) {
    Canvas canvas = call.getUserData!Canvas("canvas");
    canvas.position = Vec2f(call.getFloat("x"), call.getFloat("y"));
}