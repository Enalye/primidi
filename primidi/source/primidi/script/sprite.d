/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.sprite;

import std.conv: to;
import grimoire, atelier;

package void loadSprite(GrData data) {
    auto defSprite = data.addForeign("Sprite");
    auto defTex = grGetForeignType("Texture");
    auto defColor = grGetClassType("Color");
    auto defBlend = grGetEnumType("Blend");

    data.addPrimitive(&_makeSpriteT, "Sprite", ["tex"], [defTex], [defSprite]);
    data.addPrimitive(&_makeSpriteS, "Sprite", ["sprite"], [defSprite], [defSprite]);
    data.addPrimitive(&_setSpriteClip, "setClip", ["sprite", "x", "y", "w", "h"], [defSprite, grInt, grInt, grInt, grInt]);
    data.addPrimitive(&_setSpriteAngle, "setAngle", ["sprite", "angle"], [defSprite, grFloat]);
    data.addPrimitive(&_setSpriteAnchor, "setAnchor", ["sprite", "x", "y"], [defSprite, grFloat, grFloat]);
    data.addPrimitive(&_setSpriteColor, "setColor", ["sprite", "color"], [defSprite, defColor]);

    data.addPrimitive(&_setSpriteSize, "setSize", ["sprite", "w", "h"], [defSprite, grFloat, grFloat]);
    data.addPrimitive(&_getSpriteSize, "getSize", ["sprite"], [defSprite], [grFloat, grFloat]);
    data.addPrimitive(&_getSpriteWidth, "getWidth", ["sprite"], [defSprite], [grFloat]);
    data.addPrimitive(&_getSpriteHeight, "getHeight", ["sprite"], [defSprite], [grFloat]);

    data.addPrimitive(&_setSpriteScale, "setScale", ["sprite", "x", "y"], [defSprite, grFloat, grFloat]);
    data.addPrimitive(&_getSpriteScale, "getScale", ["sprite"], [defSprite], [grFloat, grFloat]);

    data.addPrimitive(&_setSpriteFlip, "setFlip", ["sprite", "flip"], [defSprite, grInt]);
    data.addPrimitive(&_getSpriteFlip, "setFlip", ["sprite"], [defSprite], [grInt]);

    data.addPrimitive(&_setSpriteBlend, "setBlend", ["sprite", "blend"], [defSprite, defBlend]);
    data.addPrimitive(&_getSpriteBlend, "getBlend", ["sprite"], [defSprite], [grInt]);

    data.addPrimitive(&_spriteFit, "fit", ["sprite", "w", "h"], [defSprite, grFloat, grFloat]);
    data.addPrimitive(&_spriteContain, "contain", ["sprite", "w", "h"], [defSprite, grFloat, grFloat]);
    data.addPrimitive(&_drawSprite, "draw", ["sprite", "x", "y"], [defSprite, grFloat, grFloat]);

    //data.addPrimitive(&_createText, "createText", ["font", "text"], [defFont, grString], [defSprite]);  
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
    auto c = call.getObject("color");
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"),
        c.getFloat("a"));
    sprite.color = color;
}

private void _setSpriteSize(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    sprite.size = Vec2f(call.getFloat("w"), call.getFloat("h"));
}

private void _getSpriteSize(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    call.setFloat(sprite.size.x);
    call.setFloat(sprite.size.y);
}

private void _getSpriteWidth(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    call.setFloat(sprite.size.x);
}

private void _getSpriteHeight(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    call.setFloat(sprite.size.y);
}

private void _setSpriteScale(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    sprite.scale = Vec2f(call.getFloat("w"), call.getFloat("h"));
}

private void _getSpriteScale(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    call.setFloat(sprite.scale.x);
    call.setFloat(sprite.scale.y);
}

private void _setSpriteFlip(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    auto flip = call.getInt("flip");
    if(flip >= 4 || flip < 0)
        flip = 0;
    sprite.flip = cast(Flip) flip;
}

private void _getSpriteFlip(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    call.setInt(sprite.flip);
}

private void _setSpriteBlend(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    sprite.blend = call.getEnum!Blend("blend");
}

private void _getSpriteBlend(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    call.setInt(sprite.blend);
}

private void _spriteFit(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    sprite.fit(Vec2f(call.getFloat("w"), call.getFloat("h")));
}

private void _spriteContain(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    sprite.contain(Vec2f(call.getFloat("w"), call.getFloat("h")));
}

private void _drawSprite(GrCall call) {
    Sprite sprite = call.getUserData!Sprite("sprite");
    sprite.draw(Vec2f(call.getFloat("x"), call.getFloat("y")));
}
/*
private void _createText(GrCall call) {
    auto font = call.getUserData!Font("font");
    auto texture = font.render(to!string(call.getString("text")));
	auto sprite = new Sprite(texture);
    call.setUserData!Sprite(sprite);
}*/