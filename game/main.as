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

      m = new Map(25, 25, C.size);

      Fathom.mapRef = m;

      var groundsList:Array = [ new Color(255, 100, 0).toString()
                              , new Color(255, 255, 255).toString()
                              ];

      m.fromImage(MapClass, groundsList, {
          (new Color(0, 0, 0).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(1, 2), fixedSize: true, roundOutEdges: true }
          /* water */
        , (new Color(0, 0, 100).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(4, 7), fixedSize: true, roundOutEdges: true, "transparent": true }
          /* sewer walls */
        , (new Color(0, 200, 0).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(5, 2), fixedSize: true, fancyEdges: true }
        /* trimming along sewer walls */
        , (new Color(255, 100, 0).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(10, 2), fixedSize: true, fancyEdges: true, "transparent": true }
        , (new Color(0, 150, 0).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(5, 2), fixedSize: true, roundOutEdges: true }
        , (new Color(0, 0, 0).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(0, 0), fixedSize: true }
        , (new Color(255, 0, 0).toString()) : { type: EnemyPatrolling, gfx: C.SpritesClass, spritesheet: new Vec(2, 1), fixedSize: true }
        , (new Color(0, 255, 0).toString()) : { type: Warp, fixedSize: true }
      }).loadNewMap(new Vec(0, 0));

      Fathom._camera.beBoundedBy(m);

      // The order we create these objects determines depth

      lg = new LightGrid(m);

      main.c = new Character(5 * C.dim.x + 2, 5 * C.dim.y, m, lg);

      journal = new Journal();

      new HUD();

      main.c.journal = journal;

      Fathom.start();
      m.visible = true;
    }
  }
}
