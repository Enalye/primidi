/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.script_error;

import std.conv: to;
import atelier, grimoire;
import primidi.locale;
import primidi.gui.buttons;

/// Error popup for compilation problems.
final class ScriptErrorModal: GuiElement {
    private {
        Text _text;
    }

    /// Ctor
    this(GrError error) {
        setAlign(GuiAlignX.center, GuiAlignY.center);
        isMovable(true);

        { //Error display
            string lineNumber = to!string(error.line) ~ "| ";
            string snippet, underline, extra, space;

            //Script snippet
            foreach(x; 1 .. lineNumber.length)
                space ~= " ";
            underline = space;
            extra = space;
            snippet ~= " " ~ lineNumber ~ error.lineText;

            //Underline
            underline ~= "{c:blue}|{c:red}";
            foreach(x; 0 .. error.column)
                underline ~= " ";
            foreach(x; 0 .. error.textLength)
                underline ~= "^";
            if(error.info.length)
                underline ~= "  " ~ error.info;

            extra ~= "|";

            string line = "{c:red}error:{c:black} " ~ error.message ~
                "\n" ~ space ~ "{c:blue}->{c:black} "
                ~ error.filePath ~ "(" ~ to!string(error.line)
                ~ "," ~ to!string(error.column) ~ ")\n{c:blue}" ~
                extra ~ "\n" ~ snippet ~ "\n" ~ underline ~"\n{c:blue}" ~ extra ~
                "\n{c:black}Compilation aborted...";
            _text = new Text(line);
            _text.setAlign(GuiAlignX.left, GuiAlignY.top);
            _text.position = Vec2f(20f, 50f);
            appendChild(_text);
        }

        { //Title
            auto title = new Label(getLocalizedText("error") ~ ":");
            title.color = Color(20, 20, 20);
            title.setAlign(GuiAlignX.left, GuiAlignY.top);
            title.position = Vec2f(20f, 10f);
            appendChild(title);
        }

		{ //Close
            auto closeBtn = new ConfirmationButton(getLocalizedText("close"));
            closeBtn.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            closeBtn.position = Vec2f(10f, 10f);
            closeBtn.size = Vec2f(70f, 20f);
            closeBtn.setCallback(this, "close");
            appendChild(closeBtn);
        }

        { //Exit
            auto exitBtn = new ExitButton;
            exitBtn.setAlign(GuiAlignX.right, GuiAlignY.top);
            exitBtn.position = Vec2f(10f, 10f);
            exitBtn.setCallback(this, "cancel");
            appendChild(exitBtn);
        }

        GuiState hiddenState = {
            offset: Vec2f(0f, -50f),
            alpha: 0f
        };
        addState("hidden", hiddenState);

        GuiState defaultState = {
            time: .5f,
            easing: getEasingFunction(Ease.sineOut)
        };
        addState("default", defaultState);

        setState("hidden");
        doTransitionState("default");
        size(_text.size + Vec2f(50f, 100f));
    }

    override void onCallback(string id) {
		switch(id) {
		case "close":
            stopModal();
            break;
        default:
            break;
        }
	}

    override void update(float deltaTime) {
        if(getButtonDown(KeyButton.escape) || getButtonDown(KeyButton.enter) || getButtonDown(KeyButton.enter2))
            onCallback("close");
    }

    override void draw() {
        drawFilledRect(origin, size, Color(240, 240, 240));
        drawFilledRect(_text.origin - Vec2f(10f, 10f), _text.size + Vec2f(20f, 20f), Color(204, 204, 204));
    }

    override void drawOverlay() {
        drawRect(origin, size, Color(20, 20, 20));
    }
}