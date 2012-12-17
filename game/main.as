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
                              , new Color(255, 200, 0).toString()
                              , new Color(0, 255, 0).toString()
                              , new Color(0, 255, 255).toString()
                              , new Color(255, 25, 0).toString()
                              , new Color(255, 30, 0).toString()
                              , new Color(255, 50, 0).toString()
                              , new Color(255, 75, 0).toString()
                              ];

      m.fromImage(MapClass, groundsList, {
          /* manor walls */
          (new Color(0, 0, 0).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(8, 8), fixedSize: true, fancyEdges: true }
          /* manor ceiling */
        , (new Color(12, 23, 34).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(0, 4), fixedSize: true }
          /* manor ground */
        , (new Color(0, 255, 255).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(8, 8), fixedSize: true, randoEdges: true, transparent: true }
          /* manor stone */
        , (new Color(100, 100, 100).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(1, 4), fixedSize: true }

          /* manor treasurechest */
        , (new Color(100, 110, 120).toString()) : { type: TreasureChest, gfx: C.SpritesClass, spritesheet: new Vec(1, 2), fixedSize: true }

          /* manor glass */
        , (new Color(0, 200, 255).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(0, 5), fixedSize: true, transparent: true }

          /* water */
        , (new Color(0, 0, 100).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(4, 7), fixedSize: true, roundOutEdges: true, transparent: true }
          /* sewer walls */
        , (new Color(0, 200, 0).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(5, 2), fixedSize: true, fancyEdges: true }
        /* trimming along sewer walls */
        , (new Color(255, 100, 0).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(10, 2), fixedSize: true, fancyEdges: true, transparent: true }
        /* dirt ground */
        , (new Color(255, 200, 0).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(10, 2), fixedSize: true, randoEdges: true, transparent: true }
        /* Security cam (sewer) */
        , (new Color(200, 0, 0).toString()) : { type: EnemyStatic, gfx: C.SpritesClass, spritesheet: new Vec(0, 0), fixedSize: true, args: new Vec(0, 1) }
        /* Security cam left (sewer) */
        , (new Color(199, 0, 0).toString()) : { type: EnemyStatic, gfx: C.SpritesClass, spritesheet: new Vec(1, 1), fixedSize: true, args: new Vec(1, 0) }
        /* Guard */
        , (new Color(255, 25, 0).toString()) : { type: EnemyStatic, gfx: C.SpritesClass, spritesheet: new Vec(1, 3), fixedSize: true, args: new Vec(0, 1) }
        /* Guard left */
        , (new Color(255, 30, 0).toString()) : { type: EnemyStatic, gfx: C.SpritesClass, spritesheet: new Vec(1, 3), fixedSize: true, args: new Vec(1, 0) }
        /* Guard rotating */
        , (new Color(255, 50, 0).toString()) : { type: EnemyRotating, gfx: C.SpritesClass, spritesheet: new Vec(0, 3), fixedSize: true, args: new Vec(0, 1) }
        /* Guard patrolling */
        , (new Color(255, 75, 0).toString()) : { type: EnemyPatrolling, gfx: C.SpritesClass, spritesheet: new Vec(2, 3), fixedSize: true, args: new Vec(0, 1) }
        /* power switch (sewer) */
        , (new Color(150, 0, 0).toString()) : { type: EnergySwitch, gfx: C.SpritesClass, spritesheet: new Vec(0, 2), fixedSize: true }
        , (new Color(0, 150, 0).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(5, 2), fixedSize: true, roundOutEdges: true }
        , (new Color(0, 0, 0).toString()) : { gfx: C.SpritesClass, spritesheet: new Vec(0, 0), fixedSize: true }
        , (new Color(255, 0, 0).toString()) : { type: EnemyPatrolling, gfx: C.SpritesClass, spritesheet: new Vec(2, 1), fixedSize: true }
        /* Stairs up (warp) */
        , (new Color(0, 255, 0).toString()) : { type: Warp, gfx: C.SpritesClass, spritesheet: new Vec(1, 0), fixedSize: true, "special" : true }
      }).loadNewMap(C.DEBUG ? new Vec(4, 2) : new Vec(0, 0));

      Fathom._camera.beBoundedBy(m);

      // The order we create these objects determines depth

      lg = new LightGrid(m);

      if (C.DEBUG) {
        main.c = new Character(10 * C.dim.x + 2, 10 * C.dim.y, m, lg);
      } else {
        main.c = new Character(7 * C.dim.x + 2, 7 * C.dim.y, m, lg);
      }

      journal = new Journal();

      new HUD(main.c);

      main.c.journal = journal;

      Fathom.start();
      m.visible = true;

      C.swampMusic.play(1, 999999);
    }
  }
}
