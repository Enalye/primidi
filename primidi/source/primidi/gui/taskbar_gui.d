module primidi.gui.taskbar_gui;

import atelier;
import primidi.gui.port;
import primidi.player, primidi.midi;

final class TaskbarGui: VContainer {
    private {
    }

    this() {
        position(Vec2f(0f, 50f));
        size(Vec2f(100f, 100f));
        setAlign(GuiAlignX.center, GuiAlignY.bottom);

        addChildGui(new ProgressBar);

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
        super.onCallback(id);
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

final class ProgressBar: GuiElement {
    private {
        float _factor;
    }

    this() {
        size(Vec2f(800f, 15f));
    }

    override void onEvent(Event event) {
        switch(event.type) with(EventType) {
        case mouseDown:
        import std.stdio;
        writeln(origin.x, ", ", origin.x + size.x, ", ", event.position.x);
            _factor = clamp(rlerp(origin.x, origin.x + size.x, event.position.x), 0f, 1f);
            writeln(_factor, ", ", cast(long) (getMidiDuration() * _factor));
            setMidiPosition(cast(long) (getMidiDuration() * _factor));
            break;
        case mouseUp:
            break;
        default:
            break;
        }
    }

    override void update(float deltaTime) {
        auto currentTime = getMidiTime();
        auto totalTime = getMidiDuration();
        if(totalTime <= 0) {
            _factor = 1f;
            return;
        }
        else {
            _factor = clamp(currentTime / totalTime, 0f, 1f);
        }
    }

    override void draw() {
        drawFilledRect(origin, size, isHovered ? Color.yellow : Color.grey);
        drawFilledRect(origin, size * Vec2f(_factor, 1f), Color.cyan);
    }
}