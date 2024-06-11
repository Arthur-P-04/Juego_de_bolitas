class VelocidadSection extends SectionBase {
  private controlP5.Controller<?> m_atrasButton;
  int gameState = 0; // 0: Menu, 1: Training Room, 2: Game Over
  int score = 0;
  float timeLeft = 60.0;
  int maxCircles = 2;
  float circleInterval = 3.0; // Tiempo en segundos entre aparición de círculos
  
  ArrayList<MyCircle> circles = new ArrayList<MyCircle>();
  
  PVector backButtonPos;
  
  public boolean init(GameSettings settings) {
    backButtonPos = new PVector(50, 50);
    m_atrasButton = settings.getCP5().getController("Atras");
    return true;
  }
  
  public void onFocus() {
    m_atrasButton.hide();  
  }
  
  public void paint() {
    background(240);
    pushStyle();
    
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    ellipseMode(CENTER);
    noStroke();
    
    if (gameState == 0) {
      drawMenu();
    } else if (gameState == 1) {
      drawTrainingRoom();
      updateTime();
    } else if (gameState == 2) {
      drawGameOver();
    }
    popStyle();
  }
  
  void drawMenu() {
    textSize(32);
    fill(0);
    text("Geometry Training", width / 2, height / 2 - 30);
    
    // Draw PLAY button
    fill(0, 170, 255);
    rectMode(CENTER);
    rect(width / 2, height / 2 + 30, 100, 40, 10);
    fill(0);
    textSize(24);
    text("PLAY", width / 2, height / 2 + 30);
    
    if (mouseX > width / 2 - 50 && mouseX < width / 2 + 50 && mouseY > height / 2 && mouseY < height / 2 + 60) {
      cursor(HAND);
      if (mousePressed) {
        startGame();
      }
    } else {
      cursor(ARROW);
    }
  }
  
  void drawTrainingRoom() {
    background(240);
    
    if (gameState == 0) {
      drawMenu();
    } else if (gameState == 1) {
      drawGame();
      updateTime();
    } else if (gameState == 2) {
      drawGameOver();
    }
  }
  
  void drawGame() {
    fill(0);
    textSize(24);
    text(nf(floor(timeLeft / 60), 2) + ":" + nf(floor(timeLeft % 60), 2), width / 2, 30);
    text("Puntaje: " + score, width / 2, height - 30);
    
    // Dibujar el botón de retroceso
    fill(255, 0, 0);
    rect(backButtonPos.x, backButtonPos.y, 100, 40, 10);
    fill(0);
    textSize(18);
    text("Atras", backButtonPos.x, backButtonPos.y);
    
    if (mouseX > backButtonPos.x - 50 && mouseX < backButtonPos.x + 50 &&
        mouseY > backButtonPos.y - 20 && mouseY < backButtonPos.y + 20) {
      cursor(HAND);
      if (mousePressed) {
        returnToMenu();
      }
    } else {
      cursor(ARROW);
    }
    
    if (timeLeft <= 0) {
      endGame();
    } else {
      // Actualizar y mostrar los círculos
      for (int i = circles.size() - 1; i >= 0; i--) {
        MyCircle circle = circles.get(i);
        float circleElapsedTime = (millis() - circle.getStartTime()) / 1000.0; // Tiempo transcurrido en segundos
        if (circleElapsedTime >= 2.0) {
          circles.remove(i);
          circles.add(new MyCircle(random(width), random(height), millis()));
        } else {
          if (!circleIsOverlapping(circle.getX(), circle.getY(), backButtonPos.x, backButtonPos.y, 100, 40) &&
              !circleIsOverlapping(circle.getX(), circle.getY(), width / 2, height - 30, textWidth("Puntaje: " + score), 24) &&
              !circleIsOverlapping(circle.getX(), circle.getY(), width / 2, 30, textWidth(nf(floor(timeLeft / 60), 2) + ":" + nf(floor(timeLeft % 60), 2)), 24)) {
            fill(0, 170, 255);
            ellipse(circle.getX(), circle.getY(), 50, 50);
          }
        }
        
        // Verificar si se hizo clic dentro de algún círculo
        if (dist(circle.getX(), circle.getY(), mouseX, mouseY) < 25 && mousePressed) {
          score++;
          circles.remove(i); // Eliminar el círculo clickeado
          circles.add(new MyCircle(random(width), random(height), millis())); // Agregar uno nuevo
        }
      }
    }
  }
  
  boolean circleIsOverlapping(float circleX, float circleY, float rectX, float rectY, float rectWidth, float rectHeight) {
    float distanceX = abs(circleX - rectX);
    float distanceY = abs(circleY - rectY);
    
    if (distanceX > (rectWidth / 2 + 25)) { return false; }
    if (distanceY > (rectHeight / 2 + 25)) { return false; }
    
    if (distanceX <= (rectWidth / 2)) { return true; } 
    if (distanceY <= (rectHeight / 2)) { return true; }
    
    float cornerDistance_sq = (distanceX - rectWidth / 2) * (distanceX - rectWidth / 2) +
                           (distanceY - rectHeight / 2) * (distanceY - rectHeight / 2);
  
    return (cornerDistance_sq <= (25 * 25));
  }
  
  void drawGameOver() {
    textSize(32);
    fill(0);
    text("Game Over", width / 2, height / 2 - 30);
    text("Your Score: " + score, width / 2, height / 2 + 30);
    
    // Dibujar el botón de regreso en la esquina superior izquierda
    fill(255, 0, 0);
    rectMode(CENTER);
    rect(backButtonPos.x, backButtonPos.y, 100, 40, 10);
    fill(0);
    textSize(24);
    text("Regresar", backButtonPos.x, backButtonPos.y);
    
    if (mouseX > backButtonPos.x - 50 && mouseX < backButtonPos.x + 50 &&
        mouseY > backButtonPos.y - 20 && mouseY < backButtonPos.y + 20) {
      cursor(HAND);
      if (mousePressed) {
        returnToMenu();
      }
    } else {
      cursor(ARROW);
    }
  }
  
  void mousePressed() {
    if(gameState == 0)
      m_atrasButton.show();
    else
      m_atrasButton.hide();
    
    if (gameState == 1) {
      for (int i = circles.size() - 1; i >= 0; i--) {
        MyCircle circle = circles.get(i);
        if (dist(circle.getX(), circle.getY(), mouseX, mouseY) < 25) {
          score++;
          circles.remove(i);
          circles.add(new MyCircle(random(width), random(height), millis()));
        }
      }
    }
  }
  
  void startGame() {
    gameState = 1;
    score = 0;
    timeLeft = 60.0;
    circles.clear();
    for (int i = 0; i < maxCircles; i++) {
      MyCircle newCircle = new MyCircle(random(width), random(height), millis());
      circles.add(newCircle);
    }
  }
  
  void endGame() {
    gameState = 2;
    circles.clear();
  }
  
  void returnToMenu() {
    gameState = 0;
  }
  
  void updateTime() {
    timeLeft -= 1.0 / frameRate;
  }
  
  class MyCircle {
    float x, y;
    long startTime;
    
    MyCircle(float x, float y, long startTime) {
      this.x = x;
      this.y = y;
      this.startTime = startTime;
    }
    
    float getX() {
      return x;
    }
    
    float getY() {
      return y;
    }
    
    long getStartTime() {
      return startTime;
    }
  }  
}
