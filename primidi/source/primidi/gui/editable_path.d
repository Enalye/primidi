/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.editable_path;

import std.path;
import atelier;

/// Editable url field
final class EditablePathGui : GuiElement {
    /// The current url
    Label label;
    /// The editable field
    InputField inputField;
    /// Flags
    bool isEditingName, isFirstClick = true;

    @property {
        string text() const {
            return label.text;
        }

        string text(string t) {
            label.text = t;
            size = Vec2f(400f, label.size.y + 2f);
            return label.text;
        }
    }

    /// Ctor
    this(string path = "untitled") {
        label = new Label(path);
        label.color = Color(20, 20, 20);
        label.setAlign(GuiAlignX.left, GuiAlignY.center);
        appendChild(label);
        size = label.size;
    }

    override void update(float deltaTime) {
        if (isEditingName) {
            if (getButtonDown(KeyButton.enter))
                applyEditedName();
            else if (!hasFocus)
                cancelEditedName();
        }
        else if (!hasFocus) {
            isFirstClick = true;
        }
    }

    void cancelEditedName() {
        if (!isEditingName)
            throw new Exception("The element is not in an editing state");
        isEditingName = false;
        isFirstClick = true;

        removeChildren();
        appendChild(label);
        triggerCallback();
    }

    void applyEditedName() {
        if (!isEditingName)
            throw new Exception("The element is not in an editing state");
        isEditingName = false;
        isFirstClick = true;

        auto path = inputField.text;
        path = buildNormalizedPath(path);
        label.text = path;
        removeChildren();
        appendChild(label);
        triggerCallback();
    }

    override void onSubmit() {
        if (!isEditingName) {
            if (!isFirstClick) {
                isEditingName = true;
                removeChildren();
                inputField = new InputField(size, label.text != "untitled" ? label.text : "");
                inputField.font = new TrueTypeFont(veraMonoFontData, 12);
                inputField.color = Color(20, 20, 20);
                inputField.setAlign(GuiAlignX.center, GuiAlignY.center);
                inputField.size = Vec2f(400f, label.size.y);
                inputField.hasFocus = true;
                appendChild(inputField);
            }
            isFirstClick = false;
        }
        triggerCallback();
    }

    override void draw() {
        drawFilledRect(origin, size, Color(204, 204, 204));
    }
}
