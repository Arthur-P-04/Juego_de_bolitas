class GameApp {
  private final GameSettings m_settings;
  private final ButtonInfo[] m_buttonInfos = new ButtonInfo[] {
    new ButtonInfo("Atras", 90, 20, null), // Boton especial
    new ButtonInfo("Jugar", width/2, 110, new SoloSection()),
    new ButtonInfo("Modo VS", width/2, 180, new MultiSection()),
    new ButtonInfo("Precision", width/2, 250, new PrecisionSection()),
    new ButtonInfo("Velocidad", width/2, 320, new VelocidadSection()),
    new ButtonInfo("Configuracion", width/2, 390, new ConfigurationSection())
  };
  private final ArrayList<CircleFade> m_circles = new ArrayList<>();
  private SectionBase m_actualSection;
  
  public GameApp(GameSettings settings) {
     m_settings = settings;
     
     for(int i = 0; i < 100; ++i) {
       CircleFade circle = new CircleFade();
       circle.setCallback(this::updateCircle);
       updateCircle(circle);
       m_circles.add(circle);
     }
  }
  
  private void updateCircle(CircleFade circle) {
    circle.x = random(0, width);
    circle.y = random(0, height);
    circle.increment = random(100, 300) / 100f;
    circle.radius = random(20, 100);
    circle.fillColor = color(random(0, 255), random(0, 255), random(0, 255));
  }
  
  public boolean init() {    
    if(!initSections()) return false;
    
    return true;  
  }
  
   private boolean initSections() {   
    final ControlP5 cp5 = m_settings.getCP5();
    final PFont fuente = m_settings.getFont();
   
    textFont(fuente);
    for(ButtonInfo buttonInfo : m_buttonInfos) {
      final int w = (int)textWidth(buttonInfo.name);
      final int h = (int)(textAscent() + textDescent());
     
      cp5.addButton(buttonInfo.name)
        .addCallback(this::controlEvent)
        .setPosition(buttonInfo.x-w/2, buttonInfo.y)
        .setSize(w+10, h+10)
        .setFont(fuente)
        .setColorBackground(m_settings.labelColorBackground)
        .setColorForeground(m_settings.labelColorForeground)
        .setColorActive(m_settings.labelColorActive)
        .getCaptionLabel().setColor(m_settings.captionLabelColor);
       
      if(buttonInfo.getSectionRef() != null && !buttonInfo.getSectionRef().init(m_settings)) return false;
    }

    // Esconder el botón "Atrás" inicialmente
    cp5.getController("Atras").hide();
   
    return true;
  }
 
   private void controlEvent(CallbackEvent event) {
       String nameButton = event.getController().getName();
       if(event.getAction() == ControlP5.ACTION_CLICK) {
         if(nameButton.equals("Atras")) {
           changeSection(null);
         } else {
           for(ButtonInfo buttonInfo : m_buttonInfos) {
             if(buttonInfo.name.equals(nameButton)) { 
               changeSection(buttonInfo.getSectionRef());
               break;
             }
           }
         }
       }   
  }
  
  private void changeSection(SectionBase section) {
    if(section == null) {
      showButtons();
      m_settings.getCP5().getController("Atras").hide();
    } else { 
      hideButtons();
      m_settings.getCP5().getController("Atras").show();
      section.onFocus();
    }
    
    m_actualSection = section;
  }
  
  private void showButtons() {
    ControlP5 cp5 = m_settings.getCP5();
    for(ButtonInfo button : m_buttonInfos)
      cp5.getController(button.name).show();
  }
  

  private void hideButtons() {
    ControlP5 cp5 = m_settings.getCP5();
    // Borrar los botones del menú
    for(ButtonInfo buttonInfo : m_buttonInfos)
      cp5.getController(buttonInfo.name).hide();
  }
 
  public void paint() {
    background(0);
    
    if(m_actualSection != null) {
      m_actualSection.paint();
    } else {
      for(var circle : m_circles)
        circle.paint();
    }
  }
  
  public void keyPressed() {
    if(m_actualSection != null)
      m_actualSection.keyPressed();
  }
  
  public void mousePressed() {
    if(m_actualSection != null)
      m_actualSection.mousePressed();
  }
}
