/**
 * This Processing sketch sends all the pixels of the canvas to the serial port.
 */

final int TOTAL_WIDTH  = 32;
final int TOTAL_HEIGHT = 32;
final int NUM_CHANNELS = 3;
final int BAUD_RATE    = 921600;

SerialMatrix serialMatrix;

// PImage is Processing's image type
PImage img;

boolean drawGrid = true;
boolean alreadyDrawn = false;

void setup() {
  background(70, 17, 138);
  drawShape();
  // The Processing preprocessor only accepts literal values for size()
  // We can't do: size(TOTAL_WIDTH, TOTAL_HEIGHT);
  size(32, 32);
  noSmooth();

  img = loadImage("test4.png");

  serialMatrix = new SerialMatrix(this, "/dev/tty.usbserial-02B3F643", BAUD_RATE);
}

int numPoints = 8; // Количество вершин полигона
float radius = 20;

void draw() {
  serialMatrix.buttonCheck();
  
  if(serialMatrix.buttonPressed(1) && !alreadyDrawn){
    drawShape();
    //println("trololo");
    alreadyDrawn = true;
  } else if(!serialMatrix.buttonPressed(1)) {
    alreadyDrawn = false;
  }

  if (drawGrid) {
    for (int i = 0; i<width; i++) {
      //println(i);
      if (i%2==0) {
        println(i);
        stroke(0, 0, 108);
        line(0, i, height, i);
        line(i, 0, i, width);
      }
    }
  }

  // Write to the serial port
  serialMatrix.sendPixels();
}

void keyPressed(){
  if(key == 'g'){
    drawGrid = !drawGrid;
    drawShape();
  }
}

void mouseClicked(){
  drawShape();
}

void drawShape() {

  background(30, 0, 128);
  int centerX = (int) random (10, 20);
  int centerY = (int) random (12, 18);

  int peakNum = (int) random (0, 2);

  peakGenerator(peakNum, centerX, centerY);
}

void peakGenerator(int peakNum, int centerX, int centerY) {

  if (peakNum == 0) {
    drawConvexPolygon(centerX, centerY, 20, 20, color(0, 0, 108));

    drawConvexPolygon(centerX, centerY, 20, 18, color(125, 30, 179));

    drawConvexPolygon(centerX, centerY, 20, 14, color(156, 24, 79));

    drawConvexPolygon(centerX, centerY, 16, 10, color(171, 77, 36));

    drawConvexPolygon(centerX, centerY, 8, 8, color(236, 146, 66));

    drawConvexPolygon(centerX, centerY, 5, 5, color(247, 218, 54));

    fill(255, 238, 189);
    ellipse(centerX, centerY, 3, 3);
  } else {
    drawConvexPolygon(centerX, centerY, 20, 18, color(0, 0, 108));

    drawConvexPolygon(centerX, centerY, 20, 18, color(125, 30, 179));
    drawConvexPolygon(centerX+(int)random(-7, 7), centerY+(int)random(-7, 7), 7, 12, color(125, 30, 179));

    drawConvexPolygon(centerX, centerY, 20, 14, color(156, 24, 79));
    drawConvexPolygon(centerX+(int)random(-7, 7), centerY+(int)random(-7, 7), 12, 14, color(156, 24, 79));

    drawConvexPolygon(centerX, centerY, 16, 10, color(171, 77, 36));
    drawConvexPolygon(centerX+(int)random(-7, 7), centerY+(int)random(-7, 7), 16, 10, color(171, 77, 36));

    drawConvexPolygon(centerX, centerY, 8, 7, color(236, 146, 66));
    drawConvexPolygon(centerX+(int)random(-5, 5), centerY+(int)random(-5, 5), 8, 9, color(236, 146, 66));

    drawConvexPolygon(centerX, centerY, 5, 5, color(247, 218, 54));
    drawConvexPolygon(centerX+(int)random(-5, 5), centerY+(int)random(-3, 3), 5, 4, color(247, 218, 54));

    fill(255, 238, 189);
    stroke(255, 238, 189);
    line(centerX, centerY, centerX+6, centerY+6);
    ellipse(centerX, centerY, 2, 2);
    ellipse(centerX+(int)random(-6, 6), centerY+(int)random(-6, 6), 3, 2);
  }
}

void drawConvexPolygon(float centerX, float centerY, int numPoints, float radius, color polygonColor) {

  noStroke();
  fill(polygonColor);
  float[] angles = new float[numPoints];

  for (int i = 0; i < numPoints; i++) {
    angles[i] = random(0, TWO_PI);
  }


  boolean swapped;
  do {
    swapped = false;
    for (int i = 0; i < numPoints - 1; i++) {
      if (angles[i] > angles[i + 1]) {
        float temp = angles[i];
        angles[i] = angles[i + 1];
        angles[i + 1] = temp;
        swapped = true;
      }
    }
  } while (swapped);
  ;


  float[] xPoints = new float[numPoints];
  float[] yPoints = new float[numPoints];
  for (int i = 0; i < numPoints; i++) {
    float x = centerX + cos(angles[i]) * radius;
    float y = centerY + sin(angles[i]) * radius;
    xPoints[i] = x;
    yPoints[i] = y;
  }

  beginShape();
  for (int i = 0; i < numPoints; i++) {
    vertex(xPoints[i], yPoints[i]);
  }
  endShape(CLOSE);
}
