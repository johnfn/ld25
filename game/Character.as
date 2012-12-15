
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

      this.width -= 2;
      this.height -= 2;
      this.mapRef = mapRef;
    }

    private function setCameraFocus():void {
      var focus:Vec = this.rect();

      Fathom.camera.follow(focus);

      /*
      if (Util.movementVector().x > 0) {
        focus.x += 100;
      }

      if (Util.movementVector().x < 0) {
        focus.x -= 100;
      }

      if (Util.movementVector().y > 0) {
        focus.y += 100;
      }

      if (Util.movementVector().y < 0) {
        focus.y -= 100;
      }
      */
    }

    override public function update(e:EntitySet):void {
      super.update(e);

      vel.setPos(Util.movementVector().multiply(7));

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
