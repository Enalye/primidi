module primidi.common.resource;

import std.typecons;
import std.file;
import std.path;
import std.algorithm: count;
import std.conv: to;

import primidi.core.util;
import primidi.core.json;
import primidi.core.vec2;
import primidi.render.all;

import primidi.common.settings;

private {
	ResourceCache!Texture _cacheTexture;
	ResourceCache!Font _cacheFont;
	ResourceCache!Sprite _cacheSprite;
	ResourceCache!Tileset _cacheTileset;

	string _subFolderTexture,
		_subFolderFont,
		_subFolderSprite,
		_subFolderTileset;
}

private template NameBuilder(string type) {
	const char[] NameBuilder = "_cache" ~ type;
}

private template SubFolderBuilder(string type) {
	const char[] SubFolderBuilder = "_subFolder" ~ type;
}

void loadResources(string path) {
	//Path to data.
	path = buildNormalizedPath(absolutePath(path));
	_cacheTexture = new DataCache!Texture(path, _subFolderTexture, "*.{png,bmp,jpg}");
	_cacheFont = new DataCache!Font(path, _subFolderFont, "*.{ttf}");
	_cacheSprite = new SpriteCache!Sprite(path, _subFolderSprite, "*.{sprite}", _cacheTexture);
	_cacheTileset = new TilesetCache!Tileset(path, _subFolderTileset, "*.{tileset}", _cacheTexture);
}

void setResourceLocation(T)(string name) {
	mixin(SubFolderBuilder!(T.stringof)) = name;
}

bool canFetch(T)(string name) {
	return (mixin(NameBuilder!(T.stringof))).canGet(name);
}

bool canFetchPack(T)(string name = ".") {
	return (mixin(NameBuilder!(T.stringof))).canGetPack(name);
}

T fetch(T)(string name) {
	return (mixin(NameBuilder!(T.stringof))).get(name);
}

T[] fetchPack(T)(string name = ".") {
	return mixin(NameBuilder!(T.stringof)).getPack(name);
}

string[] fetchPackNames(T)(string name = ".") {
	return mixin(NameBuilder!(T.stringof)).getPackNames(name);
}

Tuple!(T, string)[] fetchPackTuples(T)(string name = ".") {
	return mixin(NameBuilder!(T.stringof)).getPackTuples(name);
}

private class ResourceCache(T) {
	protected {
		Tuple!(T, string)[] _data;
		uint[string] _ids;
		uint[][string] _packs;
	}

	protected this() {}

	bool canGet(string name) {
		return (buildNormalizedPath(name) in _ids) !is null;
	}

	bool canGetPack(string pack = ".") {
		return (buildNormalizedPath(pack) in _packs) !is null;
	}

	T get(string name) {
		name = buildNormalizedPath(name);

		auto p = (name in _ids);
		if(p is null)
			throw new Exception("Resource: no \'" ~ name ~ "\' loaded");
		return _data[*p][0];
	}

	T[] getPack(string pack = ".") {
		pack = buildNormalizedPath(pack);

		auto p = (pack in _packs);
		if(p is null)
			throw new Exception("Resource: no pack \'" ~ pack ~ "\' loaded");

		T[] result;
		foreach(i; *p)
			result ~= _data[i][0];
		return result;
	}

	string[] getPackNames(string pack = ".") {
		pack = buildNormalizedPath(pack);

		auto p = (pack in _packs);
		if(p is null)
			throw new Exception("Resource: no pack \'" ~ pack ~ "\' loaded");

		string[] result;
		foreach(i; *p)
			result ~= _data[i][1];
		return result;
	}

	Tuple!(T, string)[] getPackTuples(string pack = ".") {
		pack = buildNormalizedPath(pack);

		auto p = (pack in _packs);
		if(p is null)
			throw new Exception("Resource: no pack \'" ~ pack ~ "\' loaded");

		Tuple!(T, string)[] result;
		foreach(i; *p)
			result ~= _data[i];
		return result;
	}
}

private class DataCache(T): ResourceCache!T {
	this(string path, string sub, string filter) {
		path = buildPath(path, sub);

		if(!isDir(path) || !exists(path))
			throw new Exception("The specified path is not a valid directory");
		auto files = dirEntries(path, filter, SpanMode.depth);
		foreach(file; files) {
			string relativeFileName = stripExtension(relativePath(file, path));
			string folder = dirName(relativeFileName);
			uint id = cast(uint)_data.length;
			_packs[folder] ~= id;
			_ids[relativeFileName] = id;
			_data ~= tuple(new T(file), relativeFileName);
		}
	}
}

private class SpriteCache(T): ResourceCache!T {
	this(string path, string sub, string filter, ResourceCache!Texture cache) {
		path = buildPath(path, sub);

		if(!isDir(path) || !exists(path))
			throw new Exception("The specified path is not a valid directory");
		auto files = dirEntries(path, filter, SpanMode.depth);
		foreach(file; files) {
			string relativeFileName = stripExtension(relativePath(file, path));
			string folder = dirName(relativeFileName);

			auto texture = cache.get(relativeFileName);
			loadJson(file, texture);
		}
	}

	private void loadJson(string file, Texture texture) {
		auto sheetJson = parseJSON(readText(file));
		foreach(string tag, JSONValue value; sheetJson.object) {
			if((tag in _ids) !is null)
				throw new Exception("Duplicate sprite defined \'" ~ tag ~ "\' in \'" ~ file ~ "\'");
			T sprite = new T(texture);

			//Clip
			sprite.clip.x = getJsonInt(value, "x");
			sprite.clip.y = getJsonInt(value, "y");
			sprite.clip.z = getJsonInt(value, "w");
			sprite.clip.w = getJsonInt(value, "h");

			//Size/scale
			sprite.size = to!Vec2f(sprite.clip.zw);
			sprite.size *= Vec2f(getJsonFloat(value, "scalex", 1f), getJsonFloat(value, "scaley", 1f));
			
			//Flip
			bool flipH = getJsonBool(value, "fliph", false);
			bool flipV = getJsonBool(value, "flipv", false);

			if(flipH && flipV)
				sprite.flip = Flip.BothFlip;
			else if(flipH)
				sprite.flip = Flip.HorizontalFlip;
			else if(flipV)
				sprite.flip = Flip.VerticalFlip;
			else
				sprite.flip = Flip.NoFlip;

			//Center expressed in texels, it does the same thing as Anchor
			Vec2f center = Vec2f(getJsonFloat(value, "centerx", -1f), getJsonFloat(value, "centery", -1f));
			if(center.x > -.5f) //Temp
				sprite.anchor.x = center.x / cast(float)(sprite.clip.z);
			if(center.y > -.5f)
				sprite.anchor.y = center.y / cast(float)(sprite.clip.w);

			//Anchor, same as Center but uses a relative coordinate system where [.5,.5] is the center
			if(center.x < 0f) //Temp
				sprite.anchor.x = getJsonFloat(value, "anchorx", .5f);
			if(center.y < 0f)
				sprite.anchor.y = getJsonFloat(value, "anchory", .5f);

			//Type
			string type = getJsonStr(value, "type", ".");

			//Register sprite
			uint id = cast(uint)_data.length;
			_packs[type] ~= id;
			_ids[tag] = id;
			_data ~= tuple(sprite, tag);
		}
	}
}

private class TilesetCache(T): ResourceCache!T {
	this(string path, string sub, string filter, ResourceCache!Texture cache) {
		path = buildPath(path, sub);

		if(!isDir(path) || !exists(path))
			throw new Exception("The specified path is not a valid directory");
		auto files = dirEntries(path, filter, SpanMode.depth);
		foreach(file; files) {
			string relativeFileName = stripExtension(relativePath(file, path));
			string folder = dirName(relativeFileName);

			auto texture = cache.get(relativeFileName);
			loadJson(relativeFileName, file, texture);
		}
	}

	private void loadJson(string tag, string file, Texture texture) {
		auto json = parseJSON(readText(file));

		Vec2i grid, tileSize;

		auto tileObject = json.object["tile"];
		tileSize.x = getJsonInt(tileObject, "w");
		tileSize.y = getJsonInt(tileObject, "h");

		grid.x = getJsonInt(json, "columns", 1);
		grid.y = getJsonInt(json, "lines", 1);

		string type = getJsonStr(json, "type", ".");

		T tileset = new T(texture, grid, tileSize);
		tileset.scale = Vec2f(getJsonFloat(json, "scalex", 1f), getJsonFloat(json, "scaley", 1f));

		uint id = cast(uint)_data.length;
		_packs[type] ~= id;
		_ids[tag] = id;
		_data ~= tuple(tileset, tag);
	}
}