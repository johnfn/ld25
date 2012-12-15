package {
  public class EnemyStatic extends Entity implements ILightSource {
    private const SIZE:int = C.size;

    function EnemyStatic(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }

    override public function groups():Set {
      return super.groups().concat("lightsource");
    }

    override public function update(e:EntitySet):void {
    	super.update(e);
    }

    /* ILightSource */

	public function location():Vec {
		return vec();
	}

	public function power():int {
		return 10;
	}

	public function angle():int {
		return 0;
	}
  }
}
