Tracker myTracker;
PImage[] imageArray;

void setup() {
   fullScreen(FX2D);  // actual screen size 1080*1920*2;
  // fullScreen(FX2D, SPAN); // use this for displaying on multiple screens
  ScreenSetup screen = new ScreenSetup(); // important for scaling the screen for the correct aspect ratio
  myTracker = new Tracker();// important for getting the tracking information from an external application
  rectMode(CENTER);
  fill(255);
  imageArray = new PImage[119];
  for (int i = 0; i <119; i++) {
    String seriesNo = nf(i, 3);
    imageArray[i] = loadImage("image"+seriesNo+".jpg");
    if (height!=1920) {
      imageArray[i].resize(width/2, height);
    }
    println(i);
  }
};

void draw() {
  PVector Pos = myTracker.getTarget(); // the getTarget returns the position of the target  
  int index = constrain(floor(imageArray.length*Pos.x), 0, imageArray.length-1);
  image(imageArray[index], 0, 0);
  image(imageArray[index], width/2, 0);
  if (frameCount % 120 == 1  ) println("FPS"+frameRate); // for checking the performance of your code
};
