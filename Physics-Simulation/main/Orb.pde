import java.lang.Math;
class Orb {
  // Fields
  PVectorD center;            // Location in pixels (100 pixels = 1 meter)
  PVectorD centerMeters;      // Location in meters
  PVectorD acceleration;      // Acceleration (m/s^2) UNUSED
  PVectorD velocity;          // Velocity (m/s)
  PVectorD momentum;          // Momentum  (kg m / s)
  double mass;                // Mass in kilograms
  double size;                // Size in pixels
  double radius;              // Radius in pixels
  double sizeMeters;          // Size in meters
  double radiusMeters;        // Radius in meters
  color c;                    // Orb color
  boolean bounces;            // Does orb bounce?
  boolean attached;           // Is orb attached by a spring
  boolean hasTail;            // Has a tale?
  Tail tail;
  // Constructor with parameters
  Orb(double x, double y, double size, double mass) {
    this.size = size;
    this.mass = mass;
    this.radius = size / 2.0;
    this.sizeMeters = size / PIXELS_PER_METER;
    this.radiusMeters = radius / PIXELS_PER_METER;
    center = new PVectorD(x, y);
    centerMeters = center.copy().div(PIXELS_PER_METER);
    velocity = new PVectorD();
    momentum = new PVectorD();
    acceleration = new PVectorD();
    bounces = true;
    attached = true;
    setColor();
    hasTail = true;
    tail = new Tail();
  }
  // Random orb constructor
  Orb() {
    this(
      random(0 + (float)MAX_SIZE, width - (float)MAX_SIZE),
      random(0 + (float)MAX_SIZE, height - (float)MAX_SIZE),
      random((float)MIN_SIZE, (float)MAX_SIZE),
      0
    );
    this.mass = (size / MAX_SIZE) * MAX_MASS;
    setColor();
  }
  // Display the orb
  void display() {
    noStroke();
    fill(c);
    if(toScale){
      circle((float)center.x, (float)center.y, (float)sizeMeters * (float)PIXELS_PER_METER);
      circle((float)center.x, (float)center.y, 1);
    } else {
      circle((float)center.x, (float)center.y, (float)size);
    }
    if(tails && hasTail){
      tail.display();
    }
  }
  // Physics movement
  void move() {
    if(hasTail){ tail.addFront(centerMeters.x, centerMeters.y); }
    velocity = getVelocity();//get velocity from momentum
    centerMeters.add(velocity.copy().mult(deltaT));
    updatePixels();
    }
  // Apply a force (in Newtons)
  void applyForce(PVectorD force) {
    momentum.add(force.copy().mult(deltaT));
  }
  // Wall bounce (Y axis)
  boolean yBounce() {
    if (center.y > height - radius) {
      momentum.y *= -0.95;
      center.y = height - radius;
      updateMeters();
      return true;
    } else if (center.y < height / 20 + radius) {
      momentum.y *= -0.95;
      center.y = radius + height / 20;
      updateMeters();
      return true;
    }
    return false;
  }
  // Wall bounce (X axis)
  boolean xBounce() {
    if (center.x > width - radius) {
      momentum.x *= -0.95;
      center.x = width - radius;
      updateMeters();
      return true;
    } else if (center.x < radius) {
      momentum.x *= -0.95;
      center.x = radius;
      updateMeters();
      return true;
    }
    return false;
  }
  void bounce(){
    if(bounces){
      xBounce();
      yBounce();
    } 
  }
  // Gravitational force between two orbs
  PVectorD getGravity(Orb other, double G) {
    double r = Math.max(centerMeters.dist(other.centerMeters), 1);
    double forceMag = G * mass * other.mass / (r * r);
    PVectorD force = other.centerMeters.copy().sub(centerMeters).normalize().mult(forceMag);
    return force;
  }
  // Spring force between two orbs
  PVectorD getSpring(Orb other, double springLength, double K) {
    double distance = centerMeters.dist(other.centerMeters);
    double stretch = distance - springLength;
    double forceMag = stretch * K;
    PVectorD force = other.centerMeters.copy().sub(centerMeters).normalize().mult(forceMag);
    return force;
  }
  // Drag force
  PVectorD getDrag(double dragConstant) {
    double speed = velocity.magnitude();
    double dragMag = dragConstant * speed * speed;
    PVectorD drag = velocity.copy().mult(-1).normalize().mult(dragMag);
    return drag;
  }
  // Momentum
  PVectorD getMomentum(){//get momentum in kg m / s
    return velocity.copy().mult(mass);
  }
  PVectorD getVelocity(){
    return momentum.copy().div(mass);
  }
  // Set orb color based on mass
  void setColor() {
    color light = color(0, 255, 255);
    color dark = color(0);
    c = lerpColor(light, dark, (float)mass / (float)MAX_MASS);
  }
  // Update pixel coordinates based on meter position
  void updatePixels() {
    center = centerMeters.copy().mult(PIXELS_PER_METER).add(OFFSET);
  }

  // Update meter position based on pixel coordinates
  void updateMeters() {
    centerMeters = center.copy().sub(OFFSET).div(PIXELS_PER_METER);
  }
  Node toNode(){
    Node tempNode = new Node();
    tempNode.center = center.copy();            // Location in pixels (100 pixels = 1 meter)
    tempNode.centerMeters = centerMeters.copy();       // Location in meters
    tempNode.acceleration = acceleration;      // Acceleration (m/s^2)
    tempNode.velocity = velocity.copy();          // Velocity (m/s)
    tempNode.momentum = momentum.copy();           // momentum (kg m / s)
    tempNode.mass = mass;                // Mass in kilograms
    tempNode.size =size;                // Size in pixels
    tempNode.radius = radius;              // Radius in pixels
    tempNode.c = c;                    // Orb color
    tempNode.bounces = bounces;              //Does it bounce
    tempNode.attached = attached;           // Is orb attached by a spring
    tempNode.radiusMeters = radiusMeters;
    tempNode.sizeMeters = sizeMeters;
    tempNode.tail = tail;
    tempNode.hasTail = hasTail;
    return tempNode;
  }
}
