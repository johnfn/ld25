package {
  public class EnemyStatic extends Entity implements ILightSource, IKillable {
    private const SIZE:int = C.size;
    public static var noPower:Boolean = false;

    var dir:Vec = new Vec(0, 1);

    function EnemyStatic(dir:Vec) {
      super(0, 0, SIZE, SIZE);

      this.dir = dir;
    }

    override public function groups():Set {
      return super.groups().concat("lightsource", "enemy");
    }

    override public function update(e:EntitySet):void {
    	super.update(e);
    }

    /* IKillable */

    public function die(type:int):void {
      if (type == Character.POISON_NEEDLE) {
        setTile(1, 6);
        Character.murdered = true;
      } else {
        setTile(1, 7);
      }
    }

    /* ILightSource */

  	public function location():Vec {
  		return vec();
  	}

  	public function power():int {
      if (EnemyStatic.noPower) {
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
