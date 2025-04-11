class NodeList{
  //objects
  Node front;
  Node end;
  
  //constructor
  NodeList(){
    front = new Node();
    end = front;
  }
  
  NodeList(Node node){
    front = node;
    end = front;
  }
  
  void addFront(Node newNode){
    if(front != null){
      Node tempNode = newNode;
      tempNode.next = front;
      front.previous = tempNode;
      front = newNode;
    } else {
      front = newNode;
    }
    if(gameState != 2){
      front.c = color(255, 0, 0);
      if(front.next != null){
        front.next.setColor();
      }
    }
  }
  
  void addFront(){
    Orb tempOrb = new Orb();
    Node tempNode = tempOrb.toNode();
    addFront(tempNode);
  }
  
  void removeNode(){
    if(front != null){
      if(front.next != null) {
        front = front.next;
        front.c = color(255, 0, 0);
      } else {
        front = null;
      }
    }
  }
}
