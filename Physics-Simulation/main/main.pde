// =========================
// SETUP AND DRAW
// =========================

void setup() {
  size(600, 600); // Set window size
  frameRate(FRAMERATE); // Set framerate
  reset(0); // Create default orbs
  states = new States(width / 6, height / 20); // Initialize UI state display
  MOVING = false;
  paused = true;//intial program states
}

void draw() {
  if (!paused) update(); // Physics updates
  display(); // Rendering
}

// =========================
// DISPLAY FUNCTIONS
// =========================

void display() {//display everything
  background(25, 0, 60); // Background color
  displayOrbs(); // Draw all orbs
  if (SPRING_FORCE) {
    displaySprings();
  } // Draw springs if enabled
  states.display(); // Draw simulation state text
  displaySpikes();// Draw all spikes
  //center = centerOfMass();//not used. Useful potentially.
  if (paused) {
    drawPauseMenu();//draw the pause menu if paused
  }
  displayTime();//draw the time
}

void displayOrbs() {//display all orbs
  if (linked) {//if using linked list data type
    Node tempNode = slinky.front;
    while (tempNode != null) {
      tempNode.display();//display the node
      tempNode = tempNode.next;//iterate
    }
  } else {//if using array data type
    for (int i = 0; i < orbs.length; i++) {//iterate through orbs
      if (orbs[i] != null) {
        orbs[i].display(); // Display each orb
      }
    }
  }
}

void displaySprings() {//draw all sprigs
  if (linked) {//if using linked nodes data type
    Node tempNode = slinky.front;
    while (tempNode != null && tempNode.next != null) {
      if (tempNode.attached && tempNode.next.attached) {
        drawSpring(tempNode, tempNode.next);//draw each springs
      }
      tempNode = tempNode.next;
    }
  } else {//if using array data type
    for (int i = 0; i < orbs.length; i++) {
      if (orbs[i] != null && orbs[i].attached) {//iterate through array
        // Draw spring to adjacent attached orbs
        if (i + 1 < orbs.length && orbs[i+1] != null && orbs[i+1].attached) {
          drawSpring(orbs[i], orbs[i+1]);//draw each spring
        }
      }
    }
  }
}

void displaySpikes() {//draw spikes
  if (spikes != null) {
    for (Spike spike : spikes) {
      if (spike != null) {
        spike.display();
      }
    }
  }
}

void drawSpring(Orb orb1, Orb orb2) {
  strokeWeight(1);
  stroke(0, 0, 139); // Blue line
  line((float)orb1.center.x, (float)orb1.center.y, (float)orb2.center.x, (float)orb2.center.y);//draw the spring
}

void drawPauseMenu() {
  fill(0, 150);//transparent gray
  rect(0, 0, width, height);//draw transparent gray box over everytihg

  fill(255);//color letters white
  textSize(18);//letter size
  textAlign(LEFT, TOP);//word locations
  text("PAUSED\n\n" +
    "t - Toggle toScale: " + toScale + "\n" +
    "p - Toggle Pause: " + paused + "\n" +
    "i - Impale: " + IMPALE + "\n"+
    "space - Toggle Motion: " + MOVING + "\n" +
    "b - Toggle Bounce: " + BOUNCE_FORCE + "\n" +
    "c - Toggle Collisions: " + COLLISIONS + "\n" +
    "g - Toggle Gravity: " + GRAVITY_FORCE + "\n" +
    "s - Toggle Springs: " + SPRING_FORCE + "\n" +
    "d - Toggle Drag: " + DRAG_FORCE + "\n" +
    "f - Toggle Tails: " + tails + "\n" +
    "l - Toggle List Mode: " + (linked ? "Linked List" : "Array") + "\n" +
    "a -  Toggle asteroid creation \n" +
    "m - Toggle Whether Spikes Spawn: " + SPIKES + "\n" +
    "f - Toggle Tails : " + tails + "\n" +
    "up arrow for faster simulation \n down arrow for slower \n Current timeMultiplier: " + timeMult + "\n" +
    "1 - ordered orbs \n 2 - unordered orbs \n 3 - solar system \n" +
    "+ - add orb \n - - remove orb \n "+
    "scroll wheel to zoom in and out of space simulation",
    40, 40);
}

void displayTime() {//display the time that has passed
  textSize(20);
  fill(255, 255, 255);
  String text = "";
  if (seconds < 60) {
    text += getSeconds() + " seconds";
  } else if (seconds < 3600) {
    text += getMinutes() + " minutes, " + getSeconds() + " seconds";
  } else if (seconds < 3600 * 24) {
    text += getHours() + " hours, " + getMinutes() + " minutes, " + getSeconds() + " seconds";
  } else if (seconds < 3600 * 24* 365) {
    text += getDays() + " days";
  } else {
    text += getYears() + " years";
  }
  textAlign(LEFT);
  text(text, 50, height * 19 / 20);
}

String getSeconds() {
  return (int)seconds + "." + (int)((seconds % 1) * 10);//return the seconds rounded down to the first decimal
}
int getMinutes() {
  return (int)seconds / 60;//integral minutes
}

int getHours() {
  return (int) seconds / 3600;//integer hours
}

String getDays() {
  double days = seconds / (3600 * 24);
  return (int)days + "." + (int)((days % 1) * 10);//days rounded down to the decimal
}

String getYears() {
  double years = seconds / (3600 * 24 * 365);
  return (int)years + "." + (int)((years % 1) * 10);//days rounded down to the the decimal
}


// =========================
// UPDATE LOGIC
// =========================

void update(){//update the program each frame
  deltaT = timeMult / FRAMERATE;//seconds foward each frame
  if (MOVING) {//if we are moving
    if (SPRING_FORCE) {
      applySprings();
    }//apply spring force
    if (GRAVITY_FORCE) {
      applyGravity();
    }//apply gravity force
    if (DRAG_FORCE) {
      applyDrag();
    }//apply drag force
    if (BOUNCE_FORCE) {
      applyBounce();
    }//apply bouncing. Buggy with collisions.
    if (COLLISIONS) {
      handleCollisions();
    } // Handle bouncing collisions
    moveOrbs();//move all orbs
    if (IMPALE) {
      applyImpales();
    }//destroy orbs that are being impaled by the spikes
    seconds += deltaT;//how much time has been simulated?
  }
}

// =========================
// INTERACTION
// =========================

void keyPressed() {
  // Toggle forces and states using keyboard keys
  if (key == ' ') {
    MOVING = !MOVING;
    paused = !MOVING;
  } else if (key == 'g') {
    GRAVITY_FORCE = !GRAVITY_FORCE;
  } else if (key == 'b') {
    BOUNCE_FORCE = !BOUNCE_FORCE;
  } else if (key == 's') {
    SPRING_FORCE = !SPRING_FORCE;
  } else if (key == 'd') {
    DRAG_FORCE = !DRAG_FORCE;
  } else if (key == 'c') {
    COLLISIONS = !COLLISIONS;
  } else if (key == '1') {
    reset(0);
  } else if (key == '2') {
    reset(1);
  } else if (key == '3') {
    reset(2);
  } else if (key == 'l') {
    linked = !linked;
    reset();
  } else if (key == 'i') {
    IMPALE = !IMPALE;
  } else if (keyCode == UP) {
    speedUp(timeMult / 20);
  } else if (keyCode == DOWN) {
    slowDown(timeMult / 20);
  } else if (key == 'p') {
    paused = !paused;
    MOVING = !paused;
  } else if (key == '+') {
    addOrb();
  } else if (key == '-') {
    removeOrb();
  } else if (key == 'm') {
    SPIKES = !SPIKES;
  } else if (key == 't') {
    toScale = !toScale;
  } else if (key == 'f') {
    tails = !tails;
  } else if (key == 'r'){
    makeOrbs(gameState);
  }  else  if (key == 'a'){
    ASTEROIDS = !ASTEROIDS;
  }
}

void mouseWheel(MouseEvent event) {
  // Zoom in/out in solar system view
  if (gameState == 2) {//only allow zooming in solar system. Buggy when used with with the massive massive  earth object zoomed in the other simlations.
    float zoom = 0.9;
    if (event.getCount() > 0) {
      zoom(zoom);
    } else if (event.getCount() < 0) {
      zoom(1 / zoom);
    }
  }
}

void mouseDragged() {
  // Pan the view when dragging
  if (gameState == 2) {
    OFFSET.add(new PVectorD(mouseX - pmouseX, mouseY - pmouseY ));
  }
}

// =========================
// PHYSICS FORCE FUNCTIONS
// =========================

void applySprings() {
  if (linked) {
    Node tempNode = slinky.front;
    while (tempNode != null && tempNode.next != null) {
      if (tempNode.attached && tempNode.next.attached) {
        tempNode.applyForce(tempNode.getSpring(tempNode.next, SPRING_LENGTH, K_CONSTANT));
        tempNode.next.applyForce(tempNode.next.getSpring(tempNode, SPRING_LENGTH, K_CONSTANT));
      }
      tempNode = tempNode.next;
    }
  } else {
    for (int i = 0; i < orbs.length; i++) {
      if (orbs[i] != null && orbs[i].attached) {
        // Apply spring force to neighbors
        if (i + 1 < orbs.length && orbs[i+1] != null && orbs[i+1].attached) {
          orbs[i].applyForce(orbs[i].getSpring(orbs[i+1], SPRING_LENGTH, K_CONSTANT));
        }
        if (i - 1 >= 0 && orbs[i-1] != null && orbs[i-1].attached) {
          orbs[i].applyForce(orbs[i].getSpring(orbs[i-1], SPRING_LENGTH, K_CONSTANT));
        }
      }
    }
  }
}

void applyBounce() {
  if (linked) {
    Node tempNode = slinky.front;
    while (tempNode != null) {
      tempNode.bounce();
      tempNode = tempNode.next;
    }
  } else {
    for (int i = 0; i < orbs.length; i++) {
      if (orbs[i] != null) {
        orbs[i].bounce();
      }
    }
  }
}

void applyGravity() {
  if (linked) {
    Node tempNode1 = slinky.front;
    while (tempNode1 != null) {
      Node tempNode2 = tempNode1.next;
      while (tempNode2 != null) {
        tempNode1.applyForce(tempNode1.getGravity(tempNode2, G_CONSTANT));
        tempNode2.applyForce(tempNode2.getGravity(tempNode1, G_CONSTANT));
        tempNode2 = tempNode2.next;
      }
      tempNode1 = tempNode1.next;
    }
  } else {
    for (int i = 0; i < orbs.length; i++) {
      for (int j = 0; j < orbs.length; j++) {
        if (i != j && orbs[i] != null && orbs[j] != null) {
          orbs[i].applyForce(orbs[i].getGravity(orbs[j], G_CONSTANT));
        }
      }
    }
  }
}

void applyImpales() {
  if (spikes != null && SPIKES) {
    for (Spike spike : spikes) {
      if (linked) {
        Node tempNode = slinky.front;
        while (tempNode != null) {
          if (spike.isImpaling(tempNode)) {
            removeOrb(tempNode);
          }
          tempNode = tempNode.next;
        }
      } else {
        for (int i = 0; i < NUM_ORBS; i++) {
          if (spike.isImpaling(orbs[i])) {
            removeOrb(i);
          }
        }
      }
    }
  }
}

void applyDrag() {
  for (int i = 0; i < orbs.length; i++) {
    if (orbs[i] != null) {
      orbs[i].applyForce(orbs[i].getDrag(DRAG_CONSTANT));
    }
  }
}

// =========================
// COLLISION HANDLING
// =========================

void handleCollisions() {
  if (linked) {
    Node tempNode1 = slinky.front;
    while (tempNode1 != null) {
      Node tempNode2 = tempNode1.next;
      while (tempNode2 != null) {
        collide(tempNode1, tempNode2);
        tempNode2 = tempNode2.next;
      }
      tempNode1 = tempNode1.next;
    }
  } else {
    for (int i = 0; i < orbs.length; i++) {
      for (int j = i + 1; j < orbs.length; j++) {
        if (orbs[i] != null && orbs[j] != null) {
          collide(orbs[i], orbs[j]);
        }
      }
    }
  }
}

void collide(Orb a, Orb b) {
  PVectorD delta = b.centerMeters.copy().sub(a.centerMeters);
  double dist = delta.magnitude();
  double minDist = (a.radiusMeters + b.radiusMeters);
  if (dist < minDist && dist > 0) {
    // Overlap correction
    double overlap = (minDist - dist) / 2;
    PVectorD correction = delta.copy().normalize().mult(overlap);
    if (!a.fixed) a.centerMeters.sub(correction);
    if (!b.fixed) b.centerMeters.add(correction);
    a.updatePixels();
    b.updatePixels();

    // Elastic collision response
    PVectorD normal = delta.copy().normalize();
    PVectorD relVel = b.velocity.copy().sub(a.velocity);
    double velAlongNormal = relVel.dot(normal);
    if (velAlongNormal > 0) return;

    double restitution = 0.95; // somewhat inelastic
    double impulseMag = -(1 + restitution) * velAlongNormal / (1/a.mass + 1/b.mass);
    PVectorD impulse = normal.copy().mult(impulseMag);
    a.velocity.sub(impulse.copy().div(a.mass));
    b.velocity.add(impulse.copy().div(b.mass));
  }
}

void moveOrbs(){//move all orbs
  if (linked) {
    Node tempNode = slinky.front;
    while (tempNode != null) {
      tempNode.move();
      tempNode = tempNode.next;
    }
  } else {
    for (int i = 0; i < orbs.length; i++) {
      if (orbs[i] != null) {
        orbs[i].move(); // Update orb position
      }
    }
  }
}

// =========================
// RESET/ZOOM/SPEED CONTROL
// =========================


void reset(int GAMESTATE){//FULLY RESET THE SIMULATION RESTORING CONSTANTS AND BOOLEANS
  gameState = GAMESTATE;
  setConstants();
  if(gameState == 0){
    makeOrbs(true);
  } else if(gameState == 1){
    makeOrbs(false);
  } else if(gameState == 2){
    makeSolarSystem();
  }
}

void reset(){//FULLY RESET  THE GAME SIMULATION RESTORING CONSTANTS AND BOOLEANS
  reset(gameState);
}

void zoom(float a) {
  PVectorD mouse = new PVectorD(mouseX, mouseY);
  PIXELS_PER_METER *= a; // Scale view
  PVectorD newMouse = mouse.copy().sub(OFFSET);
  newMouse.mult(a);
  OFFSET = mouse.copy().sub(newMouse); // Adjust offset for zoom centering
  for (Orb orb : orbs) {
    if (orb != null) {
      orb.size *= a;
      orb.radius *= a;
    }
  }
}

void speedUp(double a) {
  timeMult += a;
}//speed up the simulation. Every frame is a more seconds

void slowDown(double a) {
  timeMult -= a;
}//slow down the simulation. Every frame is a less seconds.

// =========================
// DATA STRUCTURE FUNCTIONS
// =========================
//REMOVAL FUNCTIONS
void removeOrb(Node node) {//remove a specific node orb. For linked data type
  if (node == slinky.front) { slinky.removeNode(); }
  if (node.next != null) node.next.previous = node.previous;
  if (node.previous != null) node.previous.next = node.next;
  else slinky.front = node.next;
  slinky.front.c = color(255, 0, 0);
  node = null;
}

void removeOrb() {//remove the front node or the last orb in a list
  if (linked) {//if linked data
    if (slinky.front.next !=null) { slinky.removeNode(); }//remove the last node 
  } else { removeOrb(NUM_ORBS - 1); }//remove the node at this index. Should  be the last node if everything is workring right.
}

void removeOrb(int j) {//remove an orb at index j
  if (j < 1) return;//do not remove the earth which is at position 0.
  for (int i = j; i < orbs.length -1; i++) { orbs[i] = orbs[i+1]; }//shift every  orb after the one we are removing  backwards
  orbs[orbs.length - 1] = null;//the last orb has been shifted back, so remove it from it's previous location..
  NUM_ORBS--;//one less orb
}


void addOrb() {//add an orb
  Orb tempOrb = new Orb();//make a new orb
  if (gameState == 0 && !linked) {
    tempOrb.center.x = SPRING_LENGTH * NUM_ORBS * PIXELS_PER_METER;//locate it in order if ordered game state. ONly works for array data tyep.
    tempOrb.center.y = height / 2;
    tempOrb.updateMeters();
  }
  addOrb(tempOrb);//add the orb to the orbs.
}

void addOrb(Orb orb) {//add a specific orb
  if (!linked) {//if an array data type
    for (int i = 0; i < orbs.length; i++) {//iterate  through
      if (orbs[i] == null) {//if there is space
        orbs[i] = orb;//add the orb to the array
        NUM_ORBS += 1;//one more orb
        return;//finish the function
      }
    }
    Orb[] tempOrbs = new Orb[orbs.length + 50];//if there is not space, make a new longer array
    for (int i = 0; i < orbs.length; i++) { tempOrbs[i] = orbs[i]; }//copy the contents of the old array into the new one
    orbs = tempOrbs;//orbs is now the newly created array
    addOrb(orb);//we add the orb to the new arary
  } else {
    if(slinky != null){
      slinky.addFront(orb.toNode()); 
    } else {
      slinky = new NodeList(orb.toNode());
    }
  }//if not an array, add a node copy of the orb to the slinky data
}

void setConstants(){
  if(gameState == 0 || gameState == 1){
    //set booleans
    tails = false;
    IMPALE = true;
    BOUNCE_FORCE = true;
    GRAVITY_FORCE = true;
    COLLISIONS = true;
    DRAG_FORCE = true;
    SPRING_FORCE = true;
    BOUNCE_FORCE = true;
    //set constants
    timeMult = defaultTimeMult;//
    seconds = 0;//reset time to 0
    OFFSET = new PVectorD(0, 0);//no offset (used for moving  around the mouse and zooming.
    timeMult = 1;//program is in real time by default. One second per second
    PIXELS_PER_METER = 100;//100 pixels per meter
    NUM_ORBS = 12;//12 orbs
  } else if (gameState == 2){
    //booleans
    IMPALE = false;
    BOUNCE_FORCE = true;
    GRAVITY_FORCE = true;
    COLLISIONS = true;
    DRAG_FORCE = false;
    SPRING_FORCE = false;
    tails  = true;
    BOUNCE_FORCE = false;
    //set constants
    seconds = 0;
    OFFSET = new PVectorD(width / 2, height / 2);
    timeMult = solarSystemTimeMult; // 1 second = 1 month
    NUM_ORBS = 11;
    NUM_SPIKES = 0;
    spikes = null;
    PIXELS_PER_METER = 0.35 * pow(10, -9);
  }
}

// =========================
// OBJECT CREATION
// =========================
void makeSpikes(int num) {//makes spikes. num is the number of spikes.
  NUM_SPIKES = num;
  if (NUM_SPIKES > 0) {
    spikes = new Spike[NUM_SPIKES];
    for (int i = 0; i < spikes.length; i++) {
      spikes[i] = new Spike();
    }
  } else {
    spikes = null;
  }
}

void makeOrbs(int GAMESTATE){//make a new simulation WITH THE EXACT SAME SETTINGS / BOOLEANS EXCEPT TIME
  seconds = 0;
  gameState = GAMESTATE;
  if(gameState == 0){
    timeMult = defaultTimeMult;
    makeOrbs(true);
  } else if( gameState == 1 ){
    timeMult = defaultTimeMult;
    makeOrbs(false);
  }else if (gameState == 2){
    timeMult = solarSystemTimeMult;
    makeSolarSystem();
  }
}

void makeOrbs(boolean ordered) {//makes orbs ordered or unordered
  earth = new Orb(width / 2, earthRadius * PIXELS_PER_METER + height, earthRadius * 2 * PIXELS_PER_METER, massEarth);
  earth.attached =  false;
  earth.fixed = true;
  int orbsToAdd = NUM_ORBS;
  NUM_ORBS = 0;
  orbs = new Orb[0];
  slinky = null;
  addOrb(earth);
  for(int i = 1; i < orbsToAdd; i++){
    Orb tempOrb = new Orb();
    if(ordered){
      tempOrb.center.x = 10 + i * SPRING_LENGTH * PIXELS_PER_METER;
      tempOrb.center.y = height /  2;
      tempOrb.updateMeters();
    }
    addOrb(tempOrb);
  }
  if(SPIKES){
    makeSpikes(10);
  }
}

void makeSolarSystem() {//make the solar system
  NUM_ORBS = 0;
  orbs = new Orb[NUM_ORBS];
  slinky = null;
  // Create and initialize each celestial body
  earth = new CelestialObject(0, distanceEarth, massEarth, 10, sizeEarth);//celestial bodies are described  by their location and size in space, not pixels. Attached is false by default.
  earth.c = color(0, 0, 255);
  earth.velocity.set(29784, 0);
  earth.updatePixels();

  sun = new CelestialObject(0, 0, massSun, 25, sizeSun);
  sun.tail.maxTime = (double)3600 * 24 * 365 * 100;
  sun.c = color(255, 100, 0);
  sun.updatePixels();

  mars = new CelestialObject(0, distanceMars, massMars, 10, sizeMars);
  mars.c = color(255, 0, 0);
  mars.velocity.set(velocityMars, 0);
  mars.updatePixels();

  venus = new CelestialObject(0, distanceVenus, massVenus, 10, sizeVenus);
  venus.c = color(165, 124, 27);
  venus.velocity.set(velocityVenus, 0);
  venus.updatePixels();

  mercury = new CelestialObject(0, distanceMercury, massMercury, 10, sizeMercury);
  mercury.c = color(183, 184, 185);
  mercury.velocity.set(velocityMercury, 0);
  mercury.updatePixels();

  jupiter = new CelestialObject(0, distanceJupiter, massJupiter, 15, sizeJupiter);
  jupiter.c = color(180, 167, 158);
  jupiter.velocity.set(velocityJupiter, 0);
  jupiter.updatePixels();

  saturn = new CelestialObject(0, distanceSaturn, massSaturn, 13, sizeSaturn);
  saturn.c = color(210, 180, 140);
  saturn.velocity.set(velocitySaturn, 0);
  saturn.updatePixels();

  uranus = new CelestialObject(0, distanceUranus, massUranus, 12, sizeUranus);
  uranus.c = color(173, 216, 230);
  uranus.velocity.set(velocityUranus, 0);
  uranus.updatePixels();

  neptune = new CelestialObject(0, distanceNeptune, massNeptune, 12, sizeNeptune);
  neptune.c = color(72, 61, 139);
  neptune.velocity.set(velocityNeptune, 0);
  neptune.updatePixels();

  pluto = new CelestialObject(0, distancePluto, massPluto, 4, sizePluto);
  pluto.c = color(190, 190, 190);
  pluto.velocity.set(velocityPluto, 0);
  pluto.updatePixels();

  moon = new CelestialObject(0, earth.centerMeters.y + distanceMoonFromEarth, massMoon, 3, sizeMoon);
  moon.c = color(255);
  moon.velocity.set(velocityMoonFromEarth + velocityEarth, 0);
  moon.updatePixels();

  // Add planets to orbs array
  addOrb(sun);
  addOrb(mercury);
  addOrb(venus);
  addOrb(earth);
  addOrb(moon);
  addOrb(mars);
  addOrb(jupiter);
  addOrb(saturn);
  addOrb(uranus);
  addOrb(neptune);
  addOrb(pluto);
  if(ASTEROIDS){
    makeAsteroidBelt();
  }
  
  PVectorD solarMomentum = getSolarSystemMomentum().mult(-1);
  sun.velocity = sun.momentumToVelocity(solarMomentum);
  if(linked){
    slinky.end.velocity = sun.velocity;
  }
}

void makeAsteroidBelt(){
  for(int i = 0; i < 100; i++){
    double kgPerMeter3 = random(1000, 4000);
    double radius = random(5000);
    double volume = Math.pow(radius, 3) * 4 * PI / 3;
    double mass = volume * kgPerMeter3;
    double distance = distanceJupiter * random(0.7, 0.9);
    double speed = velocityJupiter * Math.sqrt(distanceJupiter / distance);
    float angle = random(2 * PI);
    Orb asteroid = new CelestialObject(distance * cos(angle), distance * sin(angle), mass, 1, radius * 2);
    asteroid.velocity.set(speed * sin(angle), speed * -cos(angle));
    asteroid.c = color(255);
    asteroid.tail.maxTime = 3600 * 24 * 5;
    addOrb(asteroid);
  }
}

// =========================
// SOLAR SYSTEM UTILITY FUNCTIONS
// =========================
PVectorD getSolarSystemMomentum() {//return the momentum of the solar system. By setting the sun momentum  to be negative this, the solar system can have a net momentum of 0. 
  PVectorD momentum = new PVectorD();
  if (linked) {
    Node tempNode = slinky.front;
    while (tempNode != null) {
      momentum.add(tempNode.getMomentum());
      tempNode = tempNode.next;
    }
  } else {
    for (int i = 0; i < NUM_ORBS; i++) {
      momentum.add(orbs[i].getMomentum());
    }
  }
  return momentum;
}

PVectorD centerOfMass() {//returns the center of mass. Not currently used for anything
  PVectorD total = new PVectorD(0, 0);
  double totalMass = 0;
  for (Orb orb : orbs) {
    if (orb != null) {
      total.add(orb.centerMeters.copy().mult(orb.mass));
      totalMass += orb.mass;
    }
  }
  if (totalMass == 0) return new PVectorD(0, 0);
  return total.div(totalMass);
}

// =========================
// NOTES ON UNITS
// =========================
/****************
 *****************
 SCALING KEY
 TIME IS IN SECONDS
 DISTNANCE IS IN PIXELS BUT THERE IS A PIXEL TO METER CONVERSION
 MASS UNITS ARE KGS
 *****************
 *****************
 ****************/
 
// =========================
// GLOBAL VARIABLES
// =========================

// Position offset for zoom/pan
PVectorD OFFSET;//everything is offset by this many pixels. 
// Parameters
double MIN_MASS = 10;
double MAX_MASS = 100;
double MAX_SIZE = 50;
double MIN_SIZE = 10;
int FRAMERATE = 200;
int NUM_ORBS = 10;
int  NUM_SPIKES = 10;
double PIXELS_PER_METER = 100;
double timeMult;
double seconds;
double deltaT;
double solarSystemTimeMult = 3600 * 24 * 31 * 3;
double defaultTimeMult = 1;
// Solar system orbital constants,  units in kg, meters, or m/s as specified
double massEarth = 5.97219 * pow(10, 24);
double earthRadius = 6368100;
double distanceEarth = 150 * pow(10, 9);
double velocityEarth = 29784.8;
double sizeEarth = 12756000;

double massSun = 1.989 * pow(10, 30);
double sizeSun = 1392684000;

double massMars = 6.39 * pow(10, 23);
double distanceMars = 250 * pow(10, 9);
double velocityMars = 24070;
double sizeMars = 3389500;

double massVenus = 4.867 * pow(10, 24);
double distanceVenus = 107.84 * pow(10, 9);
double velocityVenus = 35020;
double sizeVenus = 12104000;

double massMercury = 3.3 * pow(10, 23);
double distanceMercury = 57.9 * pow(10, 9);
double velocityMercury = 47870;
double sizeMercury = 4879000;

double massJupiter = 1.898 * pow(10, 27);
double distanceJupiter = 778.3 * pow(10, 9);
double velocityJupiter = 13060;
double sizeJupiter = 142984000;

double massMoon = 7.34767 * pow(10, 22);
double distanceMoonFromEarth = 384.4 * pow(10, 6);
double velocityMoonFromEarth = 1022;
double sizeMoon = 3474800;

double massSaturn = 5.683 * pow(10, 26);
double distanceSaturn = 1.429 * pow(10, 12);
double velocitySaturn = 9680;
double sizeSaturn = 120536000;

double massUranus = 8.681 * pow(10, 25);
double distanceUranus = 2.871 * pow(10, 12); // 2,871,000,000 km
double velocityUranus = 6800;
double sizeUranus = 51118000;

double massNeptune = 1.024 * pow(10, 26);
double distanceNeptune = 4.495 * pow(10, 12); // 4,495,000,000 km
double velocityNeptune = 5430;
double sizeNeptune = 49528000;

double massPluto = 1.309 * pow(10, 22);
double distancePluto = 5.9 * pow(10, 12); // Average distance in meters (5,900,000,000 km)
double velocityPluto = 4740; // Approximated to match elliptical distance
double sizePluto = 2376800;
// Constants for forces
double G_CONSTANT = 6.673000 * pow(10, -11);
double K_CONSTANT = 100;
double DRAG_CONSTANT = 10;
double SPRING_LENGTH = 0.5;
// Toggles
boolean ASTEROIDS = true;
boolean GRAVITY_FORCE;
boolean SPRING_FORCE;
boolean DRAG_FORCE;
boolean COLLISIONS;
boolean BOUNCE_FORCE;
boolean MOVING;
boolean IMPALE;
boolean paused = true;
boolean linked = false;//linked list vs array
boolean SPIKES = false;
boolean toScale = false;
boolean tails = false;
int gameState = 0;//0 is ordered. 1 is unordered. 2 is solar system
// Objects
Orb[] orbs;//the array of orbs
Spike[] spikes;//the array of spikes
NodeList slinky;//the linked list of slinkies
States states;//the object that draws the guide on the top of the screen saying what's on and off
PVector center;//center of gravity. Not used
// Celestial bodies
Orb earth, sun, mars, venus, mercury, jupiter, saturn, uranus, neptune, pluto, moon;//the planets
