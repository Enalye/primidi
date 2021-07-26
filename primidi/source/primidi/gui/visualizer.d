/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.gui.visualizer;

import atelier, grimoire;
import primidi.midi, primidi.particles;

private {
    Canvas _defaultLayer, _currentLayer;
    Canvas[] _layers;
    Vec2i _layerSize;
    int _currentLayerIndex;
}

void setLayersCount(int layers) {
    _layers.length = 0;

    for(int i; i < layers; ++ i) {
        Canvas layer = new Canvas(_layerSize);
        layer.position = layer.size / 2f;
        _layers ~= layer;
    }

    setLayer(-1);
}

int getLayersCount() {
    return cast(int) _layers.length;
}

void setLayer(int layer) {
    if(layer < 0)
        layer = -1;
    if(_currentLayerIndex == layer)
        return;
    _currentLayerIndex = layer;
    if(_currentLayer)
        popCanvas();
    if(_currentLayerIndex == -1) {
        _currentLayer = _defaultLayer;
    }
    else if(_currentLayerIndex < _layers.length) {
        _currentLayer = _layers[_currentLayerIndex];
    }
    else {
        throw new Exception("layer index out of bounds");
    }
    pushCanvas(_currentLayer, false);
}

int getLayer() {
    return _currentLayerIndex;
}

void setLayerClearColor(int index, Color color) {
    if(index < 0) {
        _defaultLayer.clearColor = color;
    }
    else if(index < _layers.length) {
        _layers[index].clearColor = color;
    }
    else {
        throw new Exception("layer index out of bounds");
    }
}

void setLayerClearAlpha(int index, float alpha) {
    if(index < 0) {
        _defaultLayer.clearAlpha = alpha;
    }
    else if(index < _layers.length) {
        _layers[index].clearAlpha = alpha;
    }
    else {
        throw new Exception("layer index out of bounds");
    }
}

void setLayerBlend(int index, Blend blend) {
    if(index < 0) {
        _defaultLayer.blend = blend;
    }
    else if(index < _layers.length) {
        _layers[index].blend = blend;
    }
    else {
        throw new Exception("layer index out of bounds");
    }
}

void setLayerColor(int index, Color color) {
    if(index < 0) {
        _defaultLayer.color = color;
    }
    else if(index < _layers.length) {
        _layers[index].color = color;
    }
    else {
        throw new Exception("layer index out of bounds");
    }
}

void setLayerAlpha(int index, float alpha) {
    if(index < 0) {
        _defaultLayer.alpha = alpha;
    }
    else if(index < _layers.length) {
        _layers[index].alpha = alpha;
    }
    else {
        throw new Exception("layer index out of bounds");
    }
}

private void initializeLayers(Vec2i size) {
    _layerSize = size;

    _defaultLayer = new Canvas(_layerSize);
    _defaultLayer.position = _defaultLayer.size / 2f;
    _currentLayerIndex = -1;
    _currentLayer = null;
}

private void setLayersSize(Vec2i size) {
    _layerSize = size;

    _defaultLayer.renderSize = _layerSize;
    _defaultLayer.size = cast(Vec2f) _layerSize;
    _defaultLayer.position = _defaultLayer.size / 2f;
    foreach (Canvas layer; _layers) {
        layer.renderSize = _layerSize;
        layer.size = cast(Vec2f) _layerSize;
        layer.position = layer.size / 2f;
    }
}

/// Load and run the plugin's script
final class Visualizer: GuiElement {
    private {
        bool _isVisible = true;
    }

    /// Ctor
    this() {
        size(getWindowSize() - Vec2f(0f, 70f));
        position(Vec2f(0f, 20f));
        setAlign(GuiAlignX.left, GuiAlignY.top);

        initializeLayers(cast(Vec2i) size);
        initializeParticles();

        GuiState hiddenState = {
            offset: Vec2f(0f, -20f),
            time: .25f,
            easing: getEasingFunction(Ease.quadInOut)
        };
        addState("hidden", hiddenState);

        GuiState shownState = {
            time: .25f,
            easing: getEasingFunction(Ease.quadInOut)
        };
        addState("shown", shownState);
        setState("shown");
    }

    override void update(float deltaTime) {
        // Clear
        foreach (Canvas layer; _layers) {
            pushCanvas(layer);
            popCanvas();
        }

        _currentLayer = _defaultLayer;
        _currentLayerIndex = -1;
        pushCanvas(_defaultLayer);
        runScript();
        popCanvas();
        updateParticles(deltaTime);
    }

    override void onEvent(Event event) {
        switch(event.type) with(Event.Type) {
        case resize:
            if(_isVisible)
                size(getWindowSize() - Vec2f(0f, 70f));
            else
                size(getWindowSize());
            setLayersSize(cast(Vec2i) size);
            break;
        case custom:
            if(event.custom.id == "hide") {
                doTransitionState(_isVisible ? "hidden" : "shown");
                if(_isVisible)
                    size(getWindowSize());
                else
                    size(getWindowSize() - Vec2f(0f, 70f));
                setLayersSize(cast(Vec2i) size);
                _isVisible = !_isVisible;
            }
            break;
        default:
            break;
        }
    }

    override void draw() {
        drawFilledRect(origin, size, Color.black);

        pushCanvas(_defaultLayer, false);
        foreach (Canvas layer; _layers) {
            layer.draw(center);
        }
        drawParticles();
        popCanvas();
        _defaultLayer.draw(center);
    }

    override void onQuit() {
        killScript();
    }
}