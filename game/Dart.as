package {
  public class Dart extends MovingEntity {
    private const SIZE:int = C.size;
    private var type:int = 1;
    private var oldLoc:Vec;

    function Dart(x:int, y:int, type:int, speed:Vec) {
      super(x, y, SIZE, SIZE);

      if (type == Character.POISON_NEEDLE) {
        loadSpritesheet(C.SpritesClass, C.dim, new Vec(2, 4));
      } else {
        loadSpritesheet(C.SpritesClass, C.dim, new Vec(2, 5));
      }

      this.type = type;
      this.vel = speed.clone();
      this.oldLoc = new Vec(this.x, this.y);

      this.width -= 2;
      this.height -= 2;
    }

    public override function update(e:EntitySet):void {
    	super.update(e);

      if (this.x < 0 || this.y < 0 || this.x >= Fathom.mapRef.width || this.y >= Fathom.mapRef.height) {
        this.destroy();
      }

      // Bad hack.
      if (this.vel.x != 0 && this.oldLoc.x == this.x) {
        this.destroy();
      }

      if (this.vel.y != 0 && this.oldLoc.y == this.y) {
        this.destroy();
      }

      // TERRIBLE hack.
      this.x += this.vel.x;
      this.y += this.vel.y;

    	var enemies:EntitySet = Fathom.entities.get("enemy");

    	for each (var en:Entity in enemies) {
    		if (en.touchingRect(this)) {
    			var ik:IKillable = (en as IKillable);

          trace("MURDER MURDER DIE HA HA HA");
    			ik.die(this.type);

          this.destroy();
    		}
    	}

      this.x -= this.vel.x;
      this.y -= this.vel.y;
      this.oldLoc = new Vec(this.x, this.y);
    }
  }
}
