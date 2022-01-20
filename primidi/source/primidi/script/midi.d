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
    library.addPrimitive(&clock_getTime, "getTime", [], [grReal]);
    library.addPrimitive(&seq_getTick, "getTick", [], [grInt]);
    library.addPrimitive(&seq_setInterval, "setInterval", [grInt]);
    library.addPrimitive(&seq_setHitRatio, "setRatio", [grReal]);
    library.addPrimitive(&seq_getHitRatio, "getRatio", [], [grReal]);
    library.addPrimitive(&seq_getMidiName, "getMidiName", [], [grString]);
    library.addPrimitive(&seq_isMidiPlaying, "isMidiPlaying", [], [grBool]);
    library.addPrimitive(&seq_getMidiDuration, "getMidiDuration", [], [grReal]);
    library.addPrimitive(&seq_getMidiTime, "getMidiTime", [], [grReal]);
    library.addPrimitive(&seq_getMinPitch, "getMinPitch", [], [grInt]);
    library.addPrimitive(&seq_getMaxPitch, "getMaxPitch", [], [grInt]);

    library.addPrimitive(&bar_getTick, "getTick", [barType], [grInt]);
    library.addPrimitive(&bar_getStep, "getStep", [barType], [grInt]);
    library.addPrimitive(&bar_getCount, "getCount", [barType], [grInt]);
    library.addPrimitive(&bar_getPlayTime, "getPlayTime", [barType], [grReal]);
    library.addPrimitive(&bar_getTime, "getTime", [barType], [grReal]);
    library.addPrimitive(&bar_getDuration, "getDuration", [barType], [grReal]);

    library.addPrimitive(&bar_isPlaying, "isPlaying", [barType], [grBool]);
    library.addPrimitive(&bar_isAlive, "isAlive", [barType], [grBool]);

    library.addPrimitive(&note_getChannel, "getChannel", [noteType], [grInt]);
    library.addPrimitive(&note_getTick, "getTick", [noteType], [grInt]);
    library.addPrimitive(&note_getPitch, "getPitch", [noteType], [grInt]);
    library.addPrimitive(&note_getStep, "getStep", [noteType], [grInt]);
    library.addPrimitive(&note_getVelocity, "getVelocity", [noteType], [grInt]);
    library.addPrimitive(&note_getPlayTime, "getPlayTime", [noteType], [grReal]);
    library.addPrimitive(&note_getTime, "getTime", [noteType], [grReal]);
    library.addPrimitive(&note_getDuration, "getDuration", [noteType], [grReal]);

    library.addPrimitive(&note_isPlaying, "isPlaying", [noteType], [grBool]);
    library.addPrimitive(&note_isAlive, "isAlive", [noteType], [grBool]);

    library.addPrimitive(&chan_getPitchBend, "getPitchBend", [grInt], [grReal]);
}

private void clock_getTime(GrCall call) {
    call.setReal(getMidiTime() / 1_000f);
}

private void seq_getTick(GrCall call) {
    call.setInt(to!int(getInternalSequencerTick())); //Fix NaN on startup
}

private void seq_setInterval(GrCall call) {
    setInternalSequencerInterval(cast(int) call.getInt(0));
}

private void seq_setHitRatio(GrCall call) {
    setInternalSequencerHitRatio(call.getReal(0));
}

private void seq_getHitRatio(GrCall call) {
    call.setReal(getInternalSequencerHitRatio());
}

private void seq_getMidiName(GrCall call) {
    call.setString(baseName(stripExtension(getMidiFilePath())));
}

private void seq_isMidiPlaying(GrCall call) {
    call.setBool(isMidiPlaying());
}

private void seq_getMidiDuration(GrCall call) {
    call.setReal(getMidiDuration());
}

private void seq_getMidiTime(GrCall call) {
    call.setReal(getMidiTime());
}

private void seq_getMinPitch(GrCall call) {
    call.setInt(getMinPitch());
}

private void seq_getMaxPitch(GrCall call) {
    call.setInt(getMaxPitch());
}

// Bar
private void bar_getTick(GrCall call) {
    Bar bar = call.getForeign!Bar(0);
    if (!bar) {
        call.raise("Null parameter");
        return;
    }
    call.setInt(bar.tick);
}

private void bar_getStep(GrCall call) {
    Bar bar = call.getForeign!Bar(0);
    if (!bar) {
        call.raise("Null parameter");
        return;
    }
    call.setInt(bar.step);
}

private void bar_getCount(GrCall call) {
    Bar bar = call.getForeign!Bar(0);
    if (!bar) {
        call.raise("Null parameter");
        return;
    }
    call.setInt(bar.count);
}

private void bar_getPlayTime(GrCall call) {
    Bar bar = call.getForeign!Bar(0);
    if (!bar) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(bar.playTime);
}

private void bar_getTime(GrCall call) {
    Bar bar = call.getForeign!Bar(0);
    if (!bar) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(bar.time);
}

private void bar_getDuration(GrCall call) {
    Bar bar = call.getForeign!Bar(0);
    if (!bar) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(bar.duration);
}

private void bar_isAlive(GrCall call) {
    Bar bar = call.getForeign!Bar(0);
    if (!bar) {
        call.raise("Null parameter");
        return;
    }
    call.setBool(bar.isAlive);
}

private void bar_isPlaying(GrCall call) {
    Bar bar = call.getForeign!Bar(0);
    if (!bar) {
        call.raise("Null parameter");
        return;
    }
    call.setBool(bar.playTime >= 0f && bar.playTime <= 1f);
}

// Note
private void note_getChannel(GrCall call) {
    Note note = call.getForeign!Note(0);
    if (!note) {
        call.raise("Null parameter");
        return;
    }
    call.setInt(note.channel);
}

private void note_getPitch(GrCall call) {
    Note note = call.getForeign!Note(0);
    if (!note) {
        call.raise("Null parameter");
        return;
    }
    call.setInt(note.note);
}

private void note_getTick(GrCall call) {
    Note note = call.getForeign!Note(0);
    if (!note) {
        call.raise("Null parameter");
        return;
    }
    call.setInt(note.tick);
}

private void note_getStep(GrCall call) {
    Note note = call.getForeign!Note(0);
    if (!note) {
        call.raise("Null parameter");
        return;
    }
    call.setInt(note.step);
}

private void note_getVelocity(GrCall call) {
    Note note = call.getForeign!Note(0);
    if (!note) {
        call.raise("Null parameter");
        return;
    }
    call.setInt(note.velocity);
}

private void note_getPlayTime(GrCall call) {
    Note note = call.getForeign!Note(0);
    if (!note) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(note.playTime);
}

private void note_getTime(GrCall call) {
    Note note = call.getForeign!Note(0);
    if (!note) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(note.time);
}

private void note_getDuration(GrCall call) {
    Note note = call.getForeign!Note(0);
    if (!note) {
        call.raise("Null parameter");
        return;
    }
    call.setReal(note.duration);
}

private void note_isAlive(GrCall call) {
    Note note = call.getForeign!Note(0);
    if (!note) {
        call.raise("Null parameter");
        return;
    }
    call.setBool(note.isAlive);
}

private void note_isPlaying(GrCall call) {
    Note note = call.getForeign!Note(0);
    if (!note) {
        call.raise("Null parameter");
        return;
    }
    call.setBool(note.playTime >= 0f && note.playTime <= 1f);
}

private void chan_getPitchBend(GrCall call) {
    GrInt chan = call.getInt(0);
    if (chan >= 16 || chan < 0) {
        call.raise("Channel index out of bounds");
        return;
    }
    call.setReal(getPitchBend(cast(ubyte) chan));
}
