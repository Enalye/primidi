module primidi.gui.taskbar_gui;

import atelier;
import primidi.gui.port;

final class TaskbarGui: GuiElement {
    private {
    }

    this() {
        position(Vec2f.zero);
        size(Vec2f(screenWidth, 50f));
        setAlign(GuiAlignX.Left, GuiAlignY.Top);
    }
}