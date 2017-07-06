PImage original, p;

//identify kernel (no change)
float[][] noFilter = { 
  {0, 0, 0}, 
  {0, 1, 0}, 
  {0, 0, 0}};

//blur kernel

float[][] blur = {
  {1.0/16.0, 2.0/16.0, 1.0/16.0}, 
  {2.0/16.0, 4.0/16.0, 2.0/16.0}, 
  {1.0/16.0, 2.0/16.0, 1.0/16.0}};

//edge detection kernel
float[][] edge = { 
  {0, 1, 0}, 
  {1, -4, 1}, 
  {0, 1, 0} };

//sharpen kernel
float[][] sharpen = {
  {0, -1, 0}, 
  {-1, 5, -1}, 
  {0, -1, 0}};

int mode;

//mode 0: original
//mode 1: blur
//mode 2: edge detection
//mode 3: sharpen

float[][][] kernels = {noFilter, blur, edge, sharpen};


void setup() {
  size(800,550);
  original = loadImage("Earth.png");
  p = new PImage(original.width, original.height);
  mode = 0;
}

void draw() {
  image(original, 0, 0);
  if (mode == 0)
    image(original, 0, 0);
  else {
    processImage(p, original, kernels[mode]);
    image(p, 0, 0);
    loadPixels();
  }
}

void mouseClicked() {
  mode = (mode + 1) % 4;
}

/*
void processImage(PImage p, PImage original, float[][] kernel, int mode) {
  if (mode != 2) {
    for (int x = 1; x < 99; x++) {
      for (int y = 1; y < 99; y++) {
        color c1  = original.get(x, y);
        color c2  = original.get(x+1, y);
        color c3  = original.get(x-1, y);
        color c4  = original.get(x+1, y+1);
        color c5  = original.get(x-1, y+1);
        color c6  = original.get(x+1, y-1);
        color c7  = original.get(x-1, y-1);
        color c8  = original.get(x, y+1);
        color c9  = original.get(x, y-1);

        color[][]colors = {{c1, c2, c3}, {c4, c5, c6}, {c7, c8, c9}};

        float redVal = 0;
        float greenVal = 0;
        float blueVal = 0;

        for (int matx = 0; matx < 3; matx++) {
          for (int maty = 0; maty < 3; maty++) {
            colors[matx][maty]= color((red(colors[matx][maty])) * kernel[matx][maty], 
              (green(colors[matx][maty])) * kernel[matx][maty], 
              (blue(colors[matx][maty])) * kernel[matx][maty]);
          }
        }

        for (color[] f : colors) {
          for (color s : f) {
            redVal += red(s);
            greenVal += green(s);
            blueVal += blue(s);
            redVal = constrain(redVal, 0, 255);
            greenVal = constrain(greenVal, 0, 255);
            blueVal = constrain(blueVal, 0, 255);

            p.set(x, y, color(redVal, greenVal, blueVal));
          }
        }
      }
    }
  } else {
    for (int x = 1; x < 799; x++) {
      for (int y = 1; y < 549; y++) {
        color c1  = greyscale(original.get(x, y));
        color c2  = greyscale(original.get(x+1, y));
        color c3  = greyscale(original.get(x-1, y));
        color c4  = greyscale(original.get(x+1, y+1));
        color c5  = greyscale(original.get(x-1, y+1));
        color c6  = greyscale(original.get(x+1, y-1));
        color c7  = greyscale(original.get(x-1, y-1));
        color c8  = greyscale(original.get(x, y+1));
        color c9  = greyscale(original.get(x, y-1));

        color[][]colors = {{c1, c2, c3}, {c4, c5, c6}, {c7, c8, c9}};

        float redVal = 0;
        float greenVal = 0;
        float blueVal = 0;

        for (int matx = 0; matx < 3; matx++) {
          for (int maty = 0; maty < 3; maty++) {
            colors[matx][maty]= color((red(colors[matx][maty])) * kernel[matx][maty], 
              (green(colors[matx][maty])) * kernel[matx][maty], 
              (blue(colors[matx][maty])) * kernel[matx][maty]);
          }
        }

        for (color[] f : colors) {
          for (color s : f) {
            redVal += red(s);
            greenVal += green(s);
            blueVal += blue(s);
            redVal = constrain(redVal, 0, 255);
            greenVal = constrain(greenVal, 0, 255);
            blueVal = constrain(blueVal, 0, 255);
            p.set(x, y, color(redVal, greenVal, blueVal));
          }
        }
      }
    }
  }
}

color greyscale(color c) {
  return color(((int)red(c)+(int)green(c)+(int)blue(c))/3, 
    ((int)red(c)+(int)green(c)+(int)blue(c))/3, 
    ((int)red(c)+(int)green(c)+(int)blue(c))/3);
}
*/

void processImage(PImage destination, PImage source, float[][] kernel) {
  //calculate the scale  
  int RED =0, GREEN = 1,BLUE = 2;
  float totalWeight = sumMatrix(kernel);
  float scale = 1.0;//default for 0 and 1
  if (totalWeight > 1 || totalWeight < 0) {
    scale = 1/totalWeight;
  }

  int borderSize = (kernel.length -1 )/2;
  
  //loop through all pixels
  //skip the border!
  for (int row = borderSize; row < source.width - borderSize; row++) {
    for (int col = borderSize; col < source.height - borderSize; col++) {
      //store the sums of RED/GREEN/BLUE in an array
      float[]sum = {0,0,0};
      
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