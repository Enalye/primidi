/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.math;

import std.random;
import atelier, grimoire;
import std.algorithm.comparison: clamp;

package void loadMath(GrData data) {
    data.addPrimitive(&_clamp, "clamp", ["v", "min", "max"], [grFloat, grFloat, grFloat], [grFloat]);
    data.addPrimitive(&_random01, "random", [], [], [grFloat]);
    data.addPrimitive(&_randomf, "random", ["v1", "v2"], [grFloat, grFloat], [grFloat]);
    data.addPrimitive(&_randomi, "random", ["v1", "v2"], [grInt, grInt], [grInt]);
}

private void _clamp(GrCall call) {
    call.setFloat(clamp(call.getFloat("v"), call.getFloat("min"), call.getFloat("max")));
}

private void _random01(GrCall call) {
    call.setFloat(uniform01());
}

private void _randomf(GrCall call) {
    call.setFloat(uniform!"[]"(call.getFloat("v1"), call.getFloat("v2")));
}

private void _randomi(GrCall call) {
    call.setInt(uniform!"[]"(call.getInt("v1"), call.getInt("v2")));
}