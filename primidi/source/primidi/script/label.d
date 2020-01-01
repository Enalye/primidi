/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.label;

import std.conv;
import atelier, grimoire;

package void loadLabel(GrData data) {
    const defLabel = data.addUserType("Label");
    const defFont = grGetUserType("Font");

    data.addPrimitive(&_makeLabel, "Label", ["font", "text"], [defFont, grString], [defLabel]); 
    data.addPrimitive(&_setText, "setText", ["label", "text"], [defLabel, grString]); 
    data.addPrimitive(&_setFont, "setFont", ["label", "font"], [defLabel, defFont]);  
    data.addPrimitive(&_draw, "draw", ["label", "x", "y"], [defLabel, grFloat, grFloat]); 
}

private void _makeLabel(GrCall call) {
    Label label = new Label(
        call.getUserData!Font("font"),
        to!string(call.getString("text")));
    call.setUserData!Label(label);
}

private void _setText(GrCall call) {
    Label label = call.getUserData!Label("label");
    label.text = to!string(call.getString("text"));
}

private void _setFont(GrCall call) {
    Label label = call.getUserData!Label("label");
    label.font = call.getUserData!Font("font");
}

private void _draw(GrCall call) {
    /*Label label = call.getUserData!Label("label");
    label.position = Vec2f(call.getFloat("x"), call.getFloat("y"));
    label. = label.position;
    label.draw();*/
}