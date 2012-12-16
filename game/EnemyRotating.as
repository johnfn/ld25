package {
  public class EnemyRotating extends Entity implements ILightSource, IKillable {
    private const SIZE:int = C.size;
    private var _angle:int = 90;

    function EnemyRotating(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }

    override public function groups():Set {
      return super.groups().concat("lightsource", "enemy");
    }

    override public function update(e:EntitySet):void {
    	super.update(e);

    	_angle -= 5;
    }

    public function die(type:int):void {
      if (type == Character.POISON_NEEDLE) {
        Character.murdered = true;
        setTile(0, 6);
      } else {
        setTile(0, 7);
      }
    }

    /* ILightSource */

  	public function location():Vec {
  		return vec();
  	}

  	public function power():int {
  		return 20;
  	}

  	public function angle():int {
  		return _angle;
  	}

    public function isBenign():Boolean {
      return false;
    }
  }
}
