module primidi.gui.taskbar_gui;

import atelier;
import primidi.gui.port;

final class TaskbarGui: GuiElement {
    private {
        PortGui _portGui;
    }

    this() {
        position(Vec2f.zero);
        size(Vec2f(screenWidth, 50f));
        setAlign(GuiAlignX.Left, GuiAlignY.Top);

        auto box = new HContainer;
        box.spacing = Vec2f(15f, 5f);
        addChildGui(box);
        {
            auto font = fetch!Font("VeraMono");
            auto playBtn = new TextButton(font, "play");
            box.addChildGui(playBtn);
            auto pauseBtn = new TextButton(font, "pause");
            box.addChildGui(pauseBtn);
            auto stopBtn = new TextButton(font, "stop");
            box.addChildGui(stopBtn);
        }

        box.addChildGui(new PortGui);
    }
}