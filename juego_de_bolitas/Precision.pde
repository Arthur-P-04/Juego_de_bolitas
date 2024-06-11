class PrecisionSection extends SectionBase {
  private controlP5.Controller<?> m_atrasButton;
  ArrayList<Shape> shapes = new ArrayList<Shape>();
  int score = 0;
  int redCircleInterval = 3000; // 3 segundos en milisegundos
  int lastRedCircleTime = 0;
  
  int resetInterval = 4000; // 4 segundos en milisegundos
  int lastResetTime = 0;
  
  int gameState = 0; // 0: Menu, 1: Training Room, 2: Game Over
  Button playButton;
  Button backButton;
  
  int gameTime = 60; // Tiempo inicial en segundos
  int startTime;
  
  public boolean init(GameSettings settings) {
    noStroke();
    
    playButton = new Button(width / 2, height / 2, "Play");
    backButton = new Button(80, 20, "Atras"); // Ajuste de posición aquí
    m_atrasButton = settings.getCP5().getController("Atras");
    return true;
  }
  
  void paint() {
    pushStyle();
    background(240);
    textAlign(CENTER);
    // shape(CENTER);

    if (gameState == 0) {
      drawMenu();
    } else if (gameState == 1) {
      drawTrainingRoom();
    } else if (gameState == 2) {
      drawGameOver();
    }
    popStyle();
  }
  
  void drawMenu() {
    textSize(32);
    fill(0);
    text("Geometry Training", width / 2, height / 2 - 30);
    
    playButton.display();
    
    if (playButton.isClicked(mouseX, mouseY)) {
      cursor(HAND);
      if (mousePressed) {
        gameState = 1; // Cambiar a la sala de entrenamiento
        setupTrainingRoom();
      }
    } else {
      cursor(ARROW);
    }
  }
  
  void drawTrainingRoom() {
    background(240);
    
    for (Shape shape : shapes) {
      shape.display();
      shape.update();
    }
    
    fill(0);
    textSize(24);
    text("Score: " + score, width / 2, 30);
    
    // Verificar si es necesario generar un nuevo círculo rojo
    if (millis() - lastRedCircleTime > redCircleInterval) {
      generateRedCircle();
    }
    
    // Verificar si es necesario reiniciar las figuras
    if (millis() - lastResetTime > resetInterval) {
      resetShapes();
    }
    
    backButton.display();
    
    // Mostrar el tiempo restante
    int elapsedTime = (millis() - startTime) / 1000;
    int timeRemaining = max(0, gameTime - elapsedTime);
    fill(0);
    textSize(24);
    text("Tiempo: " + timeRemaining, width - 150, 30);
    
    // Terminar el juego cuando el tiempo llega a 0
    if (timeRemaining == 0) {
      gameState = 2;
    }
  }
  
  void drawGameOver() {
    background(240);
    
    textSize(32);
    fill(0);
    text("Game Over", width / 2, height / 2 - 30);
    text("Your Score: " + score, width / 2, height / 2 + 30);
    
    backButton.display();
  }
  
  void mousePressed() {
    if (gameState == 0) {
      if (playButton.isClicked(mouseX, mouseY)) {
        gameState = 1; // Cambiar a la sala de entrenamiento
        setupTrainingRoom();
      }
    } else if (gameState == 1) {
      if (backButton.isClicked(mouseX, mouseY)) {
        gameState = 0; // Volver al menú
        m_atrasButton.show();
      } else {
        m_atrasButton.hide();
        for (int i = shapes.size() - 1; i >= 0; i--) {
          Shape shape = shapes.get(i);
          if (shape.isClicked(mouseX, mouseY)) {
            if (shape.isCorrect()) {
              score += 10; // Figura correcta da 10 puntos
            } else {
              score -= 5; // Figura incorrecta resta 5 puntos
            }
            shapes.remove(i); // Eliminar figura clickeada
            if (shape.getColor() == color(255, 0, 0)) {
              generateRedCircle(); // Generar nuevo círculo rojo
            }
            generateShape(); // Generar nueva figura
            break;
          }
        }
      }
    } else if (gameState == 2) {
      if (backButton.isClicked(mouseX, mouseY)) {
        gameState = 0; // Volver al menú
      }
    }
  }
  
  void setupTrainingRoom() {
    shapes.clear();
    generateShapes();
    score = 0;
    startTime = millis(); // Iniciar contador de tiempo
    lastResetTime = millis(); // Reiniciar el temporizador de reinicio de figuras
  }
  
  void resetShapes() {
    shapes.clear();
    generateShapes();
    lastResetTime = millis(); // Reiniciar el temporizador de reinicio de figuras
  }
  
  void generateShapes() {
    generateRedCircle(); // Agregar círculo rojo inicial
    for (int i = 0; i < 14; i++) {
      generateShape();
    }
  }
  
  void generateShape() {
    float x = random(width);
    float y = random(height);
    int choice = int(random(6)); // 0-2: círculos, 3-5: otras figuras
    if (choice < 3) {
      shapes.add(new Circle(x, y, randomColor())); // Círculo
    } else {
      shapes.add(new Triangle(x, y, randomColor())); // Otras figuras
    }
  }
  
  void generateRedCircle() {
    float x = random(width);
    float y = random(height);
    shapes.add(new Circle(x, y, color(255, 0, 0))); // Círculo rojo
    lastRedCircleTime = millis(); // Reiniciar contador para nuevo círculo rojo
  }
  
  color randomColor() {
    int r = int(random(256));
    int g = int(random(256));
    int b = int(random(256));
    return color(r, g, b);
  }
  
  class Button {
    float x, y;
    String label;
    
    Button(float x, float y, String label) {
      this.x = x;
      this.y = y;
      this.label = label;
    }
    
    void display() {
      fill(0, 170, 255);
      rectMode(CENTER);
      rect(x, y, 100, 40, 10);
      fill(0);
      textSize(24);
      textAlign(CENTER, CENTER);
      text(label, x, y);
    }
    
    boolean isClicked(float mouseX, float mouseY) {
      if (mouseX > x - 50 && mouseX < x + 50 && mouseY > y - 20 && mouseY < y + 20) {
        return true;
      }
      return false;
    }
  }
  
  abstract class Shape {
    float x, y;
    color shapeColor;
    
    Shape(float x, float y, color shapeColor) {
      this.x = x;
      this.y = y;
      this.shapeColor = shapeColor;
    }
    
    abstract void display();
    
    void update() {
    }
    
    boolean isClicked(float mouseX, float mouseY) {
      return false;
    }
    
    boolean isCorrect() {
      return false;
    }
    
    color getColor() {
      return shapeColor;
    }
  }
  
  class Circle extends Shape {
    float diameter = 50;
    
    Circle(float x, float y, color shapeColor) {
      super(x, y, shapeColor);
    }
    
    void display() {
      fill(shapeColor);
      ellipse(x, y, diameter, diameter);
    }
    
    boolean isClicked(float mouseX, float mouseY) {
      float distance = dist(x, y, mouseX, mouseY);
      if (distance < diameter / 2) {
        return true;
      }
      return false;
    }
    
    boolean isCorrect() {
      return shapeColor == color(255, 0, 0);
    }
  }
  
  class Triangle extends Shape {
    float side = 50;
    
    Triangle(float x, float y, color shapeColor) {
      super(x, y, shapeColor);
    }
    
    void display() {
      fill(shapeColor);
      triangle(x, y - side / 2, x - sqrt(3) * side / 2, y + side / 2, x + sqrt(3) * side / 2, y + side / 2);
    }
    
    boolean isClicked(float mouseX, float mouseY) {
      float px = mouseX - x;
      float py = mouseY - (y + side / 2);
      if (px >= 0 && px <= sqrt(3) * side / 2 && py >= 0 && py <= side) {
        if (px / (sqrt(3) * side / 2) + py / side <= 1) {
          return true;
        }
      }
      return false;
    }
    
    boolean isCorrect() {
      return shapeColor == color(255, 0, 0);
    }
  }
}
