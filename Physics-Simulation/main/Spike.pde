class Spike{
  PVector point;
  PVector left;
  PVector right;
  
  Spike(float x, float y, boolean upsideDown){
    left = new PVector();
    right = new PVector();
    point = new PVector(x, y);
    float h = random(15,25);
    if (upsideDown){
      left.y = point.y - h;
    }
    else{
      left.y = point.y + h;
    }
    right.y = left.y;
    float w = random(15,25);
    left.x = point.y - w/2;
    right.x = point.y + w/2;
  }
  
  Spike(){
    boolean upsidedown = randomTrueFalse();
    float h = random(15, 25);
    float w = random(15, 25);
    float x = random(width);
    if (upsidedown){
      point = new PVector(x, h + height / 20);
      right = new PVector(x + w/2, height / 20);
      left = new PVector(x - w/2, height / 20);
    } else {
      point = new PVector(x, height - h);
      right = new PVector(x + w/2, height);
      left = new PVector(x - w/2, height);
    }
  }
  
  void display(){
    if(IMPALE){
      fill(0, 0, 0);
    } else {
      fill(0, 0, 0, 100);
    }
    strokeWeight(1);
    stroke(255);
    triangle(point.x, point .y, right.x, right.y, left.x, left.y);
  }
  
  boolean isImpaling(Orb orb){
    double x = point.x;
    double y = point.y;
    PVectorD pointD = new PVectorD(x, y);
    double dist = pointD.dist(orb.center);
    if(dist < orb.radius){
      return true;
    } else {
      return false;
    }
  }
  
  boolean randomTrueFalse(){
    float decider = random(-1, 1);
    return  decider > 0;
  }
}
