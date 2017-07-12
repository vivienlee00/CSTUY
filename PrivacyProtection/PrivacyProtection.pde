import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

float[][] sharpen = {
  {0, -1, 0}, 
  {-1, 5, -1}, 
  {0, -1, 0}};

float[][] blur = {
  {1.0/16.0, 2.0/16.0, 1.0/16.0}, 
  {2.0/16.0, 4.0/16.0, 2.0/16.0}, 
  {1.0/16.0, 2.0/16.0, 1.0/16.0}};

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
}

void draw() {
  scale(2);
  opencv.loadImage(video);
  PImage original = video;
  PImage newImage = video;
  //image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();

  loadPixels();

  for (int i = 0; i < faces.length; i++) {
    fill(0, 255, 0);
    processImage(newImage, original, faces[i].x, faces[i].y, faces[i].width, faces[i].height, sharpen);
    image(newImage, 0, 0);
  }
}

void captureEvent(Capture c) {
  c.read();
}


void processImage(PImage destination, PImage source, int x, int y, int w, int h, float[][] kernel) {
  //calculate the scale  
  int RED =0, GREEN = 1, BLUE = 2;
  float totalWeight = sumMatrix(kernel);
  float scale = 1.0;//default for 0 and 1
  if (totalWeight > 1 || totalWeight < 0) {
    scale = 1/totalWeight;
  }

  int borderSize = (kernel.length -1 )/2;

  //pixels[mouseY*320+mouseX]

  //loop through all pixels
  //skip the border!
  try {
    for (int row = x; row < x + w; row++) {
      for (int col = y; col < y + h; col++) {
        //store the sums of RED/GREEN/BLUE in an array
        float[]sum = {0, 0, 0};

        //loop through the kernel
        for (int a = 0; a < kernel.length; a++) {
          for (int b = 0; b < kernel[0].length; b++) {
            //the weight is the kernel value
            float weight = kernel[a][b]; 

            //get(row+offset, col+offset)
            color colour = source.get(row + a - borderSize, col + b - borderSize);

            //tally the value scaled by the kernel
            sum[RED] += weight * red(colour);
            sum[GREEN] += weight * green(colour);
            sum[BLUE] += weight * blue(colour);
          }
        }


        float newRed = capColor(sum[RED] * scale);
        float newGreen = capColor(sum[GREEN] * scale);
        float newBlue = capColor(sum[BLUE] * scale);

        destination.set(row, col, color(newRed, newGreen, newBlue));
      }
    }
  }
  catch(IndexOutOfBoundsException e) {
  }
}

float capColor(float val) {
  if (val < 0) return 0;
  if (val > 255) return 255;
  return val;
}

int sumMatrix(float[][] matrix) {
  int sum = 0;
  for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[0].length; j++) {
      sum += matrix[i][j];
    }
  }
  return sum;
}