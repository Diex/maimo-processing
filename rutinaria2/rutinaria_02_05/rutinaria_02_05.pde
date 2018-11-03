import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import java.util.*;  


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


// Tractors
// los tractors son las prepresentaciones de los trending topics
// para cada trending topic hay un tracto que lo muestra en pantalla
ArrayList<Tractor> tractors;
ArrayList<Tooltip> tooltips;

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

  for (int c = 0; c < 8; c++) session+= (char) random(65, 90);



  startTwitter();

  trendsActuales = trendingTopics();
  //trendsActuales = trendingTopicsMO();

  trendingTopics = new ArrayList<TrendingTopic>();
  tractors = new ArrayList<Tractor>();
  tooltips = new ArrayList<Tooltip>();

  float alpha = 0;
  float radius = 200;
  float angle = TWO_PI/5.0;

  for (int trend = 0; trend < 5; trend ++) {
    try {      
      TrendingTopic t = new TrendingTopic(trendsActuales.get(trend));
      trendingTopics.add(t);
      PVector vertex = new PVector(radius * cos(alpha), radius * sin(alpha));
      Tractor tr = new Tractor(this, t);
      tr.position = vertex;
      tractors.add(tr);
      alpha += angle;    


      Tooltip tip = new Tooltip(this, smallFont, 14, 300);

      tip.setAnchor(Direction.SOUTH_WEST);
      tip.setIsCurved(true);
      tip.showPointer(true);

      tooltips.add(tip);
    }
    catch (NullPointerException e) {
      //  todo: log
      println("problema al iniciar");
      exit();
    }
  }




  onTriggerQuery();
  onTriggerClearTopics();

  barChart = new BarChart(this);
  barChart.setMinValue(0);
  barChart.setMaxValue(1.0);     
  barChart.showValueAxis(true);
  barChart.showCategoryAxis(true);

  lineChart = new XYChart(this);
  for (int i = 0; i < 1000; i++) {
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
  lineChart.setPointColour(color(180, 50, 50, 100));
  lineChart.setPointSize(1);
  lineChart.setLineWidth(1);
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
    if (i == 0) {
      System.arraycopy(tt.count, 0, history, 0, 1000);
    }
  }

  lineChart.setData(xsamples, history);
  // --------------------------------------------------
  // --------------------------------------------------
  // visualization
  pushMatrix();
  scale(0.5);
  translate(100, 100);
  barChart.setBarLabels(labels);
  barChart.setData(values);  
  textSize(textSize);

  float heightSpace = height/4;
  barChart.draw(0, 0, width/2, heightSpace);  
  // barra
  fill(255, 0, 0);
  noStroke();
  rect(0, heightSpace + 10, width/2 * query, 2);  
  lineChart.draw(0, heightSpace+50, width/2, heightSpace);  
  popMatrix();
  // --------------------------------------------------
  // --------------------------------------------------

  // pentagon
  pushMatrix();
  translate(width/2, height/2);

  beginShape();
  noFill();
  stroke(255, 0, 0);

  float alpha = 0; //frameCount*0.0001;

  endShape(CLOSE);
  fill(255, 0, 0);
  int tipy = 30;
  for (int tractor = 0; tractor < tractors.size(); tractor++) {
    Tractor t = tractors.get(tractor);        
    vertex(t.position.x, t.position.y);    
    t.render();
    
    Tooltip tip = tooltips.get(tractor); 
    TweetView one = t.getTweet();
    if(one == null) continue;
    tip.setText(one.st.getText());
    //PVector tipos = new PVector(width- tip.getWidth(), tipy+=tip.getHeight());
    PVector tipos = new PVector(0,0);
    println(tipos);
    //tip.draw(t.position.x, t.position.y);
    tip.draw(tipos.x, tipos.y);
  }
  popMatrix();


  if (frameCount%1800 == 0) saveFrame("d_"+session+"####.jpg");
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
