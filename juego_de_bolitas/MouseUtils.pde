import java.awt.*;

static class MouseUtils {
  private static Robot s_bot;
  
  static {
    try {
    s_bot = new Robot();  
    } catch(AWTException e) {
      println("Failed to create Robot");
    }
  }
  
  static void ConfineMouse(Rect bounds) {
    var globalMousePos = MouseInfo.getPointerInfo().getLocation();
   
    s_bot.mouseMove(constrain(globalMousePos.x, bounds.x, bounds.x+bounds.w), constrain(globalMousePos.y, bounds.y, bounds.y + bounds.h));
  }
}
