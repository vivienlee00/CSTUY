import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
int cycle;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_EYE);  

  // opencv.loadCascade(OpenCV.CASCADE_MOUTH);  


  video.start();
}

void draw() {
  scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) {
    println(faces[i].x + "," + faces[i].y);

    PImage img;
    if (cycle % 2 == 0) {
      img = loadImage("heart.png");
      img.resize(faces[i].width, faces[i].height);
      image(img, faces[i].x, faces[i].y);
    }
    
    if (cycle % 2 == 1) {
      img = loadImage("googly.png");
      img.resize(faces[i].width, faces[i].height);
      image(img, faces[i].x, faces[i].y);
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}

void keyPressed() {
  cycle++;
}

void mousePressed() {
  try {
    saveFrame("screenshot.png");
  } 
  catch (Exception e) {
  }
}