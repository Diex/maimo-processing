import java.util.*;
import twitter4j.*; 
import processing.core.*;

public class TrendingTopic {
  
  public static final int MAX = 300;
  static final int TOTAL_SAMPLES = 1000;
  public int totalCount = 0;
  
  ArrayList<Status> list;
  int currentSample = -1;
  float [] count; 
  long tick = 0;
  long sampleRate = 60;
  
  long lastStatusId = 0;
  Trend trend;

  float currentLoad = 0;
  float prevLoad = 0;
  float f = 0.15f;
  
  
  public TrendingTopic(Trend trend) {
    this.trend = trend;
    list = new ArrayList<Status>();
    count = new float[TOTAL_SAMPLES];
    PApplet.println("new trending topic wk: " + trend.getQuery());
  }

 
  public void newTrend(Trend trend) {
    this.trend = trend;
    list = new ArrayList<Status>();
    count = new float[TOTAL_SAMPLES];
    PApplet.println("new trending topic wk: " + trend.getQuery());
  }

  public void addNewStatus(Status st) {
    totalCount ++;
    
    if (list.size() >= MAX) {
      list.remove(0);
    }
    list.add(st);
    lastStatusId = st.getId();
  }
  
  public void removeOne(){
    if(list.size() > 0 ) list.remove(0);
  }
  public boolean isNewStatus(Status st){
    if(st.getId() > lastStatusId) return true;
    return false;
  }
  
  public long lastId(){
    return lastStatusId;    
  }
  
  
  public void update(){
    tick++;    
    if(tick % sampleRate == 0) sample();
    prevLoad = currentLoad;
    currentLoad = easing(f, list.size() * 1.0f/MAX, prevLoad); 
  }
  
  void sample(){
    //PApplet.println("sampling...");
    currentSample = (currentSample +1) % TOTAL_SAMPLES;
    count[currentSample] = list.size();
  }
  
  float easing(float factor, float in, float prev){
    return in * factor + prev * (1-factor);
  }
  
  public float load(){
    return currentLoad;
  }
  
  public String label(){
    return trend.getName().length() > 10 ? trend.getName().toUpperCase().substring(0,10) : trend.getName().toUpperCase();
  }
}
