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
  background(240);
  strokeWeight(5);
  stroke(50);
  PVector Pos = myTracker.getTarget(); // the getTarget returns the position of the target  
  shape1(Pos);
  shape2(Pos);
  // screen split line
  strokeWeight(2);
  stroke(255, 0, 0, 70);
  line(width/2, 0, width/2, height);
  //if (frameCount % 120 == 1  ) println("FPS"+frameRate); // for checking the performance of your code
};




void shape1(PVector Pos) {
  PVector TargetPos = Pos.copy();
  TargetPos.x = 1-TargetPos.x; // invert the x axis
  TargetPos.x = constrain(TargetPos.x, .0, .5);
  TargetPos.x = TargetPos.x*width; 
  TargetPos.y = TargetPos.y*height;
  PVector myPos = new PVector(width/4, height/2);
  TargetPos.sub(myPos);
  for (int i = 1; i <= width/100; i++) {
    pushMatrix();
    float scale = (width/2)*.65-(i*15);
    float myX = myPos.x+(TargetPos.x*i*0.03);
    float myY = myPos.y+(TargetPos.y*i*0.03);
    float myZ = myPos.z+(TargetPos.z*i*0.03);
    translate(myX, myY);
    rotate(PI/4);
    rotate(radians(myZ*i));
    rect(0, 0, scale, scale);
    popMatrix();
  };
}

void shape2(PVector Pos) {
  PVector TargetPos = Pos.copy();
  TargetPos.x = 1-TargetPos.x; // invert the x axis
  TargetPos.x = constrain(TargetPos.x, .5, 1);
  TargetPos.x = TargetPos.x*width; 
  TargetPos.y = TargetPos.y*height;
  stroke(50);
  PVector myPos = new PVector(width/4*3, height/2);
  TargetPos.sub(myPos);
  for (int i = 1; i <= width/100; i++) {
    pushMatrix();
    float scale = (width/2)*.65-(i*15);
    float myX = myPos.x+(TargetPos.x*i*0.03);
    float myY = myPos.y+(TargetPos.y*i*0.03);
    translate(myX, myY);
    circle(0, 0, scale);
    popMatrix();
  };
}
