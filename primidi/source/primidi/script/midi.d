/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.midi;

import std.conv, std.path;
import grimoire, atelier;
import primidi.midi, primidi.player;

package void loadMidi(GrData data) {
    auto grNote = data.addForeign("Note");
    data.addPrimitive(&clock_getTime, "getTime", [], [], [grFloat]);
    data.addPrimitive(&seq_getTick, "getTick", [], [], [grInt]);
    data.addPrimitive(&seq_setInterval, "setInterval", ["size"], [grInt]);
    data.addPrimitive(&seq_setHitRatio, "setRatio", ["ratio"], [grFloat]);
    data.addPrimitive(&seq_getHitRatio, "getRatio", [], [], [grFloat]);
    data.addPrimitive(&seq_getMidiName, "getMidiName", [], [], [grString]);
    data.addPrimitive(&seq_isMidiPlaying, "isMidiPlaying", [], [], [grBool]);
    data.addPrimitive(&seq_getMidiDuration, "getMidiDuration", [], [], [grFloat]);
    data.addPrimitive(&seq_getMidiTime, "getMidiTime", [], [], [grFloat]);

    data.addPrimitive(&note_getChannel, "getChannel", ["note"], [grNote], [grInt]);
    data.addPrimitive(&note_getTick, "getTick", ["note"], [grNote], [grInt]);
    data.addPrimitive(&note_getPitch, "getPitch", ["note"], [grNote], [grInt]);
    data.addPrimitive(&note_getStep, "getStep", ["note"], [grNote], [grInt]);
    data.addPrimitive(&note_getVelocity, "getVelocity", ["note"], [grNote], [grInt]);
    data.addPrimitive(&note_getPlayTime, "getPlayTime", ["note"], [grNote], [grFloat]);
    data.addPrimitive(&note_getTime, "getTime", ["note"], [grNote], [grFloat]);
    data.addPrimitive(&note_getDuration, "getDuration", ["note"], [grNote], [grFloat]);

    data.addPrimitive(&note_isPlaying, "isPlaying", ["note"], [grNote], [grBool]);
    data.addPrimitive(&note_isAlive, "isAlive", ["note"], [grNote], [grBool]);


    data.addPrimitive(&chan_getPitchBend, "getPitchBend", ["chan"], [grInt], [grFloat]);
}

private void clock_getTime(GrCall call) {
    call.setFloat(getMidiTime() / 1_000f);
}

private void seq_getTick(GrCall call) {
    call.setInt(to!int(getInternalSequencerTick()));//Fix NaN on startup
}

private void seq_setInterval(GrCall call) {
    setInternalSequencerInterval(call.getInt("size"));
}

private void seq_setHitRatio(GrCall call) {
    setInternalSequencerHitRatio(call.getFloat("ratio"));
}

private void seq_getHitRatio(GrCall call) {
    call.setFloat(getInternalSequencerHitRatio());
}

private void seq_getMidiName(GrCall call) {
    call.setString(to!dstring(baseName(stripExtension(getMidiFilePath()))));
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

private void note_getChannel(GrCall call) {
    auto note = call.getUserData!Note("note");
    call.setInt(note.channel);
}

private void note_getPitch(GrCall call) {
    auto note = call.getUserData!Note("note");
    call.setInt(note.note);
}

private void note_getTick(GrCall call) {
    auto note = call.getUserData!Note("note");
    call.setInt(note.tick);
}

private void note_getStep(GrCall call) {
    auto note = call.getUserData!Note("note");
    call.setInt(note.step);
}

private void note_getVelocity(GrCall call) {
    auto note = call.getUserData!Note("note");
    call.setInt(note.velocity);
}

private void note_getPlayTime(GrCall call) {
    auto note = call.getUserData!Note("note");
    call.setFloat(note.playTime);
}

private void note_getTime(GrCall call) {
    auto note = call.getUserData!Note("note");
    call.setFloat(note.time);
}

private void note_getDuration(GrCall call) {
    auto note = call.getUserData!Note("note");
    call.setFloat(note.duration);
}


private void note_isAlive(GrCall call) {
    auto note = call.getUserData!Note("note");
    call.setBool(note.isAlive);
}

private void note_isPlaying(GrCall call) {
    auto note = call.getUserData!Note("note");
    call.setBool(note.playTime >= 0f && note.playTime <= 1f);
}

private void chan_getPitchBend(GrCall call) {
    auto chan = call.getInt("chan");
    if(chan >= 16 || chan < 0) {
        call.raise("Channel index out of bounds");
        return;
    }
    call.setFloat(getPitchBend(cast(ubyte) chan));
}