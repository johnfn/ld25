
package {
  import Util;
  import flash.events.Event;
  import flash.display.MovieClip;
  import flash.display.Shape;

  public class Character extends MovingEntity {
    private var mapRef:Map;

    function Character(x:int, y:int, mapRef:Map) {
      super(x, y, C.size, C.size);
      loadSpritesheet(C.MapClass, C.dim, new Vec(0, 0));

      /*
      animations.addAnimations({ "walk": { startPos: [0, 0], numFrames: 7 }
                               , "idle": { startPos: [0, 0], numFrames: 1 }
      });

      animations.ticksPerFrame = 3;
      */

      this.mapRef = mapRef;
    }

    private function setCameraFocus():void {
      var focus:Vec = this.rect();
      if (facing > 0) {
        focus.x += 100;
      } else {
        focus.x -= 100;
      }

      Fathom.camera.follow(focus);
    }

    override public function update(e:EntitySet):void {
      super.update(e);

      vel = Util.movementVector().multiply(3);

      setCameraFocus();

      //face(Util.movementVector().x);

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
