package {
  public class EnemyStatic extends Entity implements ILightSource, IKillable {
    private const SIZE:int = C.size;
    public static var noPower:Boolean = false;
    public var isOutOfAction:Boolean = false
    public static var noWarp:Boolean = true;

    public var countdown:int = 0;

    var dir:Vec = new Vec(0, 1);

    function EnemyStatic(dir:Vec) {
      super(0, 0, SIZE, SIZE);

      this.dir = dir;
    }

    override public function groups():Set {
      return super.groups().concat("lightsource", "enemy");
    }

    override public function update(e:EntitySet):void {
      if (isOutOfAction) {
          if (countdown > 0) {
              countdown--;
              if (countdown <= 0) {
                  isOutOfAction = false;
                  setTile(1, 3);
              }
          }

          return;
      }

    	super.update(e);
    }

    /* IKillable */

    public function die(type:int):void {
      if (type == Character.POISON_NEEDLE) {
        setTile(1, 6);
        Character.murdered = true;
      } else {
        setTile(1, 7);
        countdown = 90;
      }

      isOutOfAction = true;
    }

    /* ILightSource */

  	public function location():Vec {
  		return vec();
  	}

  	public function power():int {
      if (isOutOfAction) {
        return 0;
      }

      if (EnemyStatic.noPower && EnemyStatic.noWarp) {
        return 1;
      } else {
    		return 10;
      }
  	}

  	public function angle():int {
  		return dir.angle();
  	}

    public function isBenign():Boolean {
      return false;
    }
  }
}
