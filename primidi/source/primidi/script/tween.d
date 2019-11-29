/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.tween;

import grimoire, atelier;

package void loadTween(GrData data) {
    static foreach(value; 
        [
        "InSine",
        "OutSine",
        "InOutSine",
        "InQuad",
        "OutQuad",
        "InOutQuad",
        "InCubic",
        "OutCubic",
        "InOutCubic",
        "InQuart",
        "OutQuart",
        "InOutQuart",
        "InQuint",
        "OutQuint",
        "InOutQuint",
        "InExp",
        "OutExp",
        "InOutExp",
        "InCirc",
        "OutCirc",
        "InOutCirc",
        "InBack",
        "OutBack",
        "InOutBack",
        "InElastic",
        "OutElastic",
        "InOutElastic",
        "InBounce",
        "OutBounce",
        "InOutBounce"]) {
        mixin("data.addPrimitive(&_ease!(\"" ~ value ~ "\"), \"ease" ~ value ~ "\", [\"t\"], [grFloat], [grFloat]);");
    }
}

private void _ease(string value)(GrCall call) {
    mixin("call.setFloat(ease" ~ value ~ "(call.getFloat(\"t\")));");
}