import ch.bildspur.realsense.*;
import ch.bildspur.realsense.type.*;

import gab.opencv.*;
import java.awt.Rectangle;
import oscP5.*;
import netP5.*;
import controlP5.*;

ControlP5 cp5;


Range range;
OpenCV opencv;
OscP5 oscP5;
NetAddress remote;

int trackingLow = 1;
int trackingHigh = 2050;
boolean videoOutput = false;
ArrayList<Contour> contours = new ArrayList<Contour>();
byte[] depthRaw = new byte[640*480];

RealSenseCamera camera = new RealSenseCamera(this);
//SyphonServer server;
int measured = 0;
PImage trackImage = new PImage(640, 480);
void setup()
{
  size(640, 580, FX2D);
  camera.enableDepthStream(640, 480);
  // camera.enableColorizer(ColorScheme.Cold);
  camera.start();
  opencv = new OpenCV(this, width, height);
  noFill();
  stroke(255, 0, 0);
  // osc
  oscP5 = new OscP5(this, 12000);
  remote = new NetAddress("localhost", 8338);
  oscP5.plug(this, "videoOutput", "/videoOutput");
  // Interface

  cp5 = new ControlP5(this);
  range = cp5.addRange("rangeController")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
    .setPosition(20, height-40)
    .setSize(floor(width*0.8), 20)
    .setHandleSize(20)
    .setRange(0, 10000)
    .setRangeValues(trackingLow, trackingHigh)
    // after the initialization we turn broadcast back on again
    .setBroadcast(true)
    .setColorForeground(color(255, 40))
    .setColorBackground(color(255, 40));

  cp5.setFont(createFont("Courier", 10));
}

void draw()
{
  background(0);
  //if (camera.isCameraAvailable()) {
  blobTracking();
  image(trackImage, 0, 0);
  if (contours.size() > 0) {
    Contour biggestContour = contours.get(0);
    Rectangle r = biggestContour.getBoundingBox();
    if ( r.width>= 80) {
      measured++;
      if (measured>5) { // simple means to avoid noise 
        noFill();
        strokeWeight(2);
        stroke(30, 100, 100);
        rect(r.x, r.y, r.width, r.height);
        fill(30, 100, 100);
        rect(r.x + r.width/2, r.y + r.height/2, 10, 10);
        sendPos(r.x + r.width/2, r.y + r.height/2, r.width, r.height);
      }
    } else {
      measured = 0;
    }
  } 
  //stream(depthRaw); TODO: full resolution is too much for one OSC message 
  
  surface.setTitle("fps"+frameRate); //Set the frame title to the frame rate
}

void blobTracking() {
  try {
    camera.readFrames();
    //camera.createDepthImage(trackingLow, trackingHigh);
    trackImage = createDepthImage(camera.getDepthData(), trackingLow, trackingHigh);
    opencv.loadImage(trackImage);
    opencv.contrast(1.3);
    opencv.dilate();
    opencv.blur(5);
    opencv.erode();
    opencv.erode();
    opencv.erode();
    contours = opencv.findContours(true, true);
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}


void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isFrom("rangeController")) {
    trackingLow = int(theControlEvent.getController().getArrayValue(0));
    trackingHigh = int(theControlEvent.getController().getArrayValue(1));
    if (trackingLow>=trackingHigh) {
      trackingHigh++;
    }
  }
}

PImage createDepthImage(short[][] data, int minDepth, int maxDepth)
{
  PImage depthImage = new PImage(640, 480);
  depthImage.loadPixels();
  for (int u = 0; u < data.length; u++) {
    for (int v = 0; v < data[0].length; v++) {
      int index = (u * data[0].length) + v;
      if (data[u][v] > minDepth) {
        int datapoint = constrain(data[u][v], minDepth, maxDepth);
        int grayScale = (int) PApplet.map(datapoint, minDepth, maxDepth, 255, 0);
        depthRaw[index] = byte(grayScale);
        depthImage.pixels[index] = color(grayScale);
      } else {
        depthImage.pixels[index] = color(0);
      }
    }
  }
  depthImage.updatePixels();
  return depthImage;
}
