class MultiSection extends SectionBase {  
  private controlP5.Controller<?> m_atrasButton;
  private GameSettings m_settings;
  private Thread m_miceThread;
  private int m_nMice = 0;
  private boolean m_stop = false;
  private int m_nGameOver = 0;
  private HashMap<String, GamePlayer> m_players = new HashMap<>();
  private ArrayList<String> m_ids = new ArrayList<>();
  private Mice m_mice = new Mice();
  
  public boolean init(GameSettings settings) {
    m_settings = settings;
     if(!m_mice.tryBuild()) {
      println("Failed to init Mice-lib");
      return false;
    }
    
    m_atrasButton = settings.getCP5().getController("Atras");
    m_mice.setOnMouseAddedCallback(this::onMouseAdded);
    m_mice.setOnMouseEventCallback(this::onMouseEvent);
    m_mice.setOnMouseRemovedCallback(this::onMouseRemoved);
    
    return true;
  }
  
  private void onMouseAdded(String id) {
    m_nMice++;
    m_ids.add(id);
    
    resetMice();
  }
  
  private void onMouseRemoved(String id) {
    m_nMice--;
    m_players.remove(id);
    resetMice();
  }
  
  private void resetMice() {
    m_nGameOver = 0;
    Rect[] bounds = ComposeBounds(m_nMice, width-1, height-1);
    int i = 0;
    for(var id : m_ids) {
      addPlayer(id, bounds[i]);
      i++;
    }
  }
  
  private synchronized void addPlayer(String id, Rect bound) {
    GamePlayer player = new GamePlayer(bound.x, bound.y, bound.w, bound.h);
    player.init(m_settings);
    player.onFocus();
    player.setGameOverCallback(this::onGameOver);
    m_players.put(id, player);  
  }
  
  private void onGameOver() {
    m_nGameOver++;
    if(isGameOver()) {
      m_atrasButton.show();
      cursor();
      m_stop = true;
      try {
        m_miceThread.interrupt();
        m_miceThread.join();
      } catch(Exception e) {
        m_stop = true;
      }
    }
  }
  
  private boolean isGameOver() {
    return m_nGameOver == m_nMice;  
  }
  
  private void onMouseEvent(String id, Mouse m) {
    GamePlayer player = m_players.get(id);
    if(m.button_state == Mouse.PRESSED_STATE)
        player.mousePressed();
    
    if(!player.isGameOver()) {
      MousePlayer mousePlayer = player.getMouseRef();
      mousePlayer.setPosition(mousePlayer.getX() + round(m.x), mousePlayer.getY() + round(m.y));
    }  
  }
  
  public void onFocus() {
    reset();
    m_atrasButton.hide();
  }
  
  public void reset() {
    m_nGameOver = 0;
    m_stop = false;
    m_miceThread = new Thread(() -> {
      while(!m_stop)
        m_mice.pollEvents();
      println("Se paró correctamente");
    });
    
    m_miceThread.start();
    
    for(var player : m_players.values()) {
      if(player != null)
        player.onFocus();
    }
  }
  
  public void paint() {
    if(!isGameOver())
      confineMouse();
            
    internalPaint();
  }
  
  synchronized void internalPaint() {
    for(var it = m_players.values().iterator(); it.hasNext();) {
      GamePlayer player = it.next();
      if(player != null) {
          player.paint();
      }
    }
  }
  
  private void confineMouse() {
    MouseUtils.ConfineMouse(new Rect(getJFrame().getX() + width/2, getJFrame().getY()+37 + height/2, 1, 1));  
  }
  
  javax.swing.JFrame getJFrame() {
    return (javax.swing.JFrame)((processing.awt.PSurfaceAWT.SmoothCanvas)getSurface().getNative()).getFrame();
  }
  
  private final Rect[] ComposeBounds(int n, int width, int height) {
    switch(n) {
      case 1:
        return new Rect[] {new Rect(0, 0, width, height)};
      case 2:
        return new Rect[] {new Rect(0, 0, width/2, height), new Rect(width/2, 0, width/2, height)};
      case 3:
        return new Rect[] {new Rect(0, 0, width/2, height/2), new Rect(width/2, 0, width/2, height/2), new Rect(0, height/2, width, height/2)};
      case 4:
        return new Rect[] {new Rect(0, 0, width/2, height/2), new Rect(width/2, 0, width/2, height/2), new Rect(0, height/2, width/2, height/2), new Rect(width/2, height/2, width/2, height/2)};
      default:
        return null;
    }
  }
}
