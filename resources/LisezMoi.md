# Primidi

Un logiciel de visualisation simple et personnalisable pour créer de jolies animations midi.


## Comment configurer

Les paramètres de configuration se trouvent dans le fichier config.json.
Voici chaque balises utilisées et ce qu'elles signifient.

"midi-devices": Si vous êtes sur Windows, ce champs est inutilisé. Si vous êtes sous Linux et possédez un module sonore, cette balise est utilisée pour définir le serveur midi.
"send-midi-events": Si vous ne voulez pas entendre de son, mettez-le sur false. De cette façon, Primidi n'agira que comme visionneuse midi.
"width": Saisissez la largeur par défaut de l'application.
"height": Saisissez la hauteur par défaut de l'application.
"skin": modifiez le dossier du thème utilisé, regardez 'Comment créer des thèmes' pour plus d'informations.

## Naviguer

#### Contrôles
Escape: Fermer l'application.
Espace: Activer le mode sans distraction si vous souhaitez masquer l'interface et le curseur.

#### Menu
Bouton Arrêt: Arrête l'animation actuelle et efface la liste de lecture.
Bouton Suivant: Passez à l'animation suivante dans la liste de lecture.
Bouton Réinitialiser: Redémarrer l'animation en cours.
Bouton Plein écran: bascule le mode plein écran/fenêtré.

## Comment créer des thèmes

Veuillez regarder le dossier du thème par défaut dans "skins/" pour voir un exemple de thème.
Pour changer de thème, modifiez le nom default-skin dans "skin": "default-skin" pour votre propre thème.

Les paramètres de configuration du thème sont situées dans skin.json.
Voici chaque balises utilisées et ce qu'elles signifient.

#### Les informations générales
"font-size": Taille de la police de caractères qui sera utilisée.
"show-channels-intensity": Mettez sur false si vous souhaitez masquer les barres inférieures qui affichent chaque activitée du canal.
"show-central-bar": Mettez sur false si vous souhaitez cacher la barre de lecture au milieu de l'écran.
"show-title": Mettez sur false si vous souhaitez masquer le nom du titre du fichier Midi au lancement.
"show-overlay": Mettez sur false si vous souhaitez cacher l'image derrière le titre du fichier Midi.
"show-loading": Mettez sur false si vous souhaitez masquer l'écran de chargement.
"enable-particles": Mettez sur false si vous souhaitez que les effets de particules ne soient pas affichés.

#### Paramètres par canal
"chan1" ~ "chan16": Paramètres définies sur chaque canal.
"is-displayed": Mettez sur false si vous ne voulez pas que les notes du canal apparaissent.
"is-instrument": Mettez sur true si vous voulez que les notes soient affichées comme des barres. Mettez false si vous voulez qu'elles soient affichées comme des points.
"color": Couleur des notes affichées, laissez vide '[]' si vous voulez une couleur aléatoire.
"speed": Vitesse de défilement des notes en cours de lecture.
"bounciness": Modifiez le facteur de rebond de la note jouée, laissez à 0 si vous n'en voulez pas.

#### Fichiers requis
Les fichiers suivants sont requis pour faire un thème:
background, loading, overlay, taskbar, ui, font.ttf et skin.json.


## FAQ

Q: Pourquoi Primidi?

Je souhaitais créer des animations Midi, mais vu qu'il n'y avait rien de disponible sous Linux (contrairement à Windows où il y a MAM, Midi trail ou même Synthesia), j'ai décidé de créer mon propre logiciel.


Q: Pourquoi ne puis-je pas connecter Primidi à Timidity/un port Midi/*insérer n'importe quel périphérique midi ou logiciel*? Pourquoi les réglages du son sont-ils aussi foireux ?

R: Tout simplement, Primidi n'a jamais été, et ne sera jamais, destiné à être un client Midi.
Il a été conçu comme un outil simple pour créer des animations midi tandis que le son est enregistré par d'autres moyens (avec un logiciel de MAO, etc.).


Q: J'ai enregistré une musique et l'animation Midi de Primidi n'est pas synchronisée avec!! C'est quoi ça ?

R: L'animation Midi utilise les temps corrects du Midi, la désynchronisation semble se produire uniquement avec de la musique enregistrée depuis Domino et nulle part ailleurs.
Je suis à peu près sûre que Primidi n'est pas en tort ici.
Essayez d'enregistrer/récupérer le midi depuis un autre logiciel de MAO pour en être certain.
