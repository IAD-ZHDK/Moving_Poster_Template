import ch.bildspur.realsense.*;
import gab.opencv.*;
import java.awt.Rectangle;
import oscP5.*;
import netP5.*;

OpenCV opencv;

OscP5 oscP5;
NetAddress remote;

int trackingLow = 0;
int trackingHigh= 2300;

ArrayList<Contour> contours;

RealSenseCamera camera = new RealSenseCamera(this);

void setup()
{
  size(640, 480, FX2D);
  camera.start(640, 480, 30, true, false);
  opencv = new OpenCV(this, width, height);
  noFill();
  stroke(255, 0, 0);
  // osc
  oscP5 = new OscP5(this, 12000);
  remote = new NetAddress("localhost", 8338);
}

void draw()
{  
  background(0);
  //if (camera.isCameraAvailable()) {
  blobTracking();
  if (contours.size() > 0) {
    Contour biggestContour = contours.get(0);
    Rectangle r = biggestContour.getBoundingBox();
    if ( r.width>= 60) {
      noFill(); 
      strokeWeight(2); 
      stroke(30, 100, 100);
      rect(r.x, r.y, r.width, r.height);
      fill(30, 100, 100);
      rect(r.x + r.width/2, r.y + r.height/2, 10, 10);
      sendPos(r.x + r.width/2, r.y + r.height/2, r.width, r.height);
    }
  }
  surface.setTitle("fps"+frameRate); //Set the frame title to the frame rate
}

void blobTracking() {
  camera.readFrames();
  camera.createDepthImage(trackingLow, trackingHigh);
  PImage trackImage = camera.getDepthImage();
  opencv.loadImage(trackImage);
  opencv.contrast(1.3);
  opencv.dilate();
  opencv.blur(5);
  opencv.erode();
  opencv.erode();
  opencv.erode();
  image(opencv.getSnapshot(), 0, 0);
  contours = opencv.findContours(true, true);
}
