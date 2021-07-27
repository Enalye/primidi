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
            grFloat, grFloat, grFloat, grFloat, grInt
            ], [defParticle]);

    library.addPrimitive(&_setSprite, "setSprite", [defParticle, defSprite]);
    library.addPrimitive(&_getSprite, "getSprite", [defParticle], [defSprite]);

    library.addPrimitive(&_setColor, "setColor", [defParticle, defColor]);
    library.addPrimitive(&_getColor, "getColor", [defParticle], [defColor]);

    library.addPrimitive(&_setAlpha, "setAlpha", [defParticle, grFloat]);
    library.addPrimitive(&_getAlpha, "getAlpha", [defParticle], [grFloat]);

    library.addPrimitive(&_setPosition, "setPosition", [
            defParticle, grFloat, grFloat
            ]);
    library.addPrimitive(&_getPosition, "getPosition", [defParticle], [
            grFloat, grFloat
            ]);

    library.addPrimitive(&_setAngle, "setAngle", [defParticle, grFloat]);
    library.addPrimitive(&_getAngle, "getAngle", [defParticle], [grFloat]);

    library.addPrimitive(&_setSpeed, "setSpeed", [defParticle, grFloat]);
    library.addPrimitive(&_getSpeed, "getSpeed", [defParticle], [grFloat]);

    library.addPrimitive(&_setAngleSpeed, "setAngleSpeed", [
            defParticle, grFloat
            ]);
    library.addPrimitive(&_getAngleSpeed, "getAngleSpeed", [defParticle], [
            grFloat
            ]);

    library.addPrimitive(&_isAlive, "isAlive", [defParticle], [grBool]);
}

private void _makeParticle(GrCall call) {
    call.setForeign!Particle(createParticle(Vec2f(call.getFloat(0),
            call.getFloat(1)), call.getFloat(2), call.getFloat(3), call.getInt(4)));
}

private void _setSprite(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    Sprite sprite = call.getForeign!Sprite(1);
    particle.sprite = sprite;
}

private void _getSprite(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    call.setForeign!Sprite(particle.sprite);
}

private void _setColor(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    auto color = call.getObject(1);
    particle.color = Color(color.getFloat("r"), color.getFloat("g"), color.getFloat("b"));
}

private void _getColor(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    auto c = call.createObject("Color");
    c.setFloat("r", particle.color.r);
    c.setFloat("g", particle.color.g);
    c.setFloat("b", particle.color.b);
    call.setObject(c);
}

private void _setAlpha(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    particle.alpha = call.getFloat(1);
}

private void _getAlpha(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    call.setFloat(particle.alpha);
}

private void _setPosition(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    particle.position = Vec2f(call.getFloat(1), call.getFloat(2));
}

private void _getPosition(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    call.setFloat(particle.position.x);
    call.setFloat(particle.position.y);
}

private void _setAngle(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    particle.angle = call.getFloat(1);
}

private void _getAngle(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    call.setFloat(particle.angle);
}

private void _setSpeed(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    particle.speed = call.getFloat(1);
}

private void _getSpeed(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    call.setFloat(particle.speed);
}

private void _setAngleSpeed(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    particle.angleSpeed = call.getFloat(1);
}

private void _getAngleSpeed(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    call.setFloat(particle.angleSpeed);
}

private void _isAlive(GrCall call) {
    Particle particle = call.getForeign!Particle(0);
    call.setBool(particle.time <= particle.timeToLive);
}
