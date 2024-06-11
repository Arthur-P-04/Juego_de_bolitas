interface GameOverCallback {
  void onGameOver();  
}

class GamePlayer extends SectionBase {
  private int x, y;
  private int w, h;
  private final MousePlayer m_mouse;
  private GameOverCallback m_callback;
  private PGraphics balls;
  private AudioSample disparo;
  private AudioSample jumpscare;
   
  int jugar = 1;
  int repita = 1;
  int tamaño = 35;
  int puntos = 0;
  int posX = 0;
  int posY = 0;
  int last = 0;
  
  public GamePlayer(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    m_mouse = new MousePlayer(x+w/2, y+h/2, new Rect(x, y, w, h));
  }
  
  public boolean init(GameSettings settings) {
    balls = createGraphics(w, h);
    if((disparo = settings.getPlayer().loadSample("tor.mp3", 1024)) == null)
      return false;
    if((jumpscare = settings.getPlayer().loadSample("opo.mp3", 1024)) == null)
      return false;
    
    return true;
  }
  
  private void reset() {
    jugar = 1;
    repita = 1;
    tamaño = 35;
    puntos = 0;
    posX = 0;
    posY = 0;
    last = millis(); 
    
    createBalls();
  }
  
  public void setGameOverCallback(GameOverCallback callback) {
    m_callback = callback;
  }
  private void onGameOver() {
    if(m_callback != null)  
      m_callback.onGameOver();
  }
  
  public void onFocus() {
    noCursor();
    reset();
  }
  
  private void createBalls() {
    balls.beginDraw();
    balls.background(0, 0, 0, 0);
    // balls.sphere(CENTER);
    
    // para despitar al jugador 
    for(int i = 0; i<=puntos;i++)
    {
      balls.fill(floor(random(0,254)),floor(random(0,255-i*10)),floor(random(0,255-i*10)));
      balls.ellipse(floor(random(50, w - 50)),floor(random(100, h - 50)),tamaño,tamaño);
      balls.rect(floor(random(50, w - 50)), floor(random(100, h - 50)), tamaño,tamaño);
    }
    //objeto
    posX = floor(random(50, w - 50));
    posY = floor(random(50, h - 50));
    balls.fill(255,0,0);
    balls.ellipse(posX,posY,tamaño,tamaño);
    
    balls.endDraw();
  }
  
  private int getCurrentTime() {
    return (int)(millis() - last)/1000;  
  }
  
  public void paint() {
    stroke(255);
    noFill();
    rect(x, y, w, h);
    image(balls, x, y);
    
    fill(#44B2FA);
    textAlign(LEFT);
    textSize(18);
    text("Tiempo: " + getCurrentTime(), width-100, 20);
    
    //score
    fill(#2D00FF);
    textAlign(CENTER);
    textSize(20);
    text("Score: " + (puntos), x + 50, y + h*0.9);
    
    m_mouse.paint(); 
  }
  
  public boolean isGameOver() {
    return jugar == 0;  
  }
  
  public MousePlayer getMouseRef() {
    return m_mouse;
  }
 
  public void mousePressed() {
    if(!isInside())
      return;
    
    int mX = getMouseRef().getX();
    int mY = getMouseRef().getY();
    
    if (jugar == 1)
    {
      if (repita == 0)
      {
        repita=1;
      }
      if(dist(x + posX, y + posY, mX, mY) <= 15)
      {
        puntos+=1;
        createBalls();
        disparo.trigger();
      }
      else
      {
        jugar=0;
        //GAME OVER
        balls.beginDraw();
        
        balls.fill(255, 0, 0);
        balls.textAlign(CENTER);
        balls.textSize(20);
        balls.text("GAME OVER: tus puntos fueron " + puntos + "\nen un tiempo de " + getCurrentTime() + " segundos", w/2, 30);
          jumpscare.trigger();
        balls.endDraw();
        
        onGameOver();
      }
    }
  }
  
  private boolean isInside() {
    int mX = getMouseRef().getX();
    int mY = getMouseRef().getY();
    return mX >= x && mX <= x + w && mY >= y && mY <= y + h;  
  }
}
