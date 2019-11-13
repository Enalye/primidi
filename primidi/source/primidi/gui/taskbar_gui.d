module primidi.gui.taskbar_gui;

import atelier;
import primidi.gui.port;
import primidi.player;

final class TaskbarGui: GuiElement {
    private {
    }

    this() {
        position(Vec2f.zero);
        size(Vec2f(screenWidth, 50f));
        setAlign(GuiAlignX.left, GuiAlignY.top);

        auto hbox = new HContainer;
        addChildGui(hbox);

        auto playBtn = new TextButton(getDefaultFont(), "Play/Stop");
        playBtn.setCallback(this, "play");
        hbox.addChildGui(playBtn);

        auto rewindBtn = new TextButton(getDefaultFont(), "Rewind");
        rewindBtn.setCallback(this, "rewind");
        hbox.addChildGui(rewindBtn);
    }

    override void onCallback(string id) {
        switch(id) {
        case "play":
            pauseMidi();
            break;
        case "rewind":
            rewindMidi();
            break;
        default:
            break;
        }
    }
}