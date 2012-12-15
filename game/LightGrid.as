package {
  public class LightGrid extends Entity {
    private var SIZE:int = C.size;
    private var casters:Object = {};
    private var mapRef:Map;
    private var grid:Array = [];

    public static var BEHAVIOR_STATIC:int = 0;
    public static var BEHAVIOR_ROTATE:int = 1;
    public static var BEHAVIOR_PATROL:int = 2;

    private static var SPREAD_ANGLE:int    = 45;
    private static var RAY_COUNT:int       = 5;
    private static var LIGHT_PRECISION:int = C.size; //smaller == more precise
    private static var LIGHT_POWER:Number  = 0.4; // could be a property of casters.

    function LightGrid(mapRef:Map) {
      super(0, 0, mapRef.width, mapRef.height); //TODO

      this.mapRef = mapRef;
    }

    public function loadNewMap():void {
      this.mapRef = mapRef;

      for (var i:int = 0; i < mapRef.widthInTiles; i++) {
        grid[i] = [];

        for (var j:int = 0; j < mapRef.heightInTiles; j++) {
          setLightAt(i, j, 0.0);
        }
      }
    }

    private function setLightAt(x:int, y:int, power:Number):void {
      grid[x][y] = power;
      graphics.drawRect(x * C.dim.x, y * C.dim.y, C.dim.x, C.dim.y);
    }

    public function addCaster(e:Entity, behavior:int, angle:int, power:int = 15):void {
      casters.push({"entity" : e, "behavior" : behavior, "angle" : angle});
    }

    public override function update(e:EntitySet):void {
      // Reset lights from last time
      var i:int;
      var j:int;

      graphics.clear();
      graphics.beginFill(0x000000, LIGHT_POWER);
      graphics.drawRect(0, 0, width, height);

      // Cast ray from every caster

      for (i = 0; i < casters.length; i++) {
        // Cast rays in a spread in the direction they're looking

        var rayStartAngle:int = casters.angle - SPREAD_ANGLE / 2;
        var rayEndAngle:int = casters.angle   + SPREAD_ANGLE / 2;
        var step:int = SPREAD_ANGLE / RAY_COUNT;

        // Cast an individual ray
        for (var angle:int = rayStartAngle; angle < rayEndAngle; angle += step) {
          var curX:int = casters[i].entity.x;
          var curY:int = casters[i].entity.y;

          // Step
          for (j = 0; j < casters[i].power; j++) {
            curX += Math.cos(angle) * LIGHT_PRECISION;
            curY += Math.sin(angle) * LIGHT_PRECISION;

            grid[curX / C.dim.x][curY / C.dim.y].addAlpha(LIGHT_POWER);

            if (Fathom.anythingAt(curX, curY)) {
              return;
            }
          }
        }
      }
    }

    override public function groups():Set {
      return super.groups().concat("non-blocking");
    }
  }
}
