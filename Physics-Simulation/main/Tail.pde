class Tail{
  TailNode front;
  TailNode end;
  double timePassed;
  double maxTime = 24 * 3600 * 31 * 6;
  
  Tail(){}
  
  void display(){
    TailNode tempNode = front;
    beginShape();
    noFill();
    stroke(255, 255, 255);
    while(tempNode != null){
      tempNode.updatePixels();
      vertex((float)tempNode.positionPixels.x, (float)tempNode.positionPixels.y);
      tempNode =  tempNode.next;
    }
    endShape();
  }
  
  void addFront(double x, double y){
    if(front == null){
      front = new TailNode(x, y);
      end = front;
    } else {
      TailNode tempNode;
      tempNode = new TailNode(x, y);
      tempNode.next = front;
      front.previous = tempNode;
      front = tempNode;
    }
    findTimePassed();
    limit();
  }
  
  void limit(){
    if(gameState == 2){
      while(timePassed > maxTime){
        removeEnd();
      }
    } else {
      while(timePassed > 1){
        removeEnd();
      }
    }
  }
  
  void findTimePassed(){
    timePassed = front.time - end.time;
  }
  
  void removeEnd(){
    end = end.previous;
    end.next = null;
    timePassed = front.time - end.time;
  }
}
