import processing.core.*;
import java.util.*;
import twitter4j.*; 

import org.gicentre.utils.gui.HelpScreen;
import org.gicentre.utils.gui.Tooltip;          
import org.gicentre.utils.spatial.Direction;    // For tooltip anchor direction.


class Tractor implements StatusListener {

  String topic;
  int maxTweets = 100;

  ArrayList<PVector> nodes = new ArrayList<PVector>();
  ArrayList<Tooltip> tips = new ArrayList<Tooltip>();
  ArrayList<String> lines = new ArrayList<String>();
  
  float carrouselSpeed = 0.01f;

  PFont smallFont;
  PApplet parent;
  Tractor(PApplet pa, PFont font) {
    this.parent = pa;
    smallFont = font;  
    for (int i = 0; i < maxTweets; i++) {
      nodes.add(new PVector(parent.random(1.0f), parent.random(PConstants.TWO_PI)));  // radio y angulo inicial
    }
  }

  float alpha = 0.0f;
  void render(float x, float y, float rad) {
    alpha += carrouselSpeed;
    for (int tip = 0; tip < tips.size(); tip++) {      
      Tooltip t = tips.get(tip);
      
      float radius = nodes.get(tip).x;
      float angle = nodes.get(tip).y;
      t.draw(x + PApplet.cos(alpha+angle) * radius * rad, y + PApplet.sin(alpha+angle)  * radius * rad);
    }
  }


  public void onStatus(Status status) {
    //System.out.println("@" + status.getUser().getScreenName() + " - " + status.getText());
    PApplet.println(status.getText());
    lines.add(status.getText());

    Tooltip tip = new Tooltip(parent, smallFont, 6, 200);
    tip.setText(status.getText());
    tip.setAnchor(Direction.SOUTH_WEST);
    tip.setIsCurved(true);
    tip.showPointer(true);
    tips.add(tip);


    //tweets.add(status.getText());
  }

  public void onStallWarning(StallWarning sw) {
    System.out.println(sw);
  }
  public void onException(Exception e) {
    System.out.println(e.getStackTrace());
    e.printStackTrace();
  }
  public void onTrackLimitationNotice(int notice) {
    System.out.println(notice);
  }

  public void onDeletionNotice(StatusDeletionNotice sdl) {
    System.out.println(sdl);
  }
  public void onScrubGeo(long a, long b) {
    System.out.println(a+":"+b);
  }
}
