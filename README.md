# Primidi #

Primidi is a simple and customizable viewer for creating pretty midi animations.


## How to build ##

You need the following installed: dmd, dub, SDL2.

To build you only need to type
```dub build```


## How to configurate

The configuration properties are located in the config.json file.
Here are each tag description and what they mean.

"midi-devices": If you're on Windows, you have no use of this tag. If you're on Linux and have a sound module, this tag is used to retrieve it and use it as a midi server.
"send-midi-events": If you don't want to hear any sound, set it to false. This way, primidi will only act as a midi viewer.
"width": set the default width of the application.
"height": set the default height of the application.
"skin": Change the skin folder used, please watch 'How to create skins' for more informations.

## Navigation

#### Controls
Escape: Close the application.
Space: Toggle the no distraction mode if you want to hide the GUI and the cursor.

#### Menu
Stop button: Stop the current animation and flushes the playlist.
Next button: Skip to the next animation in the playlist.
Reset button: Restart the current animation.
Fullscreen button: Toggle the fullscreen/windowed mode.

## How to create skins

Please watch the default-skin folder in "skins/" to see an example of skin.
To change skin, change the name default-skin in "skin": "default-skin" to your own skin.

The skin configuration properties are located in the skin.json.
Here are each tag description and what they mean.

#### General Properties
"font-size": Size of the font that will be loaded.
"show-channels-intensity": Set to false if you want to hide the bottom bars that display each channel activity.
"show-central-bar": Set to false if you want to hide the bar in the middle of the screen.
"show-title": Set to false if you want to hide the Midi file title name from appearing.
"show-overlay":	Set to false if you want to hide the overlay behind the Midi file title name.
"show-loading":	Set to false if you want to hide the loading panel.
"enable-particles": Set to false if you want the particle effects to not be displayed.

#### Per channel properties
"chan1" ~ "chan16": Properties set to each channels.
"is-displayed": If false, the notes won't be displayed at all.
"is-instrument": If true, the notes will be displayed like bars. If false, they'll be displayed like dots.
"color": Color of the notes being displayed, leave empty '[]' if you want a random color.
"speed": Speed of the notes being played.
"bounciness": Change the bouciness factor of the note being played, leave to 0 if you don't want any.

#### Required files
The following files are required in a skin folder:
background, loading, overlay, taskbar, ui, font.ttf and skin.json.


## FAQ

Q: Why Primidi ?

I wanted to create Midi animations, but there was nothing available on Linux.
Nothing like MAM, Midi trail or even Synthesia.
So I decided to create my own.


Q: Why can't I connect Primidi to Timidity/Midi port/*insert any midi device or software* ? Why are the sound settings so 'hacky' ?

A: Simply put, Primidi was and will never be intended to be a Midi client.
It started as a simple tool to create midi animations while the sound is recorded by other means (with your DAW, etc.).


Q: The music I recorded and the Midi animation from Primidi are no synchronized !! Wtf is this ?!

A: The Midi animation use correct times from the Midi, the desynchronization only seems to be happening with music recorded from Domino and nowhere else.
I am pretty sure Primidi is not at fault here.
Try to record/save the midi from another DAW to be sure.