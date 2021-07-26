/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.config;

import std.file, std.path;
import atelier, minuit;
import primidi.player, primidi.midi, primidi.locale;

private {
    bool _isConfigFilePathConfigured;
    string _configFilePath = "config.json";
    string _pluginFilePath;
    bool _isDevMode = true;
}

bool isDevMode() {
    return _isDevMode;
}

string getBasePath() {
    if(_isDevMode) {
        return getcwd();
    }
    else {
        return dirName(thisExePath());
    }
}

void loadConfig() {
    if(!_isConfigFilePathConfigured) {
        _isConfigFilePathConfigured = true;
        _configFilePath = buildNormalizedPath(getBasePath(), _configFilePath);
    }
    if(!exists(_configFilePath)) {
        saveConfig();
        if(!exists(_configFilePath))
            return;
    }
    JSONValue json = parseJSON(readText(_configFilePath));
    string inputName = getJsonStr(json, "input", "");
    string outputName = getJsonStr(json, "output", "");
    string pluginPath = buildNormalizedPath(absolutePath(getJsonStr(json, "plugin", ""), getBasePath()));
    string localePath = buildNormalizedPath(absolutePath(getJsonStr(json, "locale", ""), getBasePath()));
    selectMidiInDevice(mnFetchInput(inputName));
    selectMidiOutDevice(mnFetchOutput(outputName));
    if(exists(pluginPath)) {
        loadPlugin(pluginPath);
    }
    setLocale(localePath);
}

private bool loadPlugin(string pluginPath) {
    JSONValue json = parseJSON(readText(pluginPath));
    string scriptPath = buildNormalizedPath(absolutePath(getJsonStr(json, "script", ""), dirName(pluginPath)));
    if(!exists(scriptPath))
        return false;
    _pluginFilePath = pluginPath;
    loadScript(scriptPath);
    return true;
}

void setPlugin(string pluginPath) {
    if(loadPlugin(pluginPath))
        saveConfig();
}

string getPluginPath() {
    return _pluginFilePath;
}

void saveConfig() {
    JSONValue json;
    auto midiIn = getMidiIn();
    auto midiOut = getMidiOut();
    json["input"] = (midiIn && midiIn.port) ? midiIn.port.name : "";
    json["output"] = (midiOut && midiOut.port) ? midiOut.port.name : "";
    json["plugin"] = relativePath(buildNormalizedPath(_pluginFilePath), getBasePath());
    json["locale"] = (getLocale().length && exists(getLocale())) ?
        relativePath(buildNormalizedPath(getLocale()), getBasePath()) :
        buildNormalizedPath("data", "locale", "en.json");

    std.file.write(_configFilePath, toJSON(json, true));
}