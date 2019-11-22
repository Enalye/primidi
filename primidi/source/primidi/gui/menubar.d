module primidi.gui.menubar;

import atelier;

/** 
 * Bar on top that contains configuration options.
 */
final class MenuBar: GuiElement {
    this() {
        size(Vec2f(screenWidth, 20f));
        auto box = new HContainer;
        addChildGui(box);

        box.addChildGui(new MenuButton("Test"));
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

    override void draw() {
        drawFilledRect(origin, size, Color.white);
    }
}

private final class MenuButton: TextButton {
    this(string name) {
        super(getDefaultFont(), name);
        size(Vec2f(50f, 20f));
        label.color = Color.black;
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
}

/** 
 * Overlay container
 */
private final class MenuList: VContainer {
    this(GuiElement callbackObject, string[] options) {
        foreach(option; options) {
            auto btn = new TextButton(getDefaultFont(), option); // TODO: Localize text.
            btn.setCallback(callbackObject, option);
            addChildGui(btn);
        }
        setOverlay(this);
    }
}