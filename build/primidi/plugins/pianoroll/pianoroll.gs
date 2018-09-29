main {
    print("Script started");
    bool play = true;
    int note;
    while(play) {
        //print("Current tick: " ~ to_string(midi_getTick()));

        note = 0;
        loop(chan_getCount(0)) {
            float factor = note_getFactor(0, note);
            if((factor >= 0.0) and (factor <= 1.0)) {
                int pitch = note_getPitch(0, note);
                print(pitch);
            }
            note ++;
        }
        yield
    }
}

/*
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

                _borderSprite.texture.setColorMod(noteColor);
                _rectSprite.texture.setColorMod(noteColor);
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
                    _bloomSprite.texture.setColorMod(bloomColor);
                    pushSfx();
                    _bloomSprite.draw(position + size / 2f);
                    popView();
                }
            }
        }
        */