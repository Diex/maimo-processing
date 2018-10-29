import twitter4j.conf.*; 
import twitter4j.api.*; 
import twitter4j.*; 
import twitter4j.util.*;


Twitter twitter;                // interactuo con la red
StreamListener listener;        // recibo los mensajes del stream
TwitterStream twitterStream;    // abro un stream. danger ! porque te banean si lo usas mal.


void startTwitter() {

  ConfigurationBuilder cb = new ConfigurationBuilder();      //Acreditacion
  cb.setOAuthConsumerKey("hhUTr4VQ2brD8RIKpqO9ToQim");   
  cb.setOAuthConsumerSecret("8qZ7tysS6IlaKu5BUAid5BnaG1YAk2kNsRz7z66QICRqhE7mMU");   
  cb.setOAuthAccessToken("1053757245408854016-knypkI2bAQIR5CGiBtWLroT8uI2rXx");   
  cb.setOAuthAccessTokenSecret("BBRdnTDcWcrrRJGNPZinLCG36s3y6KpPowu3EBg0iMNSN");  

  Configuration config = cb.build();

  twitter = new TwitterFactory(config).getInstance();  
 
}

String [] trendingTopics() {

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
    te.printStackTrace();
  }

  return tt;
}


List<Status> queryTwitter(String q) {   

  Query query = new Query(q);   
  query.setCount(10);
  List<Status> tweets = null;
  try {     
    QueryResult result = twitter.search(query);     
    tweets = result.getTweets();     
    println("New Tweet : ");     
    for (Status tw : tweets) {       
      String msg = tw.getText();       
      println("tweet : " + msg);
    }
  }   
  catch (TwitterException te) {     
    println("Couldn''t connect: " + te);
  }
  
  return tweets;
}
