module primidi.gui.taskbar_gui;

import atelier;
import primidi.gui.port;
import primidi.player, primidi.midi;

final class TaskbarGui: GuiElement {
    private {
    }

    this() {
        size(Vec2f(screenWidth, 50f));
        setAlign(GuiAlignX.center, GuiAlignY.bottom);

        {
            auto hbox = new HContainer;
            addChildGui(hbox);
            hbox.addChildGui(new CurrentTimeGui);
            hbox.addChildGui(new ProgressBar);
            hbox.addChildGui(new TotalTimeGui);
        }

        {
            auto playBtn = new PlayButton;
            addChildGui(playBtn);
        }

        {
            auto hbox = new HContainer;
            hbox.setAlign(GuiAlignX.left, GuiAlignY.bottom);
            hbox.position = Vec2f(48f, 5f);
            hbox.spacing = Vec2f(2f, 0f);
            addChildGui(hbox);

            auto rewindBtn = new RewindButton;
            hbox.addChildGui(rewindBtn);

            auto stopBtn = new StopButton;
            hbox.addChildGui(stopBtn);
        }
    }

    override void onEvent(Event event) {
        switch(event.type) with(EventType) {
        case resize:
            size(Vec2f(event.window.size.x, 50f));
            break;
        default:
            break;
        }
    }

    override void onCallback(string id) {
        super.onCallback(id);
        switch(id) {
        default:
            break;
        }
    }

    override void draw() {
        drawFilledRect(origin, size, Color(240, 240, 240));
    }
}

final class PlayButton: Button {
    private {
        Sprite _pauseSprite, _playSprite;
        bool _isPaused;
    }

    this() {
        _pauseSprite = fetch!Sprite("pause");
        _playSprite = fetch!Sprite("play");

        setAlign(GuiAlignX.left, GuiAlignY.bottom);
        position = Vec2f(4f, 2f);
        size = Vec2f(30f, 30f);
    }

	override void onSubmit() {
        _isPaused = !_isPaused;
        pauseMidi();
    }

    override void draw() {
        drawFilledRect(origin, size, isHovered ? Color(229, 241, 251) : Color(225, 225, 225));
        drawRect(origin, size, isHovered ? Color(0, 120, 215) : Color(173, 173, 173));
        if(_isPaused)
            _playSprite.draw(center);
        else
            _pauseSprite.draw(center);
    }
}

final class RewindButton: Button {
    private {
        Sprite _rewindSprite;
    }

    this() {
        _rewindSprite = fetch!Sprite("rewind");
        size = Vec2f(24f, 24f);
    }

    override void onSubmit() {
        rewindMidi();
    }

    override void draw() {
        drawFilledRect(origin, size, isHovered ? Color(229, 241, 251) : Color(225, 225, 225));
        drawRect(origin, size, isHovered ? Color(0, 120, 215) : Color(173, 173, 173));
        _rewindSprite.draw(center);
    }
}

final class StopButton: Button {
    private {
        Sprite _stopSprite;
    }

    this() {
        _stopSprite = fetch!Sprite("stop");
        size = Vec2f(24f, 24f);
    }

    override void onSubmit() {
        stopMidi();
    }

    override void draw() {
        drawFilledRect(origin, size, isHovered ? Color(229, 241, 251) : Color(225, 225, 225));
        drawRect(origin, size, isHovered ? Color(0, 120, 215) : Color(173, 173, 173));
        _stopSprite.draw(center);
    }
}

final class ProgressBar: GuiElement {
    private {
        float _factor;
        Sprite _cursorSprite;
    }

    this() {
        size(Vec2f(screenWidth - 100f, 15f));
        _cursorSprite = fetch!Sprite("cursor");
    }

    override void onEvent(Event event) {
        switch(event.type) with(EventType) {
        case mouseDown:
            _factor = clamp(rlerp(origin.x, origin.x + size.x, event.mouse.position.x), 0f, 1f);
            setMidiPosition(cast(long) (getMidiDuration() * _factor));
            break;
        case mouseUp:
            break;
        case resize:
            size(Vec2f(event.window.size.x - 100f, 15f));
            break;
        default:
            break;
        }
    }

    override void update(float deltaTime) {
        auto currentTime = getMidiTime();
        auto totalTime = getMidiDuration();
        if(!isMidiPlaying()) {
            _factor = 0f;
        }
        else if(totalTime <= 0) {
            _factor = 1f;
            return;
        }
        else {
            _factor = clamp(currentTime / totalTime, 0f, 1f);
        }
    }

    override void draw() {
        drawFilledRect(Vec2f(origin.x, center.y - (size.y / 2f)), Vec2f(size.x, 10f), Color.grey * .5f);
        drawFilledRect(Vec2f(origin.x, center.y - (size.y / 2f)), Vec2f(size.x, 10f) * Vec2f(_factor, 1f), Color.cyan);
        if(isMidiPlaying())
            _cursorSprite.draw(origin + size * Vec2f(_factor, .5f));
    }
}

alias TotalTimeGui = CurrentTimeGui;
final class CurrentTimeGui: GuiElement {
    private {
        Label _label;
    }

    this() {
        _label = new Label("00:00");
        _label.color = Color.black;
        _label.setAlign(GuiAlignX.center, GuiAlignY.top);
        size(Vec2f(50f, 25f));
        addChildGui(_label);
    }

    override void update(float deltaTime) {

    }

    override void draw() {
        _label.draw();
    }
}