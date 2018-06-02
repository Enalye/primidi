module primidi.workstation.common.sequencer;

import std.algorithm;
import std.stdio;
import derelict.sdl2.sdl;

import grimoire;

import primidi.midi.all;

import primidi.workstation.pianoroll.settings;

struct Note {
	uint tick;
	uint step;

	uint note;
	uint velocity;
	float factor;
}

alias NotesArray = IndexedArray!(Note, 4096u);

private Sequencer _sequencer;

void setupInternalSequencer(MidiFile midiFile) {
	_sequencer = new Sequencer;
	if(_sequencer)
		_sequencer.play(midiFile);
}

void startInternalSequencer() {
	if(_sequencer)
		_sequencer.start();
}

void updateInternalSequencer() {
	if(_sequencer)
		_sequencer.update();
}

NotesArray fetchInternalSequencerNotesInRange(ubyte channelId) {
	if(_sequencer && channelId < 16u)
		return _sequencer.channels[channelId].notesInRange;
	return null;
}

double getInternalSequencerTick() {
	if(_sequencer)
        return _sequencer.totalTicksElapsed;
    return 0uL;
}

private class Sequencer {
	struct Channel {
		Note[] notes;
		uint top;

		NotesArray notesInRange;
		long lastTickProcessed = -1;
		
		Note getTop() {
			return notes[top];
		}

		void process(long tick) {
			while(notes.length > top) {
				auto note = notes[top];
				if((tick + 6000)  > note.tick) {
					notesInRange.push(note);
					top ++;
				}
				else break;
			}

			int i = 0;
			foreach(ref note; notesInRange) {
				note.factor = cast(float)(cast(int)tick - cast(int)note.tick) / cast(float)note.step;
				if(tick > (note.tick + note.step + 6000))
					notesInRange.markInternalForRemoval(i);
				i ++;
			}
			notesInRange.sweepMarkedData();
			lastTickProcessed = tick;
		}
	}

	Channel[16] channels;


	MidiEvent[] events;
	uint eventsTop;

	TempoEvent[] tempoEvents;
	uint tempoEventsTop;

	long ticksPerQuarter;
	long tickAtLastChange = -1000;
	double ticksElapsedSinceLastChange, tickPerMs, msPerTick, timeAtLastChange;
	float currentBpm = 0f;
    double totalTicksElapsed;

	this() {
		foreach(channelId; 0.. 16) {
			channels[channelId].notesInRange = new NotesArray;
		}
	}

	void play(MidiFile midiFile) {
		tickOffset = 1000; //Temp
		speedFactor = 1f;
		initialBpm = 120;

		ticksPerQuarter = midiFile.ticksPerBeat;

		//ubyte trackId = 0u;
		Note[][16] noteOnEvents, noteOffEvents;

		//Set channel notes
		foreach(uint t; 0 .. cast(uint)midiFile.tracks.length) {
			//Temporarily here, move them to Channel
			int maxNote = 0, minNote = 0;

			//List all NOTE ON and NOTE OFF events.
			foreach(MidiEvent event; midiFile.tracks[t]) {
				switch(event.type) with(MidiEventType) {
					case NoteOn:
						Note note;
						note.tick = event.tick;
						note.note = event.note.note;
						note.velocity = event.note.velocity;
						if(note.velocity == 0)
							noteOffEvents[event.note.channel] ~= note;
						else
							noteOnEvents[event.note.channel] ~= note;

						if(event.note.note > maxNote)
							maxNote = event.note.note;//Temp

						if(event.note.note < minNote)
							minNote = event.note.note;//Temp
						break;
					case NoteOff:
						Note note;
						note.tick = event.tick;
						note.note = event.note.note;
						note.velocity = event.note.velocity;
						noteOffEvents[event.note.channel] ~= note;
						break;
					default:
						break;
				}

				//Fill in the tempo track.
				if(event.subType == MidiEvents.Tempo) {
					TempoEvent tempoEvent;
					tempoEvent.tick = event.tick;
					tempoEvent.usPerQuarter = event.tempo.microsecondsPerBeat;
					tempoEvents ~= tempoEvent;
				}
			}
		}

		foreach(channelId; 0u.. 16u) {
			//Use the NOTE OFF events to set each note length.
			foreach(uint i; 0.. cast(uint)(noteOnEvents[channelId].length)) {
				int note = noteOnEvents[channelId][i].note;
				foreach(uint y; 0.. cast(uint)(noteOffEvents[channelId].length)) {
					if(note == noteOffEvents[channelId][y].note) {
						noteOnEvents[channelId][i].step = noteOffEvents[channelId][y].tick - noteOnEvents[channelId][i].tick;
						//Minimal rendering step.
						if(noteOnEvents[channelId][i].step < 25)
							noteOnEvents[channelId][i].step = 25;
						noteOffEvents[channelId] = noteOffEvents[channelId][0 .. y] ~ noteOffEvents[channelId][y + 1 .. $];
						break;
					}
				}
			}

			if(noteOnEvents[channelId].length) {
				channels[channelId].notes = noteOnEvents[channelId];
				//trackId ++;
			}
		}
	}

	void start() {
		//Initialize
		tickAtLastChange = -tickOffset;
		tickPerMs = (initialBpm * ticksPerQuarter * speedFactor) / 60_000f;
		msPerTick = 60_000f / (initialBpm * ticksPerQuarter * speedFactor);
		timeAtLastChange = SDL_GetTicks();
	}

	void update() {
		//Just copied from pianoroll for now

		double currentTime = SDL_GetTicks();
		double msDeltaTime = currentTime - timeAtLastChange; //The time since last tempo change.
		ticksElapsedSinceLastChange = msDeltaTime * tickPerMs;

		//double totalTicksElapsed = tickAtLastChange + ticksElapsedSinceLastChange;

		totalTicksElapsed = tickAtLastChange + ticksElapsedSinceLastChange;
		if(tempoEvents.length > tempoEventsTop) {
			long tickThreshold = tempoEvents[tempoEventsTop].tick;
			if(totalTicksElapsed > tickThreshold) {
				long tickDelta = tickThreshold - tickAtLastChange;
				double finalDeltaTime = tickDelta * msPerTick;

				long usPerQuarter = tempoEvents[tempoEventsTop].usPerQuarter;
				tempoEventsTop ++;

				ticksElapsedSinceLastChange = 0;
				tickAtLastChange = tickThreshold;
				timeAtLastChange += finalDeltaTime;
				tickPerMs = (1000f * ticksPerQuarter * speedFactor) / usPerQuarter;
				msPerTick = usPerQuarter / (ticksPerQuarter * 1000f * speedFactor);
				currentBpm = tickPerMs * 60000f / ticksPerQuarter;
			}
		}
		
		//Events handling.
		foreach(channelId; 0.. 16) {
			channels[channelId].process(cast(long)totalTicksElapsed);
		}
	}
}