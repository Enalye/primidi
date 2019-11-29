/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.midi;

import std.conv;
import grimoire, atelier;
import primidi.midi;

package void loadMidi(GrData data) {
    auto grNote = data.addUserType("Note");
    data.addPrimitive(&clock_getTime, "getTime", [], [], [grFloat]);
    data.addPrimitive(&seq_getTick, "getTick", [], [], [grInt]);
    data.addPrimitive(&seq_setInterval, "setInterval", ["start", "end"], [grInt, grInt]);

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
}

private void clock_getTime(GrCall call) {
    call.setFloat(getMidiTime() / 1_000f);
}

private void seq_getTick(GrCall call) {
    call.setInt(to!int(getInternalSequencerTick()));//Fix NaN on startup
}

private void seq_setInterval(GrCall call) {
    setInternalSequencerInterval(call.getInt("start"), call.getInt("end"));
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