class CelestialObject extends Orb{
  CelestialObject(){
    super();
    attached = false;
  }
  CelestialObject(double x, double y, double size, double mass){//physical location in meters, not pixels! 
    super(x, y, size, mass);
    centerMeters.set(x, y);
    attached = false;
    fixed = false;
  }
  
  CelestialObject(double x, double y, double  size, double mass, double sizeMeters){//location  AND SIZE in meters, not pixels
    this(x, y, mass, size);
    this.sizeMeters = sizeMeters;
    this.radiusMeters = sizeMeters / 2;
  }
}
