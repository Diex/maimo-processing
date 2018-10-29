import java.util.*;
import twitter4j.*; 
import processing.core.*;

public class TrendingTopic {
  
  ArrayList<Status> list;
  int maxQty = 100;
  long lastStatusId = 0;
  String keyword = "";

  public TrendingTopic(String keyword) {
    this.keyword = keyword;    
    list = new ArrayList<Status>();
    PApplet.println("new trending topic wk: " + keyword);
  }

  public void addNewStatus(Status st) {
  
    if (list.size() >= maxQty) {
      list.remove(0);
    }
    list.add(st);
    lastStatusId = st.getId();
  }
  
  public boolean isNewStatus(Status st){
    if(st.getId() > lastStatusId) return true;
    return false;
  }
}
