package {
  public class Dart extends MovingEntity {
    private const SIZE:int = C.size;
    private var type:int = 1;

    function Dart(x:int, y:int, type:int, speed:Vec) {
      super(x, y, SIZE, SIZE);

      if (type == Character.POISON_NEEDLE) {
        loadSpritesheet(C.SpritesClass, C.dim, new Vec(2, 4));
      } else {
        loadSpritesheet(C.SpritesClass, C.dim, new Vec(2, 3));
      }

      this.type = type;
    }

    public override function update(e:EntitySet):void {
    	super.update(e);

    	var enemies:EntitySet = Fathom.entities.get("enemy");

    	for each (var en:Entity in enemies) {
    		if (en.touchingRect(this)) {
    			var ik:IKillable = (en as IKillable);

    			ik.die(this.type);
    		}
    	}
    }
  }
}
