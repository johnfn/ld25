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

  [SWF(backgroundColor="#FFFFFF", width="500", height="500", frameRate="30", wmode="transparent")]
  public dynamic class main extends MovieClip {
    [Embed(source = "../data/map.png")] static public var MapClass:Class;

    public static var MainObj:main;
    public static var c:Character;
    public static var lg:LightGrid;
    public static var journal:Journal;

    private var m:Map;

    public function main():void {
      play();
    }

    public override function play():void {
      MainObj = this;

      Fathom.initialize(stage);

      m = new Map(25, 25, C.size).fromImage(MapClass, {
        //(new Color(0, 0, 0).toString()) : { type: Block, gfx: C.SpritesheetClass, spritesheet: new Vec(1, 2), fixedSize: true, roundOutEdges: true },
          (new Color(0, 0, 0).toString()) : { type: Block, gfx: C.SpritesClass, spritesheet: new Vec(0, 0), fixedSize: true }
        , (new Color(255, 0, 0).toString()) : { type: EnemyStatic, gfx: C.SpritesClass, spritesheet: new Vec(2, 1), fixedSize: true }
      }).loadNewMap(new Vec(0, 0));

      Fathom._camera.beBoundedBy(m);

      Fathom.mapRef = m;

      // The order we create these objects determines depth

      lg = new LightGrid(m);

      main.c = new Character(2 * C.dim.x + 2, 2 * C.dim.y, m);

      journal = new Journal();

      new HUD();

      main.c.journal = journal;

      Fathom.start();
      m.visible = true;
    }
  }
}
