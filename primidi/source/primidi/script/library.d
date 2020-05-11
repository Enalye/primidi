/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.library;

public {
    import primidi.script.canvas, primidi.script.font, primidi.script.label, primidi.script.midi;
    import primidi.script.sprite, primidi.script.texture, primidi.script.tween, primidi.script.window;
    import primidi.script.particles;
}
import grimoire;

void loadScriptDefinitions(GrData data) {
    loadCanvas(data);
    loadFont(data);
    loadLabel(data);
    loadMidi(data);
    loadSprite(data);
    loadTexture(data);
    loadTween(data);
    loadWindow(data);
    loadParticles(data);
}