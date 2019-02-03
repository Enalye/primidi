module primidi.script.vec2;

import grimoire, atelier;

package void loadVec2() {
    auto defVec2f = grAddStructure("Vec2f", ["x", "y"], [grFloat, grFloat]);

	grAddPrimitive(&_makeVec2f, "Vec2f", ["x", "y"], [grFloat, grFloat], defVec2f);

    static foreach(op; ["+", "-", "*", "/", "%"]) {
        grAddOperator(&_opBinaryVec2f!op, op, ["v1", "v2"], [defVec2f, defVec2f], defVec2f);
        grAddOperator(&_opBinaryScalarVec2f!op, op, ["v", "s"], [defVec2f, grFloat], defVec2f);
        grAddOperator(&_opBinaryScalarRightVec2f!op, op, ["s", "v"], [grFloat, defVec2f], defVec2f);
    }

    static foreach(op; ["==", "!=", ">=", "<=", ">", "<"]) {
        grAddOperator(&_opBinaryVec2f!op, op, ["v1", "v2"], [defVec2f, defVec2f], grBool);
    }
}

private void _makeVec2f(GrCall call) {
    call.setFloat(call.getFloat("x"));
    call.setFloat(call.getFloat("y"));
}

private void _opBinaryVec2f(string op)(GrCall call) {
    mixin("const auto x = call.getFloat(\"v1.x\")" ~ op ~ "call.getFloat(\"v2.x\");");
    mixin("const auto y = call.getFloat(\"v1.y\")" ~ op ~ "call.getFloat(\"v2.y\");");
    call.setFloat(x);
    call.setFloat(y);
}

private void _opBinaryScalarVec2f(string op)(GrCall call) {
    const auto s = call.getFloat("s");
    mixin("auto x = call.getFloat(\"v.x\")" ~ op ~ "s;");
    mixin("auto y = call.getFloat(\"v.y\")" ~ op ~ "s;");
    call.setFloat(x);
    call.setFloat(y);
}

private void _opBinaryScalarRightVec2f(string op)(GrCall call) {
    const auto s = call.getFloat("s");
    mixin("auto x = s" ~ op ~ "call.getFloat(\"v.x\");");
    mixin("auto y = s" ~ op ~ "call.getFloat(\"v.y\");");
    call.setFloat(x);
    call.setFloat(y);
}

private void _opBinaryCompare(string op)(GrCall call) {
    auto v1x = call.getFloat("v1.x");
    auto v1y = call.getFloat("v1.y");
    auto v2x = call.getFloat("v2.x");
    auto v2y = call.getFloat("v1.y");
    mixin("call.setBool(v1x" ~ op ~ "v2x && v2x" ~ op ~ "v2y);");
}