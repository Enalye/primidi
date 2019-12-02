/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.texture;

import std.conv, std.file, std.path;
import grimoire, atelier;

package void loadTexture(GrData data) {
    auto defTexture = data.addUserType("Texture");
    auto defSprite = grGetUserType("Sprite");

    data.addPrimitive(&_makeTexture, "Texture", ["path"], [grString], [defTexture]);

    data.addCast(&_castTextureToSprite, "tex", defTexture, defSprite, true);
}

private void _makeTexture(GrCall call) {
    auto tex = new Texture(buildNormalizedPath(buildPath(dirName(thisExePath()), "plugin",  to!string(call.getString("path")))));
    call.setUserData(tex);
}

private void _castTextureToSprite(GrCall call) {
    auto texture = call.getUserData!Texture("tex");
    auto sprite = new Sprite(texture);
    call.setUserData!Sprite(sprite);
}