module primidi.script.midi;

import std.conv;
import grimoire, atelier;
import primidi.midi;

void loadMidiDefinitions() {
    auto defVec2 = grGetStructureType("Vec2f");

    auto grNote = grAddUserType("Note");
    grAddPrimitive(&seq_getTick, "seq_getTick", [], [], grInt);
    grAddPrimitive(&note_getTick, "note_getTick", ["note"], [grNote], grInt);
    grAddPrimitive(&note_getPitch, "note_getPitch", ["note"], [grNote], grInt);
    grAddPrimitive(&note_getStep, "note_getStep", ["note"], [grNote], grInt);
    grAddPrimitive(&note_getVelocity, "note_getVelocity", ["note"], [grNote], grInt);
    grAddPrimitive(&note_getFactor, "note_getFactor", ["note"], [grNote], grFloat);
}

private void seq_getTick(GrCall call) {
    call.setInt(to!int(getInternalSequencerTick()));//Fix NaN on startup
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

private void note_getFactor(GrCall call) {
    auto note = call.getUserData!Note("note");
    call.setFloat(note.factor);
}