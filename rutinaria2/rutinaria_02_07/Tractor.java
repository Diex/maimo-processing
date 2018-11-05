import processing.core.*;
import java.util.*;
import twitter4j.*; 



import org.gicentre.utils.gui.HelpScreen;
import org.gicentre.utils.gui.Tooltip;          
import org.gicentre.utils.spatial.Direction;    // For tooltip anchor direction.


class Tractor {

  String topic;
  int maxTweets = 100;
  public PVector position = new PVector(0, 0);
  float carrouselSpeed = 0.01f;





  PApplet parent;
  TrendingTopic tt;
  PFont smallFont;




  float alpha = 0.0f;
  float size = 100;

  Tooltip tip;

  Tractor(PApplet pa, TrendingTopic tt) {
    this.parent = pa;
    this.tt = tt;
    smallFont = parent.loadFont("Univers-Black-Normal-48.vlw");


    tip = new Tooltip(pa, smallFont, 14, 300);
    tip.setBackgroundColour(parent.color(245,239,44));
    tip.setTextColour(0);
    tip.setAnchor(Direction.SOUTH_WEST);
    tip.setIsCurved(true);
    tip.showPointer(true);
  }




  public void render() {
    alpha += carrouselSpeed * tt.load() * tt.direction();

    parent.pushStyle();
    parent.rectMode(PConstants.CENTER);
    parent.ellipseMode(PConstants.CENTER);

    parent.fill(0, 255, 0);
    parent.stroke(0, 255, 0);

    //int maxFavs = tt.getMaxFavs();
    int maxRt = tt.getMaxRt() == 0 ? 1 : tt.getMaxRt();

    parent.pushMatrix();

    parent.translate(position.x, position.y);
    parent.textSize(12);
    
    parent.pushMatrix();
    parent.rotate(alpha);
    
    renderTweets();
  
    renderTractorInfluence();
    
    
    TweetView one = getTweet();
    if (one != null) {
      tip.setText(one.st.getText());
      parent.rotateZ(-currentZ);
      parent.rotateX(-parent.radians(80));
      tip.draw(one.pos.x * size, one.pos.y * size);
    }
    parent.popMatrix();
    parent.popStyle();
  }

float currentZ = 0;
  void setZrotation(float z){
    currentZ = z;
  }
  
  
  int getColor(int[] col){
    return parent.color(col[0], col[1], col[2], col[3]);
  }
  TweetView currentDisplay;

  public TweetView getTweet() {
    if (tt.list.size() == 0) return null;
    if (currentDisplay == null) currentDisplay = tt.list.get((int) parent.random(tt.list.size())); 
    if (parent.random(1000) < 4) currentDisplay = tt.list.get((int) parent.random(tt.list.size()));

    return currentDisplay;
  }
  
  void renderTweets(){
     for (int tweet = 0; tweet < tt.list.size(); tweet++) {      
      TweetView st = tt.list.get(tweet);            
      parent.pushMatrix();
      parent.pushStyle();
      //parent.fill(getColor(st.fill));
      parent.fill(getColor(st.stroke)); parent.sphereDetail(10);
      //parent.stroke(getColor(st.stroke)); parent.strokeWeight(0.1f);
      parent.noStroke();
      parent.translate(st.pos.x * size, st.pos.y* size,st.pos.z* size); 
      parent.sphere(st.radius*size*0.1f);
      parent.popStyle();
      parent.popMatrix();

      // TODO darle vida
      parent.stroke(127, 127);
      parent.line(st.pos.x* size, st.pos.y* size, st.pos.z* size, 0, 0,0);
      
    }
   
  }
  
  void renderTractorInfluence(){
    parent.noFill();
    parent.stroke(255, 0, 0);    
    parent.ellipse(0, 0, tt.load() * 4 * size, tt.load() * 4 * size);
    parent.popMatrix();
    
  }
}
