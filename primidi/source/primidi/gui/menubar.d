module primidi.gui.menubar;

import atelier;

/** 
 * Bar on top that contains configuration options.
 */
final class MenuBar: GuiElement {
    this() {
        size(Vec2f(screenWidth, 25f));
        auto box = new HContainer;
        addChildGui(box);

        box.addChildGui(new TextButton(getDefaultFont(), "Test"));
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
/*
private final class MenuButton: TextButton {
    this() {

    }
}*/

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