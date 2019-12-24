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
    data.addPrimitive(&_createParticle,
    "createParticle", ["x", "y", "angle", "speed", "angleSpeed", "timeToLive", "startColor", "endColor"],
    [grFloat, grFloat, grFloat, grFloat, grFloat, grInt, defColor, defColor]);
}

private void _createParticle(GrCall call) {
    createParticle(
        Vec2f(
            call.getFloat("x"),
            call.getFloat("y")),
        call.getFloat("angle"),
        call.getFloat("speed"),
        call.getFloat("angleSpeed"),
        call.getInt("timeToLive"),
        Color(
            call.getFloat("startColor:r"),
            call.getFloat("startColor:g"),
            call.getFloat("startColor:b"),
            call.getFloat("startColor:a")),
        Color(
            call.getFloat("endColor:r"),
            call.getFloat("endColor:g"),
            call.getFloat("endColor:b"),
            call.getFloat("endColor:a"))
        );
}