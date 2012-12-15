package {
  public class LightGrid extends Entity {
    private const SIZE:int = C.size;
    private casters:Object = {};
    private mapRef:Map;
    private grid:Array = [];

    public static var BEHAVIOR_STATIC:int = 0;
    public static var BEHAVIOR_ROTATE:int = 1;
    public static var BEHAVIOR_PATROL:int = 2;

    private static var SPREAD_ANGLE:int    = 45;
    private static var RAY_COUNT:int       = 5;
    private static var LIGHT_PRECISION:int = C.size; //smaller == more precise
    private static var LIGHT_POWER:float   = 0.4; // could be a property of casters.

    function LightGrid(x:int=0, y:int=0, mapRef:Map) {
      super(x, y, SIZE, SIZE);
    }

    public function loadNewMap(mapRef:Map) {
      this.mapRef = mapRef;

      for (var i:int = 0; i < mapRef.width; i++) {
        for (var j:int = 0; j < mapRef.height; j++) {
          grid[i][j] = new LightSquare(i * mapRef.tileWidth, j * mapRef * tileHeight);
        }
      }
    }

    public function addCaster(e:Entity, behavior:int, angle:int, power:int = 15) {
      casters.push({"entity" : e, "behavior" : behavior, "angle" : angle});
    }

    public function update(e:EntitySet) {
      // Reset lights from last time

      for (var i:int = 0; i < mapRef.width; i++) {
        for (var j:int = 0; j < mapRef.height; j++) {
          grid[i][j].reset();
        }
      }

      // Cast ray from every caster

      for (var i:int = 0; i < casters.length; i++) {
        // Cast rays in a spread in the direction they're looking

        var rayStartAngle:int = casters.angle - SPREAD_ANGLE / 2;
        var rayEndAngle:int = casters.angle   + SPREAD_ANGLE / 2;
        var step:int = SPREAD_ANGLE / RAY_COUNT;

        // Cast an individual ray
        for (var angle:int = rayStartAngle; angle < rayEndAngle; angle += step) {
          var curX = casters[i].entity.x;
          var curY = casters[i].entity.y;

          // Step
          for (var j:int = 0; k < casters[i].power; j++) {
            curX += Math.cos(angle) * LIGHT_PRECISION;
            curY += Math.sin(angle) * LIGHT_PRECISION;

            grid[curX / c.dim.x][curY / c.dim.y].addAlpha(LIGHT_POWER);

            if (Fathom.anythingAt(curX, curY)) {
              return;
            }
          }
        }
      }
    }
  }
}

class LightSquare extends Entity {
  function LightSquare(x:int, y:int) {
    super(x, y, C.size, C.size);
    loadImage(C.BlackSquareClass);
  }

  public function reset() {
    this.spritesheetObj.alpha = 0;
  }

  public function addAlpha(amount:float) {
    if (amount + spritesheetObj.alpha > 1) {
      spritesheetObj.alpha = 1;
    } else {
      this.spritesheetObj.alpha += amount;
    }
  }
}