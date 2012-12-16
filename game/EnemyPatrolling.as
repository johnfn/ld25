package {
  public class EnemyPatrolling extends MovingEntity implements ILightSource, IKillable {
    private const SIZE:int = C.size;
    private var _angle:int = 90;

    private static var ROTATION_SPEED:int = 5;
    private static var PATROLLING:int = 0;
    private static var ROTATING:int = 1;

    private var state:int = PATROLLING;
    private var rotationGoal:int = 0;

    private var dir:Vec = new Vec(0, 5);

    function EnemyPatrolling(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }

    override public function groups():Set {
      return super.groups().concat("lightsource", "enemy");
    }

    override public function update(e:EntitySet):void {
    	super.update(e);

    	vel.x = 0;
    	vel.y = 0;

    	if (state == PATROLLING) {
    		if (touchingLeft || touchingRight || touchingTop || touchingBottom) {
    			state = ROTATING;
    			// Always add, never subtract. This ensures we can use >
    			rotationGoal = _angle + 180;
    		} else {
    			vel.setPos(dir);
	    	}
    	} else {
	    	_angle += ROTATION_SPEED;

	    	if (_angle > rotationGoal) {
	    		state = PATROLLING;

	    		dir.x *= -1;
	    		dir.y *= -1;
	    	}
    	}
    }

    /* IKillable */

    public function die(type:int):void {
      if (type == Character.POISON_NEEDLE) {
        Character.murdered = true;
        setTile(2, 6);
      } else {
        setTile(2, 7);
      }
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

    public function isBenign():Boolean {
      return false;
    }

  }
}
