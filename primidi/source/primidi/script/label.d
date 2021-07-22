/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.label;

import std.conv;
import atelier, grimoire;

package void loadLabel(GrLibrary library) {
    const defLabel = library.addForeign("Label");
    const defFont = grGetForeignType("Font");

    library.addPrimitive(&_makeLabel, "Label", [grString], [defLabel]); 
    library.addPrimitive(&_makeLabelFont, "Label", [grString, defFont], [defLabel]); 
    library.addPrimitive(&_setText, "setText", [defLabel, grString]); 
    library.addPrimitive(&_setFont, "setFont", [defLabel, defFont]);  
    library.addPrimitive(&_draw, "draw", [defLabel, grFloat, grFloat]); 
}

private void _makeLabel(GrCall call) {
    Label label = new Label(call.getString(0));
    call.setForeign!Label(label);
}

private void _makeLabelFont(GrCall call) {
    Label label = new Label(
        call.getString(0),
        call.getForeign!Font(1));
    call.setForeign!Label(label);
}

private void _setText(GrCall call) {
    Label label = call.getForeign!Label(0);
    label.text = call.getString(1);
}

private void _setFont(GrCall call) {
    Label label = call.getForeign!Label(0);
    label.font = call.getForeign!Font(1);
}

private void _draw(GrCall call) {
    /*Label label = call.getForeign!Label("label");
    label.position = Vec2f(call.getFloat("x"), call.getFloat("y"));
    label. = label.position;
    label.draw();*/
}