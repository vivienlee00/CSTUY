import java.util.*;
import java.io.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

String info;
HashMap<String, ArrayList<String>> hm = new HashMap<String, ArrayList<String>>();
Minim minim;
AudioOutput out;


void setup() {
  loadFile("markovsound.txt");
  minim = new Minim(this);
  out = minim.getLineOut();
  out.setTempo(80);
}

void draw() {
  String last = "E";
  while (!last.contains(".")) {
    last = hm.get(last).get((int)random(hm.get(last).size()));
    delay(1000);
    println(last);
    if (last.contains(".")) {
      out.playNote(0, last.substring(0, 1));
    } else {
      out.playNote(0, last);
    }
  }
  noLoop();
}

void loadFile(String filename) {
  String[] orig = loadStrings(filename);
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