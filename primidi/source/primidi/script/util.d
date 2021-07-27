/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.util;

import std.conv : to;
import std.file, std.path;
import atelier;
import primidi.midi;

private {
    Font _scriptFont;
    Color _scriptColor;
    float _scriptAlpha;
}

/// Called after each script load.
void initScriptState() {
    _scriptFont = getDefaultFont();
    _scriptColor = Color.white;
    _scriptAlpha = 1f;
}

/// Construct a path relative to the base script file path.
string getResourcePath(string path) {
    return buildNormalizedPath(buildPath(dirName(getScriptFilePath()), path));
}

/// Ditto
string getResourcePath(dstring path) {
    return buildNormalizedPath(buildPath(dirName(getScriptFilePath()), to!string(path)));
}

void setScriptFont(Font font) {
    if (!font) {
        _scriptFont = getDefaultFont();
        return;
    }
    _scriptFont = font;
}

Font getScriptFont() {
    if(!_scriptFont) {
        _scriptFont = getDefaultFont();
    }
    return _scriptFont;
}

void setScriptColor(Color color) {
    _scriptColor = color;
}

Color getScriptColor() {
    return _scriptColor;
}

void setScriptAlpha(float alpha) {
    _scriptAlpha = alpha;
}

float getScriptAlpha() {
    return _scriptAlpha;
}