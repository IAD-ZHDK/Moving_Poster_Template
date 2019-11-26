import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 
import gab.opencv.*; 
import processing.video.*; 
import java.awt.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Opencv_Face_OSC extends PApplet {








Capture video;
OpenCV opencv;

// OSC
int downScale = 2;
OscP5 oscP5;
NetAddress remote;
boolean updateFlag = false;


public void setup() {
  
  video = new Capture(this, 640/downScale, 480/downScale);
  opencv = new OpenCV(this, 640/downScale, 480/downScale);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  noFill();
  video.start();
  // osc
  oscP5 = new OscP5(this, 12000);
  remote = new NetAddress("localhost", 8338);
}

public void draw() {
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


public void captureEvent(Capture c) {
  c.read();
}

public void sendPos(int x, int y, float w, float h) {
  float xNormal = PApplet.parseFloat(x*downScale);
  float yNormal = PApplet.parseFloat(y*downScale);
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
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Opencv_Face_OSC" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
