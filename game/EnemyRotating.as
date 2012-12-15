package {
  public class EnemyRotating extends Entity implements ILightSource {
    private const SIZE:int = C.size;
    private var _angle:int = 90;

    function EnemyRotating(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }

    override public function groups():Set {
      return super.groups().concat("lightsource");
    }

    override public function update(e:EntitySet):void {
    	super.update(e);

    	_angle += 5;
    }

    /* ILightSource */

	public function location():Vec {
		return vec();
	}

	public function power():int {
		return 10;
	}

	public function angle():int {
		return _angle;
	}
  }
}
