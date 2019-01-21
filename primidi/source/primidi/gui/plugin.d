module primidi.gui.plugin;

import atelier, grimoire;
import primidi.midi;

/// Load and run the plugin's script
final class PluginGui: GuiElement {
    private {
        Canvas _canvas;
    }

    this() {
        position(Vec2f.zero);
        size(screenSize);
        setAlign(GuiAlignX.Left, GuiAlignY.Top);

        _canvas = new Canvas(screenSize);
        _canvas.position = screenSize / 2f;
        initializeScript();
    }

    void reload() {}

    override void update(float deltaTime) {
        pushCanvas(_canvas);
        runScript();
        popCanvas();
    }

    override void draw() {
        _canvas.draw(center);
    }
}