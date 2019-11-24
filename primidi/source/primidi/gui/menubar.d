module primidi.gui.menubar;

import atelier;

private {
    bool _isMenuFocused;
}

/** 
 * Bar on top that contains configuration options.
 */
final class MenuBar: GuiElement {
    private {
        MenuButton[] _buttons;
    }

    this() {
        size(Vec2f(screenWidth, 20f));
        auto box = new HContainer;
        addChildGui(box);

        int i;
        const auto menuNames = ["Test1", "Test2", "Test3"];
        foreach(menuName; menuNames) {
            auto menuBtn = new MenuButton(menuName, i, cast(uint) menuNames.length);
            menuBtn.setCallback(this, "menu");
            box.addChildGui(menuBtn);
            _buttons ~= menuBtn;
            i ++;
        }
    }

    override void onEvent(Event event) {
        switch(event.type) with(EventType) {
        case resize:
            size(Vec2f(event.window.size.x, 25f));
            break;
        default:
            break;
        }
    }

    override void onCallback(string id) {
        _isMenuFocused = true;
        switch(id) {
        case "menu":
            stopOverlay();
            foreach(child; _buttons) {
                child.isHovered = false;
                child.isClicked = false;
                child.hasFocus = false;
            }
            foreach(child; _buttons) {
                if(child.requestChange) {
                    child.requestChange = false;
                    _buttons[child.changeId].isHovered = true;
                    _buttons[child.changeId].onSubmit();
                    break;
                }
            }
            break;
        default:
            break;
        }
    }

    override void draw() {
        drawFilledRect(origin, size, Color.white);
    }
}

private final class MenuCancel: GuiElement {
    this() {
        size(screenSize);
    }

    override void onSubmit() {
        triggerCallback();
    }
}

private final class MenuChange: GuiElement {
    uint triggerId;

    this(uint id) {
        triggerId = id;
    }

    override void onHover() {
        triggerCallback();
    }

    override void draw() {
        //drawFilledRect(origin, size, Color.red);
    }
}

private final class MenuButton: GuiElement {
    private {
        Label _label;
        MenuCancel _cancelTrigger;
        MenuChange[] _changeTriggers;
        MenuList _list;
        uint _changeId;
    }
    bool requestChange;

    @property uint changeId() const { return _changeId; }

    this(string name, uint id, uint maxId) {
        _label = new Label(name);
        _label.setAlign(GuiAlignX.center, GuiAlignY.center);
        _label.color = Color.black;
        addChildGui(_label);
        size(Vec2f(50f, 20f));

        _list = new MenuList(this, ["1", "2", "Hello"]);
        _cancelTrigger = new MenuCancel;
        _cancelTrigger.setCallback(this, "cancel");

        for(uint i = 0u; i < maxId; ++ i) {
            if(i == id)
                continue;
            auto changeTrigger = new MenuChange(i);
            changeTrigger.size = size;
            changeTrigger.setCallback(this, "change");
            _changeTriggers ~= changeTrigger;
        }
    }

    override void onEvent(Event event) {
        if(event.type == EventType.resize) {
            _cancelTrigger.size = cast(Vec2f) event.window.size;
        }
    }

    override void onSelect() {
        if(isSelected)
            onSubmit();
    }

    override void onSubmit() {
        setOverlay(_cancelTrigger);
        foreach(changeTrigger; _changeTriggers) {
            setOverlay(changeTrigger);
        }
        setOverlay(_list);
    }

    override void onCallback(string id) {
        if(id == "cancel") {
            stopOverlay();
            isHovered = false;
        }
        else if(id == "change") {
            foreach(changeTrigger; _changeTriggers) {
                if(changeTrigger.isHovered) {
                    _changeId = changeTrigger.triggerId;
                    requestChange = true;
                    triggerCallback();
                    break;
                }
            }
        }
    }

    override void draw() {
        if(isClicked) {
            drawFilledRect(origin, size, Color(153, 209, 255));
            drawRect(origin, size, Color(204, 232, 255));
        }
        else if(isHovered) {
            drawFilledRect(origin, size, Color(229, 243, 255));
            drawRect(origin, size, Color(204, 232, 255));
        }
    }

    override void drawOverlay() {
        _list.position = origin + Vec2f(0f, _size.y);

        foreach(changeTrigger; _changeTriggers) {
            changeTrigger.position = Vec2f(changeTrigger.triggerId * 50f, 0f);
        }
    }
}

/** 
 * Overlay container
 */
private final class MenuList: VContainer {
    this(GuiElement callbackObject, string[] options) {
        position(Vec2f(0f, 20f));
        setChildAlign(GuiAlignX.left);
        foreach(option; options) {
            auto btn = new MenuItem(option); // TODO: Localize text.
            btn.setCallback(callbackObject, option);
            addChildGui(btn);
        }
    }

    override void draw() {
        drawFilledRect(origin, size, Color.white);
    }
}

private final class MenuItem: GuiElement {
    private {
        Label _label;
    }

    this(string name) {
        _label = new Label(name);
        _label.position(Vec2f(50f, 0f));
        _label.setAlign(GuiAlignX.left, GuiAlignY.center);
        _label.color = Color.black;
        addChildGui(_label);
        size(Vec2f(150f, 30f));
    }

    override void onSubmit() {
        triggerCallback();
    }

    override void onHover() {

    }

    override void draw() {
        if(isHovered) {
            drawFilledRect(origin, size, Color(229, 243, 255));
            drawRect(origin, size, Color(204, 232, 255));
        }
    }
}