/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.logger;

import atelier;

/// Display every print/printl messages on screen
final class Logger : GuiElement {
    private {
        VContainer _box;
        bool _isVisible = true;
    }

    /// Ctor
    this() {
        setAlign(GuiAlignX.left, GuiAlignY.bottom);
        position(Vec2f(0f, 50f));
        size(getWindowSize() - Vec2f(0f, 70f));
        isInteractable(false);
    }

    override void update(float deltaTime) {
        int i;
        foreach_reverse (child; children) {
            LogMessage msg = cast(LogMessage) child;
            msg.index = i;
            i++;
        }
    }

    override void onEvent(Event event) {
        switch (event.type) with (Event.Type) {
        case resize:
            if (_isVisible)
                size(getWindowSize() - Vec2f(0f, 70f));
            else
                size(getWindowSize());
            break;
        case custom:
            if (event.custom.id == "hide") {
                if (_isVisible)
                    size(getWindowSize());
                else
                    size(getWindowSize() - Vec2f(0f, 70f));
                _isVisible = !_isVisible;
            }
            break;
        default:
            break;
        }
    }

    /// Add a new message
    void add(string message) {
        appendChild(new LogMessage(message));
    }

    override void draw() {

    }
}

/// A single line of text
final class LogMessage : GuiElement {
    private {
        Label _label;
    }

    /// Message position
    int index;

    /// Ctor
    this(string text) {
        setAlign(GuiAlignX.left, GuiAlignY.bottom);
        _label = new Label(text);
        appendChild(_label);

        GuiState hiddenState = {
            alpha: 0f, offset: Vec2f(0f, 50f), time: 2f, easing: getEasingFunction(Ease.sineIn),
            callback: "hidden"
        };
        addState("hidden", hiddenState);

        GuiState log3State = {time: 5f, callback: "log3"};
        addState("log3", log3State);

        GuiState log2State = {
            time: 1f, easing: getEasingFunction(Ease.sineOut), callback: "log2"
        };
        addState("log2", log2State);

        GuiState log1State = {offset: Vec2f(0f, -10f), alpha: 0f};
        addState("log1", log1State);

        setState("log1");
        doTransitionState("log2");

        size(_label.size);
    }

    override void onCallback(string id) {
        if (id == "hidden") {
            removeSelf();
        }
        else if (id == "log2") {
            doTransitionState("log3");
        }
        else if (id == "log3") {
            doTransitionState("hidden");
        }
    }

    override void update(float deltaTime) {
        position = Vec2f(10f, index * size.y);
        _label.alpha = alpha;
    }
}
