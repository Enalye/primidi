/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.open_file;

import std.file, std.path, std.string;
import atelier;
import primidi.locale;
import primidi.gui.editable_path, primidi.gui.buttons;

final class OpenModal : GuiElement {
    final class DirListGui : VList {
        private {
            string[] _subDirs;
        }

        this() {
            super(Vec2f(434f, 334f));
            color = Color.white;
            _container.canvas.clearColor = Color.white;
        }

        override void onCallback(string id) {
            super.onCallback(id);
            if (id == "list") {
                triggerCallback();
            }
        }

        void add(string subDir, Color color) {
            auto btn = new DirButton(subDir, color);
            appendChild(btn);
            _subDirs ~= subDir;
        }

        string getSubDir() {
            if (selected() >= _subDirs.length)
                throw new Exception("Subdirectory index out of range");
            return _subDirs[selected()];
        }

        void reset() {
            removeChildren();
            _subDirs.length = 0;
        }
    }

    /// Search field
    final class SearchField : GuiElement {
        private {
            InputField _inputField;
        }

        @property {
            /// Input text
            string text() const {
                return _inputField.text;
            }
        }

        /// Ctor
        this() {
            _inputField = new InputField(Vec2f(200f, 20f));
            _inputField.setCallback(this, "search");
            _inputField.color = Color(20, 20, 20);
            _inputField.font = new TrueTypeFont(veraMonoFontData, 12);
            appendChild(_inputField);
            size = _inputField.size;
        }

        override void onCallback(string id) {
            if (id == "search")
                triggerCallback();
        }

        override void draw() {
            drawFilledRect(origin, size, Color(204, 204, 204));
        }
    }

    private {
        EditablePathGui _pathLabel;
        SearchField _searchField;
        DirListGui _list;
        string _path, _fileName;
        Label _filePathLabel;
        GuiElement _applyBtn;
        string[] _extensionList;
    }

    this(string basePath, string[] extensionList) {
        _extensionList = extensionList;
        if (basePath.length) {
            _path = basePath;
        }
        else {
            _path = getcwd();
        }

        size(Vec2f(500f, 500f));
        setAlign(GuiAlignX.center, GuiAlignY.center);
        isMovable(true);

        { //Title
            auto title = new Label(getLocalizedText("file_to_open") ~ ":");
            title.color = Color.black;
            title.setAlign(GuiAlignX.left, GuiAlignY.top);
            title.position = Vec2f(20f, 10f);
            appendChild(title);
        }

        {
            auto hbox = new HContainer;
            hbox.position = Vec2f(0f, 50f);
            hbox.setAlign(GuiAlignX.center, GuiAlignY.top);
            hbox.spacing = Vec2f(10f, 0f);
            appendChild(hbox);

            _pathLabel = new EditablePathGui(_path);
            _pathLabel.setAlign(GuiAlignX.left, GuiAlignY.top);
            _pathLabel.setCallback(this, "path");
            hbox.appendChild(_pathLabel);

            auto parentBtn = new ParentButton;
            parentBtn.setCallback(this, "parent_folder");
            hbox.appendChild(parentBtn);
        }

        {
            _filePathLabel = new Label(getLocalizedText("file") ~ ": ---");
            _filePathLabel.color = Color.black;
            _filePathLabel.setAlign(GuiAlignX.left, GuiAlignY.bottom);
            _filePathLabel.position = Vec2f(20f, 30f);
            appendChild(_filePathLabel);
        }

        { //Validation
            auto box = new HContainer;
            box.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            box.position = Vec2f(10f, 10f);
            box.spacing = Vec2f(8f, 0f);
            appendChild(box);

            auto applyBtn = new ConfirmationButton(getLocalizedText("open"));
            applyBtn.size = Vec2f(70f, 20f);
            applyBtn.setCallback(this, "apply");
            applyBtn.isLocked = true;
            box.appendChild(applyBtn);
            _applyBtn = applyBtn;

            auto cancelBtn = new ConfirmationButton(getLocalizedText("cancel"));
            cancelBtn.size = Vec2f(70f, 20f);
            cancelBtn.setCallback(this, "cancel");
            box.appendChild(cancelBtn);
        }

        { //Exit
            auto exitBtn = new ExitButton;
            exitBtn.setAlign(GuiAlignX.right, GuiAlignY.top);
            exitBtn.position = Vec2f(10f, 10f);
            exitBtn.setCallback(this, "cancel");
            appendChild(exitBtn);
        }

        {
            _list = new DirListGui;
            _list.setAlign(GuiAlignX.center, GuiAlignY.center);
            _list.setCallback(this, "file");
            appendChild(_list);
        }

        {
            auto hbox = new HContainer;
            hbox.position = Vec2f(33f, 53f);
            hbox.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            hbox.spacing = Vec2f(10f, 0f);
            appendChild(hbox);

            Label label = new Label(getLocalizedText("search") ~ ":");
            label.color = Color.black;
            hbox.appendChild(label);

            _searchField = new SearchField;
            _searchField.setCallback(this, "search");
            hbox.appendChild(_searchField);
        }

        reloadList();

        GuiState hiddenState = {offset: Vec2f(0f, -50f), alpha: 0f};
        addState("hidden", hiddenState);

        GuiState defaultState = {
            time: .5f, easing: getEasingFunction(Ease.sineOut)
        };
        addState("default", defaultState);

        setState("hidden");
        doTransitionState("default");
    }

    string getPath() {
        return buildPath(_path, _fileName);
    }

    override void onCallback(string id) {
        switch (id) {
        case "path":
            if (!exists(_pathLabel.text)) {
                _pathLabel.text = _path;
            }
            else if (isDir(_pathLabel.text)) {
                _path = _pathLabel.text;
                reloadList();
            }
            else {
                _path = dirName(_pathLabel.text);
                _fileName = baseName(_pathLabel.text);
                _filePathLabel.text = getLocalizedText("file") ~ ": " ~ _fileName;
                _applyBtn.isLocked = false;
            }
            break;
        case "search":
            reloadList(false);
            break;
        case "file":
            string path = buildPath(_path, _list.getSubDir());
            if (isDir(path)) {
                _path = path;
                reloadList();
            }
            else {
                _fileName = _list.getSubDir();
                _filePathLabel.text = getLocalizedText("file") ~ ": " ~ _fileName;
                _applyBtn.isLocked = false;
            }
            break;
        case "parent_folder":
            _path = dirName(_path);
            reloadList();
            break;
        case "apply":
            triggerCallback();
            break;
        case "cancel":
            stopModal();
            break;
        default:
            break;
        }
    }

    private enum FileType {
        InvalidType,
        DirectoryType,
        MidiFileType
    }

    /// Discriminate between file types.
    private FileType getFileType(string filePath) {
        import std.algorithm : canFind;

        try {
            if (isDir(filePath))
                return FileType.DirectoryType;
            const string ext = extension(filePath).toLower();
            if (_extensionList.canFind(ext))
                return FileType.MidiFileType;
            return FileType.InvalidType;
        }
        catch (Exception e) {
            //Functions like isDir can return an exception
            //when reading a file it can't open.
            //So we don't care about those file.
            return FileType.InvalidType;
        }
    }

    private void reloadList(bool resetSelection = true) {
        import std.typecons : No;
        import std.string : indexOf;

        if (resetSelection) {
            _fileName = "";
            _filePathLabel.text = getLocalizedText("file") ~ ": ---";
            _applyBtn.isLocked = true;
        }
        _pathLabel.text = _path;
        string search = _searchField.text;
        _list.reset();
        auto files = dirEntries(_path, SpanMode.shallow);
        foreach (file; files) {
            if (file.indexOf(search, No.caseSentitive) == -1)
                continue;
            const auto type = getFileType(file);
            final switch (type) with (FileType) {
            case DirectoryType:
                _list.add(baseName(file), Color(20, 20, 20));
                continue;
            case MidiFileType:
                _list.add(baseName(file), Color.blue);
                continue;
            case InvalidType:
                continue;
            }
        }
    }

    override void update(float deltaTime) {
        if (getButtonDown(KeyButton.escape))
            onCallback("cancel");
        else if (!_applyBtn.isLocked) {
            if (getButtonDown(KeyButton.enter) || getButtonDown(KeyButton.enter2))
                onCallback("apply");
        }
    }

    override void draw() {
        drawFilledRect(origin, size, Color(240, 240, 240));
    }

    override void drawOverlay() {
        drawRect(origin, size, Color(20, 20, 20));
    }
}

final class ParentButton : Button {
    private {
        Sprite _parentSprite;
    }

    this() {
        _parentSprite = fetch!Sprite("parent");
        size = Vec2f(24f, 24f);
    }

    override void draw() {
        if (isClicked) {
            drawFilledRect(origin, size, Color(204, 228, 247));
            drawRect(origin, size, Color(0, 84, 153));
        }
        else if (isHovered) {
            drawFilledRect(origin, size, Color(229, 241, 251));
            drawRect(origin, size, Color(0, 120, 215));
        }
        else {
            drawFilledRect(origin, size, Color(225, 225, 225));
            drawRect(origin, size, Color(173, 173, 173));
        }
        _parentSprite.draw(center);
    }
}
