import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import java.util.*;  


import org.gicentre.utils.gui.HelpScreen;
import org.gicentre.utils.gui.Tooltip;          
import org.gicentre.utils.spatial.Direction;    // For tooltip anchor direction.
import org.gicentre.utils.stat.*;    // For chart classes.


boolean DEBUG = false;


ArrayList <TrendingTopic> trendingTopics;
ArrayList <Trend> trendsActuales;
PFont largeFont, smallFont;
float screenFactor = 0.0;


float query = 0.0;
Ani callQueryTwitter;
int callQueryTwitterTimeout = 35;

float clearTopics = 0.0;
Ani callClearTopics;
float callClearTopicsTimeout = 5;

BarChart barChart;
User user;

void setup() {       

  size(1360, 768,P3D);
  screenFactor = 1920 / width;
  smallFont = loadFont("Monospaced-48.vlw");
  
  Ani.init(this);

  startTwitter();
  
  trendsActuales = trendingTopics();
  trendingTopics = new ArrayList<TrendingTopic>();
  for(int trend = 0; trend < 5; trend ++){
    trendingTopics.add(new TrendingTopic(trendsActuales.get(trend)));
  }
  
  onTriggerQuery();
  onTriggerClearTopics();
  
  barChart = new BarChart(this);
  barChart.setMinValue(0);
  barChart.setMaxValue(1.0);     
  barChart.showValueAxis(true);
  barChart.showCategoryAxis(true);
  
  
} 

int timesCalled = 0;
int maxCalls = 20;  // se cachea cada 5 minutos...

public void itsStarted() {
}


public void onTriggerQuery() {
  
  timesCalled++;
  println("timesCalled: " + timesCalled);
  if(timesCalled > maxCalls){
    trendsActuales = trendingTopics();
    // aca tengo que comparar mis dos listas...
     for(int trend = 0; trend < 5; trend ++){
        trendingTopics.get(trend).trend = trendsActuales.get(trend);
    }
    timesCalled = 0;
    
  }
  query = 0.0;
  callQueryTwitter = new Ani(this, random(callQueryTwitterTimeout/2,callQueryTwitterTimeout*2), "query", 1.0, Ani.LINEAR, "onStart:itsStarted, onEnd:onTriggerQuery");
  searchTweetsForTt();
}


public void onTriggerClearTopics() {
  
  callClearTopics = new Ani(this, callClearTopicsTimeout, "clearTopics", 1.0, Ani.LINEAR, "onStart:itsStarted, onEnd:onTriggerClearTopics");
  clearTopics();
}

void clearTopics(){
  for(TrendingTopic tt : trendingTopics){
    tt.removeOne();
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
  
  float values[] = new float[trendingTopics.size()];
  String labels[] = new String[trendingTopics.size()];  
  for (int i = 0; i < values.length; i++) {
    TrendingTopic tt = trendingTopics.get(i);
    tt.update();
    values[i] = tt.load();
    labels[i] = tt.label(); 
  }
  
  barChart.setBarLabels(labels);
  barChart.setData(values);  
  barChart.draw(0, 0, width/2, height/4);
  fill(255,0,0);
  noStroke();
  rect(0, height/4 + 10,width/2 * query , 2);
}

void keyPressed() {
  //if (key ==' ') queryTwitter();
  if (key =='t') trendingTopics();
}
