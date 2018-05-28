# Primidi

A simple and customizable viewer for creating pretty midi animations.



## How to configurate

The configuration properties are located in the config.json file.
Here are each tag description and what they mean.

"midi-devices": If you're on Windows, you have no use of this tag. If you're on Linux and have a sound module, this tag is used to retrieve it and use it as a midi server. (Default value: [])

"send-midi-events": If you don't want to hear any sound, set it to false. This way, primidi will only act as a midi viewer. (Default value: true)

"width": Set the default width of the application. (Default value: 1280)

"height": Set the default height of the application. (Default value: 720)

"fps": Set the framerate of the application. (Default value: 60)

"speed": Speed factor at which the midi file is played. (Default value: 1.0)

"start-bpm": Starting bpm before the midi is played. (Default value: 120)

"start-offset": Number of tick with the default bpm before the actual midi file is played. (Default value: 1000)

"skin": Change the skin folder used, please read 'How to create skins' below for more informations. (Default value: "default-skin")



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

"font-size": Size of the font.ttf that will be loaded. (Default value: 50)

"show-channels-intensity": Set to false if you want to hide the bottom bars that display each channel activity. (Default value: true)

"show-central-bar": Set to false if you want to hide the bar in the middle of the screen. (Default value: true)

"show-title": Set to false if you want to hide the Midi file title name from appearing. (Default value: true)

"enable-particles": Set to false if you want the particle effects to not be displayed. (Default value: true)



#### Textures
Those are texture used in the application, some are required, other are optional.
If an optional texture is not defined, it'll not be displayed.

Required definitions: "taskbar", "stop", "next", "restart", "fullscreen".
Optional definitions: "background", "foreground", "loading", "overlay", "cursor".

Inside each definition, you can define which texture file it uses and how to crop it.
"texture": Name of the texture file without its extension. (Default value: same as the object name)

"x": Left border of the sprite (Default value: 0)

"y": Upper border of the sprite (Default value: 0)

"w": Width of the sprite (Default value: texture file width)

"h": Height of the sprite (Default value: texture file height)



#### Per channel properties
"chan1" ~ "chan16": Properties set to each channels.

"is-displayed": If false, the notes won't be displayed at all. (Default value: true)

"is-instrument": If true, the notes will be displayed like bars. If false, they'll be displayed like dots. (Default value: true)

"color": Color of the notes being displayed, leave empty '[]' if you want a random color. (Default value: Random)

"speed": Speed of the notes being played. (Default value: 1.0)

"bounciness": Change the bouciness factor of the note being played, leave to 0 if you don't want any. (Default value: 1.0)

"size": Custom height in pixels, leave 0 or don't define it if you want the program to choose the best size. (Default value: 0)

"min-pos": Upper bound in pixel in which notes can be displayed (0 = Upper limit, 720 = Lower limit) (Default value: 0)

"max-pos": Lower bound in pixel in which notes can be displayed (0 = Upper limit, 720 = Lower limit) (Default value: 720)

"use-absolute-pos": If false, the notes will be resized to best fit the lower/upper bound (min-pos/max-pos) of the screen.
If true, the lower bound will be the lowest note possible, and the upper bound the highest. (Default value: false)

"sprite": (Optional) Like the textures definition above, you can define a custom sprite for your channel.

Inside "sprite", you can define which texture file it uses and how to crop it.

"texture": Name of the texture file without its extension. (Default value: same as the object name)

"x": Left border of the sprite (Default value: 0)

"y": Upper border of the sprite (Default value: 0)

"w": Width of the sprite (Default value: texture file width)

"h": Height of the sprite (Default value: texture file height)



## FAQ

Q: Why Primidi ?

I wanted to create Midi animations, but there was nothing available on Linux, like MAM, Midi trail or even Synthesia.
So I decided to create my own.


Q: Why can't I connect Primidi to Timidity/Midi port/*insert any midi device or software* ? Why are the sound settings so 'hacky' ?

A: Simply put, Primidi was never intended to be a Midi client and will never be.
It started as a simple tool to create midi animations while the sound is recorded by other means (with your DAW, etc.).


Q: The music I recorded and the Midi animation from Primidi are no synchronized !! Wtf is this ?!

A: The Midi animation use correct times from the Midi, the desynchronization only seems to be happening with music recorded from Domino and nowhere else.
I am pretty sure Primidi is not at fault here.
Try to record/save the midi from another DAW to be sure, or change the speed in the config.json.