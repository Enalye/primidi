/**
Primidi
Copyright (c) 2016 Enalye

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising
from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute
it freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented;
	   you must not claim that you wrote the original software.
	   If you use this software in a product, an acknowledgment
	   in the product documentation would be appreciated but
	   is not required.

	2. Altered source versions must be plainly marked as such,
	   and must not be misrepresented as being the original software.

	3. This notice may not be removed or altered from any source distribution.
*/

module primidi.workstation.pianoroll.pianoroll;

import std.conv;
import std.format;
import std.random;
import std.path;

import derelict.sdl2.sdl;
import grimoire;

import primidi.workstation.pianoroll.settings;

import primidi.midi.all;

import primidi.workstation.pianoroll.channel;
import primidi.workstation.pianoroll.particle;
import primidi.workstation.pianoroll.title;

class PianoRoll: Widget {
	Channel[] channels;
	TempoEvent[] tempoEvents;
	uint tempoEventsTop;
	uint ticksPerQuarter;

	long tickAtLastChange = -1000, lastTickOfMidi, currentBpm;
	double totalTicksElapsed, ticksElapsedSinceLastChange, tickPerMs, msPerTick, timeAtLastChange;

	Color barColor = Color.white;
	IndexedArray!(Spark, 5000u) particles = new IndexedArray!(Spark, 5000u)();
	Title title;

	bool isPlaying = false, isLoaded = false;

	this() {
		_position = Vec2f(screenWidth / 2.0f, screenHeight / 2.0f);
	}

	override void onEvent(Event event) {
		/+switch(event.type) with(EventType) {
		case RestartMusic:
		case EndMusic:
		case Quit:
			isPlaying = false;
			break;
		case LoadMusic:
			play(event.str);
			break;
		default:
			break;
		}+/
	}

	override void update(float deltaTime) {
		if(isLoaded && !isPlaying) {
			isLoaded = false;
			
			//Start event.
			/+Event startEvent;
			startEvent.type = EventType.StartMusic;
			startEvent.str = title.titleLabel.text;
			sendEvent(startEvent);+/

			timeAtLastChange = SDL_GetTicks();
			isPlaying = true;
		}

		//Updates
		double currentTime = SDL_GetTicks();
		double msDeltaTime = currentTime - timeAtLastChange; //The time since last tempo change.
		ticksElapsedSinceLastChange = msDeltaTime * tickPerMs;

		if(isPlaying) {
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
					currentBpm = cast(uint)(tickPerMs * 60000f / ticksPerQuarter);
				}
			}
		}

		if(title !is null)
			title.update(deltaTime);

		foreach(Channel chan; channels)
			chan.update(totalTicksElapsed);

		foreach(Spark particle, uint index; particles) {
			if(particle.update(deltaTime))
				particles.markInternalForRemoval(index);
		}

		particles.sweepMarkedData();

		if(isPlaying) {
			if(totalTicksElapsed > lastTickOfMidi) {
				/+Event event;
				event.type = EventType.EndMusic;
				sendEvent(event);+/

				//Set initial time step (120 BPM).
				tickPerMs = (initialBpm * ticksPerQuarter * speedFactor) / 60000f;
				msPerTick = 60000f / (initialBpm * ticksPerQuarter * speedFactor);
				timeAtLastChange = SDL_GetTicks();
				tickAtLastChange = lastTickOfMidi;

				isPlaying = false;
			}
		}
	}

	override void draw() {
		//Drawing
		if(showCentralBar)
			drawBar();

		foreach(Channel chan; channels)
			chan.draw();

		foreach(const Spark particle; particles)
			particle.draw();

		if(title !is null)
			title.draw();
	}

	void drawBar() {
		if(totalTicksElapsed < 0f)
			drawFilledRect(Vec2f(0f, 0f), Vec2f(((1000f + totalTicksElapsed) / 1000f) * 2f, screenHeight), barColor);
		else if(totalTicksElapsed > lastTickOfMidi) {
			if((totalTicksElapsed - lastTickOfMidi) < 1000)
				drawFilledRect(Vec2f(0f, 0f), Vec2f(((1000f - (totalTicksElapsed - lastTickOfMidi)) / 1000f) * 2f, screenHeight), barColor);
		}
		else
			drawFilledRect(Vec2f(0f, 0f), Vec2f(2f, screenHeight), barColor);
	}

	void addNoteParticle(float pitch, float factor, Color color) {
		if((particles.length + 1) == particles.capacity)
			return;

		Spark p = new Spark;
		p.color = color;
		p.position = Vec2f(0f, pitch);
		p.timeToLive = uniform(1f, 15f);
		p.angle = uniform(0f, 360f);
		p.speed = uniform(0.1f, 2f);
		p.angleSpeed = uniform(-2f, 2f);
		particles.push(p);
		barColor = mix(barColor, color);
	}

	void play(string filePath) {
		MidiFile file = new MidiFile(filePath);
		MidiEvent[][] tracks;
		int minNote = 0x0F, maxNote = 0u;

		channels.length = 0;
		tempoEvents.length = 0;
		tempoEventsTop = 0;
		tickAtLastChange = -tickOffset;

		ticksPerQuarter = file.ticksPerBeat;

		//Extract only Note ON/OFF and Tempo events.
		foreach(uint t; 0 .. cast(uint)file.tracks.length) {
			foreach(MidiEvent ev; file.tracks[t]) {
				if(ev.type == MidiEventType.NoteOn) {
					if(ev.note.velocity == 0)
						ev.type = MidiEventType.NoteOff;

					if(ev.note.channel >= tracks.length)
						tracks.length = ev.note.channel + 1;

					tracks[ev.note.channel] ~= ev;
				}
				else if(ev.type == MidiEventType.NoteOff)
					tracks[ev.note.channel] ~= ev;

				if(ev.subType == MidiEvents.Tempo) {
					if(!tracks.length)
						tracks.length = 1;
					tracks[0] ~= ev;
				}
			}
		}

		foreach(uint t; 0 .. cast(uint)tracks.length) {
			Channel chan = new Channel;
			chan.pianoRoll = this;
			Channel.Note[] noteOnEvents, noteOffEvents;

			//List all NOTE ON and NOTE OFF events.
			foreach(MidiEvent event; tracks[t]) {
				switch(event.type) with(MidiEventType) {
					case NoteOn:
						Channel.Note note;
						note.tick = event.tick;
						note.note = event.note.note;
						note.velocity = event.note.velocity;
						noteOnEvents ~= note;

						if(event.note.note > maxNote)
							maxNote = event.note.note;

						if(event.note.note < minNote)
							minNote = event.note.note;
						break;
					case NoteOff:
						Channel.Note note;
						note.tick = event.tick;
						note.note = event.note.note;
						note.velocity = event.note.velocity;
						noteOffEvents ~= note;
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

			//Use the NOTE OFF events to set each note length.
			foreach(uint i; 0 .. cast(uint)noteOnEvents.length) {
				int note = noteOnEvents[i].note;
				foreach(uint y; 0 .. cast(uint)noteOffEvents.length) {
					if(note == noteOffEvents[y].note) {
						noteOnEvents[i].step = noteOffEvents[y].tick - noteOnEvents[i].tick;
						noteOffEvents = noteOffEvents[0 .. y] ~ noteOffEvents[y + 1 .. $];
						break;
					}
				}
			}

			chan.notes = noteOnEvents;
			channels ~= chan;
		}

		foreach(ubyte i, Channel chan; channels) {
			chan.id = i;
			chan.setInterval(minNote, maxNote);
		}

		title = new Title(baseName(filePath, ".mid"));

		//MidiEvent lastEvent = sequencerEvents[$ - 1];
		//lastTickOfMidi = lastEvent.tick;

		isLoaded = true;
	}
}