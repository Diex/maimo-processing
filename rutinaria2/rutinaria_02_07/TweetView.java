import processing.core.*;
import java.util.*;
import twitter4j.*; 
import java.util.Random;

class TweetView{
  Status st;
  float alpha;
  float radius;
  PVector pos;
  boolean isOn = false;
  static Random rand;
    
  int fill[] = {186,191,193, 255};
  int stroke[] = {201,0,255, 255};
  
  public TweetView(Status st, float maxRt){
    this.st = st;
    if(rand == null) rand = new Random();    
    
    alpha = PApplet.radians((st.getId() % 360) * 1.0f); // un angulo a partir del ID                
    radius = PApplet.map(st.getRetweetCount() * 1.0f, 0, maxRt, 0.f, 1.0f);  
    
    pos = new PVector(  PApplet.cos(alpha)*radius, 
                        PApplet.sin(alpha)*radius, 
                        PApplet.sin(PApplet.map(rand.nextFloat(), 0.2f,1.f, -PConstants.PI, PConstants.PI)) *radius );
    
  }
  
  String getImageURL(){
  
    return st.getUser().getProfileImageURL();
  }
  
  PImage profileImage;
  
  PImage getImage(){
    return profileImage;
  }
  
  void setImage(PApplet p){
    
    if(profileImage == null) {      
      profileImage = p.loadImage(getImageURL());
    }else{
      
    }
  }
  
  
      
  

}
