class PVectorD {
  //borrowed this class from the internet, but heavily modified it. All methods below are my additions until stated otherwise
  double x, y, z;
  
  PVectorD(){
  }
  
  PVectorD copy(){
    return new PVectorD(x, y, z);
  }
  
  PVectorD mult(double m){
    x *= m;
    y *= m;
    z *= m;
    return this;
  }
  
  PVectorD add(PVectorD vector){
    x += vector.x;
    y += vector.y;
    z += vector.z;
    return  this;
  }
  
  PVectorD sub(PVectorD vector){
    x -= vector.x;
    y -= vector.y;
    z -= vector.z;
    return  this;
  }
  
  PVectorD div(double d){
    x /= d;
    y /= d;
    z /= d;
    return this;
  }
  
  double magnitude(){
    return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2) + Math.pow(z, 2));
  }
  
  double dist(PVectorD other){
    return Math.sqrt(Math.pow(this.x - other.x, 2) + Math.pow(this.y - other.y, 2) + Math.pow(this.z - other.z, 2));
  }
  
  PVectorD normalize(){
    double magnitude = dist(new PVectorD());
    if(magnitude != 0){
      this.div(magnitude);
    } else {
      this.set(1, 0, 0);
    }
    return this;
  }
  
  double dot(PVectorD other){
    return other.x * x + other.y * y + other.z * z;
  }
  
//END OF MY ADDITIONS
  PVectorD(double x, double y) {
    this.x = x;
    this.y = y;
  }

  PVectorD(double x, double y, double z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  PVectorD(PVector p) {
    set(p);
  }
  
  void clear() {
    x = y = z = 0;
  }

  void set(double x, double y) {
    this.x = x;
    this.y = y;
  }

  void set(double x, double y, double z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  void set(PVector p) {
    x = p.x;
    y = p.y;
    z = p.z;
  }

  PVector toPVector() {
    return new PVector((float) x, (float) y, (float) z);
  }
  
  String toString() {
    return "[ " + x + ", " + y + ", " + z + " ]";
  }
}
