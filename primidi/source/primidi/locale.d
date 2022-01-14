/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.locale;

import std.file, std.path;
import atelier;

private {
    string _localeFilePath, _localeKey;
    string[string] _localizations;
}

string getLocale() {
    return _localeFilePath;   
}

string getLocaleKey() {
    return _localeKey;   
}

void setLocale(string filePath) {
    if(!exists(filePath))
        return;
    _localeFilePath = filePath;
    _localeKey = baseName(stripExtension(filePath));

    JSONValue json = parseJSON(readText(_localeFilePath));
    foreach(string key, JSONValue value; json) {
        _localizations[key] = value.str;
    }

    sendCustomEvent("locale");

    import primidi.config: saveConfig;
    saveConfig();
}

string getLocalizedText(string key) {
    auto value = key in _localizations;
    if(value is null)
        return key;
    return *value;
}