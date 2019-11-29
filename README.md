# Primidi #

Primidi is a customizable viewer for creating pretty midi animations.
It runs a script to make different kind of animations.

## Usage

You can play a midi file by either:
 * Drag & drop the `.mid` or `.midi` file into the application.
 * `Media` > `Open midi file` and select a midi file to open.
 * By command line with `primidi PATH_TO_YOUR_FILE`.

## Connect midi ports

Go to `Ports` then `Select input device` or `Select output device`.

## Change script

To change the rendering, go to `Script` > `Open script file` and choose a valid script (.gr).
You can also write your own script, Primidi uses [Grimoire](https://github.com/Enalye/grimoire) for scripting and you can find its documentation [> here ! <](https://enalye.github.io/grimoire).

For the other options:
 * `Reload` will recompile the file and runs it.
 * `Restart` will only run it again without recompiling.

## Navigation

### Shortcuts
`Space`, `k` or `p`: Play/Pause
`F10`: Hide/Show the interface
`F11`: Toggle fullscreen

## How to build ##

You need the following installed: dmd, dub, SDL2.

To build you only need to type
```dub build```
There is also a bash script in `tools/`.