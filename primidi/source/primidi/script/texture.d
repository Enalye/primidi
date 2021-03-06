/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.texture;

import std.conv: to;
import grimoire, atelier;
import primidi.script.util;

package void loadTexture(GrData data) {
    auto defTexture = data.addForeign("Texture");
    auto defSprite = grGetForeignType("Sprite");
    data.addEnum("Blend", ["none", "modular", "additive", "alpha"]);
    data.addPrimitive(&_makeTexture, "Texture", ["path"], [grString], [defTexture]);

    data.addCast(&_castTextureToSprite, "tex", defTexture, defSprite, true);
}

private void _makeTexture(GrCall call) {
    auto tex = new Texture(getResourcePath(call.getString("path")));
    call.setUserData(tex);
}

private void _castTextureToSprite(GrCall call) {
    auto texture = call.getUserData!Texture("tex");
    auto sprite = new Sprite(texture);
    call.setUserData!Sprite(sprite);
}