module primidi.gui.options;

import atelier;
import primidi.gui.ports_section;
import primidi.gui.ports_section, primidi.menu;
/*
final class OptionsGui: GuiElement {
    private {
        PortsSectionGui _portsSectionGui;
    }

    this() {
        _portsSectionGui = new PortsSectionGui;
        addChildGui(_portsSectionGui);

    }
}
*/
final class OptionsGui: GuiElement {
    private {
        PortsSectionGui _portsSectionGui;
    }

    this() {
        position(Vec2f.zero);
        size(screenSize);
        setAlign(GuiAlignX.left, GuiAlignY.top);

        auto box = new HContainer;
        box.spacing = Vec2f(15f, 5f);
        addChildGui(box);
        {
            auto exitBtn = new TextButton(getDefaultFont(), "exit");
            exitBtn.setCallback(this, "exit");
            box.addChildGui(exitBtn);
        }

        _portsSectionGui = new PortsSectionGui;
        addChildGui(_portsSectionGui);

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