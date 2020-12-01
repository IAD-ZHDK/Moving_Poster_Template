Tracker myTracker;

void setup() {
  fullScreen(FX2D);  // actual screen size 1080*1920*2;
  // fullScreen(FX2D, SPAN); use this for displaying on multiple screens
  ScreenSetup screen = new ScreenSetup(); // important for scaling the screen for the correct aspect ratio
  myTracker = new Tracker();// important for getting the tracking information from an external application
  rectMode(CENTER);
  fill(255);
};

void draw() {
  background(255);
  PVector Pos = myTracker.getTarget(); // the getTarget returns the position of the target  
  fill(255, 0, 0);
  int ellipseW = floor(width * 0.01);
  ellipse(Pos.x*width, Pos.y*height, ellipseW, ellipseW);

  fill(0);
  
  float spacingX = width/15.0; 
  float spacingY = height/15.0; 

  for (float x = 0; x<=width+spacingX; x+=spacingX) {
    for (float y = 0; y<=height+spacingY; y+=spacingY) {
      float reactor = dist(x,y,Pos.x*width,Pos.y*height);
      float scaler = (Pos.z*0.01)+0.001;
      reactor = reactor*scaler;
      float diameter = ( spacingX / 5 )*reactor;
      push();
      translate(x,y);
      rotate(reactor);
      translate(20,0);
      rect(0, 0, diameter, diameter);
      pop();
    }
  }

  // screen split line
  pushStyle();
    strokeWeight(2);
    stroke(255, 0, 0, 70);
    line(width/2, 0, width/2, height);
  popStyle();
 //if (frameCount % 120 == 1  ) println("FPS"+frameRate); // for checking the performance of your code
};
