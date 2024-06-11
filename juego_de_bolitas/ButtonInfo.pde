// Clase que llevará información de los diferentes botones de nuestro juego.
class ButtonInfo {    
    public final String name;
    public final int x, y;
    
    private final SectionBase m_section;
    
    public ButtonInfo(String name, int x, int y, SectionBase section) {
      this.name = name;
      this.x = x;
      this.y = y;
      m_section = section;
    }
   
    public SectionBase getSectionRef() {return m_section;}
}
