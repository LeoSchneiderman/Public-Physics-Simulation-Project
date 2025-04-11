public class States{
  int w;
  int h;
  States(int w, int h){
    this.w = w;
    this.h = h;
  }
  void display(){
    stroke(0);
    strokeWeight(1);
    textSize(10);
    textAlign(CENTER);
    if(GRAVITY_FORCE){fill(0, 255, 0);} else {fill(255, 0, 0);} rect(0, 0, w, h); fill(0, 0, 0); text("Gravity", w/2, h/2);
    if(MOVING){fill(0, 255, 0);} else {fill(255, 0, 0);} rect(w, 0, w, h); fill(0, 0, 0); text("Moving", w/2 + w, h/2);
    if(BOUNCE_FORCE){fill(0, 255, 0);} else {fill(255, 0, 0);} rect(w * 2, 0, w, h); fill(0, 0, 0); text("Bouncing", w/2 + w * 2, h/2);
    if(SPRING_FORCE){fill(0, 255, 0);} else {fill(255, 0, 0);} rect(w * 3, 0, w, h); fill(0, 0, 0); text("Spring", w/2 + w * 3, h/2);
    if(DRAG_FORCE){fill(0, 255, 0);} else {fill(255, 0, 0);} rect(w * 4, 0, w, h); fill(0, 0, 0); text("Drag", w/2 + w * 4, h/2);
    if(COLLISIONS){fill(0, 255, 0);} else {fill(255, 0, 0);} rect(w * 5, 0, w, h); fill(0, 0, 0); text("Collsiions", w/2 + w * 5, h/2);
    fill(0, 255, 0); rect(0, h, w, h); fill(0, 0, 0); text(linked ? "Linked" : "Array", w/2, h/2 + h);
    if(IMPALE){fill(0, 255, 0);} else {fill(255, 0, 0);} rect(w, h, w, h); fill(0, 0, 0); text("Impaling", w/2 + w, h/2 + h);
    if(SPIKES){fill(0, 255, 0);} else {fill(255, 0, 0);} rect(w * 2, h, w, h); fill(0, 0, 0); text("Spawn Spikes", w/2 + 2*w, h/2 + h);
    if(toScale){fill(0, 255, 0);} else {fill(255, 0, 0);} rect(w * 3, h, w, h); fill(0, 0, 0); text("to scale", w/2 + 3*w, h/2 + h);
    if(tails){fill(0, 255, 0);} else {fill(255, 0, 0);} rect(w * 4, h, w, h); fill(0, 0, 0); text("tales", w/2 + 4*w, h/2 + h);
  }
}
