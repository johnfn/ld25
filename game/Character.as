
package {
  import Util;
  import flash.events.Event;
  import flash.display.MovieClip;
  import flash.display.Shape;

  public class Character extends MovingEntity implements ILightSource {
    private var mapRef:Map;
    private var dir:Vec = new Vec(0, 0);

    private var restorePt:Vec = new Vec(2, 2);
    private var lg:LightGrid;
    private var _angle:int = 0;
    private var angleVec:Vec = new Vec(1, 0);

    public var journal:Journal;

    function Character(x:int, y:int, mapRef:Map, lg:LightGrid) {
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
      this.lg = lg;
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

      /* update angle too */

      if (signX != 0 || signY != 0) {
        angleVec = new Vec(signX, signY);
      }

      _angle = Math.atan2(angleVec.y, angleVec.x) * 180.0 / Math.PI;
    }

    override public function update(e:EntitySet):void {
      super.update(e);

      vel.setPos(Util.movementVector().multiply(7));

      setCameraFocus();

      Hooks.onLeaveMap(this, mapRef, leftMap);

      if (Util.KeyJustDown.J) {
        journal.show();
      }

      checkForMessage();

      if (!lg.isBenign(x, y)) {
        restoreFromPoint();
      }

      checkForWarps();
    }

    private function checkForWarps():void {
      if (!touchingSet("warp").any()) return;

      var warp:Warp = touchingSet("warp").one() as Warp;
      warp.doWarp(this);
    }

    private function setRestorePoint():void {
      restorePt = vec();
    }

    private function restoreFromPoint():void {
      setPos(restorePt);
      Fathom.camera.snapTo(this);
    }

    private function checkForMessage():void {
      if (!C.mapToJournal.hasOwnProperty(mapRef.getTopLeftCorner().toString())) return;

      var curJournal:int = C.mapToJournal[mapRef.getTopLeftCorner().toString()];

      if (journal.haveSeen(curJournal)) {
        return;
      }

      journal.addJournalEntry(curJournal);

      new DialogText(C.journalog[curJournal].concat().splice(1));

      // Restore points = whenever dialog is initiated.
      setRestorePoint();
    }

    private function leftMap():void {
      Hooks.loadNewMap(this, mapRef)();
      Fathom.camera.snapTo(this);

      raiseToTop();
      setRestorePoint();
    }

    override public function groups():Set {
      return super.groups().concat("lightsource");
    }

    override public function modes():Array { return [0]; }

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
      return true;
    }
  }
}
