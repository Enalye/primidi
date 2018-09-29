module primidi.workstation.common.piano;

import atelier;


import primidi.workstation.common.all;

class Piano: Widget {
	private {
		Sprite _blackNoteSprite, _whiteNoteSprite, _bloomSprite;
		ubyte _channelId;
	}

	this(ubyte channelId) {
		_channelId = channelId;
		_whiteNoteSprite = fetch!Sprite("note_white");
		_blackNoteSprite = fetch!Sprite("note_black");
		_bloomSprite = fetch!Sprite("bloom");

		/+
		The size of the piano only depends on the size of the white notes.
			7 is the number of white notes in an octave
			10 the number of complete octaves.
			The 11th octave is incomplete and has only 5 white notes.
		+/
		_size = Vec2f(_whiteNoteSprite.size.x * (7 * 10 + 5), _whiteNoteSprite.size.y);
		_whiteNoteSprite.anchor = Vec2f.zero;
		_blackNoteSprite.anchor = Vec2f.zero;
	}

	override void update(float deltaTime) {

	}

	override void onEvent(Event event) {

	}

	override void draw() {
		/+
			Octaves range from -1 to 9
			An octave have 12 notes:
				C C# D D# E F F# G G# A A# B
				0 1  2 3  4 5 6  7 8  9 10 11
		+/
		bool[128] notesState = false;
		auto notesInRange = fetchInternalSequencerNotesInRange(_channelId);
		if(notesInRange) {
			foreach(note; notesInRange) {
				if(note.factor > 0f && note.factor < 1f) {
					notesState[note.note] = true;
				}
			}
		}

		foreach(octave; 0.. 11) {
			//White notes
			Vec2f notePosition = _position - _size / 2f + Vec2f(octave * 70f, 0f);
			foreach(note; 0.. 7) {
				if(octave == 10 && note > 4)
					continue;
				auto noteIndex = [0, 2, 4, 5, 7, 9, 11][note];

				if(notesState[octave * 12 + noteIndex]) {
					_whiteNoteSprite.texture.setColorMod(Color.cyan);
					_whiteNoteSprite.draw(notePosition);
					_bloomSprite.size = _whiteNoteSprite.size + 10f;
					Color bloomColor = mix(Color.cyan, Color.white);
					bloomColor.a = .4f;
					_bloomSprite.texture.setColorMod(bloomColor);
					pushSfx();
					_bloomSprite.draw(notePosition + _whiteNoteSprite.size / 2f);
					popView();
				}
				else {
					_whiteNoteSprite.texture.setColorMod(Color.white);
					_whiteNoteSprite.draw(notePosition);
				}
				notePosition.x += 10f;
			}

			//Black notes
			notePosition = _position - _size / 2f + Vec2f(octave * 70f, 0f);
			foreach(note; 0.. 5) {
				if(octave == 10 && note > 2)
					continue;
				auto noteIndex = [1, 3, 6, 8, 10][note];
				auto noteOffset = [5, 18, 36, 48, 60][note];
				Vec2f finalPosition = notePosition + Vec2f(noteOffset, 0f);
				if(notesState[octave * 12 + noteIndex]) {
					_blackNoteSprite.texture.setColorMod(Color.cyan);
					_blackNoteSprite.draw(finalPosition);
					_bloomSprite.size = _blackNoteSprite.size + 10f;
					Color bloomColor = mix(Color.cyan, Color.white);
					bloomColor.a = .4f;
					_bloomSprite.texture.setColorMod(bloomColor);
					pushSfx();
					_bloomSprite.draw(finalPosition + _blackNoteSprite.size / 2f);
					popView();
				}
				else {
					_blackNoteSprite.texture.setColorMod(Color.black);
					_blackNoteSprite.draw(finalPosition);
				}
			}
		}
	}
}