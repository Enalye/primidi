module primidi.pianoroll.channel;

import atelier;

import primidi.workstation.common.all;

class Channel: GuiElement {
	Color color;
    
	private {
		Sprite _rectSprite, _borderSprite, _bloomSprite;
		ubyte _channelId;
	}

	this(ubyte channelId) {
        _channelId = channelId;
		_bloomSprite = fetch!Sprite("bloom");
        _rectSprite = fetch!Sprite("note_rect");
        _borderSprite = fetch!Sprite("note_rect_border");

        color = Color.blue;

    auto tab = [
        Color.red,
        Color.lime,
        Color.blue,
        Color.yellow,
        Color.cyan,
        Color.magenta,
        Color.silver,
        Color.gray,
        Color.maroon,
        Color.olive,
        Color.green,
        Color.purple,
        Color.teal,
        Color.navy,
        Color.pink,
        Color.pink];

        color = tab[_channelId];
	}

	override void onEvent(Event event) {

	}

	override void update(float deltaTime) {

	}

    override void draw() {
        auto notesInRange = fetchInternalSequencerNotesInRange(_channelId);
        auto tick = getInternalSequencerTick();
        if(notesInRange) {
            foreach(note; notesInRange) {
                float pitch = (1f - (note.note / 128f)) * screenHeight;
               // float pitch = lerp(screenHeight / 128f, screenHeight - screenHeight / 128f, note.note);

                Vec2f position = Vec2f((note.tick - tick) / 6f + screenWidth / 2f, pitch);
                Vec2f size = Vec2f(note.step / 6f, screenHeight / 128f);

                Color noteColor;
                bool isPlayed = false;

                if(note.factor > 1f) {
                    noteColor = color;
                }
                else if(note.factor < 0f) {
                    noteColor = color;
                }
                else {
				    noteColor = lerp(Color.white, color, note.factor);
                    isPlayed = true;               
                }

                _borderSprite.color = noteColor;
                _rectSprite.color = noteColor;
                _borderSprite.fit(size);

                if(size.x < _borderSprite.size.x * 2f) {
                   /+ _borderSprite.anchor = Vec2f(.75f, 0f);
                    _borderSprite.flip = Flip.HorizontalFlip;
                    _borderSprite.draw(position);

                    _borderSprite.anchor = Vec2f(.25f, 0f);
                    _borderSprite.fit(size);
                    _borderSprite.flip = Flip.NoFlip;
                    _borderSprite.draw(position);+/

                    _rectSprite.anchor = Vec2f.half;
                    _rectSprite.size = size;
                    _rectSprite.draw(position + size / 2f);
                }
                else {
                    _borderSprite.anchor = Vec2f.zero;
                    _borderSprite.flip = Flip.HorizontalFlip;
                    _borderSprite.draw(position + Vec2f(_borderSprite.size.x / 2f, 0f));

                    _borderSprite.anchor = Vec2f(1f, 0f);
                    _borderSprite.fit(Vec2f.one * size.y);
                    _borderSprite.flip = Flip.NoFlip;        
                    _borderSprite.draw(position + Vec2f(size.x - _borderSprite.size.x / 2f, 0f));
                    
                    _rectSprite.anchor = Vec2f.half;
                    _rectSprite.size = size - Vec2f(_borderSprite.size.x + 4f, 0f);
                    _rectSprite.draw(position + size / 2f);
                }

                //Bloom
                if(isPlayed) {
                    _bloomSprite.size = size + 10f;
                    Color bloomColor = Color.white;
                    bloomColor.a = lerp(1f, 0f, note.factor);
                    _bloomSprite.color = bloomColor;
                    pushSfx();
                    _bloomSprite.draw(position + size / 2f);
                    popView();
                }
            }
        }
    }
}