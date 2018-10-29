import java.util.*;  

import twitter4j.conf.*; 
import twitter4j.api.*; 
import twitter4j.*; 
import twitter4j.util.*;



Query query; 
Twitter twitter;
StreamListener listener;
TwitterStream twitterStream;

void setup() {       

  ConfigurationBuilder cb = new ConfigurationBuilder();      //Acreditacion
  cb.setOAuthConsumerKey("VKLefa21Qivo90eCzqT7th26U");   
  cb.setOAuthConsumerSecret("WdzGgQeoVewURhrw4kY02eg5saOCp76gPRO14rHV3zbnIlrb7Y");   
  cb.setOAuthAccessToken("23246215-zVJb5dbSXdvQrpKCimwT43YiliIVZzJs4JY25uVXI");   
  cb.setOAuthAccessTokenSecret("4czDio4GbZ5VPaHSgGugg1zuIcXjmWayp96tUw24GS7rz");  

  Configuration config = cb.build();

  twitter = new TwitterFactory(config).getInstance();   
  twitterStream = new TwitterStreamFactory(config).getInstance(); 

  listener = new StatusListener() {
    public void onStatus(Status status) {
      System.out.println("@" + status.getUser().getScreenName() + " - " + status.getText());
    }
    public void onStallWarning(StallWarning sw) {
      System.out.println(sw);
    }
    public void onException(Exception e) {
      System.out.println(e.getStackTrace());
    }
    public void onTrackLimitationNotice(int notice) {
      System.out.println(notice);
    }

    public void onDeletionNotice(StatusDeletionNotice sdl) {
      System.out.println(sdl);
    }
    public void onScrubGeo(long a, long b) {
      System.out.println(a+":"+b);
    }
  };

  // The factory instance is re-useable and thread safe.
  //AsyncTwitterFactory factory = new AsyncTwitterFactory(config);
  //asyncTwitter = factory.getInstance();
  twitterStream.addListener(listener);
  twitterStream.filter("Carrizo");



  queryTwitter();
} 


void draw() {
  background(127);
}

void keyPressed() {
  if (key ==' ') queryTwitter();
  if (key =='t') queryTrends();
}


String [] queryTrends() {

  String [] tt = new String[20];  // me guardo los 5tt  
  Trend[] ts;

  try {
    TrendsResources trends = twitter.trends();
    ResponseList<Location> locationsNearby = trends.getClosestTrends(new GeoLocation(-34.605188, -58.383777));    
    for (Location l : locationsNearby) {      
      ts = (trends.getPlaceTrends(l.getWoeid())).getTrends();      
      for (int i = 0; i < tt.length; i++) {
        tt[i] = ts[i].getName();        
        println(ts[i].getName());                // el nombre
        println(ts[i].getTweetVolume());          // cuantos hubo en las ultimas 24 hs
        println(ts[i].getQuery());                // cómo se busca...
      }
    }
  }
  catch (TwitterException te) {     
    println("Couldn''t connect: " + te);
  }

  return tt;
}


void queryTwitter() {   
  query = new Query("#processing");   
  query.setCount(10);   
  try {     
    QueryResult result = twitter.search(query);     
    List<Status> tweets = result.getTweets();     
    println("New Tweet : ");     
    for (Status tw : tweets) {       
      String msg = tw.getText();       
      println("tweet : " + msg);
    }
  }   
  catch (TwitterException te) {     
    println("Couldn''t connect: " + te);
  }
}
