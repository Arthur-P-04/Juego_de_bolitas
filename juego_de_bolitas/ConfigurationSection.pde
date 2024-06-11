// Sección en donde se configurará el volumen del juego
class ConfigurationSection extends SectionBase {
  private int m_maxVolume;
  private int m_currentVolume = 80;
  private AudioPlayer m_music;
  
  public boolean init(GameSettings settings) {
    if((m_music = settings.getPlayer().loadFile("Game.mp3")) == null) {
       println("Error al iniciar música");
       return false; 
    }
    m_maxVolume = settings.getMaxVolume();
    
    clampMusicVolume();
    m_music.loop();
    return true;  
  }
  
  private void clampMusicVolume() {
   m_music.setGain(map(m_currentVolume, 0, m_maxVolume, -40, 0)); 
  }
  
  public void paint() {
    background(0);
    fill(255);
    textSize(30);
    textAlign(CENTER);
    text(String.format("PRESIONE '+' y '-' PARA MANEJAR EL VOLUMEN\nVOLUMEN: %d", m_currentVolume), width/2, height/2);
  }
  
  public void keyPressed() {
     if (key == '+')
       m_currentVolume = min(m_currentVolume + 1, m_maxVolume);
     else if (key == '-')
       m_currentVolume = max(m_currentVolume - 1, 0);
    
     clampMusicVolume();
  }
}
