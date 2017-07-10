import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import javax.swing.*;

Capture video;
OpenCV opencv;
int ypos = 0;
int xpos = 0;
boolean up = false;
int platx, platy, ex, ey;
PImage img;
int platwidth, platheight;

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
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(0, 0, 255);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();

  for (int i = 0; i < faces.length; i++) {

    img = loadImage("platform.png");
    img.resize(faces[i].width, img.height/faces[i].width);
    image(img, faces[i].x, faces[i].y+100);
    platx = faces[i].x;
    platy = faces[i].y+100;
    platwidth = faces[i].width;
    platheight = img.height/faces[i].width;
  }

  ellipse(xpos, ypos, 30, 30);
  ex = xpos;
  move();
  for (int i = 0; i < faces.length; i++) {
    /*if (
     (ex<platx+(faces[i].width/2) 
     && 
     ex>platx-(faces[i].width/2))
     &&
     ((ey>platy-((img.height/faces[i].width)/2))
     &&
     (ey<platy+((img.height/faces[i].width)/2)))
     ) {
     up = !up;
     }*/
  
    if (Math.abs(ey - platy) < 5 &&
      ((ex<platx+platwidth)&&ex>platx)) {
      up = !up;
    }
    if (Math.abs(0-ey) < 5) {
      up = !up;
    }
    println(ex);
    if (Math.abs(0-ex) < 5 || ex > 315) {
      ballxdir = -ballxdir;
    }
    if(ey > 235){
      javax.swing.JOptionPane.showMessageDialog(null, "game lost");
      noLoop();
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}


void move() {
  if (up) {
    ypos -= 3;
    xpos += ballxdir;
  } else {
    ypos += 3;
    xpos += ballxdir;
  }
  ey = ypos;
  ex = xpos;
}