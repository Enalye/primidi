# Primidi

Simpla kaj akomodebla vidigilo por krei belajn MIDI-ajn animaciojn.


## Kiel agordi

La parametroj troviĝas en la dosiero config.json.
Jen ĉiuj uzataj etikedoj kaj siaj definoj.

"midi-devices": Se vi estas en Vindozo, ĉi tiu etikedo ne servas. Sed en Linukso, vi povas defini la nomon de sonora modulo.
"send-midi-events": Se vi ne volas aŭdi sono, agordu ĝin al false. Tiel, Primidi nur agos tiel, kiel MIDI-a vidigilo.
"width": Tajpi la defaŭlta larĝeco de la programaro.
"height": Tajpi la defaŭlta alteco de la programaro.
"skin": Ŝanĝi la dosierujon de la haŭto, legu 'Kiel krei haŭton' por havi pli da informoj.

## Uzi la programaron

#### Klavoj
eskapklavo: Fermi la programaron.
spacklavo: Baskuligi la sendistraĵan reĝimon por kaŝi la interfacon kaj la kursoron.

#### Menuo
Haltigi butono: Haltigas la aktualan animacion kaj forviŝas la ludliston.
Sekvanta Butono: Ludi la sekvontan animacion el la ludlisto.
Rekomencigi Butono: Rekomencigi la aktualan animacion.
Tutekrana Butono: Baskuligi la tutekranan reĝimon.

## Kiel krei haŭton

Bonvolu rigardi la dosierujon de la defaŭlta haŭto en "skins/" por vidi ekzemplon de haŭto.
Por ŝanĝi la haŭton, modifu la nomon default-skin en "skin": "default-skin" kun via haŭto.

La agordoj de la haŭto troviĝas en skin.json.
Jen ĉiuj uzataj etikedoj kaj siaj definoj.

#### La ĝeneralaj informoj
"font-size": Grandeco de la uzota tiparo.
"show-channels-intensity": Metu false se vi volas kaŝi la subajn bastonojn ke elmontras ĉiujn aktivecojn de la kanalo.
"show-central-bar": Metu false se vi volas kaŝi la centran bastonon.
"show-title": Metu false se vi volas kaŝi la titulon kiam la animacio komanciĝas.
"show-overlay": Metu false se vi volas kaŝi la bildon malantaŭ la titulo de la MIDI-a dosiero.
"show-loading": Metu false se vi volas kaŝi la ŝargan ekranon.
"enable-particles": Metu false se vi volas kaŝi la partiklojn.

#### Agordoj por kanalo
"chan1" ~ "chan16": Agordoj por ĉiu kanalo.
"is-displayed": Metu false se vi ne volas vidi la tonojn de la kanalo.
"is-instrument": Metu true se vi volas ke la tonoj estas montrataj kiel bastonoj. Metu false se vi volas ke la tonoj estas montrataj kiel punktoj.
"color": La koloro de la tonoj. Lasu malplena '[]' se vi volas aleatoran koloron.
"speed": Rapideco de la tonoj.
"bounciness": Ŝanĝu la faktoron de resalto de la ludata tono, lasu 0 se vi ne volas ĝin.


#### Bezonataj Dosieroj
La programaro bezonas la sekvajn dosierojn por fari haŭton: 
background, loading, overlay, taskbar, ui, font.ttf kaj skin.json.


## Respondaro

D: Kial Primidi?

R: Mi deziris krei MIDI-ajn animaciojn, sed estis nenia programaro por Linukso.
Nenio kiel MAM, Midi trail aŭ Synthesia.
Do mi decidis krei mian propran programaron.


D: Kial mi ne povas ligi Primidi al Timidity/MIDI-a konektejo/*anigu ian ajn MIDI-an aparaton aŭ programaron* ? Kial la sonaj agordoj estas tiel malbona ?

R: Simple, Primidi neniam estis kaj neniam estos kreiĝi por fariĝi MIDI-a kliento.
Ĝi kreiĝis kiel simpla ilo por krei MIDI-an animacion dum la muziko estas kreata per aliaj programaroj.


D: Kial mia muziko kaj la MIDI-a animacio ne havas la saman tempon ?

R: La MIDI-a animacio uzas ĝustajn tempojn. Ŝajnas ke la problemo nur venas de muzikoj el la programaro Domino.
Mi pensas ke Primidi ne eraras ĉi tie.
Provu konservi la muzikon kaj la MIDI-an dosieron kun alia programaro por esti certa.
