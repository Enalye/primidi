module primidi.config;

import std.file, std.path;
import atelier, minuit;
import primidi.player, primidi.midi, primidi.locale;

private enum _configFilePath = "config.json";

void loadConfig() {
    if(!exists(_configFilePath))
        return;
    JSONValue json = parseJSON(readText(_configFilePath));
    string inputName = getJsonStr(json, "input");
    string outputName = getJsonStr(json, "output");
    string scriptPath = absolutePath(buildNormalizedPath(getJsonStr(json, "script")));
    string localePath = absolutePath(buildNormalizedPath(getJsonStr(json, "locale")));
    
    selectMidiInDevice(mnFetchInput(inputName));
    selectMidiOutDevice(mnFetchOutput(outputName));
    loadScript(scriptPath);
    setLocale(localePath);
}

void saveConfig() {
    JSONValue json;
    auto midiIn = getMidiIn();
    auto midiOut = getMidiOut();
    if(midiIn && midiIn.port)
        json["input"] = midiIn.port.name;
    if(midiOut && midiOut.port)
        json["output"] = midiOut.port.name;
    json["script"] = relativePath(buildNormalizedPath((getScriptFilePath())));
    json["locale"] = relativePath(buildNormalizedPath(getLocale()));

    std.file.write(_configFilePath, toJSON(json, true));
}