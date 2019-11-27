module primidi.gui.plugin;

import atelier, grimoire;
import primidi.midi;

/// Load and run the plugin's script
final class PluginGui: GuiElement {
    private {
        Canvas _canvas;
    }

    this() {
        size(screenSize - Vec2f(0f, 70f));
        position(Vec2f(0f, 20f));
        setAlign(GuiAlignX.left, GuiAlignY.top);

        _canvas = new Canvas(size);
        _canvas.position = centerScreen; //TODO: remove that.
    }

    override void update(float deltaTime) {
        pushCanvas(_canvas);
        runScript();
        popCanvas();
    }

    override void onEvent(Event event) {
        switch(event.type) with(EventType) {
        case resize:
            size(screenSize - Vec2f(0f, 70f));
            _canvas.renderSize = cast(Vec2u) size;
            break;
        default:
            break;
        }
    }

    override void draw() {
        drawFilledRect(origin, size, Color.black);
        _canvas.draw(center);
    }

    override void onQuit() {
        killScript();
    }
}