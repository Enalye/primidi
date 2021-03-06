/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.visualizer;

import atelier, grimoire;
import primidi.midi, primidi.particles;

/// Load and run the plugin's script
final class Visualizer: GuiElement {
    private {
        Canvas _canvas;
        bool _isVisible = true;
    }

    this() {
        import primidi.script: setScriptCanvas;

        size(screenSize - Vec2f(0f, 70f));
        position(Vec2f(0f, 20f));
        setAlign(GuiAlignX.left, GuiAlignY.top);

        _canvas = new Canvas(size);
        _canvas.position = centerScreen;
        setScriptCanvas(_canvas);

        initializeParticles();

        GuiState hiddenState = {
            offset: Vec2f(0f, -20f),
            time: .25f,
            easing: getEasingFunction(Ease.quadInOut)
        };
        addState("hidden", hiddenState);

        GuiState shownState = {
            time: .25f,
            easing: getEasingFunction(Ease.quadInOut)
        };
        addState("shown", shownState);
        setState("shown");
    }

    override void update(float deltaTime) {
        pushCanvas(_canvas);
        runScript();
        popCanvas();
        updateParticles(deltaTime);
    }

    override void onEvent(Event event) {
        switch(event.type) with(EventType) {
        case resize:
            if(_isVisible)
                size(screenSize - Vec2f(0f, 70f));
            else
                size(screenSize);
            _canvas.renderSize = cast(Vec2u) size;
            break;
        case custom:
            if(event.custom.id == "hide") {
                doTransitionState(_isVisible ? "hidden" : "shown");
                if(_isVisible)
                    size(screenSize);
                else
                    size(screenSize - Vec2f(0f, 70f));
                _canvas.renderSize = cast(Vec2u) size;
                _isVisible = !_isVisible;
            }
            break;
        default:
            break;
        }
    }

    override void draw() {
        drawFilledRect(origin, size, Color.black);
        pushCanvas(_canvas, false);
        drawParticles();
        popCanvas();
        _canvas.draw(center);
    }

    override void onQuit() {
        killScript();
    }
}