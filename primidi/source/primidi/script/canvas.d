/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.canvas;

import grimoire, atelier;
import primidi.gui;

package void loadCanvasLibrary(GrLibrary library) {
    const defCanvas = library.addForeign("Canvas");
    const defColor = grGetClassType("Color");
    auto defBlend = grGetEnumType("Blend");

    library.addPrimitive(&_makeCanvasf, "Canvas", [grReal, grReal], [
            defCanvas
        ]);
    library.addPrimitive(&_makeCanvasi, "Canvas", [grInt, grInt], [defCanvas]);
    library.addPrimitive(&_pushCanvas, "pushCanvas", [defCanvas]);
    library.addPrimitive(&_popCanvas, "popCanvas");
    library.addPrimitive(&_clearCanvas, "clear", [defCanvas]);
    library.addPrimitive(&_renderCanvas, "draw", [defCanvas, grReal, grReal]);

    library.addPrimitive(&_setClearColor, "setClearColor", [defCanvas, defColor]);
    library.addPrimitive(&_setClearAlpha, "setClearAlpha", [defCanvas, grReal]);
    library.addPrimitive(&_setBlend, "setBlend", [defCanvas, defBlend]);
    library.addPrimitive(&_setColor, "setColor", [defCanvas, defColor]);
    library.addPrimitive(&_setAlpha, "setAlpha", [defCanvas, grReal]);
    library.addPrimitive(&_setPosition, "setPosition", [
            defCanvas, grReal, grReal
        ]);
}

private void _makeCanvasf(GrCall call) {
    call.setForeign!Canvas(new Canvas(Vec2f(call.getReal32(0), call.getReal32(1))));
}

private void _makeCanvasi(GrCall call) {
    call.setForeign!Canvas(new Canvas(Vec2i(call.getInt32(0), call.getInt32(1))));
}

private void _pushCanvas(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    if (!canvas) {
        call.raise("Null parameter");
        return;
    }
    pushCanvas(canvas, false);
}

private void _popCanvas(GrCall call) {
    popCanvas();
}

private void _clearCanvas(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    if (!canvas) {
        call.raise("Null parameter");
        return;
    }
    pushCanvas(canvas, true);
    popCanvas();
}

private void _renderCanvas(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    if (!canvas) {
        call.raise("Null parameter");
        return;
    }
    canvas.draw(Vec2f(call.getReal32(1), call.getReal32(2)));
}

private void _setClearColor(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    GrObject obj = call.getObject(1);
    if (!canvas || !obj) {
        call.raise("Null parameter");
        return;
    }
    canvas.clearColor = Color(obj.getReal("r"), obj.getReal("g"), obj.getReal("b"));
}

private void _setClearAlpha(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    if (!canvas) {
        call.raise("Null parameter");
        return;
    }
    canvas.clearAlpha = call.getReal32(1);
}

private void _setBlend(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    if (!canvas) {
        call.raise("Null parameter");
        return;
    }
    const Blend blend = call.getEnum!Blend(1);
    canvas.blend(blend);
}

private void _setColor(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    GrObject obj = call.getObject(1);
    if (!canvas || !obj) {
        call.raise("Null parameter");
        return;
    }
    const Color color = Color(obj.getReal("r"), obj.getReal("g"), obj.getReal("b"));
    canvas.color(color);
}

private void _setAlpha(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    if (!canvas) {
        call.raise("Null parameter");
        return;
    }
    const float alpha = call.getReal32(1);
    canvas.alpha(alpha);
}

private void _setPosition(GrCall call) {
    Canvas canvas = call.getForeign!Canvas(0);
    if (!canvas) {
        call.raise("Null parameter");
        return;
    }
    canvas.position = Vec2f(call.getReal32(1), call.getReal32(2));
}
