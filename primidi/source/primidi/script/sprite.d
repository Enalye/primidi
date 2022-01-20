/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.sprite;

import std.conv : to;
import grimoire, atelier;

package void loadSpriteLibrary(GrLibrary library) {
    auto defSprite = library.addForeign("Sprite");
    auto defTex = grGetForeignType("Texture");
    auto defColor = grGetClassType("Color");
    auto defBlend = grGetEnumType("Blend");

    library.addPrimitive(&_makeSpriteT, "Sprite", [defTex], [defSprite]);
    library.addPrimitive(&_makeSpriteTClip, "Sprite", [
            defTex, grInt, grInt, grInt, grInt
        ], [defSprite]);
    library.addPrimitive(&_makeSpriteS, "Sprite", [defSprite], [defSprite]);
    library.addPrimitive(&_setSpriteClip, "setClip", [
            defSprite, grInt, grInt, grInt, grInt
        ]);
    library.addPrimitive(&_setSpriteAngle, "setAngle", [defSprite, grReal]);
    library.addPrimitive(&_setSpriteAnchor, "setAnchor", [
            defSprite, grReal, grReal
        ]);
    library.addPrimitive(&_setSpriteColor, "setColor", [defSprite, defColor]);
    library.addPrimitive(&_setSpriteAlpha, "setAlpha", [defSprite, grReal]);

    library.addPrimitive(&_setSpriteSize, "setSize", [
            defSprite, grReal, grReal
        ]);
    library.addPrimitive(&_getSpriteSize, "getSize", [defSprite], [
            grReal, grReal
        ]);
    library.addPrimitive(&_getSpriteWidth, "getWidth", [defSprite], [grReal]);
    library.addPrimitive(&_getSpriteHeight, "getHeight", [defSprite], [grReal]);

    library.addPrimitive(&_setSpriteScale, "setScale", [
            defSprite, grReal, grReal
        ]);
    library.addPrimitive(&_getSpriteScale, "getScale", [defSprite], [
            grReal, grReal
        ]);

    library.addPrimitive(&_setSpriteFlip, "setFlip", [defSprite, grInt]);
    library.addPrimitive(&_getSpriteFlip, "setFlip", [defSprite], [grInt]);

    library.addPrimitive(&_setSpriteBlend, "setBlend", [defSprite, defBlend]);
    library.addPrimitive(&_getSpriteBlend, "getBlend", [defSprite], [grInt]);

    library.addPrimitive(&_spriteFit, "fit", [defSprite, grReal, grReal]);
    library.addPrimitive(&_spriteContain, "contain", [
            defSprite, grReal, grReal
        ]);
    library.addPrimitive(&_drawSprite, "draw", [defSprite, grReal, grReal]);

    //library.addPrimitive(&_createText, "createText", ["font", "text"], [defFont, grString], [defSprite]);  
}

private void _makeSpriteT(GrCall call) {
    Sprite sprite = new Sprite(call.getForeign!Texture(0));
    call.setForeign(sprite);
}

private void _makeSpriteTClip(GrCall call) {
    Sprite sprite = new Sprite(call.getForeign!Texture(0),
        Vec4i(cast(int) call.getInt(1), cast(int) call.getInt(2),
            cast(int) call.getInt(3), cast(int) call.getInt(4)));
    call.setForeign(sprite);
}

private void _makeSpriteS(GrCall call) {
    Sprite sprite = new Sprite(call.getForeign!Sprite(0));
    call.setForeign(sprite);
}

private void _setSpriteClip(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    sprite.clip.x = cast(int) call.getInt(1);
    sprite.clip.y = cast(int) call.getInt(2);
    sprite.clip.z = cast(int) call.getInt(3);
    sprite.clip.w = cast(int) call.getInt(4);
}

private void _setSpriteAngle(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    sprite.angle = call.getReal(1);
}

private void _setSpriteAnchor(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    sprite.anchor = Vec2f(call.getReal(1), call.getReal(2));
}

private void _setSpriteColor(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    GrObject c = call.getObject(1);
    if (!sprite || !c) {
        call.raise("Null parameter");
        return;
    }
    Color color = Color(c.getReal("r"), c.getReal("g"), c.getReal("b"));
    sprite.color = color;
}

private void _setSpriteAlpha(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    sprite.alpha = call.getReal(1);
}

private void _setSpriteSize(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    sprite.size = Vec2f(call.getReal(1), call.getReal(2));
}

private void _getSpriteSize(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(sprite.size.x);
    call.setReal(sprite.size.y);
}

private void _getSpriteWidth(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(sprite.size.x);
}

private void _getSpriteHeight(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(sprite.size.y);
}

private void _setSpriteScale(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    sprite.scale = Vec2f(call.getReal(1), call.getReal(2));
}

private void _getSpriteScale(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(sprite.scale.x);
    call.setReal(sprite.scale.y);
}

private void _setSpriteFlip(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    GrInt flip = call.getInt(1);
    if (flip >= 4 || flip < 0)
        flip = 0;
    sprite.flip = cast(Flip) flip;
}

private void _getSpriteFlip(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    call.setInt(sprite.flip);
}

private void _setSpriteBlend(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    sprite.blend = call.getEnum!Blend(1);
}

private void _getSpriteBlend(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    call.setInt(sprite.blend);
}

private void _spriteFit(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    sprite.fit(Vec2f(call.getReal(1), call.getReal(2)));
}

private void _spriteContain(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    sprite.contain(Vec2f(call.getReal(1), call.getReal(2)));
}

private void _drawSprite(GrCall call) {
    Sprite sprite = call.getForeign!Sprite(0);
    if (!sprite) {
        call.raise("Null parameter");
        return;
    }
    sprite.draw(Vec2f(call.getReal(1), call.getReal(2)));
}
