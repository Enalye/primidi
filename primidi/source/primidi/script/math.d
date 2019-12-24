/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.math;

import std.random;
import atelier, grimoire;

package void loadMath(GrData data) {
    data.addPrimitive(&_random01, "random", [], [], [grFloat]);
    data.addPrimitive(&_randomf, "random", ["v1", "v2"], [grFloat, grFloat], [grFloat]);
    data.addPrimitive(&_randomi, "random", ["v1", "v2"], [grInt, grInt], [grInt]);
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