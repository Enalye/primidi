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

GrLibrary loadPrimidiLibrary() {
    GrLibrary library = new GrLibrary;
    loadCanvas(library);
    loadFont(library);
    loadLabel(library);
    loadMidi(library);
    loadSprite(library);
    loadTexture(library);
    loadTween(library);
    loadWindow(library);
    loadParticles(library);
    return library;
}