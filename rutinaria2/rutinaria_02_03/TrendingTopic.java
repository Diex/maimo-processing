import java.util.*;
import twitter4j.*; 
import processing.core.*;

public class TrendingTopic {
  
  public static final int MAX = 1000;
  
  public int totalCount = 0;
  
  ArrayList<Status> list;
  
  long lastStatusId = 0;
  Trend trend;

  float currentLoad = 0;
  float prevLoad = 0;
  float f = 0.15f;
  
  
  public TrendingTopic(Trend trend) {
    this.trend = trend;
    list = new ArrayList<Status>();
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
    prevLoad = currentLoad;
    currentLoad = easing(f, list.size() * 1.0f/MAX, prevLoad); 
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
