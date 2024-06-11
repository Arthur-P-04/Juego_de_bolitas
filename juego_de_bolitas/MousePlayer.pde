class MousePlayer {
  private int m_x, m_y;
  private final Rect m_bounds;
  public MousePlayer(int x, int y, Rect bounds) {
    m_x = x;
    m_y = y;
    
    m_bounds = bounds;
  }
  
  public void paint() {
    fill(255);
    noStroke();
    rect(m_x-5, m_y, 12, 2);
    rect(m_x, m_y-5, 2, 12);
  }
  
  public void setPosition(int x, int y) {
    m_x = constrain(x, m_bounds.x, m_bounds.x + m_bounds.w - 6);
    m_y = constrain(y, m_bounds.y, m_bounds.y + m_bounds.h);
  }
  
  public int getX() {return m_x;}
  public int getY() {return m_y;}
}
