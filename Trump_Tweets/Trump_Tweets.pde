//import org.json.*;
import java.util.*;
import java.io.*;
import twitter4j.*;
import twitter4j.conf.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;


String info;
//String apiKey = "d2e0b5614ba64637bfbc5dfbbe1bcdf4";
//String baseURL = "http://api.nytimes.com/svc/search/v2/articlesearch.json";
HashMap<String, ArrayList<String>> hm = new HashMap<String, ArrayList<String>>();
//String startDate, endDate;
List<Status> statuses;
String[] lines;
ArrayList<String> individualwords = new ArrayList<String>();
String post;
String ansss = "";
float counter = 230;

void setup() {
  size(887, 319);
  /*Date today = new Date();
   DateFormat df = new SimpleDateFormat("yyyyMMdd"); 
   endDate = df.format(today); 
   Date beginning = new Date(System.currentTimeMillis() - 4L * 24 * 3600 * 1000);
   startDate = df.format(beginning);
   println(startDate +","+ endDate);
   */

  ConfigurationBuilder conf = new ConfigurationBuilder();
  conf.setDebugEnabled(true).setOAuthConsumerKey("aT30Di4mOCvILCZJ6Wxw9vyHj")
    .setOAuthConsumerSecret("prn5wjFP4KWB0mTgCIgsMoyi4iw1jN5Y13CX4Ynaqjvt7Te4KN")
    .setOAuthAccessToken("889586752549265408-3HgUbOBKmi1FF72uJ49Ny6EZIMY7X8r")
    .setOAuthAccessTokenSecret("rh9TIWmviMFpreViN3XOUM7NnrIMO7eTH0mzvDW0l6lwA");


  Twitter twitter = new TwitterFactory(conf.build()).getInstance();

  int pageno = 1;
  String user = "realDonaldTrump";

  try {

    Paging page = new Paging(pageno++, 200);
    statuses = twitter.getUserTimeline(user, page);
    println("Total: "+statuses.size());
    String[] temp = new String[statuses.size()];
    int i = 0;
    for (Status s : statuses) {
      temp[i] = s.getText();
      i++;
    }
    loadFile(temp);
  }
  catch(TwitterException e) {

    e.printStackTrace();
  }
  //getDTArticles();
}


void draw() {
  PImage img;
  img = loadImage("twitterbg.PNG");
  background(img);
  fill(0);
  if (mousePressed) {
    if (mouseX > 620 && mouseX<720 && mouseY>240 && mouseY<295) {
      int charcount = 0;
      String ans = "";
      String last = ".";
      try {
        last = individualwords.get((int)random(individualwords.size()));
        while (last.contains(".")) {
          last = individualwords.get((int)random(individualwords.size()));
        }
      }
      catch(NullPointerException e) {
      }
      ans += last;  
      while (!last.contains(".") && charcount < 120) {
        ans += " ";
        try {
          last = hm.get(last).get((int)random(hm.get(last).size()));
        }
        catch(NullPointerException e) {
        }
        ans += last;
        charcount += last.length() + 1;
      }
      ansss=ans;
      ans += '\n';
      mousePressed = false;
    }
    if (mouseX>755&&mouseX<860&&mouseY>240&&mouseY<290) {
      poster();
    }
  }
  textSize(20);
  if (ansss.length() < 70) {
    text(ansss, 40, 140);
  } else {
    String ln1, ln2;
    int sep = ansss.substring(70).indexOf(" ") + 70;
    if (sep!=-1 && sep!= 69) {
      ln1 = ansss.substring(0, sep);
      ln2 = ansss.substring(sep);
      text(ln1, 40, 140);
      text(ln2, 35, 170);
    } else {
      text(ansss, 40, 140);
    }
  }
}

void loadFile(String[] lines) {
  String[] orig = lines;
  for (int i =0; i < orig.length; i++) {
    info += orig[i] + " ";
  }

  String[] ary = info.split(" "); 
  for (int i = 1; i < ary.length - 1; i++) {
    ArrayList<String> following = new ArrayList<String>(); 
    if (!hm.containsKey(ary[i])) {
      hm.put(ary[i], following);
      individualwords.add(ary[i]);
    }
  }
  for (int i = 1; i < ary.length - 1; i++)
  {
    hm.get(ary[i]).add(ary[i+1]);
  }
}

/*
void getDTArticles() {
 
 String request = baseURL + "?q=Trump&begin_date=" + startDate + "&end_date=" + endDate + "&api-key=" + apiKey;
 println(request);
 String result = join( loadStrings( request ), "");
 
 //println( result );
 }
 */

void poster() {
  post = ansss;
  try 
  {
    ConfigurationBuilder conf = new ConfigurationBuilder();
    conf.setDebugEnabled(true).setOAuthConsumerKey("aT30Di4mOCvILCZJ6Wxw9vyHj")
      .setOAuthConsumerSecret("prn5wjFP4KWB0mTgCIgsMoyi4iw1jN5Y13CX4Ynaqjvt7Te4KN")
      .setOAuthAccessToken("889586752549265408-3HgUbOBKmi1FF72uJ49Ny6EZIMY7X8r")
      .setOAuthAccessTokenSecret("rh9TIWmviMFpreViN3XOUM7NnrIMO7eTH0mzvDW0l6lwA");

    TwitterFactory factory = new TwitterFactory(conf.build());
    Twitter twitter = factory.getInstance();

    System.out.println(twitter.getScreenName());
    Status status = twitter.updateStatus(post);
    System.out.println("Successfully updated the status to [" + status.getText() + "].");
  }
  catch (TwitterException te) {
    te.printStackTrace();
  }
  mousePressed = false;
}