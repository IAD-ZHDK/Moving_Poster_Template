
import oscP5.*;
import netP5.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

// OSC
int downScale = 2;
OscP5 oscP5;
NetAddress remote;
boolean updateFlag = false;


void setup() {
  size(640, 480);
  video = new Capture(this, 640/downScale, 480/downScale);
  opencv = new OpenCV(this, 640/downScale, 480/downScale);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  noFill();
  video.start();
  // osc
  oscP5 = new OscP5(this, 12000);
  remote = new NetAddress("localhost", 8338);
}

void draw() {
  scale(downScale);

  opencv.loadImage(video);
  image(video, 0, 0 );
  filter(GRAY);
  Rectangle[] faces = opencv.detect();

  stroke(255, 0, 0);
  if (faces.length>0) {
    int x = faces[0].x + faces[0].width/2;
    int y = faces[0].y + faces[0].height/2;
    rect(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
    sendPos(x, y, faces[0].width, faces[0].height);
  }
  surface.setTitle("fps"+frameRate); //Set the frame title to the frame rate
}


void captureEvent(Capture c) {
  c.read();
}

void sendPos(int x, int y, float w, float h) {
  float xNormal = float(x*downScale);
  float yNormal = float(y*downScale);
  xNormal = xNormal/width;
  yNormal = yNormal/height;
  OscMessage myOscMessage = new OscMessage("/pose/position");
  myOscMessage.add(xNormal);
  myOscMessage.add(yNormal);
  oscP5.send(myOscMessage, remote);
  OscMessage myOscMessage2 = new OscMessage("/pose/scale");
  myOscMessage2.add((w/width));
  //  myOscMessage2.add(h);
  oscP5.send(myOscMessage2, remote);
}
