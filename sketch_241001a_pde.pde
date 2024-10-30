import processing.video.*;

Movie video; // Pour la vidéo principale
Movie cancelVideo; // Pour la vidéo d'annulation
PImage choixImage; // Pour l'image "choix" qui s'affiche à la fin de la vidéo principale
boolean videoPlaying = false; // Indicateur de lecture de la vidéo principale
boolean cancelVideoPlaying = false; // Indicateur de lecture de la vidéo d'annulation
boolean videoLoaded = false; // Vérifier si la vidéo principale est bien chargée
boolean cancelVideoLoaded = false; // Vérifier si la vidéo d'annulation est bien chargée
boolean showChoiceImage = false; // Indicateur pour afficher l'image de choix

int buttonWidth, buttonHeight, buttonRadius; // Propriétés des boutons
int marginBetweenButtons = 100; // Marge de 100 pixels entre les boutons

PFont segoeFont; // Variable pour la police "Segoe UI Semibold"

// Coordonnées des deux boutons
int button1X, button1Y;
int button2X, button2Y;

void setup() {
  size(2560, 1440); // Taille de la fenêtre en format 9:16

  // Charger la police "Segoe UI Semibold"
  segoeFont = createFont("SegoeUI-Semibold-30.vlw", 30); // Assurez-vous que ce fichier existe dans le dossier data

  loadVideo("video.mp4"); // Charger la première vidéo
  choixImage = loadImage("choix.jpg"); // Charger l'image "choix"

  buttonWidth = 200; // Largeur des boutons
  buttonHeight = 80; // Hauteur des boutons
  buttonRadius = buttonHeight / 2; // Rayon pour les demi-cercles

  // Calculer les positions des boutons au centre, côte à côte (inversés), et descendre de 500 pixels
  int centerX = width / 2;
  int centerY = height / 2 + 200; // Descendre les boutons de 500 pixels

  button1X = centerX + marginBetweenButtons / 2; // Placer le bouton "Continuer" à droite du centre
  button1Y = centerY - buttonHeight / 2; // Centrer verticalement

  button2X = centerX - buttonWidth - marginBetweenButtons / 2; // Placer le bouton "Annuler" à gauche du centre
  button2Y = button1Y; // Même hauteur pour les deux boutons
}

void draw() {
  background(0);

  if (showChoiceImage) {
    // Afficher l'image "choix" à la fin de la première vidéo
    image(choixImage, 0, 0, width, height);

    // Dessiner les boutons seulement lorsque l'image de choix est affichée
    drawButtonWithHalfCircles(button1X, button1Y, "Continuer");
    drawButtonWithHalfCircles(button2X, button2Y, "Annuler");
  } else if (cancelVideoPlaying && cancelVideoLoaded) {
    // Afficher la vidéo d'annulation si elle est en lecture
    if (cancelVideo.available()) {
      cancelVideo.read();
    }
    image(cancelVideo, 0, 0, width, height);
  } else if (videoLoaded) {
    // Afficher la vidéo principale si elle est bien chargée et en lecture
    if (videoPlaying) {
      if (video.available()) {
        video.read();
      }
      image(video, 0, 0, width, height); // Afficher la vidéo en plein écran
    }
    // Vérifier si la vidéo principale est terminée
    if (video.time() >= video.duration() - 0.1) {
      videoPlaying = false;
      showChoiceImage = true; // Activer l'affichage de l'image "choix"
    }
  } else {
    // Afficher un message si la vidéo n'est pas chargée
    fill(255);
    textAlign(CENTER, CENTER);
    text("Chargement de la vidéo...", width / 2, height / 2);
  }
}

// Fonction pour dessiner un bouton avec des demi-cercles
void drawButtonWithHalfCircles(int x, int y, String label) {
  fill(color(34, 28, 162)); // Couleur de fond des boutons #221CA2
  noStroke();

  // Dessiner le rectangle central du bouton
  rect(x, y, buttonWidth, buttonHeight); 

  // Dessiner les demi-cercles aux extrémités gauche et droite du bouton
  ellipse(x, y + buttonHeight / 2, buttonHeight, buttonHeight); // Demi-cercle à gauche
  ellipse(x + buttonWidth, y + buttonHeight / 2, buttonHeight, buttonHeight); // Demi-cercle à droite

  // Ajouter le texte centré dans le bouton
  fill(color(126, 213, 201)); // Couleur du texte #7ED5C9
  textAlign(CENTER, CENTER);
  textSize(30); // Augmenter la taille du texte

  // Appliquer la police "Segoe UI Semibold"
  textFont(segoeFont);

  text(label, x + buttonWidth / 2, y + buttonHeight / 2); // Centrer le texte
}

// Fonction de gestion des clics sur les boutons
void mousePressed() {
  // Vérifier si le bouton "Continuer" est cliqué et que l'image de choix est affichée
  if (showChoiceImage && mouseX > button1X && mouseX < button1X + buttonWidth &&
      mouseY > button1Y && mouseY < button1Y + buttonHeight) {
    showChoiceImage = false; // Cacher l'image de choix
    loadVideo("continuation.mp4"); // Charger et démarrer la vidéo de continuation
  }

  // Vérifier si le bouton "Annuler" est cliqué et que l'image de choix est affichée
  if (showChoiceImage && mouseX > button2X && mouseX < button2X + buttonWidth &&
      mouseY > button2Y && mouseY < button2Y + buttonHeight) {
    showChoiceImage = false; // Cacher l'image de choix
    loadCancelVideo("annulation.mp4"); // Charger et démarrer la vidéo d'annulation
  }
}

// Pour charger la vidéo principale
void loadVideo(String videoFile) {
  try {
    video = new Movie(this, videoFile);
    video.play();
    videoPlaying = true;
    videoLoaded = true;
    cancelVideoPlaying = false; // Arrêter la vidéo d'annulation si elle est en lecture
  } catch (Exception e) {
    println("Erreur lors du chargement de la vidéo : " + e.getMessage());
    videoLoaded = false;
  }
}

// Pour charger la vidéo d'annulation
void loadCancelVideo(String videoFile) {
  try {
    cancelVideo = new Movie(this, videoFile);
    cancelVideo.play();
    cancelVideoPlaying = true;
    cancelVideoLoaded = true;
  } catch (Exception e) {
    println("Erreur lors du chargement de la vidéo d'annulation : " + e.getMessage());
    cancelVideoLoaded = false;
  }
}

// Pour éviter les erreurs de lecture
void movieEvent(Movie m) {
  m.read();
}
