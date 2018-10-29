import processing.core.*;
import java.util.*;
import twitter4j.*; 

import org.gicentre.utils.stat.*;    // For chart classes.


import org.gicentre.utils.gui.HelpScreen;
import org.gicentre.utils.gui.Tooltip;          
import org.gicentre.utils.spatial.Direction;    // For tooltip anchor direction.


class Tractor {

  String topic;
  int maxTweets = 100;

  ArrayList<PVector> nodes = new ArrayList<PVector>();
  ArrayList<Tooltip> tips = new ArrayList<Tooltip>();
  ArrayList<String> lines = new ArrayList<String>();

  float carrouselSpeed = 0.01f;

  PFont smallFont;
  PApplet parent;
  BarChart barChart;
  PVector position = new PVector(200, 200);
  
  Tractor(PApplet pa, PFont font) {
    this.parent = pa;
    barChart = new BarChart(parent);
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



  public void render(ArrayList<Status> list) {
   // parent.println(list.size());
    barChart.setData(new float[] {list.size()});
    barChart.draw(position.x, position.y, 10, 100);
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
}
