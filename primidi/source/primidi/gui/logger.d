/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.logger;

import atelier;

final class Logger: GuiElement {
    private {
        Label _text;
    }

    this() {
        setAlign(GuiAlignX.left, GuiAlignY.bottom);
        size(Vec2f(200f, 200f));
        isInteractable(false);

        _text = new Label;
        addChildGui(_text);

        GuiState hiddenState = {
            color: Color.clear,
            offset: Vec2f(0f, 50f),
            time: 2f,
            easingFunction: getEasingFunction(EasingAlgorithm.sineIn),
            callbackId: "hidden"
        };
        addState("hidden", hiddenState);

        GuiState shownState = {};
        addState("shown", shownState);
    }

    override void onCallback(string id) {
        if(id == "hidden") {
            _text.text = "";
        }
    }

    override void update(float deltaTime) {
        _text.color = color;
    }

    void add(string message) {
        _text.text = message;
        setState("shown");
        doTransitionState("hidden");
    }
    
    override void draw() {
        
    }
}