import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import java.util.*;  


import org.gicentre.utils.gui.HelpScreen;
import org.gicentre.utils.gui.Tooltip;          
import org.gicentre.utils.spatial.Direction;    // For tooltip anchor direction.
import org.gicentre.utils.stat.*;    // For chart classes.


boolean DEBUG = false;
boolean useMotors = false;

// trendingTopics
// son los objetos que almacenan un trending topic en particular
// hay siempre 5 y pueden cambiar de keyword
ArrayList <TrendingTopic> trendingTopics;
ArrayList <Trend> trendsActuales;


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




BarChart barChart;
XYChart lineChart;


float [] xsamples = new float[1000];



void setup() {       

  size(1200, 600, P3D);
  screenFactor = 1920 / width;
  smallFont = loadFont("Monospaced-48.vlw");
  if (useMotors) setupSerial();
  Ani.init(this);

  startTwitter();

  trendsActuales = trendingTopics();
  trendingTopics = new ArrayList<TrendingTopic>();
  for (int trend = 0; trend < 5; trend ++) {
    // null pointer
    trendingTopics.add(new TrendingTopic(trendsActuales.get(trend)));
  }

  onTriggerQuery();
  onTriggerClearTopics();

  barChart = new BarChart(this);
  barChart.setMinValue(0);
  barChart.setMaxValue(1.0);     
  barChart.showValueAxis(true);
  barChart.showCategoryAxis(true);
  
  lineChart = new XYChart(this);
  for(int i = 0; i < 1000; i++){
    xsamples[i] = i;
  }
  
  // Axis formatting and labels.
  lineChart.showXAxis(true); 
  lineChart.showYAxis(true); 
  lineChart.setMinY(0);
  lineChart.setMaxY(TrendingTopic.MAX);
     
  lineChart.setYFormat("###,###");  // Monetary value in $US
  lineChart.setXFormat("0000");      // Year
   
  // Symbol colours
  lineChart.setPointColour(color(180,50,50,100));
  lineChart.setPointSize(1);
  lineChart.setLineWidth(1);
  
  
} 

int timesCalled = 0;
int maxCalls = 20;  // se cachea cada 5 minutos...

public void itsStarted() {
}


public void onTriggerQuery() {

  timesCalled++;
  println("timesCalled: " + timesCalled);
  if (timesCalled > maxCalls) {
    trendsActuales = trendingTopics();
    // aca tengo que comparar mis dos listas...
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


 


void draw() {
  background(255);  
  
  //updateSerial();

  // generate data
  float values[] = new float[trendingTopics.size()];
  String labels[] = new String[trendingTopics.size()];    
  
  float history [] = new float[1000];
  
  for (int i = 0; i < values.length; i++) {
    TrendingTopic tt = trendingTopics.get(i);
    tt.update();
    values[i] = tt.load();
    labels[i] = tt.label();
    if(i == 0){
      System.arraycopy(tt.count, 0, history, 0, 1000);
    }
  }
  
  
  
  lineChart.setData(xsamples,history);
  // --------------------------------------------------
  // --------------------------------------------------
  // visualization
  pushMatrix();
  translate(100, 100);
  //scale(.5,.5);
  // draw
  barChart.setBarLabels(labels);
  barChart.setData(values);  
  textSize(textSize);
  float heightSpace = height/4;
  barChart.draw(0, 0, width/2, heightSpace);
  
  // barra
  fill(255, 0, 0);
  noStroke();
  rect(0, heightSpace + 10, width/2 * query, 2);
  
  lineChart.draw(0,heightSpace+50,width/2,heightSpace);  
  popMatrix();
  // --------------------------------------------------
  // --------------------------------------------------
  
  
  //for (int tractor = 0; tractor < 
  
  
  
  if(frameCount%1800 == 0) saveFrame("data_02_####.jpg");

}

void keyPressed() {
  if (key =='t') trendingTopics();
}
