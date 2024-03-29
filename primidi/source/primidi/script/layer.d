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
            grInt, grReal
        ]);
    library.addPrimitive(&_setLayerClearAlphaDefault, "setLayerClearAlpha", [
            grReal
        ]);
    library.addPrimitive(&_setLayerBlend, "setLayerBlend", [grInt, defBlend]);
    library.addPrimitive(&_setLayerBlendDefault, "setLayerBlend", [defBlend]);
    library.addPrimitive(&_setLayerColor, "setLayerColor", [grInt, defColor]);
    library.addPrimitive(&_setLayerColorDefault, "setLayerColor", [defColor]);
    library.addPrimitive(&_setLayerAlpha, "setLayerAlpha", [grInt, grReal]);
    library.addPrimitive(&_setLayerAlphaDefault, "setLayerAlpha", [grReal]);

    library.addPrimitive(&_setCameraSizei, "setCameraSize", [grInt, grInt]);
    library.addPrimitive(&_setCameraSizef, "setCameraSize", [grReal, grReal]);
    library.addPrimitive(&_setCameraPosition, "setCameraPosition", [
            grReal, grReal
        ]);
    library.addPrimitive(&_setCameraClearColor, "setCameraClearColor", [
            defColor, grReal
        ]);
}

private void _setLayersCount(GrCall call) {
    setLayersCount(call.getInt32(0));
}

private void _getLayersCount(GrCall call) {
    call.setInt(getLayersCount());
}

private void _setLayer(GrCall call) {
    setLayer(call.getInt32(0));
}

private void _setLayerDefault(GrCall call) {
    setLayer(-1);
}

private void _getLayer(GrCall call) {
    call.setInt(getLayer());
}

private void _setLayerClearColor(GrCall call) {
    GrObject obj = call.getObject(1);
    if (!obj) {
        call.raise("Null parameter");
        return;
    }
    setLayerClearColor(call.getInt32(0), Color(obj.getReal("r"),
            obj.getReal("g"), obj.getReal("b")));
}

private void _setLayerClearColorDefault(GrCall call) {
    GrObject obj = call.getObject(0);
    if (!obj) {
        call.raise("Null parameter");
        return;
    }
    setLayerClearColor(-1, Color(obj.getReal("r"), obj.getReal("g"), obj.getReal("b")));
}

private void _setLayerClearAlpha(GrCall call) {
    setLayerClearAlpha(call.getInt32(0), call.getReal32(1));
}

private void _setLayerClearAlphaDefault(GrCall call) {
    setLayerClearAlpha(-1, call.getReal32(0));
}

private void _setLayerBlend(GrCall call) {
    setLayerBlend(call.getInt32(0), call.getEnum!Blend(1));
}

private void _setLayerBlendDefault(GrCall call) {
    setLayerBlend(-1, call.getEnum!Blend(0));
}

private void _setLayerColor(GrCall call) {
    GrObject obj = call.getObject(1);
    if (!obj) {
        call.raise("Null parameter");
        return;
    }
    const Color color = Color(obj.getReal("r"), obj.getReal("g"), obj.getReal("b"));
    setLayerColor(call.getInt32(0), color);
}

private void _setLayerColorDefault(GrCall call) {
    GrObject obj = call.getObject(0);
    if (!obj) {
        call.raise("Null parameter");
        return;
    }
    const Color color = Color(obj.getReal("r"), obj.getReal("g"), obj.getReal("b"));
    setLayerColor(-1, color);
}

private void _setLayerAlpha(GrCall call) {
    setLayerAlpha(call.getInt32(0), call.getReal32(1));
}

private void _setLayerAlphaDefault(GrCall call) {
    setLayerAlpha(-1, call.getReal32(0));
}

private void _setCameraSizef(GrCall call) {
    //_canvas.size = Vec2f(call.getReal32(0), call.getReal32(1));
}

private void _setCameraSizei(GrCall call) {
    //_canvas.size = Vec2f(call.getInt(0), call.getInt(1));
}

private void _setCameraPosition(GrCall call) {
    //_canvas.position = Vec2f(call.getReal32(0), call.getReal32(1));
}

private void _setCameraClearColor(GrCall call) {
    /+auto obj = call.getObject(0);
    const Color color = Color(obj.getReal("r"), obj.getReal("g"), obj.getReal("b"));
    _canvas.color = color;
    _canvas.alpha = call.getReal32(1);+/
}
