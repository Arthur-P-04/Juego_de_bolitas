abstract class SectionBase {
  public abstract boolean init(GameSettings settings);
  public abstract void paint();
  public void onFocus() {}
  public void keyPressed() {}
  public void mousePressed() {}
}
