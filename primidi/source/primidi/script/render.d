module primidi.script.render;

import atelier, grimoire;

void loadRenderDefinitions() {
    auto defVec2f = grGetStructureType("vec2f");
    grAddPrimitive(&_drawFilledRect, "drawFilledRect", ["pos", "size"], [defVec2f, defVec2f]);
}

private void _drawFilledRect(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("pos.x"), call.getFloat("pos.y"));
    Vec2f size = Vec2f(call.getFloat("size.x"), call.getFloat("size.y"));
    drawFilledRect(pos, size, Color.red);
}