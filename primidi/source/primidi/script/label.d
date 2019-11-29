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
    const defVec2f = grGetTupleType("Vec2f");

    data.addPrimitive(&_makeLabel, "Label", ["font", "text"], [defFont, grString], [defLabel]); 
    data.addPrimitive(&_setText, "label_setText", ["label", "text"], [defLabel, grString]); 
    data.addPrimitive(&_setFont, "label_setFont", ["label", "font"], [defLabel, defFont]); 
    data.addPrimitive(&_setPosition, "label_setPosition", ["label", "pos"], [defLabel, defVec2f]); 
    data.addPrimitive(&_draw, "label_draw", ["label"], [defLabel]); 
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

private void _setPosition(GrCall call) {
    Label label = call.getUserData!Label("label");
    Vec2f pos = Vec2f(call.getFloat("pos.x"), call.getFloat("pos.y"));
    label.position = pos;
}

private void _draw(GrCall call) {
    Label label = call.getUserData!Label("label");
    label.draw();
}