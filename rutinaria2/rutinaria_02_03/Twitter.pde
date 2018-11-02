import twitter4j.conf.*; 
import twitter4j.api.*; 
import twitter4j.*; 
import twitter4j.util.*;


Twitter twitter;                // interactuo con la red
StreamListener listener;        // recibo los mensajes del stream
TwitterStream twitterStream;    // abro un stream. danger ! porque te banean si lo usas mal.


void startTwitter() {

  
  //ConfigurationBuilder cb = new ConfigurationBuilder();      //Acreditacion rutinaria
  //cb.setOAuthConsumerKey("hhUTr4VQ2brD8RIKpqO9ToQim");   
  //cb.setOAuthConsumerSecret("8qZ7tysS6IlaKu5BUAid5BnaG1YAk2kNsRz7z66QICRqhE7mMU");   
  //cb.setOAuthAccessToken("1053757245408854016-knypkI2bAQIR5CGiBtWLroT8uI2rXx");   
  //cb.setOAuthAccessTokenSecret("BBRdnTDcWcrrRJGNPZinLCG36s3y6KpPowu3EBg0iMNSN");  


  ConfigurationBuilder cb = new ConfigurationBuilder();      //Acreditacion @rutinaria18 
  cb.setOAuthConsumerKey("9pVUylljhihzsTp2ch7I2TKyS");   
  cb.setOAuthConsumerSecret("7X9qmtZEHkWeKiWylYF1yJhh0iYgG3PFf7KEQw31DrnnBWmr2H");   
  cb.setOAuthAccessToken("23246215-726dQgGUabXLybDpV9THy52RH8st7QeIGk6zWTqNU");   
  cb.setOAuthAccessTokenSecret("KR2xibIWOwTXFXIa97rfiFIdnnoxSTNrmY7kD0I1lPX7x");  

  Configuration config = cb.build();
  twitter = new TwitterFactory(config).getInstance();  
 
}

ArrayList<Trend> trendingTopics() {

  //String [] tt = new String[20];  // me guardo los 5tt  
  Trend[] ts;
  ArrayList <Trend> topFive = new ArrayList<Trend>();
  try {
    
    TrendsResources trends = twitter.trends();
    ResponseList<Location> locationsNearby = trends.getClosestTrends(new GeoLocation(-34.605188, -58.383777));    
    for (Location l : locationsNearby) {      
      ts = (trends.getPlaceTrends(l.getWoeid())).getTrends();      
      
      for (int i = 0; i < ts.length; i++) {
        if(ts[i].getTweetVolume() == -1) continue;
        topFive.add(ts[i]);
        if(topFive.size() == 5) return topFive;        
      }
    }
  }
  catch (TwitterException te) {     
    println("Couldn''t connect: " + te);
    te.printStackTrace();
  }

  return topFive;
}


List<Status> queryTwitter(String q, long lastId) {   

  Query query = new Query(q);   
  query.setCount(30);  
  //getSince()
  query.setSinceId(lastId);
    
  List<Status> tweets = null;
  try {    
    //Requests / 15-min window (user auth)  900
    // ~ 1/s
    QueryResult result = twitter.search(query);     
    println("user: " + result.getRateLimitStatus());
    tweets = result.getTweets();     
  }   
  
  catch (TwitterException te) {     
    println("Couldn''t connect: " + te);
  }
  
  return tweets;
}
