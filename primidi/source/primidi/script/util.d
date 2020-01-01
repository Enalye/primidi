/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.script.util;

import std.conv: to;
import std.file, std.path;
import primidi.midi;

/// Construct a path relative to the base script file path.
string getResourcePath(string path) {
    return buildNormalizedPath(buildPath(dirName(getScriptFilePath()), path));
}

/// Ditto
string getResourcePath(dstring path) {
    return buildNormalizedPath(buildPath(dirName(getScriptFilePath()), to!string(path)));
}