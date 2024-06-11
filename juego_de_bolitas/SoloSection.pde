class SoloSection extends SectionBase {
  private GamePlayer m_player;
  private controlP5.Controller<?> m_atrasButton;
  private boolean m_firstMouseEvent = false;
  
  public boolean init(GameSettings settings) {
    m_player = new GamePlayer(0, 0, width-1, height-1);
    m_player.init(settings);
    m_player.setGameOverCallback(this::onGameOver);
    m_atrasButton = settings.getCP5().getController("Atras");
    
    return true;  
  }
  
  private void onGameOver() {
    cursor();
    m_atrasButton.show();
  }
  
  public void paint() {
    if(!m_player.isGameOver())
      m_player.getMouseRef().setPosition(mouseX, mouseY);
    m_player.paint();
  }
  
  public void mousePressed() {
    // Ignorar el primer evento del mouse
    if(!m_firstMouseEvent) {
      m_firstMouseEvent = true;
      return;
    }
    m_player.mousePressed();
  }
  
  public void onFocus(){
    m_player.onFocus();
    m_atrasButton.hide();
    m_firstMouseEvent = false;
  }
}
