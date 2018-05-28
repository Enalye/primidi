module primidi.workstation.common.sfx;

import primidi.core.all;
import primidi.common.all;
import primidi.render.all;

private View _postEffectView;

void initializeSfx() {
	_postEffectView = new View(screenSize);
	_postEffectView.setColorMod(Color.white, Blend.AdditiveBlending);
}

void pushSfx() {
	pushView(_postEffectView, false);
}

void renderSfx() {
	_postEffectView.draw(centerScreen);
	pushView(_postEffectView, true);
	popView();
}