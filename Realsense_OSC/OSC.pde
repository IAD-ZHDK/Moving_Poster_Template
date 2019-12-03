

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
