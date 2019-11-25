module primidi.config;

import std.file;
import atelier, minuit;
import primidi.player, primidi.midi;

private enum _configFilePath = "config.json";

void loadConfig() {
    if(!exists(_configFilePath))
        return;
    JSONValue json = parseJSON(readText(_configFilePath));
    string inputName = getJsonStr(json, "input");
    string outputName = getJsonStr(json, "output");
    string scriptPath = getJsonStr(json, "script");
    
    selectMidiInDevice(mnFetchInput(inputName));
    selectMidiOutDevice(mnFetchOutput(outputName));
    loadScript(scriptPath);
}

void saveConfig() {
    JSONValue json;
    auto midiIn = getMidiIn();
    auto midiOut = getMidiOut();
    if(midiIn && midiIn.port)
        json["input"] = midiIn.port.name;
    if(midiOut && midiOut.port)
        json["output"] = midiOut.port.name;
    json["script"] = getScriptFilePath();

    std.file.write(_configFilePath, toJSON(json, true));
}