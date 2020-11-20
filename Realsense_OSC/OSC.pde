import javax.imageio.*;
import java.awt.image.*; 
import java.io.*;

void sendPos(int x, int y, float w, float h) {
  float xNormal = float(x);
  float yNormal = float(y);
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

void stream(byte[] raw) {
  OscMessage myOscMessage = new OscMessage("/stream");
  //myOscMessage.add(encodeIMG(img));
  myOscMessage.add(raw);
  //  myOscMessage2.add(h);
  oscP5.send(myOscMessage, remote);
  // camera.readFrames();
  // PImage trackImage = camera.getDepthImage();
  // server.sendImage(trackImage);
}

byte[] encodeIMG(PImage img){
  BufferedImage bimg = new BufferedImage(img.width,img.height, BufferedImage.TYPE_INT_RGB );

  // Transfer pixels from localFrame to the BufferedImage
  img.loadPixels();
  bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);

  // Need these output streams to get image as bytes for UDP communication
  ByteArrayOutputStream baStream  = new ByteArrayOutputStream();
  BufferedOutputStream bos    = new BufferedOutputStream(baStream);

  // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
  // Requires try/catch
  try {
    ImageIO.write(bimg, "jpg", bos);
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
  byte[] b = baStream.toByteArray();
  return b;
}

void videoOutput(boolean streaming) {
  videoOutput = streaming;
}


/* incoming osc message are forwarded to the oscEvent method. */
public void oscEvent(OscMessage theOscMessage) {
  /* with theOscMessage.isPlugged() you check if the osc message has already been
   * forwarded to a plugged method. if theOscMessage.isPlugged()==true, it has already
   * been forwared to another method in your sketch. theOscMessage.isPlugged() can
   * be used for double posting but is not required.
   */

  if (theOscMessage.isPlugged()==false) {
    /* print the address pattern and the typetag of the received OscMessage */
    // println("### received an osc message.");
    //println("### addrpattern\t"+theOscMessage.addrPattern()+ " typetag\t"+theOscMessage.typetag());
  }
}
