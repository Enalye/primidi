module primidi.script.midi;

import std.conv;
import grimoire, atelier;
import primidi.midi;

package void loadMidi() {
    auto defVec2 = grGetStructureType("Vec2f");

    auto grNote = grAddUserType("Note");
    grAddPrimitive(&seq_getTick, "seq_tick", [], [], [grInt]);
    grAddPrimitive(&seq_setInterval, "seq_setInterval", ["start", "end"], [grInt, grInt]);

    grAddPrimitive(&note_getChannel, "note_channel", ["note"], [grNote], [grInt]);
    grAddPrimitive(&note_getTick, "note_tick", ["note"], [grNote], [grInt]);
    grAddPrimitive(&note_getPitch, "note_pitch", ["note"], [grNote], [grInt]);
    grAddPrimitive(&note_getStep, "note_step", ["note"], [grNote], [grInt]);
    grAddPrimitive(&note_getVelocity, "note_velocity", ["note"], [grNote], [grInt]);
    grAddPrimitive(&note_getPlayTime, "note_playTime", ["note"], [grNote], [grFloat]);
    grAddPrimitive(&note_getTime, "note_time", ["note"], [grNote], [grFloat]);
    grAddPrimitive(&note_getDuration, "note_duration", ["note"], [grNote], [grFloat]);

    grAddPrimitive(&note_isPlaying, "note_isPlaying", ["note"], [grNote], [grBool]);
    grAddPrimitive(&note_isAlive, "note_isAlive", ["note"], [grNote], [grBool]);
}
//note_isPlaying() note_isAlive() note_getProgress() note_setTickRange()

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