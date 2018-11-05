import processing.core.*;
import java.util.*;
import twitter4j.*; 


class TweetView{
  Status st;
  float alpha;
  float radius;
  PVector pos;
  boolean isOn = false;
  
  public TweetView(Status st, float maxRt){
    this.st = st;
    alpha = PApplet.radians((st.getId() % 360) * 1.0f); // un angulo a partir del ID            
    radius = PApplet.map(st.getRetweetCount() * 1.0f, 0, maxRt, 0.f, 1.0f);    
    pos = new PVector(PApplet.cos(alpha)*radius, PApplet.sin(alpha)*radius, PApplet.sin(alpha) *radius );
    
  }
  
  
      
  

}
