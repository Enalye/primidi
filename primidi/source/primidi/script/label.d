module primidi.script.label;

import std.conv;
import atelier, grimoire;

package void loadLabel() {
    const defLabel = grAddUserType("Label");
    const defFont = grGetUserType("Font");
    const defVec2f = grGetStructureType("Vec2f");

    grAddPrimitive(&_makeLabel, "Label", ["font", "text"], [defFont, grString], defLabel); 
    grAddPrimitive(&_setText, "label_setText", ["label", "text"], [defLabel, grString]); 
    grAddPrimitive(&_setFont, "label_setFont", ["label", "font"], [defLabel, defFont]); 
    grAddPrimitive(&_setPosition, "label_setPosition", ["label", "pos"], [defLabel, defVec2f]); 
    grAddPrimitive(&_draw, "label_draw", ["label"], [defLabel]); 
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