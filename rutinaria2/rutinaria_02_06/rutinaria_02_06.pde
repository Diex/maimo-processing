import grafica.*;

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import java.util.*;  
import java.lang.Object;


import org.gicentre.utils.gui.HelpScreen;
import org.gicentre.utils.gui.Tooltip;          
import org.gicentre.utils.spatial.Direction;    // For tooltip anchor direction.
import org.gicentre.utils.stat.*;    // For chart classes.


boolean DEBUG = false;
boolean useMotors = false;
String session = ""; 

// trendingTopics
// son los objetos que almacenan un trending topic en particular
// hay siempre 5 y pueden cambiar de keyword
ArrayList <TrendingTopic> trendingTopics;
ArrayList <Trend> trendsActuales;
int maxTrends = 5;



// Tractors
// los tractors son las prepresentaciones de los trending topics
// para cada trending topic hay un tracto que lo muestra en pantalla
ArrayList<Tractor> tractors;


// Callbacks
float query = 0.0;  // ani
Ani callQueryTwitter;
int callQueryTwitterTimeout = 35;

float clearTopics = 0.0;
Ani callClearTopics;
float callClearTopicsTimeout = 5;



float textSize = 12;
PFont largeFont, smallFont;
float screenFactor = 0.0;


void setup() {       

  size(1200, 600, P3D);
  screenFactor = 1920 / width;
  smallFont = loadFont("Monospaced-48.vlw");
  if (useMotors) setupSerial();
  Ani.init(this);

  for (int c = 0; c < 8; c++) session+= (char) random(65, 90);


  startTwitter();

  trendsActuales = trendingTopics();
  trendingTopics = new ArrayList<TrendingTopic>();
  tractors = new ArrayList<Tractor>();

  float alpha = 0;
  float radius = 200;
  float angle = TWO_PI/maxTrends;

  for (int trend = 0; trend < maxTrends; trend ++) {
    try {      
      TrendingTopic t = new TrendingTopic(trendsActuales.get(trend));
      trendingTopics.add(t);
      
      // ubico los tractos formando un pentagono
      PVector vertex = new PVector(radius * cos(alpha), radius * sin(alpha));
      Tractor tr = new Tractor(this, t);
      tr.position = vertex;
      tractors.add(tr);
      alpha += angle;
    }
    catch (NullPointerException e) {
      //  todo: log
      println("problema al iniciar");
      exit();
    }
  }

  onTriggerQuery();
  onTriggerClearTopics();
  setupGraph();
} 



void draw() {
  background(255);  

  //updateSerial();

  // generate data
  updateGraphData(trendingTopics);
  // --------------------------------------------------
  // --------------------------------------------------
  // visualization
   //renderGraphData();
  // --------------------------------------------------
  // --------------------------------------------------

  // pentagon
  pushMatrix();
  translate(width/2, height/2);


  pushStyle();
  beginShape();
  stroke(0);
  strokeWeight(1); 
  noFill();
  for (int tractor = 0; tractor < tractors.size(); tractor++) {
    Tractor t = tractors.get(tractor);        
    vertex(t.position.x, t.position.y);
  }


  endShape(CLOSE);
  popStyle();

  for (int tractor = 0; tractor < tractors.size(); tractor++) {
    Tractor t = tractors.get(tractor);        
    t.render();
  }



  popMatrix();



  if (frameCount%450 == 0) saveFrame("d_"+session+"####.jpg");
}






public void itsStarted() {
}


int timesCalled = 0;
int maxCalls = 20;  // se cachea cada 5 minutos...

public void onTriggerQuery() {
  timesCalled++;
  println("timesCalled: " + timesCalled);
  if (timesCalled > maxCalls) {
    trendsActuales = trendingTopics();
    // aca tengo que comparar mis dos listas
    // para que si el orden cambió el trend se mantenga en el lugar...
    for (int trend = 0; trend < 5; trend ++) {
      //trendingTopics.get(trend).trend = trendsActuales.get(trend);
      trendingTopics.get(trend).newTrend(trendsActuales.get(trend));
    }
    timesCalled = 0;
  }

  query = 0.0;
  callQueryTwitter = new Ani(this, random(callQueryTwitterTimeout/2, callQueryTwitterTimeout*2), "query", 1.0, Ani.LINEAR, "onStart:itsStarted, onEnd:onTriggerQuery");
  searchTweetsForTt();
}


public void onTriggerClearTopics() {
  callClearTopics = new Ani(this, callClearTopicsTimeout, "clearTopics", 1.0, Ani.LINEAR, "onStart:itsStarted, onEnd:onTriggerClearTopics");
  clearTopics();
}

void clearTopics() {
  for (TrendingTopic tt : trendingTopics) {
    tt.removeOne();
  }

  if (useMotors) {
    float value = trendingTopics.get(1).load();
    if (value > 0.25) {
      float speed = map(value, 0.25, 1.0, 30, 100);
      port.write("1:"+ (int) speed +'\n');                        // Write the angle to the serial port
    }
  }
}


void searchTweetsForTt() {

  for (TrendingTopic tt : trendingTopics) {                
    println("search for: " + tt.trend.getQuery());
    List<Status> results = queryTwitter(tt.trend.getQuery(), tt.lastId());   

    println("result has: " + results.size());    
    for (int i = results.size() - 1; i >= 0; i--) {                 
      tt.addNewStatus(results.get(i));
    }
  }
}


void exit() {
  println("stoping");
  super.exit();
} 


void keyPressed() {
  if (key =='t') trendingTopics();
}
