import org.gicentre.utils.gui.HelpScreen;
import org.gicentre.utils.gui.Tooltip;          
import org.gicentre.utils.spatial.Direction;    // For tooltip anchor direction.



Tooltip tip;
PFont largeFont, smallFont;

void setup(){
  size(1280, 720);
  smallFont = loadFont("Monospaced-48.vlw");
  
  tip = new Tooltip(this,smallFont,12,200);
  tip.setText("This is an example of a tooltip that should fit the text inside its user-defined width");
  tip.setAnchor(Direction.SOUTH_WEST);
  tip.setIsCurved(true);
  tip.showPointer(true);

}


void draw(){
  background(0);
  tip.draw(mouseX,mouseY);
}
