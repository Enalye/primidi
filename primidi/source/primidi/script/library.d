/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.library;

public {
    import primidi.script.canvas, primidi.script.color, primidi.script.font, primidi.script.label, primidi.script.midi;
    import primidi.script.sprite, primidi.script.texture, primidi.script.tween, primidi.script.vec2, primidi.script.window;
    import primidi.script.ninepatch, primidi.script.particles, primidi.script.math;
}
import grimoire;

void loadScriptDefinitions(GrData data) {
    loadCanvas(data);
    loadColor(data);
    loadFont(data);
    loadLabel(data);
    loadMidi(data);
    loadSprite(data);
    loadNinePatch(data);
    loadTexture(data);
    loadTween(data);
    loadVec2(data);
    loadWindow(data);
    loadParticles(data);
    loadMath(data);
}