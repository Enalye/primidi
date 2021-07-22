/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.canvas;

import grimoire, atelier;

private {
    Canvas _canvas;
}

void setScriptCanvas(Canvas canvas) {
    _canvas = canvas;
}

package void loadCanvas(GrLibrary library) {
    const defCanvas = library.addForeign("Canvas");
    const defColor = grGetClassType("Color");
    auto defBlend = grGetEnumType("Blend");

    library.addPrimitive(&_makeCanvasf, "Canvas", [grFloat, grFloat], [defCanvas]);
    library.addPrimitive(&_makeCanvasi, "Canvas", [grInt, grInt], [defCanvas]);
    library.addPrimitive(&_pushCanvas, "pushCanvas", [defCanvas]);
    library.addPrimitive(&_popCanvas, "popCanvas");
    library.addPrimitive(&_clearCanvas, "clear", [defCanvas]);
    library.addPrimitive(&_renderCanvas, "draw", [defCanvas, grFloat, grFloat]);
    
    library.addPrimitive(&_setClearColor, "setClearColor", [defCanvas, defColor]);
    library.addPrimitive(&_setClearAlpha, "setClearAlpha", [defCanvas, grFloat]);
    library.addPrimitive(&_setColorMod, "setColorMod", [defCanvas, defColor, defBlend]);
    library.addPrimitive(&_setAlpha, "setAlpha", [defCanvas, grInt]);
    library.addPrimitive(&_setPosition, "setPosition", [defCanvas, grFloat, grFloat]);

    library.addPrimitive(&_setCameraSizei, "setCameraSize", [grInt, grInt]);
    library.addPrimitive(&_setCameraSizef, "setCameraSize", [grFloat, grFloat]);
    library.addPrimitive(&_setCameraPosition, "setCameraPosition", [grFloat, grFloat]);
    library.addPrimitive(&_setCameraClearColor, "setCameraClearColor", [defColor, grFloat]);
}

private void _makeCanvasf(GrCall call) {
    call.setForeign!Canvas(new Canvas(Vec2f(call.getFloat(0), call.getFloat(1))));
}

private void _makeCanvasi(GrCall call) {
    call.setForeign!Canvas(new Canvas(Vec2i(call.getInt(0), call.getInt(1))));
}

private void _pushCanvas(GrCall call) {
    pushCanvas(call.getForeign!Canvas(0), false);
}

private void _popCanvas(GrCall call) {
    popCanvas();
}

private void _clearCanvas(GrCall call) {
    pushCanvas(call.getForeign!Canvas(0), true);
    popCanvas();
}

private void _renderCanvas(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    canvas.draw(Vec2f(call.getFloat(1), call.getFloat(2)));
}

private void _setClearColor(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    auto obj = call.getObject(1);
    canvas.color = Color(obj.getFloat("r"), obj.getFloat("g"), obj.getFloat("b"));
}

private void _setClearAlpha(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    canvas.alpha = call.getFloat(1);
}

private void _setColorMod(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    auto obj = call.getObject(1);
    const Color color = Color(obj.getFloat("r"), obj.getFloat("g"), obj.getFloat("b"));
    const Blend blend = call.getEnum!Blend(2);
    canvas.setColorMod(color, blend);
}

private void _setAlpha(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    const float alpha = call.getInt(1);
    canvas.setAlpha(alpha);
}

private void _setPosition(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    canvas.position = Vec2f(call.getFloat(1), call.getFloat(2));
}

private void _setCameraSizef(GrCall call) {
    _canvas.size = Vec2f(call.getFloat(0), call.getFloat(1));
}

private void _setCameraSizei(GrCall call) {
    _canvas.size = Vec2f(call.getInt(0), call.getInt(1));
}

private void _setCameraPosition(GrCall call) {
    _canvas.position = Vec2f(call.getFloat(0), call.getFloat(1));
}

private void _setCameraClearColor(GrCall call) {
    auto obj = call.getObject(0);
    const Color color = Color(obj.getFloat("r"), obj.getFloat("g"), obj.getFloat("b"));
    _canvas.color = color;
    _canvas.alpha = call.getFloat(1);
}