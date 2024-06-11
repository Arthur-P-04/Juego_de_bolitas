import controlP5.*;
import ddf.minim.*;

class GameSettings {
  private final ControlP5 m_cp5;
  private final PFont m_font;
  private final Minim m_audioPlayer;
  
  public color labelColorBackground;
  public color labelColorForeground;
  public color labelColorActive;
  public color captionLabelColor;
  
  private GameSettings(PApplet parent) {   
    m_cp5 = new ControlP5(parent);
    m_font = parent.createFont("Vermin Vibes 1989.ttf", 48);
    m_audioPlayer = new Minim(parent);
  }
  
  public ControlP5 getCP5() {return m_cp5;}
  public PFont getFont() {return m_font;}
  public Minim getPlayer() {return m_audioPlayer;}
  public int getMaxVolume() {return 100;}
}
