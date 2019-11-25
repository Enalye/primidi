module primidi.gui.plugin;

import atelier, grimoire;
import primidi.midi;

/// Load and run the plugin's script
final class PluginGui: GuiElement {
    private {
        Canvas _fullscreenCanvas;
    }

    this() {
        size(screenSize);
        setAlign(GuiAlignX.center, GuiAlignY.center);

        _fullscreenCanvas = new Canvas(screenSize);
        _fullscreenCanvas.position = centerScreen;
        initializeScript();
    }

    void reload() {}

    void setFullscreen() {}

    override void update(float deltaTime) {
        pushCanvas(_fullscreenCanvas);
        runScript();
        popCanvas();
    }

    override void onEvent(Event event) {
        switch(event.type) with(EventType) {
        case resize:
            _fullscreenCanvas = new Canvas(event.window.size);
            break;
        default:
            break;
        }
    }

    override void draw() {
        drawFilledRect(origin, size, Color.black);
        _fullscreenCanvas.draw(center);
    }

    override void onQuit() {
        killScript();
    }
}