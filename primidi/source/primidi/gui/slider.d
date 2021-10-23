module primidi.gui.slider;

import atelier;
import std.conv : to;
import primidi.midi;

final class SpeedSlider : HSlider {
    private {
        Sprite _railCenterSprite, _railBorderSprite, _cursorSprite;
        immutable double[] _speeds = [
            .1, .2, .3, .4, .5, .6, .7, .8, .9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5,
            1.6, 1.7, 1.8, 1.9, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0
        ];
    }

    /// Ctor
    this() {
        anchor(Vec2f(0f, .5f));
        size(Vec2f(150f, 22f));

        steps(cast(uint) _speeds.length);
        minValue(0);
        maxValue((cast(int) _speeds.length) - 1);
        ivalue(10);

        _railCenterSprite = fetch!Sprite("slider.center");
        _railBorderSprite = fetch!Sprite("slider.border");
        _cursorSprite = fetch!Sprite("texel");

        _railCenterSprite.size = Vec2f(size.x - 2f, 4);
        _cursorSprite.size = Vec2f(10f, 22f);

        _cursorSprite.color = Color.fromHex(0xcccccc);
    }

    double getSpeed() const {
        const id = ivalue();
        if (id >= _speeds.length)
            return 1.0;
        else
            return _speeds[id];
    }

    override void draw() {
        _cursorSprite.color = Color.fromHex(isClicked ? 0x007ad9 : (isHovered ? 0x747474 : 0xcccccc));
        _railBorderSprite.anchor = Vec2f(0f, .5f);
        _railBorderSprite.draw(Vec2f(origin.x, center.y));
        _railBorderSprite.anchor = Vec2f(1f, .5f);
        _railBorderSprite.draw(Vec2f(origin.x + size.x, center.y));
        _railCenterSprite.draw(center);
        _cursorSprite.draw(Vec2f(getSliderPosition().x, center.y));
    }
}
