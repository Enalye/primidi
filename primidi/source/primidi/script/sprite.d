/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.sprite;

import grimoire, atelier;

package void loadSprite(GrData data) {
    auto defSprite = data.addUserType("Sprite");
    auto defTex = grGetUserType("Texture");
    auto defColor = grGetTupleType("Color");

    data.addPrimitive(&_makeSpriteT, "Sprite", ["tex"], [defTex], [defSprite]);
    data.addPrimitive(&_makeSpriteS, "Sprite", ["sprite"], [defSprite], [defSprite]);
    data.addPrimitive(&_setSpriteClip, "setClip", ["sprite", "x", "y", "w", "h"], [defSprite, grInt, grInt, grInt, grInt]);
    data.addPrimitive(&_setSpriteAngle, "setAngle", ["sprite", "angle"], [defSprite, grFloat]);
    data.addPrimitive(&_setSpriteAnchor, "setAnchor", ["sprite", "x", "y"], [defSprite, grFloat, grFloat]);
    data.addPrimitive(&_setSpriteColor, "setColor", ["sprite", "color"], [defSprite, defColor]);
    data.addPrimitive(&_setSpriteSize, "setSize", ["sprite", "w", "h"], [defSprite, grFloat, grFloat]);
    data.addPrimitive(&_setSpriteFlip, "setFlip", ["sprite", "flip"], [defSprite, grInt]);
    data.addPrimitive(&_spriteFit, "fit", ["sprite", "w", "h"], [defSprite, grFloat, grFloat]);
    data.addPrimitive(&_drawSprite, "draw", ["sprite", "x", "y"], [defSprite, grFloat, grFloat]);
}

private void _makeSpriteT(GrCall call) {
    Sprite sprite = new Sprite(call.getUserData!Texture("tex"));
    call.setUserData(sprite);
}

private void _makeSpriteS(GrCall call) {
    Sprite sprite = new Sprite(call.getUserData!Sprite("sprite"));
    call.setUserData(sprite);
}

private void _setSpriteClip(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    sprite.clip.x = call.getInt("x");
    sprite.clip.y = call.getInt("y");
    sprite.clip.z = call.getInt("w");
    sprite.clip.w = call.getInt("h");
}

private void _setSpriteAngle(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    sprite.angle = call.getFloat("angle");
}

private void _setSpriteAnchor(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    sprite.anchor = Vec2f(call.getFloat("x"), call.getFloat("y"));
}

private void _setSpriteColor(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    sprite.color = Color(
        call.getFloat("color:r"), call.getFloat("color:g"),
        call.getFloat("color:b"), call.getFloat("color:a"));
}

private void _setSpriteSize(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    sprite.size = Vec2f(call.getFloat("w"), call.getFloat("h"));
}

private void _setSpriteFlip(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    auto flip = call.getInt("flip");
    if(flip > 4 || flip < 0)
        flip = 0;
    sprite.flip = cast(Flip)flip;
}

private void _spriteFit(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    sprite.fit(Vec2f(call.getFloat("w"), call.getFloat("h")));
}

private void _drawSprite(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    sprite.draw(Vec2f(call.getFloat("x"), call.getFloat("y")));
}