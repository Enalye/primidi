/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.library;

public {
    import primidi.script.layer, primidi.script.canvas, primidi.script.font,
        primidi.script.text, primidi.script.midi;
    import primidi.script.sprite, primidi.script.texture, primidi.script.tween,
        primidi.script.window;
    import primidi.script.particle;
}
import grimoire;

/// Load all the functions and types of Primidi
GrLibrary loadPrimidiLibrary() {
    GrLibrary library = new GrLibrary;
    loadLayerLibrary(library);
    loadCanvasLibrary(library);
    loadFontLibrary(library);
    loadTextLibrary(library);
    loadMidiLibrary(library);
    loadSpriteLibrary(library);
    loadTextureLibrary(library);
    loadTweenLibrary(library);
    loadWindowLibrary(library);
    loadParticleLibrary(library);
    return library;
}
