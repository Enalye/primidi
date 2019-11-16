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
        hbox.padding = Vec2f(0f, 0f);

        auto rewindBtn = new RewindButton;
        hbox.addChildGui(rewindBtn);

        auto playBtn = new PlayButton;
        hbox.addChildGui(playBtn);
    }

    override void onCallback(string id) {
        super.onCallback(id);
        switch(id) {
        default:
            break;
        }
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
        _pauseSprite.size /= 2f;
        _playSprite.size /= 2f;
        size = Vec2f(50f, 50f);
    }

	override void onSubmit() {
        _isPaused = !_isPaused;
        pauseMidi();
    }

    override void draw() {
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
        _rewindSprite.size /= 2f;
        size = Vec2f(50f, 50f);
    }

    override void onSubmit() {
        rewindMidi();
    }

    override void draw() {
        _rewindSprite.draw(center);
    }
}

final class ProgressBar: GuiElement {
    private {
        float _factor;
        Sprite _cursorSprite;
    }

    this() {
        size(Vec2f(screenWidth, 15f));
        _cursorSprite = fetch!Sprite("cursor");
        _cursorSprite.size /= 2f;
    }

    override void onEvent(Event event) {
        switch(event.type) with(EventType) {
        case mouseDown:
            _factor = clamp(rlerp(origin.x, origin.x + size.x, event.position.x), 0f, 1f);
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
        drawFilledRect(Vec2f(origin.x, center.y - 3f), Vec2f(size.x, 6f), Color.grey * .5f);
        drawFilledRect(Vec2f(origin.x, center.y - 3f), Vec2f(size.x, 6f) * Vec2f(_factor, 1f), Color.cyan);
        _cursorSprite.draw(origin + size * Vec2f(_factor, .5f));
    }
}