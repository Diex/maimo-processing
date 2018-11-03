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
  float size = 50;
  
  
  Tractor(PApplet pa, TrendingTopic tt) {
    this.parent = pa;
    this.tt = tt;
    smallFont = parent.loadFont("Univers-Black-Normal-48.vlw");
  }



  
  public void render() {
    alpha += carrouselSpeed*tt.load()*tt.direction();
    parent.pushStyle();
    parent.rectMode(PConstants.CENTER);
    parent.ellipseMode(PConstants.CENTER);
    
    parent.fill(0,255,0);
    parent.stroke(0,255,0);
    
    //int maxFavs = tt.getMaxFavs();
    int maxRt = tt.getMaxRt() == 0 ? 1 : tt.getMaxRt();
    
    parent.pushMatrix();
    
    parent.translate(position.x, position.y);
    parent.textSize(12);
    parent.rotate(alpha);
    for(int tweet = 0; tweet < tt.list.size(); tweet++){      
      TweetView st = tt.list.get(tweet);      
      parent.ellipse(st.pos.x * size, st.pos.y* size, 0.1f*size, 0.1f*size);
      parent.stroke(127,127);
      parent.line(st.pos.x* size, st.pos.y* size, 0, 0);
      if(st.isOn) {
        // random
      }
    }
    
    parent.noFill();
    parent.stroke(255, 0,0);    
    parent.ellipse(0, 0, tt.load() * 4 * size, tt.load() * 4 * size);
    
    parent.popMatrix();
    parent.popStyle();
  }
  
  public TweetView getTweet(){
    if(tt.list.size() == 0) return null;
    return tt.list.get(0);            
  }

}
