import processing.core.*;
import java.util.*;
import twitter4j.*; 



import org.gicentre.utils.gui.HelpScreen;
import org.gicentre.utils.gui.Tooltip;          
import org.gicentre.utils.spatial.Direction;    // For tooltip anchor direction.


class Tractor {

  String topic;
  int maxTweets = 100;

  //ArrayList<PVector> nodes = new ArrayList<PVector>();
  //ArrayList<Tooltip> tips = new ArrayList<Tooltip>();
  //ArrayList<String> lines = new ArrayList<String>();
  public PVector position = new PVector(0, 0);
  float carrouselSpeed = 0.01f;





  PApplet parent;
  TrendingTopic tt;
  PFont smallFont;

  Tractor(PApplet pa, TrendingTopic tt) {
    this.parent = pa;
    this.tt = tt;

    smallFont = parent.loadFont("Univers-Black-Normal-48.vlw");
    //for (int i = 0; i < maxTweets; i++) {
    //  nodes.add(new PVector(parent.random(1.0f), parent.random(PConstants.TWO_PI)));  // radio y angulo inicial
    //}
  }



  void render(float x, float y, float rad) {
    //for (int tip = 0; tip < tips.size(); tip++) {      
    //  Tooltip t = tips.get(tip);
    //  float radius = nodes.get(tip).x;
    //  float angle = nodes.get(tip).y;
    //  t.draw(x + PApplet.cos(alpha+angle) * radius * rad, y + PApplet.sin(alpha+angle)  * radius * rad);
    //}
  }


  float alpha = 0.0f;
  float centerWeight = 10;
  
  public void render() {
    alpha += carrouselSpeed;
    centerWeight = tt.load() * 100;
    parent.pushStyle();
    parent.rectMode(PConstants.CENTER);
    parent.rect(position.x, position.y, centerWeight, centerWeight);
    
    
    parent.popStyle();
  }


  public void onStatus(Status status) {
    //System.out.println("@" + status.getUser().getScreenName() + " - " + status.getText());
    PApplet.println(status.getText());
    //lines.add(status.getText());

    Tooltip tip = new Tooltip(parent, smallFont, 6, 200);
    tip.setText(status.getText());
    tip.setAnchor(Direction.SOUTH_WEST);
    tip.setIsCurved(true);
    tip.showPointer(true);
    //tips.add(tip);


    //tweets.add(status.getText());
  }
}
