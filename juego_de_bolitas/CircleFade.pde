interface FadeInOutCallback {
  void onFadeInOut(CircleFade circle);  
}

// Circulo que irá apareciendo y desapareciendo
class CircleFade {
  public float x, y;
  public float radius;
  public color fillColor;
  public float increment = 1;
  
  private float m_alpha;
  private FadeInOutCallback m_callback;
  private float m_direction = 1;
  
  public void setCallback(FadeInOutCallback callback) {m_callback = callback;}
  
  public void paint() {
    noStroke();
    fill(red(fillColor), green(fillColor), blue(fillColor), m_alpha);
    circle(x, y, radius);
    m_alpha += m_direction * increment;
    
    if(m_alpha >= 255 || m_alpha <= 0)
      changeDirection();
    if(m_alpha <= 0)
      fadeInOutCompleted();
  }
  
  private void changeDirection() {
    m_direction = -m_direction;  
  }
  
  private void fadeInOutCompleted() {
    if(m_callback != null)
      m_callback.onFadeInOut(this);
  }
}
