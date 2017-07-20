import java.util.*;
import java.io.*;

String info;
HashMap<String, ArrayList<String>> hm = new HashMap<String, ArrayList<String>>();

void setup() {
  loadFile("markovtext.txt");
}

void draw() {
  String ans = "";
  ans += "I";
  String last = "I";
  while (!last.contains(".")) {
    ans += " ";
    last = hm.get(last).get((int)random(hm.get(last).size()));
    ans += last;
  }
  println(ans);
}

void loadFile(String filename) {
  String[] orig = loadStrings("markovtext.txt");
  for (int i =0; i < orig.length; i++) {
    info += orig[i] + " ";
  }

  String[] ary = info.split(" ");
  for (int i = 1; i < ary.length - 1; i++) {
    ArrayList<String> following = new ArrayList<String>();
    if (!hm.containsKey(ary[i])) {
      hm.put(ary[i], following);
    }
  }
  for (int i = 1; i < ary.length - 1; i++)
  {
    hm.get(ary[i]).add(ary[i+1]);
  }
}