/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.midi;

import std.conv, std.path;
import grimoire, atelier;
import primidi.midi, primidi.player;

package void loadMidiLibrary(GrLibrary library) {
    auto barType = library.addForeign("Bar");
    auto noteType = library.addForeign("Note");
    library.addPrimitive(&clock_getTime, "getTime", [], [grFloat]);
    library.addPrimitive(&seq_getTick, "getTick", [], [grInt]);
    library.addPrimitive(&seq_setInterval, "setInterval", [grInt]);
    library.addPrimitive(&seq_setHitRatio, "setRatio", [grFloat]);
    library.addPrimitive(&seq_getHitRatio, "getRatio", [], [grFloat]);
    library.addPrimitive(&seq_getMidiName, "getMidiName", [], [grString]);
    library.addPrimitive(&seq_isMidiPlaying, "isMidiPlaying", [], [grBool]);
    library.addPrimitive(&seq_getMidiDuration, "getMidiDuration", [], [grFloat]);
    library.addPrimitive(&seq_getMidiTime, "getMidiTime", [], [grFloat]);
    
    library.addPrimitive(&bar_getTick, "getTick", [barType], [grInt]);
    library.addPrimitive(&bar_getStep, "getStep", [barType], [grInt]);
    library.addPrimitive(&bar_getCount, "getCount", [barType], [grInt]);
    library.addPrimitive(&bar_getPlayTime, "getPlayTime", [barType], [grFloat]);
    library.addPrimitive(&bar_getTime, "getTime", [barType], [grFloat]);
    library.addPrimitive(&bar_getDuration, "getDuration", [barType], [grFloat]);

    library.addPrimitive(&bar_isPlaying, "isPlaying", [barType], [grBool]);
    library.addPrimitive(&bar_isAlive, "isAlive", [barType], [grBool]);

    library.addPrimitive(&note_getChannel, "getChannel", [noteType], [grInt]);
    library.addPrimitive(&note_getTick, "getTick", [noteType], [grInt]);
    library.addPrimitive(&note_getPitch, "getPitch", [noteType], [grInt]);
    library.addPrimitive(&note_getStep, "getStep", [noteType], [grInt]);
    library.addPrimitive(&note_getVelocity, "getVelocity", [noteType], [grInt]);
    library.addPrimitive(&note_getPlayTime, "getPlayTime", [noteType], [grFloat]);
    library.addPrimitive(&note_getTime, "getTime", [noteType], [grFloat]);
    library.addPrimitive(&note_getDuration, "getDuration", [noteType], [grFloat]);

    library.addPrimitive(&note_isPlaying, "isPlaying", [noteType], [grBool]);
    library.addPrimitive(&note_isAlive, "isAlive", [noteType], [grBool]);

    library.addPrimitive(&chan_getPitchBend, "getPitchBend", [grInt], [grFloat]);
}

private void clock_getTime(GrCall call) {
    call.setFloat(getMidiTime() / 1_000f);
}

private void seq_getTick(GrCall call) {
    call.setInt(to!int(getInternalSequencerTick())); //Fix NaN on startup
}

private void seq_setInterval(GrCall call) {
    setInternalSequencerInterval(cast(int) call.getInt(0));
}

private void seq_setHitRatio(GrCall call) {
    setInternalSequencerHitRatio(call.getFloat(0));
}

private void seq_getHitRatio(GrCall call) {
    call.setFloat(getInternalSequencerHitRatio());
}

private void seq_getMidiName(GrCall call) {
    call.setString(baseName(stripExtension(getMidiFilePath())));
}

private void seq_isMidiPlaying(GrCall call) {
    call.setBool(isMidiPlaying());
}

private void seq_getMidiDuration(GrCall call) {
    call.setFloat(getMidiDuration());
}

private void seq_getMidiTime(GrCall call) {
    call.setFloat(getMidiTime());
}

// Bar
private void bar_getTick(GrCall call) {
    auto bar = call.getForeign!Bar(0);
    call.setInt(bar.tick);
}

private void bar_getStep(GrCall call) {
    auto bar = call.getForeign!Bar(0);
    call.setInt(bar.step);
}

private void bar_getCount(GrCall call) {
    auto bar = call.getForeign!Bar(0);
    call.setInt(bar.count);
}

private void bar_getPlayTime(GrCall call) {
    auto bar = call.getForeign!Bar(0);
    call.setFloat(bar.playTime);
}

private void bar_getTime(GrCall call) {
    auto bar = call.getForeign!Bar(0);
    call.setFloat(bar.time);
}

private void bar_getDuration(GrCall call) {
    auto bar = call.getForeign!Bar(0);
    call.setFloat(bar.duration);
}

private void bar_isAlive(GrCall call) {
    auto bar = call.getForeign!Bar(0);
    call.setBool(bar.isAlive);
}

private void bar_isPlaying(GrCall call) {
    auto bar = call.getForeign!Bar(0);
    call.setBool(bar.playTime >= 0f && bar.playTime <= 1f);
}

// Note
private void note_getChannel(GrCall call) {
    auto note = call.getForeign!Note(0);
    call.setInt(note.channel);
}

private void note_getPitch(GrCall call) {
    auto note = call.getForeign!Note(0);
    call.setInt(note.note);
}

private void note_getTick(GrCall call) {
    auto note = call.getForeign!Note(0);
    call.setInt(note.tick);
}

private void note_getStep(GrCall call) {
    auto note = call.getForeign!Note(0);
    call.setInt(note.step);
}

private void note_getVelocity(GrCall call) {
    auto note = call.getForeign!Note(0);
    call.setInt(note.velocity);
}

private void note_getPlayTime(GrCall call) {
    auto note = call.getForeign!Note(0);
    call.setFloat(note.playTime);
}

private void note_getTime(GrCall call) {
    auto note = call.getForeign!Note(0);
    call.setFloat(note.time);
}

private void note_getDuration(GrCall call) {
    auto note = call.getForeign!Note(0);
    call.setFloat(note.duration);
}

private void note_isAlive(GrCall call) {
    auto note = call.getForeign!Note(0);
    call.setBool(note.isAlive);
}

private void note_isPlaying(GrCall call) {
    auto note = call.getForeign!Note(0);
    call.setBool(note.playTime >= 0f && note.playTime <= 1f);
}

private void chan_getPitchBend(GrCall call) {
    auto chan = call.getInt(0);
    if (chan >= 16 || chan < 0) {
        call.raise("Channel index out of bounds");
        return;
    }
    call.setFloat(getPitchBend(cast(ubyte) chan));
}
