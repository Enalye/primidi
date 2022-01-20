/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.particle;

import atelier, grimoire;
import primidi.particles;

package void loadParticleLibrary(GrLibrary library) {
    const GrType defColor = grGetClassType("Color");
    const GrType defSprite = grGetForeignType("Sprite");
    const GrType defParticle = library.addForeign("Particle");

    library.addPrimitive(&_makeParticle, "Particle", [
            grReal, grReal, grReal, grReal, grInt
        ], [defParticle]);

    library.addPrimitive(&_setSprite, "setSprite", [defParticle, defSprite]);
    library.addPrimitive(&_getSprite, "getSprite", [defParticle], [defSprite]);

    library.addPrimitive(&_setColor, "setColor", [defParticle, defColor]);
    library.addPrimitive(&_getColor, "getColor", [defParticle], [defColor]);

    library.addPrimitive(&_setAlpha, "setAlpha", [defParticle, grReal]);
    library.addPrimitive(&_getAlpha, "getAlpha", [defParticle], [grReal]);

    library.addPrimitive(&_setPosition, "setPosition", [
            defParticle, grReal, grReal
        ]);
    library.addPrimitive(&_getPosition, "getPosition", [defParticle], [
            grReal, grReal
        ]);

    library.addPrimitive(&_setAngle, "setAngle", [defParticle, grReal]);
    library.addPrimitive(&_getAngle, "getAngle", [defParticle], [grReal]);

    library.addPrimitive(&_setSpeed, "setSpeed", [defParticle, grReal]);
    library.addPrimitive(&_getSpeed, "getSpeed", [defParticle], [grReal]);

    library.addPrimitive(&_setAngleSpeed, "setAngleSpeed", [
            defParticle, grReal
        ]);
    library.addPrimitive(&_getAngleSpeed, "getAngleSpeed", [defParticle], [
            grReal
        ]);

    library.addPrimitive(&_isAlive, "isAlive", [defParticle], [grBool]);
}

private void _makeParticle(GrCall call) {
    call.setForeign!Particle(createParticle(Vec2f(call.getReal(0),
            call.getReal(1)), call.getReal(2), call.getReal(3), cast(int) call.getInt(4)));
}

private void _setSprite(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    if (!particle) {
        call.raise("Null parameter");
        return;
    }
    Sprite sprite = call.getForeign!Sprite(1);
    particle.sprite = sprite;
}

private void _getSprite(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    if (!particle) {
        call.raise("Null parameter");
        return;
    }
    call.setForeign!Sprite(particle.sprite);
}

private void _setColor(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    GrObject color = call.getObject(1);
    if (!particle || !color) {
        call.raise("Null parameter");
        return;
    }
    particle.color = Color(color.getReal("r"), color.getReal("g"), color.getReal("b"));
}

private void _getColor(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    if (!particle) {
        call.raise("Null parameter");
        return;
    }
    auto c = call.createObject("Color");
    c.setReal("r", particle.color.r);
    c.setReal("g", particle.color.g);
    c.setReal("b", particle.color.b);
    call.setObject(c);
}

private void _setAlpha(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    if (!particle) {
        call.raise("Null parameter");
        return;
    }
    particle.alpha = call.getReal(1);
}

private void _getAlpha(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    if (!particle) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(particle.alpha);
}

private void _setPosition(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    if (!particle) {
        call.raise("Null parameter");
        return;
    }
    particle.position = Vec2f(call.getReal(1), call.getReal(2));
}

private void _getPosition(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    if (!particle) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(particle.position.x);
    call.setReal(particle.position.y);
}

private void _setAngle(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    if (!particle) {
        call.raise("Null parameter");
        return;
    }
    particle.angle = call.getReal(1);
}

private void _getAngle(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    if (!particle) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(particle.angle);
}

private void _setSpeed(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    if (!particle) {
        call.raise("Null parameter");
        return;
    }
    particle.speed = call.getReal(1);
}

private void _getSpeed(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    if (!particle) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(particle.speed);
}

private void _setAngleSpeed(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    if (!particle) {
        call.raise("Null parameter");
        return;
    }
    particle.angleSpeed = call.getReal(1);
}

private void _getAngleSpeed(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    if (!particle) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(particle.angleSpeed);
}

private void _isAlive(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    if (!particle) {
        call.raise("Null parameter");
        return;
    }
    call.setBool(particle.time <= particle.timeToLive);
}
