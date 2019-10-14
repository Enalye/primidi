module primidi.gui.ports_section;

import atelier;
import primidi.gui.port, primidi.menu;

final class PortsSectionGui: GuiElement {
    private {
        OutPortGui _outPortGui;
        InPortGui _inPortGui;
    }

    this() {
        position(Vec2f(25f, 100f));
        size(screenSize);
        setAlign(GuiAlignX.left, GuiAlignY.top);

        auto box = new VContainer;
        box.spacing = Vec2f(5f, 15f);
        addChildGui(box);

        _outPortGui = new OutPortGui;
        box.addChildGui(_outPortGui);

        _inPortGui = new InPortGui;
        box.addChildGui(_inPortGui);
    }
}