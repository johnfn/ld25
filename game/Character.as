
package {
  import Util;
  import flash.events.Event;
  import flash.display.MovieClip;
  import flash.display.Shape;

  public class Character extends MovingEntity {
    private var mapRef:Map;
    private var dir:Vec = new Vec(0, 0);

    function Character(x:int, y:int, mapRef:Map) {
      super(x, y, C.size, C.size);
      loadSpritesheet(C.MapClass, C.dim, new Vec(0, 0));

      /*
      animations.addAnimations({ "walk": { startPos: [0, 0], numFrames: 7 }
                               , "idle": { startPos: [0, 0], numFrames: 1 }
      });

      animations.ticksPerFrame = 3;
      */

      this.width -= 2;
      this.height -= 2;
      this.mapRef = mapRef;
    }

    private function setCameraFocus():void {
      var focus:Vec = this.rect();

      var signX:int = Util.sign(Util.movementVector().x);
      var signY:int = Util.sign(Util.movementVector().y);

      if (signX != 0) dir.x = signX;
      if (signY != 0) dir.y = signY;

      focus.x += dir.x * 100;
      focus.y += dir.y * 100;

      Fathom.camera.follow(focus);
    }

    override public function update(e:EntitySet):void {
      super.update(e);

      vel.setPos(Util.movementVector().multiply(7));

      setCameraFocus();

      Hooks.onLeaveMap(this, mapRef, leftMap);
    }

    private function leftMap():void {
      Hooks.loadNewMap(this, mapRef)();
      Fathom.camera.snapTo(this);

      raiseToTop();
    }

    override public function modes():Array { return [0]; }
  }
}
