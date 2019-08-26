module primidi.gui.options_gui;

import atelier;
import primidi.gui.port, primidi.menu;

final class OptionsGui: GuiElement {
    private {
        OutPortGui _outPortGui;
        InPortGui _inPortGui;
    }

    this() {
        position(Vec2f.zero);
        size(screenSize);
        setAlign(GuiAlignX.Left, GuiAlignY.Top);

        auto box = new HContainer;
        box.spacing = Vec2f(15f, 5f);
        addChildGui(box);
        {
            auto font = fetch!Font("VeraMono");
            auto exitBtn = new TextButton(font, "exit");
            exitBtn.setCallback(this, "exit");
            box.addChildGui(exitBtn);
        }

        _outPortGui = new OutPortGui;
        box.addChildGui(_outPortGui);

        _inPortGui = new InPortGui;
        box.addChildGui(_inPortGui);

        const GuiState hiddenState = {
            offset: Vec2f(screenSize.x, 0f),
            time: .2f
        };
        addState("hidden", hiddenState);

        const GuiState activeState = {
            time: .2f
        };
        addState("active", activeState);
        setState("hidden");
    }

    override void onCallback(string id) {
        super.onCallback(id);
        if(id == "exit") {
            doTransitionState("hidden");
        }
    }

    override void draw() {
        drawFilledRect(origin, size, Color.black);
    }
}