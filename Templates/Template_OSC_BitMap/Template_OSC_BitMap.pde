Tracker myTracker;
PImage baseImage;

void setup() {
  fullScreen(FX2D);  // actual screen size 1080*1920*2;
  // fullScreen(FX2D, SPAN); use this for displaying on multiple screens
  ScreenSetup screen = new ScreenSetup(); // important for scaling the screen for the correct aspect ratio
  myTracker = new Tracker();// important for getting the tracking information from an external application
  rectMode(CENTER);
  fill(255);  
  baseImage = loadImage("image.jpg");
};

void draw() {
  background(255);
  PVector Pos = myTracker.getTarget(); // the getTarget returns the position of the target  
  float spacingX = float(width)/baseImage.width; 
  float spacingY =  float(height)/baseImage.height; 
  println(spacingX);
  baseImage.loadPixels();
  for (int i = 0; i<baseImage.height; i++) {
    float y = spacingY*i;
    beginShape();
    curveVertex(0, y);
    for (int j = 0; j<baseImage.width; j++) {
      int index = j + i * baseImage.width;
      float x = spacingX*j; 
      float size = red(baseImage.pixels[index])*Pos.x;
      curveVertex(x, y-size);
    }
    curveVertex(width, y);
    curveVertex(width, y);
    endShape();
  }

};
