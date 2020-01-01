/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.particles;

import atelier, grimoire;
import primidi.particles;

package void loadParticles(GrData data) {
    const GrType defColor = grGetTupleType("Color");
    const GrType defSprite = grGetUserType("Sprite");
    const GrType defParticle = data.addUserType("Particle");

    data.addPrimitive(&_createParticle,
        "createParticle",
        ["x", "y", "angle", "speed", "timeToLive"],
        [grFloat, grFloat, grFloat, grFloat, grInt], [defParticle]);

    data.addPrimitive(&_setSprite, "setSprite", ["p", "s"], [defParticle, defSprite]);
    data.addPrimitive(&_getSprite, "getSprite", ["p"], [defParticle], [defSprite]);

    data.addPrimitive(&_setColor, "setColor", ["p", "c"], [defParticle, defColor]);
    data.addPrimitive(&_getColor, "getColor", ["p"], [defParticle], [defColor]);

    data.addPrimitive(&_setPosition, "setPosition", ["p", "x", "y"], [defParticle, grFloat, grFloat]);
    data.addPrimitive(&_getPosition, "getPosition", ["p"], [defParticle], [grFloat, grFloat]);

    data.addPrimitive(&_setAngle, "setAngle", ["p", "v"], [defParticle, grFloat]);
    data.addPrimitive(&_getAngle, "getAngle", ["p"], [defParticle], [grFloat]);

    data.addPrimitive(&_setSpeed, "setSpeed", ["p", "v"], [defParticle, grFloat]);
    data.addPrimitive(&_getSpeed, "getSpeed", ["p"], [defParticle], [grFloat]);

    data.addPrimitive(&_setAngleSpeed, "setAngleSpeed", ["p", "v"], [defParticle, grFloat]);
    data.addPrimitive(&_getAngleSpeed, "getAngleSpeed", ["p"], [defParticle], [grFloat]);

    data.addPrimitive(&_isAlive, "isAlive", ["p"], [defParticle], [grBool]);
}

private void _createParticle(GrCall call) {
    call.setUserData!Particle(createParticle(
        Vec2f(
            call.getFloat("x"),
            call.getFloat("y")),
        call.getFloat("angle"),
        call.getFloat("speed"),
        call.getInt("timeToLive")));
}

private void _setSprite(GrCall call) {
    Particle particle = call.getUserData!Particle("p");
    Sprite sprite = call.getUserData!Sprite("s");
    particle.sprite = sprite;
}

private void _getSprite(GrCall call) {
    Particle particle = call.getUserData!Particle("p");
    call.setUserData!Sprite(particle.sprite);
}

private void _setColor(GrCall call) {
    Particle particle = call.getUserData!Particle("p");
    particle.color = Color(
        call.getFloat("c:r"),
        call.getFloat("c:g"),
        call.getFloat("c:b"),
        call.getFloat("c:a"));
}

private void _getColor(GrCall call) {
    Particle particle = call.getUserData!Particle("p");
    call.setFloat(particle.color.r);
    call.setFloat(particle.color.g);
    call.setFloat(particle.color.b);
    call.setFloat(particle.color.a);
}

private void _setPosition(GrCall call) {
    Particle particle = call.getUserData!Particle("p");
    particle.position = Vec2f(call.getFloat("x"), call.getFloat("y"));
}

private void _getPosition(GrCall call) {
    Particle particle = call.getUserData!Particle("p");
    call.setFloat(particle.position.x);
    call.setFloat(particle.position.y);
}

private void _setAngle(GrCall call) {
    Particle particle = call.getUserData!Particle("p");
    particle.angle = call.getFloat("v");
}

private void _getAngle(GrCall call) {
    Particle particle = call.getUserData!Particle("p");
    call.setFloat(particle.angle);
}

private void _setSpeed(GrCall call) {
    Particle particle = call.getUserData!Particle("p");
    particle.speed = call.getFloat("v");
}

private void _getSpeed(GrCall call) {
    Particle particle = call.getUserData!Particle("p");
    call.setFloat(particle.speed);
}

private void _setAngleSpeed(GrCall call) {
    Particle particle = call.getUserData!Particle("p");
    particle.angleSpeed = call.getFloat("v");
}

private void _getAngleSpeed(GrCall call) {
    Particle particle = call.getUserData!Particle("p");
    call.setFloat(particle.angleSpeed);
}

private void _isAlive(GrCall call) {
    Particle particle = call.getUserData!Particle("p");
    call.setBool(particle.time <= particle.timeToLive);
}