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
    bool _isLibraryLoaded;
}

void setCurrentPlugin(Plugin plugin) {
    _plugin = plugin;
}

void loadPluginPrimitives() {
    if(_isLibraryLoaded)
        return;
    _isLibraryLoaded = true;
    auto defColor = grAddStructure("Color", ["r", "g", "b", "a"], [grFloat, grFloat, grFloat, grFloat]);
    auto defEvent = grAddStructure("Event", ["type", "value", "tick", "step", "factor"], [grInt, grInt, grInt, grInt, grFloat]);

    auto defVec2 = grGetStructureType("Vec2");

    grAddPrimitive(&getFloat, "getFloat", ["name"], [grString], grFloat);
    grAddPrimitive(&getBool, "getBool", ["name"], [grString], grBool);

    grAddPrimitive(&getEvent, "getEvent", ["channelId", "eventId"], [grInt, grInt], defEvent);

    grAddPrimitive(&seq_getTick, "seq_getTick", [], [], grInt);
    grAddPrimitive(&chan_getCount, "chan_getCount", ["channelId"], [grInt], grInt);
    grAddPrimitive(&note_getTick, "note_getTick", ["channelId", "noteId"], [grInt, grInt], grFloat);
    grAddPrimitive(&note_getPitch, "note_getPitch", ["channelId", "noteId"], [grInt, grInt], grFloat);
    grAddPrimitive(&note_getStep, "note_getStep", ["channelId", "noteId"], [grInt, grInt], grFloat);
    grAddPrimitive(&note_getVelocity, "note_getVelocity", ["channelId", "noteId"], [grInt, grInt], grInt);
    grAddPrimitive(&note_getFactor, "note_getFactor", ["channelId", "noteId"], [grInt, grInt], grFloat);
    grAddPrimitive(&draw_rect, "draw_rect", ["pos", "size"], [defVec2, defVec2]);
}

private void getFloat(GrCall call) {
    call.setFloat(_plugin.getFloat(call.getString("name")));
}

private void getBool(GrCall call) {
    call.setBool(_plugin.getBool(call.getString("name")));    
}

private void getEvent(GrCall call) {
    auto chanId = call.getInt("channelId");
    auto eventId = call.getInt("eventId");
    auto event = sequencerNotes[chanId][eventId];

    call.setInt(0); //Not supported for now
    call.setInt(event.note);
    call.setInt(event.tick);
    call.setInt(event.step);
    call.setFloat(event.factor);
}

private void seq_getTick(GrCall call) {
    call.setInt(to!int(getInternalSequencerTick()));//Fix NaN on startup
}
/+
void createNote(GrCall call) {
    Object obj;
    obj.id = getObjectId("note");
    obj.value 
    call.ostack ~= new  
}+/

private void chan_getCount(GrCall call) {
    auto chanId = call.getInt("channelId");
    call.setInt(cast(int)(sequencerNotes[chanId].length));
}

void note_getPitch(GrCall call) {
    auto chanId = call.getInt("channelId");
    auto noteId = call.getInt("noteId");
    call.setFloat(sequencerNotes[chanId][noteId].note);
}

void note_getTick(GrCall call) {
    auto chanId = call.getInt("channelId");
    auto noteId = call.getInt("noteId");
    call.setFloat(sequencerNotes[chanId][noteId].tick);
}

void note_getStep(GrCall call) {
    auto chanId = call.getInt("channelId");
    auto noteId = call.getInt("noteId");
    call.setFloat(sequencerNotes[chanId][noteId].step);
}

void note_getVelocity(GrCall call) {
    auto chanId = call.getInt("channelId");
    auto noteId = call.getInt("noteId");
    call.setInt(sequencerNotes[chanId][noteId].velocity);
}

void note_getFactor(GrCall call) {
    auto chanId = call.getInt("channelId");
    auto noteId = call.getInt("noteId");
    call.setFloat(sequencerNotes[chanId][noteId].factor);
}

//Render
void draw_rect(GrCall call) {
    Vec2f pos = Vec2f(call.getFloat("pos.x"), call.getFloat("pos.y"));
    Vec2f size = Vec2f(call.getFloat("size.x"), call.getFloat("size.y"));
    drawFilledRect(pos, size, Color.red);
}