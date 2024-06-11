GameApp app;                                                                     // Nuestra aplicación

void setup() {
  size(800, 600);
  // Establecemos los ajustes de nuestro juego
  GameSettings settings = new GameSettings(this);
  settings.labelColorBackground = #430087;
  settings.labelColorForeground = #9200D1;
  settings.captionLabelColor = #E6BE0E;
  ///////////////////////////////////////////////////////
  
  // Creamos e iniciamos nuestro juego
  app = new GameApp(settings);
  
  if(!app.init()) {
     println("Error al iniciar juego");
     System.exit(1);
  }
  ///////////////////////////////////////////////////////
}

// Manejamos los diferentes eventos de nuestro juego
void mouseClicked() {
  app.mousePressed();
}

void keyPressed() {
  app.keyPressed(); 
}

void draw() {   
   app.paint(); 
}
