package {
  import Util;
  import flash.events.Event;
  import flash.display.MovieClip;
  import flash.display.Shape;

  public class Character extends MovingEntity implements ILightSource {
    private var mapRef:Map;
    private var dir:Vec = new Vec(2, 1);

    public static var murdered:Boolean = false;
    public static var numMurders:int = 0;

    public static var NO_NEEDLE:int = 0;
    public static var POISON_NEEDLE:int = 1;
    public static var TRANQ_NEEDLE:int = 2;

    public static var needles:int = C.DEBUG ? POISON_NEEDLE : NO_NEEDLE;

    private var restorePt:Vec = new Vec(2, 2);
    private var lg:LightGrid;
    private var _angle:int = 0;
    private var angleVec:Vec = new Vec(1, 0);

    private var hasToggledPower:Boolean = false;

    public var journal:Journal;

    function Character(x:int, y:int, mapRef:Map, lg:LightGrid) {
      super(x, y, C.size, C.size);
      loadSpritesheet(C.SpritesClass, C.dim, new Vec(2, 1));

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

      this.restorePt = new Vec(x, y);
    }

    public function canPressSwitch():Boolean {
      if (!Fathom.entities.any("switch")) return false;
      if (hasToggledPower) return false;

      var c:Entity = Fathom.entities.get("Character").one();
      var s:Entity = Fathom.entities.get("switch").one();

      var dist:Number = Math.abs(c.x - s.x) + Math.abs(c.y - s.y);
      trace(dist);

      return dist < 50;
    }

    public function canOpenChest():Boolean {
      if (!Fathom.entities.any("TreasureChest")) return false;

      var c:Entity = Fathom.entities.get("Character").one();
      var s:Entity = Fathom.entities.get("TreasureChest").one();

      var dist:Number = Math.abs(c.x - s.x) + Math.abs(c.y - s.y);

      return dist < 50;
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

      _angle = angleVec.angle();
    }

    public function canShootNeedle():Boolean {
      return (needles != NO_NEEDLE && !canPressSwitch() && !canOpenChest());
    }

    public function shootNeedle():void {
      var d:Entity = new Dart(this.x, this.y, needles, angleVec.clone().multiply(12));
    }

    override public function update(e:EntitySet):void {
      super.update(e);

      var speed:int = Util.KeyDown.X ? 14 : 7;

      if (!isFlickering) {
        vel.setPos(Util.movementVector().multiply(speed));
      } else {
        vel.setPos(new Vec(0, 0));
      }

      setCameraFocus();

      Hooks.onLeaveMap(this, mapRef, leftMap);

      if (Util.KeyJustDown.J) {
        journal.show();
      }

      if (Util.KeyJustDown.Z) {
        if (canPressSwitch()) {
          hasToggledPower = true;
          new DialogText(C.toggledSwitch);
          (Fathom.entities.get("switch").one() as EnergySwitch).flip();
          EnemyStatic.noPower = true;
        } else if (canOpenChest()) {
          checkForTreasure();
        } else if (needles != NO_NEEDLE) {
          shootNeedle();
        }
      }

      checkForMessage();

      if (!lg.isBenign(x, y)) {
        restoreFromPoint();
      }

      checkForWarps();

      if (Fathom.mapRef.getTopLeftCorner().clone().divide(25).equals(new Vec(4, 2))) {
        if (murdered) {
          new DialogText(
              [ "..."
              , "Oh crap."
              , "*The guards look you over."
              , "GUARDS: Greetings, test subject #1334."
              , "Who are you people? What do you want from me?"
              , "GUARDS: Nothing more than to explain why you are here."
              , "..."
              , "GUARDS: We gave you one instruction."
              , "GUARDS: 'Kill Daniel.'"
              , "GUARDS: You had no idea who Daniel is."
              , "GUARDS: You had no idea why he should die."
              , "GUARDS: Nevertheless you resolved to kill him."
              , "GUARDS: Not only that."
              , "GUARDS: But you killed " + numMurders + " of us in the process."
              , "GUARDS: Just because we stood in your way."
              , "FADEHALFWAY"
              , "GUARDS: Daniel isn't the villain here."
              , "FADEALLTHEWAY"
              , "GUARDS: You are."
              , "GUARDS: You are."
              , "GUARDS: You are."
              // lol don't ask
              , "GUARDS: You are."
              , "GUARDS: You are."
              , "GUARDS: You are."
              , "GUARDS: You are."
              , "GUARDS: You are."
              , "GUARDS: You are."
              , "GUARDS: You are."
              , "GUARDS: You are."
              , "GUARDS: You are."
              , "GUARDS: You are."
              ]
            );
        } else {
          new DialogText(
              [ "..."
              , "Oh hey."
              , "*The guards look you over."
              , "GUARDS: Greetings, test subject #1334."
              , "Who are you people? What do you want from me?"
              , "GUARDS: Nothing more than to explain why you are here."
              , "..."
              , "GUARDS: We gave you one instruction."
              , "GUARDS: 'Kill Daniel.'"
              , "GUARDS: You had no idea who Daniel is."
              , "GUARDS: You had no idea why he should die."
              , "GUARDS: Nevertheless you resolved to kill him."
              , "No I didn't."
              , "GUARDS: And you put like 5 of us to sleep!"
              , "That's not even the right number."
              , "GUARDS: Well, it's definitely more than one!"
              , "GUARDS: Counting is hard. Give us a break."
              , "Cut me some slack here. How do you even know I was going to kill the guy?"
              , "GUARDS: ..."
              , "Heck I just wanted to meet up with the guy. Figure out why someone had it out for him."
              , "Maybe open up a can of natty light."
              , "Play a nice game of pool."
              , "GUARDS: .............."
              , "GUARDS: Wat."
              , "Yeah. OK. I'm outta here. You guys are freaks."
              , "FADEHALFWAY"
              , "And stop dimming those lights! Jesus you guys are overdramatic."
              , "FADENORMAL"
              , "You win!"
              , "You win!"
              , "You win!"
              , "You win!"
              , "You win!"
              ]
            );

        }
      }
    }

    private function checkForWarps():void {
      if (!Fathom.entities.any("warp")) return;
      if (!Fathom.entities.get("warp").one().touchingRect(this)) return;

      var warp:Warp = Fathom.entities.get("warp").one() as Warp;
      warp.doWarp(this);
      EnemyStatic.noWarp = false;
      raiseToTop();

    }

    private function checkForTreasure():void {
      if (!Fathom.entities.any("TreasureChest")) return;

      var chest:TreasureChest = Fathom.entities.get("TreasureChest").one() as TreasureChest;
      var curLoc:Vec = mapRef.getTopLeftCorner().clone().divide(25);

      if (curLoc.equals(new Vec(8, 6))) {
        if (needles == NO_NEEDLE) {
          new DialogText(C.gotPoisonDarts);
          needles = POISON_NEEDLE;
        } else if (needles == TRANQ_NEEDLE) {
          new DialogText(C.alreadyHasTranq);
        }

        chest.open();
      }

      if (curLoc.equals(new Vec(3, 0))) {
        if (needles == NO_NEEDLE) {
          new DialogText(C.gotTranqDarts);
          needles = TRANQ_NEEDLE;
        } else if (needles == POISON_NEEDLE) {
          new DialogText(C.alreadyHasPoison);
          needles = TRANQ_NEEDLE;
        }

        chest.open();

      }
    }

    private function setRestorePoint():void {
      restorePt = vec();
    }

    private function restoreFromPoint():void {
      setPos(restorePt);
      Fathom.camera.snapTo(this);

      listen(Hooks.flicker(this));
    }

    private function checkForMessage():void {
      var loc:String = mapRef.getTopLeftCorner().clone().divide(25).toString();
      if (!C.mapToJournal.hasOwnProperty(loc)) return;

      var curJournal:int = C.mapToJournal[loc];

      if (journal.haveSeen(curJournal)) {
        return;
      }

      journal.addJournalEntry(curJournal);

      // Force light to update.
      LightGrid.singleton.update(Fathom.entities);
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
      return 0;
    }

    public function angle():int {
      return _angle;
    }

    public function isBenign():Boolean {
      return true;
    }
  }
}
