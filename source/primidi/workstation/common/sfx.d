module primidi.workstation.common.sfx;

import atelier;


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