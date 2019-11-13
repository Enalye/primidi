module primidi.gui.taskbar_gui;

import atelier;
import primidi.gui.port;
import primidi.midi;

final class TaskbarGui: GuiElement {
    private {
    }

    this() {
        position(Vec2f.zero);
        size(Vec2f(screenWidth, 50f));
        setAlign(GuiAlignX.left, GuiAlignY.top);

        auto playBtn = new TextButton(getDefaultFont(), "Play/Stop");
        playBtn.setCallback(this, "play");
        addChildGui(playBtn);
    }

    override void onCallback(string id) {
        if(id == "play") {
            if(isMidiClockRunning())
                pauseMidiClock();
            else
                startMidiClock();
        }
    }
}