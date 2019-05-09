module primidi.script.texture;

import std.conv;
import grimoire, atelier;

package void loadTexture() {
    auto defTexture = grAddUserType("Texture");
    auto defSprite = grGetUserType("Sprite");

    grAddPrimitive(&_makeTexture, "Texture", ["path"], [grString], [defTexture]);

    grAddCast(&_castTextureToSprite, "tex", defTexture, defSprite, true);
}

private void _makeTexture(GrCall call) {
    auto tex = new Texture(to!string(call.getString("path")));
    call.setUserData(tex);
}

private void _castTextureToSprite(GrCall call) {
    auto texture = call.getUserData!Texture("tex");
    auto sprite = new Sprite(texture);
    call.setUserData!Sprite(sprite);
}