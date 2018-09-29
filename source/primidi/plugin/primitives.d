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

module primidi.plugin.primitives;

import std.conv: to;

import atelier;
import grimoire;

import primidi.plugin.plugin;
import primidi.workstation.common.all;

private {
    Plugin _plugin; //Current plugin being run
}

void setCurrentPlugin(Plugin plugin) {
    _plugin = plugin;
}

void loadPluginPrimitives() {
    grType_addPrimitive(&getFloat, "getFloat", grFloat, [grString]);
    grType_addPrimitive(&getBool, "getBool", grBool, [grString]);
    grType_addPrimitive(&midi_getTick, "midi_getTick", grFloat, []);
    grType_addPrimitive(&chan_getCount, "chan_getCount", grInt, [grInt]);
    grType_addPrimitive(&note_getTick, "note_getTick", grInt, [grInt, grInt]);
    grType_addPrimitive(&note_getPitch, "note_getPitch", grInt, [grInt, grInt]);
    grType_addPrimitive(&note_getStep, "note_getStep", grInt, [grInt, grInt]);
    grType_addPrimitive(&note_getVelocity, "note_getVelocity", grInt, [grInt, grInt]);
    grType_addPrimitive(&note_getFactor, "note_getFactor", grFloat, [grInt, grInt]);
    grType_addPrimitive(&render_rect, "render_rect", grVoid, [grInt, grInt, grInt, grInt]);

}

void getFloat(GrCoroutine coro) {
    coro.fstack ~= _plugin.getFloat(coro.sstack[$ - 1]);
    coro.sstack.length --;
}

void getBool(GrCoroutine coro) {
    coro.istack ~= _plugin.getBool(coro.sstack[$ - 1]);
    coro.sstack.length --;
}

void midi_getTick(GrCoroutine coro) {
    coro.fstack ~= getInternalSequencerTick();//Fix NaN on startup
}
/+
void createNote(GrCoroutine coro) {
    Object obj;
    obj.id = getObjectId("note");
    obj.value 
    coro.ostack ~= new  
}+/

void chan_getCount(GrCoroutine coro) {
    auto chanId = coro.istack[$ - 1];
    coro.istack[$ - 1] = cast(int)(sequencerNotes[chanId].length);
}

void note_getPitch(GrCoroutine coro) {
    auto chanId = coro.istack[$ - 2];
    auto noteId = coro.istack[$ - 1];
    coro.istack[$ - 2] = sequencerNotes[chanId][noteId].note;
    coro.istack.length --;
}

void note_getTick(GrCoroutine coro) {
    auto chanId = coro.istack[$ - 2];
    auto noteId = coro.istack[$ - 1];
    coro.istack[$ - 2] = sequencerNotes[chanId][noteId].tick;
    coro.istack.length --;
}

void note_getStep(GrCoroutine coro) {
    auto chanId = coro.istack[$ - 2];
    auto noteId = coro.istack[$ - 1];
    coro.istack[$ - 2] = sequencerNotes[chanId][noteId].step;
    coro.istack.length --;
}

void note_getVelocity(GrCoroutine coro) {
    auto chanId = coro.istack[$ - 2];
    auto noteId = coro.istack[$ - 1];
    coro.istack[$ - 2] = sequencerNotes[chanId][noteId].velocity;
    coro.istack.length --;
}

void note_getFactor(GrCoroutine coro) {
    auto chanId = coro.istack[$ - 2];
    auto noteId = coro.istack[$ - 1];
    coro.istack.length -= 2;
    coro.fstack ~= sequencerNotes[chanId][noteId].factor;
}


//Render
void render_rect(GrCoroutine coro) {
    Vec2f pos = Vec2f(coro.fstack[$ - 4], coro.fstack[$ - 3]);
    Vec2f size = Vec2f(coro.fstack[$ - 2], coro.fstack[$ - 1]);

    drawFilledRect(pos, size, Color.red);
}