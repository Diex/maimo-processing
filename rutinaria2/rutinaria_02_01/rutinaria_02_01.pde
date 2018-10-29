import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import java.util.*;  


import org.gicentre.utils.gui.HelpScreen;
import org.gicentre.utils.gui.Tooltip;          
import org.gicentre.utils.spatial.Direction;    // For tooltip anchor direction.




Tractor t;
TrendingTopic tt;

String [] trendsActuales;



PFont largeFont, smallFont;
float screenFactor = 0.0;


float dummy = 0;
Ani callQueryTwitter;
int callQueryTwitterTimeout = 20;

void setup() {       
  
  size(1360, 768);
  screenFactor = 1920 / width;
  smallFont = loadFont("Monospaced-48.vlw");


  
  startTwitter();
  trendsActuales = trendingTopics();
  //printArray(trendsActuales);

  
  // Ani.init() must be called always first!
  Ani.init(this);
  

  t = new Tractor(this, smallFont);
  tt = new TrendingTopic(trendsActuales[0]);
  
  onTriggerQuery();
  
} 

int timesCalled = 0;

public void itsStarted(){

}


public void onTriggerQuery(){
  timesCalled++;
  println("timesCalled: " + timesCalled);
  callQueryTwitter = new Ani(this, callQueryTwitterTimeout, "dummy", 1.0, Ani.LINEAR, "onStart:itsStarted, onEnd:onTriggerQuery");
  query();
}



void query(){
  
  List<Status> tt0 = queryTwitter(tt.keyword);
  for(Status st : tt0){
    println(st.getId());
  }

}

void exit() {
  println("stoping");
  //twitterStream.shutdown();
  String[] lines = (String[]) t.lines.toArray(new String[0]);
  saveStrings("lines.txt", lines);
  super.exit();
} 

void draw() {
  background(random(255));
  t.render(width/2, height/2, 200 * screenFactor);
}

void keyPressed() {
  //if (key ==' ') queryTwitter();
  if (key =='t') trendingTopics();
}
