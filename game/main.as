package {
  import flash.display.Sprite;
  import flash.utils.setTimeout;
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.text.TextField;
  import flash.filters.DropShadowFilter;
  import flash.text.TextFormat;
  import flash.utils.getTimer;
  import mochi.as3.*;

  import flash.display.DisplayObject;

  import Entity;
  import Hooks;
  import Map;
  import Color;

  [SWF(backgroundColor="#00000000", width="500", height="500", frameRate="30", wmode="transparent")]
  public dynamic class main extends MovieClip {
    [Embed(source = "../data/map.png")] static public var MapClass:Class;

    public static var MainObj:main;
    public static var c:Character;
    public static var weather:Particles;
    public static var foundBoots:Boolean = false;

    public static var startTime:Number;
    public static var stopTime:Number;

    public static var totalTime:Number;

    private var m:Map;

    private var scrollBG:ScrollingBackground;
    private var scrollBG2:ScrollingBackgroundBottom; // Lower
    private var scrollBG3:ScrollingBackgroundBottomOverlay; // Lower - planets

    private function addBG():void {
      scrollBG = new ScrollingBackground();
      addChild(scrollBG);

      scrollBG2 = new ScrollingBackgroundBottom();
      addChild(scrollBG2);

      scrollBG3 = new ScrollingBackgroundBottomOverlay();
      addChild(scrollBG3);

      addEventListener(Event.ENTER_FRAME, scroll);
    }

    private function scroll(e:Event):void {
      if (m.getTopLeftCorner().y == 0) {
        scrollBG.move(.3, 0);
        scrollBG.x = -Fathom.camera.x * 15/20;
        scrollBG.y = -Fathom.camera.y * 15/20;
        scrollBG.visible = true;
        scrollBG2.visible = false;
        scrollBG3.visible = false;
      } else {
        scrollBG2.move(.3, 0);
        scrollBG3.move(.1, 0);
        scrollBG2.x = -Fathom.camera.x * 15/20;
        scrollBG2.y = -Fathom.camera.y * 15/20;
        scrollBG3.x = -Fathom.camera.x * 15/20;
        scrollBG3.y = -Fathom.camera.y * 15/20;
        scrollBG.visible = false;
        scrollBG2.visible = true;
        scrollBG3.visible = true;
      }
    }

    public function showEndGameScreen():void {
      var eg:* = new C.EndGameClass();
      var c:* = new MovieClip();
      c.addChild(eg);
      c.scaleX = 2;
      c.scaleY = 2;

      stopTime = getTimer() / 1000;

      stage.addChild(c);

      var newFormat:TextFormat = new TextFormat();
      newFormat.size = 16;
      newFormat.font = C.fontName;

      var finaltext:TextField = new TextField();
      finaltext.text = "You turn into Godzilla. You win by default!";
      finaltext.wordWrap = true;
      finaltext.x = 40;
      finaltext.y = 200;
      finaltext.width = 200;
      finaltext.filters = [new DropShadowFilter(1.0, 45, 0, 1, 0, 0, 1)];
      finaltext.textColor = 0xffffff;
      finaltext.selectable = false;
      finaltext.setTextFormat(newFormat);
      stage.addChild(finaltext);

      var text2:TextField = new TextField();
      text2.text = "Later you terrorize Tokyo just for the heck of it.";
      text2.wordWrap = true;
      text2.x = 40;
      text2.y = 400;
      text2.width = 400;
      text2.filters = [new DropShadowFilter(1.0, 45, 0, 1, 0, 0, 1)];
      text2.textColor = 0xffffff;
      text2.selectable = false;
      stage.addChild(text2);
      text2.setTextFormat(newFormat);

      var text3:TextField = new TextField();
      main.totalTime = Math.floor(stopTime - startTime - (foundBoots ? 60 : 0));

      if (foundBoots) {
        text3.text = "Play time: " + totalTime + " seconds (you found the boots!)";
      } else {
        text3.text = "Play time: " + totalTime + " seconds";
      }

      text3.wordWrap = true;
      text3.x = 40;
      text3.y = 460;
      text3.width = 400;
      text3.filters = [new DropShadowFilter(1.0, 45, 0, 1, 0, 0, 1)];
      text3.textColor = 0xffffff;
      text3.selectable = false;
      stage.addChild(text3);
      text3.setTextFormat(newFormat);
    }

    public function main():void {
      play();
    }

    public override function play():void {
      addBG();
      MainObj = this;

      Fathom.initialize(stage);

      m = new Map(25, 25, C.size).fromImage(MapClass, {
        (new Color(0, 0, 0).toString()) : { type: Block, gfx: C.SpritesheetClass, spritesheet: new Vec(1, 2), fixedSize: true, roundOutEdges: true },
        (new Color(200, 100, 0).toString()) : { type: BGBlock, gfx: C.SpritesheetClass, spritesheet: new Vec(1, 7), fixedSize: true, roundOutEdges: true },
        (new Color(0, 0, 255).toString()) : { type: Treasure, gfx: C.SpritesheetClass, spritesheet: new Vec(2, 0), fixedSize: true },
        (new Color(0, 255, 0).toString()) : { type: Professor, gfx: C.ProfessorClass, spritesheet: new Vec(0, 0), fixedSize: true },
        (new Color(255, 0, 0).toString()) : { type: PushBlock, gfx: C.SpritesheetClass, spritesheet: new Vec(0, 5), fixedSize: true },
        (new Color(255, 0, 255).toString()) : { type: EasterEgg, gfx: C.SpritesheetClass, spritesheet: new Vec(7, 1), fixedSize: true },
        (new Color(0, 255, 255).toString()) : { type: SmashBlock, gfx: C.SpritesheetClass, spritesheet: new Vec(1, 0), fixedSize: true },
        (new Color(0, 0, 200).toString()) : { type: Gate, gfx: C.SpritesheetClass, spritesheet: new Vec(3, 4), fixedSize: true },
        (new Color(0, 0, 101).toString()) : { type: Telephone, gfx: C.SpritesheetClass, spritesheet: new Vec(4, 3), fixedSize: true },
        (new Color(100, 100, 100).toString()) : { type: Terminal, gfx: C.SpritesheetClass, spritesheet: new Vec(3, 3), fixedSize: true },
        (new Color(101, 101, 101).toString()) : { type: AlmostStatic, gfx: C.SpritesheetClass, spritesheet: new Vec(5, 4), fixedSize: true },
        (new Color(102, 102, 102).toString()) : { type: AlmostStatic, gfx: C.SpritesheetClass, spritesheet: new Vec(6, 4), fixedSize: true }
      }).loadNewMap(new Vec(0, 0));

      Fathom._camera.beBoundedBy(m);

      Fathom.mapRef = m;

      var i:Inventory = new Inventory();
      var c:Character = new Character(3 * 25 + 2, 5 * 25, m, i);

      c.visible = false;

      main.c = c;

      Fathom.start();

      c.visible = true;
      m.visible = true;

      startTime = getTimer() / 1000;

      new HUD(c);
    }
  }
}