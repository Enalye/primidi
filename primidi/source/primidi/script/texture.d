/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.texture;

import std.conv : to;
import grimoire, atelier;
import primidi.script.util;

package void loadTextureLibrary(GrLibrary library) {
    auto defTexture = library.addForeign("Texture");
    auto defSprite = grGetForeignType("Sprite");
    library.addEnum("Blend", ["none", "modular", "additive", "alpha"]);
    library.addPrimitive(&_makeTexture, "Texture", [grString], [defTexture]);

    library.addCast(&_castTextureToSprite, defTexture, defSprite, true);
}

private void _makeTexture(GrCall call) {
    auto tex = new Texture(getResourcePath(call.getString(0)));
    call.setForeign(tex);
}

private void _castTextureToSprite(GrCall call) {
    auto texture = call.getForeign!Texture(0);
    auto sprite = new Sprite(texture);
    call.setForeign!Sprite(sprite);
}
