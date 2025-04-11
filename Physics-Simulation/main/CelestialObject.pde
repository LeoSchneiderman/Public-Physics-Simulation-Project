class CelestialObject extends Orb{
  CelestialObject(){
    super();
    attached = false;
  }
  CelestialObject(double x, double y, double mass, double size){//physical location and size in meters, not pixels! 
    super(x, y, mass, size);
    centerMeters.set(x, y);
    attached = false;
    fixed = false;
  }
  
  CelestialObject(double x, double y, double  mass, double size, double sizeMeters){
    this(x, y, mass, size);
    this.sizeMeters = sizeMeters;
    this.radiusMeters = sizeMeters / 2;
  }
}
