import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import javax.swing.*;

Capture video;
OpenCV opencv;
int ypos = 0;
int xpos = 0;
boolean up = false;
int bearx, beary;
PImage img;
int bearwidth, bearheight;

int ballxdir = 2;


void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  // opencv.loadCascade(OpenCV.CASCADE_MOUTH);  


  video.start();
}

void draw() {
  scale(2);
  
  PImage img;
  img = loadImage("snow.jpg");
  background(img);
  
  noFill();
  stroke(0, 0, 255);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();

  for (int i = 0; i < faces.length; i++) {

    img = loadImage("polarbear.png");
    img.resize(faces[i].width, img.height/faces[i].width);
    image(img, faces[i].x, faces[i].y+100);
    bearx = faces[i].x;
    beary = faces[i].y+100;
    bearwidth = faces[i].width;
    bearheight = img.height/faces[i].width;
  }
}

void captureEvent(Capture c) {
  c.read();
}