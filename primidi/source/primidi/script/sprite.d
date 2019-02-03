module primidi.script.sprite;

import grimoire, atelier;

package void loadSprite() {
    auto defSprite = grAddUserType("Sprite");
    auto defTex = grGetUserType("Texture");
    auto defVec2f = grGetStructureType("Vec2f");
    auto defColor = grGetStructureType("Color");

    grAddPrimitive(&_makeSprite, "Sprite", ["tex"], [defTex], defSprite);
    grAddPrimitive(&_setSpriteClip, "sprite_setClip", ["sprite", "x", "y", "w", "h"], [defSprite, grInt, grInt, grInt, grInt]);
    grAddPrimitive(&_setSpriteAngle, "sprite_setAngle", ["sprite", "angle"], [defSprite, grFloat]);
    grAddPrimitive(&_setSpriteAngle, "sprite_setColor", ["sprite", "color"], [defSprite, defColor]);
    grAddPrimitive(&_drawSprite, "sprite_draw", ["sprite", "pos"], [defSprite, defVec2f]);
}

private void _makeSprite(GrCall call) {
    auto sprite = new Sprite(call.getUserData!Texture("tex"));
    call.setUserData(sprite);
}

private void _setSpriteClip(GrCall call) {
    auto sprite = call.getUserData!Sprite("sprite");
    sprite.clip.x = call.getInt("x");
    sprite.clip.y = call.getInt("y");
    sprite.clip.z = call.getInt("w");
    sprite.clip.w = call.getInt("h");
}

private void _setSpriteAngle(GrCall call) {
    auto sprite = call.getUserData!Sprite("sprite");
    sprite.angle = call.getFloat("angle");
}

private void _setSpriteColor(GrCall call) {
    auto sprite = call.getUserData!Sprite("sprite");
    sprite.color = Color(
        call.getFloat("color.r"), call.getFloat("color.g"),
        call.getFloat("color.b"), call.getFloat("color.a"));
}

private void _drawSprite(GrCall call) {
    auto sprite = call.getUserData!Sprite("sprite");
    sprite.draw(Vec2f(call.getFloat("pos.x"), call.getFloat("pos.y")));
}