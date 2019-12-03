//code for setting up correct aspect ratio
// do not change!
class ScreenSetup {
  private int posterWidth;
  private int posterHeight;
  private  float pageWidth = 1080*2;
  private  float pageHeight = 1920;
  ScreenSetup() {
    surface.setResizable(true);
    float aspectRatioH = pageWidth/pageHeight;
    float aspectRatioV = pageHeight/pageWidth;

    if (displayWidth< displayHeight) {
      // for portrait mode
      posterWidth= displayWidth;
      posterHeight = floor(displayWidth*aspectRatioV);
    } else {
      // for landscape mode
      posterWidth= floor(displayHeight*aspectRatioH);
      posterHeight = displayHeight;
    }

    surface.setSize(posterWidth, posterHeight);
    width = floor(posterWidth);
    height = floor(posterHeight);
    //reposition output in center of display
    int startPointX = (displayWidth/2) - (width/2);
    int startPointY = (displayHeight/2) - (height/2);
    surface.setLocation(startPointX, startPointY);
  }
}
