module primidi.script.canvas;

import grimoire, atelier;

package void loadCanvas() {
    const defCanvas = grAddUserType("Canvas");
    const defVec2f = grGetStructureType("Vec2f");
    const defColor = grGetStructureType("Color");

    grAddPrimitive(&_makeCanvas, "Canvas", ["width", "height"], [grInt, grInt], defCanvas);
    grAddPrimitive(&_pushCanvas, "canvas_push", ["canvas"], [defCanvas]);
    grAddPrimitive(&_popCanvas, "canvas_pop", [], []);
    grAddPrimitive(&_clearCanvas, "canvas_clear", ["canvas"], [defCanvas]);
    grAddPrimitive(&_renderCanvas, "canvas_render", ["canvas", "pos"], [defCanvas, defVec2f]);
    
    grAddPrimitive(&_setColorMod, "canvas_setColorMod", ["canvas", "color", "blend"], [defCanvas, defColor, grInt]);
    grAddPrimitive(&_setAlpha, "canvas_setAlpha", ["canvas", "pos"], [defCanvas, grFloat]);
}

private void _makeCanvas(GrCall call) {
    call.setUserData!Canvas(new Canvas(Vec2i(call.getInt("width"), call.getInt("height"))));
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
    canvas.draw(Vec2f(call.getFloat("pos.x"), call.getFloat("pos.y")));
}

private void _setColorMod(GrCall call) {
    Canvas canvas = call.getUserData!Canvas("canvas");
    Color color = Color(
        call.getFloat("color.r"),
        call.getFloat("color.g"),
        call.getFloat("color.b"),
        call.getFloat("color.a"));
    const Blend blend = cast(Blend)call.getInt("blend");
    canvas.setColorMod(color, blend);

}

private void _setAlpha(GrCall call) {
    Canvas canvas = call.getUserData!Canvas("canvas");
    const float alpha = call.getInt("alpha");
    canvas.setAlpha(alpha);
}