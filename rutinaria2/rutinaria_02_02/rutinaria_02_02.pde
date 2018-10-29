import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import java.util.*;  


import org.gicentre.utils.gui.HelpScreen;
import org.gicentre.utils.gui.Tooltip;          
import org.gicentre.utils.spatial.Direction;    // For tooltip anchor direction.




Tractor t;
ArrayList <TrendingTopic> trendingTopics;

String [] trendsActuales;



PFont largeFont, smallFont;
float screenFactor = 0.0;


float dummy = 0;
Ani callQueryTwitter;
int callQueryTwitterTimeout = 5;

void setup() {       

  size(1360, 768);
  screenFactor = 1920 / width;
  smallFont = loadFont("Monospaced-48.vlw");

  trendingTopics = new ArrayList<TrendingTopic>();


  startTwitter();
  trendsActuales = trendingTopics();
  //printArray(trendsActuales);


  // Ani.init() must be called always first!
  Ani.init(this);


  t = new Tractor(this, smallFont);
  trendingTopics.add(new TrendingTopic(trendsActuales[0]));
  onTriggerQuery();
} 

int timesCalled = 0;

public void itsStarted() {
}


public void onTriggerQuery() {
  timesCalled++;
  println("timesCalled: " + timesCalled);
  callQueryTwitter = new Ani(this, callQueryTwitterTimeout, "dummy", 1.0, Ani.LINEAR, "onStart:itsStarted, onEnd:onTriggerQuery");
  query();
}



void query() {

  for (TrendingTopic tt : trendingTopics) {                // para un tt
    println("tw query for: " + tt.keyword);
    List<Status> list = queryTwitter(tt.keyword);           // busco los st   
    println("list has: " + list.size());
    
    for (int i = list.size() - 1; i >= 0; i--) {                                //      
      Status st = list.get(i);
      println(st.getId());
      if (tt.isNewStatus(st)) tt.addNewStatus(st);          // si hay uno nuevo lo agrego:
    
    }
    println("tt has: " + tt.list.size() + " statuses");
  }
}

void exit() {
  println("stoping");
  String[] lines = (String[]) t.lines.toArray(new String[0]);
  saveStrings("lines.txt", lines);
  super.exit();
} 

void draw() {
  background(127);  
  t.render(trendingTopics.get(0).list);
}

void keyPressed() {
  //if (key ==' ') queryTwitter();
  if (key =='t') trendingTopics();
}
