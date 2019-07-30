module primidi.script.color;

import std.stdio, std.conv;
import grimoire, atelier;

package void loadColor() {
    auto defColor = grAddTuple("Color", ["r", "g", "b", "a"], [grFloat, grFloat, grFloat, grFloat]);

	grAddPrimitive(&_makeColor3, "Color", ["r", "g", "b"], [grFloat, grFloat, grFloat], [defColor]);
	grAddPrimitive(&_makeColor4, "Color", ["r", "g", "b", "a"], [grFloat, grFloat, grFloat, grFloat], [defColor]);

    grAddPrimitive(&_makeColor3i, "Color", ["r", "g", "b"], [grInt, grInt, grInt], [defColor]);
	grAddPrimitive(&_makeColor4i, "Color", ["r", "g", "b", "a"], [grInt, grInt, grInt, grInt], [defColor]);

    static foreach(op; ["+", "-", "*", "/", "%"]) {
        grAddOperator(&_opBinaryColor!op, op, ["c1", "c2"], [defColor, defColor], defColor);
        grAddOperator(&_opBinaryScalarColor!op, op, ["c", "s"], [defColor, grFloat], defColor);
        grAddOperator(&_opBinaryScalarRightColor!op, op, ["s", "c"], [grFloat, defColor], defColor);
    }

	grAddPrimitive(&_mixColor, "mix", ["c1", "c2"], [defColor, defColor], [defColor]);
	grAddPrimitive(&_lerpColor, "lerp", ["c1", "c2", "t"], [defColor, defColor, grFloat], [defColor]);

    grAddPrimitive(&_printColor, "print", ["c"], [defColor]);
    grAddCast(&_castArrayToColor, "ary", grIntArray, defColor);
    grAddCast(&_castColorToString, "c", defColor, grString);
}

private void _makeColor3(GrCall call) {
    call.setFloat(call.getFloat("r"));
    call.setFloat(call.getFloat("g"));
    call.setFloat(call.getFloat("b"));
    call.setFloat(1f);
}

private void _makeColor4(GrCall call) {
    call.setFloat(call.getFloat("r"));
    call.setFloat(call.getFloat("g"));
    call.setFloat(call.getFloat("b"));
    call.setFloat(call.getFloat("a"));
}

private void _makeColor3i(GrCall call) {
    Color color = Color(call.getInt("r"), call.getInt("g"), call.getInt("b"));
    call.setFloat(color.r);
    call.setFloat(color.g);
    call.setFloat(color.b);
    call.setFloat(color.a);
}

private void _makeColor4i(GrCall call) {
    Color color = Color(call.getInt("r"), call.getInt("g"), call.getInt("b"), call.getInt("a"));
    call.setFloat(color.r);
    call.setFloat(color.g);
    call.setFloat(color.b);
    call.setFloat(color.a);
}

private void _opBinaryColor(string op)(GrCall call) {
    mixin("const auto r = call.getFloat(\"c1:r\")" ~ op ~ "call.getFloat(\"c2:r\");");
    mixin("const auto g = call.getFloat(\"c1:g\")" ~ op ~ "call.getFloat(\"c2:g\");");
    mixin("const auto b = call.getFloat(\"c1:b\")" ~ op ~ "call.getFloat(\"c2:b\");");
    mixin("const auto a = call.getFloat(\"c1:a\")" ~ op ~ "call.getFloat(\"c2:a\");");
    call.setFloat(r);
    call.setFloat(g);
    call.setFloat(b);
    call.setFloat(a);
}

private void _opBinaryScalarColor(string op)(GrCall call) {
    const auto s = call.getFloat("s");
    mixin("auto r = call.getFloat(\"c:r\")" ~ op ~ "s;");
    mixin("auto g = call.getFloat(\"c:g\")" ~ op ~ "s;");
    mixin("auto b = call.getFloat(\"c:b\")" ~ op ~ "s;");
    mixin("auto a = call.getFloat(\"c:a\")" ~ op ~ "s;");
    call.setFloat(r);
    call.setFloat(g);
    call.setFloat(b);
    call.setFloat(a);
}

private void _opBinaryScalarRightColor(string op)(GrCall call) {
    const auto s = call.getFloat("s");
    mixin("auto r = s" ~ op ~ "call.getFloat(\"c:r\");");
    mixin("auto g = s" ~ op ~ "call.getFloat(\"c:g\");");
    mixin("auto b = s" ~ op ~ "call.getFloat(\"c:b\");");
    mixin("auto a = s" ~ op ~ "call.getFloat(\"c:a\");");
    call.setFloat(r);
    call.setFloat(g);
    call.setFloat(b);
    call.setFloat(a);
}

private void _mixColor(GrCall call) {
    Color c1 = Color(call.getFloat("c1:r"), call.getFloat("c1:g"), call.getFloat("c1:b"), call.getFloat("c1:a"));
    Color c2 = Color(call.getFloat("c2:r"), call.getFloat("c2:g"), call.getFloat("c2:b"), call.getFloat("c2:a"));
    Color cr = mix(c1, c2);
    call.setFloat(cr.r);
    call.setFloat(cr.g);
    call.setFloat(cr.b);
    call.setFloat(cr.a);
}

private void _lerpColor(GrCall call) {
    Color c1 = Color(call.getFloat("c1:r"), call.getFloat("c1:g"), call.getFloat("c1:b"), call.getFloat("c1:a"));
    Color c2 = Color(call.getFloat("c2:r"), call.getFloat("c2:g"), call.getFloat("c2:b"), call.getFloat("c2:a"));
    Color cr = lerp(c1, c2, call.getFloat("t"));
    call.setFloat(cr.r);
    call.setFloat(cr.g);
    call.setFloat(cr.b);
    call.setFloat(cr.a);
}

private void _printColor(GrCall call) {
   writeln("Color(" ~ to!dstring(call.getFloat("c:r"))
        ~ ", " ~ to!dstring(call.getFloat("c:g"))
        ~ ", " ~ to!dstring(call.getFloat("c:b"))
        ~ ", " ~ to!dstring(call.getFloat("c:a")) ~ ")");
}

private void _castArrayToColor(GrCall call) {
    auto array = call.getIntArray("ary");
    if(array.data.length == 4) {
        Color color = Color(array.data[0], array.data[1], array.data[2], array.data[3]);
        call.setFloat(color.r);
        call.setFloat(color.g);
        call.setFloat(color.b);
        call.setFloat(color.a);
        return;
    }
    else if(array.data.length == 3) {
        Color color = Color(array.data[0], array.data[1], array.data[2]);
        call.setFloat(color.r);
        call.setFloat(color.g);
        call.setFloat(color.b);
        call.setFloat(color.a);
        return;
    }
    call.raise("Cannot convert array to Color, invalid size");
}

private void _castColorToString(GrCall call) {
   call.setString("Color(" ~ to!dstring(call.getFloat("c:r"))
        ~ ", " ~ to!dstring(call.getFloat("c:g"))
        ~ ", " ~ to!dstring(call.getFloat("c:b"))
        ~ ", " ~ to!dstring(call.getFloat("c:a")) ~ ")");
}