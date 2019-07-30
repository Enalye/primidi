module primidi.script.ninepatch;

import grimoire, atelier;

package void loadNinePatch() {
    auto defNinePatch = grAddUserType("NinePatch");
    auto defTex = grGetUserType("Texture");
    auto defColor = grGetTupleType("Color");

    grAddPrimitive(&_makeNinePatch, "NinePatch",
        ["tex", "x", "y", "w", "h", "top", "bottom", "left", "right"],
        [defTex, grInt, grInt, grInt, grInt, grInt, grInt, grInt, grInt], [defNinePatch]);
    grAddPrimitive(&_setNinePatchClip, "setClip", ["ninePatch", "x", "y", "w", "h"], [defNinePatch, grInt, grInt, grInt, grInt]);
    grAddPrimitive(&_setNinePatchBounds, "setBounds", ["ninePatch", "top", "bottom", "left", "right"], [defNinePatch, grInt, grInt, grInt, grInt]);
    grAddPrimitive(&_setNinePatchAngle, "setAngle", ["ninePatch", "angle"], [defNinePatch, grFloat]);
    grAddPrimitive(&_setNinePatchColor, "setColor", ["ninePatch", "color"], [defNinePatch, defColor]);
    grAddPrimitive(&_setNinePatchSize, "setSize", ["ninePatch", "w", "h"], [defNinePatch, grFloat, grFloat]);
    grAddPrimitive(&_drawNinePatch, "draw", ["ninePatch", "x", "y"], [defNinePatch, grFloat, grFloat]);
}

private void _makeNinePatch(GrCall call) {
    auto ninePatch = new NinePatch(
        call.getUserData!Texture("tex"),
        Vec4i(call.getInt("x"),
            call.getInt("y"),
            call.getInt("w"),
            call.getInt("h")),
        call.getInt("top"),
        call.getInt("bottom"),
        call.getInt("left"),
        call.getInt("right"));
    call.setUserData(ninePatch);
}

private void _setNinePatchClip(GrCall call) {
    auto ninePatch = call.getUserData!NinePatch("ninePatch");
    ninePatch.clip.x = call.getInt("x");
    ninePatch.clip.y = call.getInt("y");
    ninePatch.clip.z = call.getInt("w");
    ninePatch.clip.w = call.getInt("h");
}

private void _setNinePatchBounds(GrCall call) {
    auto ninePatch = call.getUserData!NinePatch("ninePatch");
    ninePatch.top = call.getInt("top");
    ninePatch.bottom = call.getInt("bottom");
    ninePatch.left = call.getInt("left");
    ninePatch.right = call.getInt("right");
}

private void _setNinePatchAngle(GrCall call) {
    /*auto ninePatch = call.getUserData!NinePatch("ninePatch");
    ninePatch.angle = call.getFloat("angle");*/
}

private void _setNinePatchColor(GrCall call) {
    /*auto ninePatch = call.getUserData!NinePatch("ninePatch");
    ninePatch.color = Color(
        call.getFloat("color:r"), call.getFloat("color:g"),
        call.getFloat("color:b"), call.getFloat("color:a"));*/
}

private void _setNinePatchSize(GrCall call) {
    auto ninePatch = call.getUserData!NinePatch("ninePatch");
    ninePatch.size = Vec2f(call.getFloat("w"), call.getFloat("h"));
}

private void _drawNinePatch(GrCall call) {
    auto ninePatch = call.getUserData!NinePatch("ninePatch");
    ninePatch.draw(Vec2f(call.getFloat("x"), call.getFloat("y")));
}