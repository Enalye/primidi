/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.layer;

import grimoire, atelier;
import primidi.gui;

package void loadLayerLibrary(GrLibrary library) {
    const defColor = grGetClassType("Color");
    auto defBlend = grGetEnumType("Blend");

    library.addPrimitive(&_setLayersCount, "setLayersCount", [grInt]);
    library.addPrimitive(&_getLayersCount, "getLayersCount", [], [grInt]);
    library.addPrimitive(&_setLayer, "setLayer", [grInt]);
    library.addPrimitive(&_setLayerDefault, "setLayer");
    library.addPrimitive(&_getLayer, "getLayer", [], [grInt]);

    library.addPrimitive(&_setLayerClearColor, "setLayerClearColor", [
            grInt, defColor
            ]);
    library.addPrimitive(&_setLayerClearColorDefault, "setLayerClearColor", [
            defColor
            ]);
    library.addPrimitive(&_setLayerClearAlpha, "setLayerClearAlpha", [
            grInt, grFloat
            ]);
    library.addPrimitive(&_setLayerClearAlphaDefault, "setLayerClearAlpha", [
            grFloat
            ]);
    library.addPrimitive(&_setLayerBlend, "setLayerBlend", [grInt, defBlend]);
    library.addPrimitive(&_setLayerBlendDefault, "setLayerBlend", [defBlend]);
    library.addPrimitive(&_setLayerColor, "setLayerColor", [grInt, defColor]);
    library.addPrimitive(&_setLayerColorDefault, "setLayerColor", [defColor]);
    library.addPrimitive(&_setLayerAlpha, "setLayerAlpha", [grInt, grFloat]);
    library.addPrimitive(&_setLayerAlphaDefault, "setLayerAlpha", [grFloat]);

    library.addPrimitive(&_setCameraSizei, "setCameraSize", [grInt, grInt]);
    library.addPrimitive(&_setCameraSizef, "setCameraSize", [grFloat, grFloat]);
    library.addPrimitive(&_setCameraPosition, "setCameraPosition", [
            grFloat, grFloat
            ]);
    library.addPrimitive(&_setCameraClearColor, "setCameraClearColor", [
            defColor, grFloat
            ]);
}

private void _setLayersCount(GrCall call) {
    setLayersCount(call.getInt(0));
}

private void _getLayersCount(GrCall call) {
    call.setInt(getLayersCount());
}

private void _setLayer(GrCall call) {
    setLayer(call.getInt(0));
}

private void _setLayerDefault(GrCall call) {
    setLayer(-1);
}

private void _getLayer(GrCall call) {
    call.setInt(getLayer());
}

private void _setLayerClearColor(GrCall call) {
    auto obj = call.getObject(1);
    setLayerClearColor(call.getInt(0), Color(obj.getFloat("r"),
            obj.getFloat("g"), obj.getFloat("b")));
}

private void _setLayerClearColorDefault(GrCall call) {
    auto obj = call.getObject(0);
    setLayerClearColor(-1, Color(obj.getFloat("r"), obj.getFloat("g"), obj.getFloat("b")));
}

private void _setLayerClearAlpha(GrCall call) {
    setLayerClearAlpha(call.getInt(0), call.getFloat(1));
}

private void _setLayerClearAlphaDefault(GrCall call) {
    setLayerClearAlpha(-1, call.getFloat(0));
}

private void _setLayerBlend(GrCall call) {
    setLayerBlend(call.getInt(0), call.getEnum!Blend(1));
}

private void _setLayerBlendDefault(GrCall call) {
    setLayerBlend(-1, call.getEnum!Blend(0));
}

private void _setLayerColor(GrCall call) {
    auto obj = call.getObject(1);
    const Color color = Color(obj.getFloat("r"), obj.getFloat("g"), obj.getFloat("b"));
    setLayerColor(call.getInt(0), color);
}

private void _setLayerColorDefault(GrCall call) {
    auto obj = call.getObject(0);
    const Color color = Color(obj.getFloat("r"), obj.getFloat("g"), obj.getFloat("b"));
    setLayerColor(-1, color);
}

private void _setLayerAlpha(GrCall call) {
    setLayerAlpha(call.getInt(0), call.getFloat(1));
}

private void _setLayerAlphaDefault(GrCall call) {
    setLayerAlpha(-1, call.getFloat(0));
}

private void _setCameraSizef(GrCall call) {
    //_canvas.size = Vec2f(call.getFloat(0), call.getFloat(1));
}

private void _setCameraSizei(GrCall call) {
    //_canvas.size = Vec2f(call.getInt(0), call.getInt(1));
}

private void _setCameraPosition(GrCall call) {
    //_canvas.position = Vec2f(call.getFloat(0), call.getFloat(1));
}

private void _setCameraClearColor(GrCall call) {
    /+auto obj = call.getObject(0);
    const Color color = Color(obj.getFloat("r"), obj.getFloat("g"), obj.getFloat("b"));
    _canvas.color = color;
    _canvas.alpha = call.getFloat(1);+/
}
