/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.sprite;

import std.conv: to;
import grimoire, atelier;

package void loadSprite(GrLibrary library) {
    auto defSprite = library.addForeign("Sprite");
    auto defTex = grGetForeignType("Texture");
    auto defColor = grGetClassType("Color");
    auto defBlend = grGetEnumType("Blend");

    library.addPrimitive(&_makeSpriteT, "Sprite", [defTex], [defSprite]);
    library.addPrimitive(&_makeSpriteTClip, "Sprite", [defTex, grInt, grInt, grInt, grInt], [defSprite]);
    library.addPrimitive(&_makeSpriteS, "Sprite", [defSprite], [defSprite]);
    library.addPrimitive(&_setSpriteClip, "setClip", [defSprite, grInt, grInt, grInt, grInt]);
    library.addPrimitive(&_setSpriteAngle, "setAngle", [defSprite, grFloat]);
    library.addPrimitive(&_setSpriteAnchor, "setAnchor", [defSprite, grFloat, grFloat]);
    library.addPrimitive(&_setSpriteColor, "setColor", [defSprite, defColor]);
    library.addPrimitive(&_setSpriteAlpha, "setAlpha", [defSprite, grFloat]);

    library.addPrimitive(&_setSpriteSize, "setSize", [defSprite, grFloat, grFloat]);
    library.addPrimitive(&_getSpriteSize, "getSize", [defSprite], [grFloat, grFloat]);
    library.addPrimitive(&_getSpriteWidth, "getWidth", [defSprite], [grFloat]);
    library.addPrimitive(&_getSpriteHeight, "getHeight", [defSprite], [grFloat]);

    library.addPrimitive(&_setSpriteScale, "setScale", [defSprite, grFloat, grFloat]);
    library.addPrimitive(&_getSpriteScale, "getScale", [defSprite], [grFloat, grFloat]);

    library.addPrimitive(&_setSpriteFlip, "setFlip", [defSprite, grInt]);
    library.addPrimitive(&_getSpriteFlip, "setFlip", [defSprite], [grInt]);

    library.addPrimitive(&_setSpriteBlend, "setBlend", [defSprite, defBlend]);
    library.addPrimitive(&_getSpriteBlend, "getBlend", [defSprite], [grInt]);

    library.addPrimitive(&_spriteFit, "fit", [defSprite, grFloat, grFloat]);
    library.addPrimitive(&_spriteContain, "contain", [defSprite, grFloat, grFloat]);
    library.addPrimitive(&_drawSprite, "draw", [defSprite, grFloat, grFloat]);

    //library.addPrimitive(&_createText, "createText", ["font", "text"], [defFont, grString], [defSprite]);  
}

private void _makeSpriteT(GrCall call) {
    Sprite sprite = new Sprite(call.getForeign!Texture(0));
    call.setForeign(sprite);
}

private void _makeSpriteTClip(GrCall call) {
    Sprite sprite = new Sprite(
        call.getForeign!Texture(0),
        Vec4i(
            call.getInt(1),
            call.getInt(2),
            call.getInt(3),
            call.getInt(4)
        ));
    call.setForeign(sprite);
}

private void _makeSpriteS(GrCall call) {
    Sprite sprite = new Sprite(call.getForeign!Sprite(0));
    call.setForeign(sprite);
}

private void _setSpriteClip(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    sprite.clip.x = call.getInt(1);
    sprite.clip.y = call.getInt(2);
    sprite.clip.z = call.getInt(3);
    sprite.clip.w = call.getInt(4);
}

private void _setSpriteAngle(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    sprite.angle = call.getFloat(1);
}

private void _setSpriteAnchor(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    sprite.anchor = Vec2f(call.getFloat(1), call.getFloat(2));
}

private void _setSpriteColor(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    auto c = call.getObject(1);
    Color color = Color(
        c.getFloat("r"),
        c.getFloat("g"),
        c.getFloat("b"));
    sprite.color = color;
}

private void _setSpriteAlpha(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    sprite.alpha = call.getFloat(1);
}

private void _setSpriteSize(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    sprite.size = Vec2f(call.getFloat(1), call.getFloat(2));
}

private void _getSpriteSize(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    call.setFloat(sprite.size.x);
    call.setFloat(sprite.size.y);
}

private void _getSpriteWidth(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    call.setFloat(sprite.size.x);
}

private void _getSpriteHeight(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    call.setFloat(sprite.size.y);
}

private void _setSpriteScale(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    sprite.scale = Vec2f(call.getFloat(1), call.getFloat(2));
}

private void _getSpriteScale(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    call.setFloat(sprite.scale.x);
    call.setFloat(sprite.scale.y);
}

private void _setSpriteFlip(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    auto flip = call.getInt(1);
    if(flip >= 4 || flip < 0)
        flip = 0;
    sprite.flip = cast(Flip) flip;
}

private void _getSpriteFlip(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    call.setInt(sprite.flip);
}

private void _setSpriteBlend(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    sprite.blend = call.getEnum!Blend(1);
}

private void _getSpriteBlend(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    call.setInt(sprite.blend);
}

private void _spriteFit(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    sprite.fit(Vec2f(call.getFloat(1), call.getFloat(2)));
}

private void _spriteContain(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    sprite.contain(Vec2f(call.getFloat(1), call.getFloat(2)));
}

private void _drawSprite(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    sprite.draw(Vec2f(call.getFloat(1), call.getFloat(2)));
}
/*
private void _createText(GrCall call) {
    auto font = call.getForeign!Font("font");
    auto texture = font.render(to!string(call.getString("text")));
	auto sprite = new Sprite(texture);
    call.setForeign!Sprite(sprite);
}*/