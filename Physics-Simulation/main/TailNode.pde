class TailNode{
  TailNode next;
  TailNode previous;
  PVectorD position;
  PVectorD positionPixels;
  color c;
  double time;
  
  TailNode(double x, double y){
    position = new PVectorD(x, y);
    c = color(255,255, 255);
    time = seconds;
  }
  
  void updatePixels() {
    positionPixels = position.copy().mult(PIXELS_PER_METER).add(OFFSET);
  }
}
