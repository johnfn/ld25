package {
  import flash.filters.*;

  public class LightGrid extends Entity {
    private var SIZE:int = C.size;
    private var mapRef:Map;
    private var intensity:Array = [];
    private var benign:Array = [];

    public static var BEHAVIOR_STATIC:int = 0;
    public static var BEHAVIOR_ROTATE:int = 1;
    public static var BEHAVIOR_PATROL:int = 2;

    private static var SPREAD_ANGLE:int    = 45;
    private static var RAY_COUNT:int       = 9;
    private static var LIGHT_PRECISION:int = C.size; //smaller == more precise
    private static var START_DARK:Number   = 0.8;
    private static var LIGHT_POWER:Number  = 0.6; // could be a property of casters.

    function LightGrid(mapRef:Map) {
      super(0, 0, mapRef.width, mapRef.height); //TODO

      this.mapRef = mapRef;

      var myBlur:BlurFilter = new BlurFilter(5, 5);
      filters = [myBlur];

      loadNewMap();
    }

    private function loadNewMap():void {
      this.mapRef = mapRef;

      for (var i:int = 0; i < mapRef.widthInTiles; i++) {
        intensity[i] = [];
        benign[i] = [];

        for (var j:int = 0; j < mapRef.heightInTiles; j++) {
          intensity[i][j] = LIGHT_POWER;
          benign[i][j]    = true;
        }
      }
    }

    public function isBenign(x:int, y:int):Boolean {
      var xRel:int = Math.floor(x / C.dim.x);
      var yRel:int = Math.floor(y / C.dim.y);
      return benign[xRel][yRel];
    }

    public override function update(e:EntitySet):void {
      // Reset lights from last time
      var i:int;
      var j:int;

      var casters:EntitySet = Fathom.entities.get("lightsource");

      for (i = 0; i < mapRef.widthInTiles; i++) {
        for (j = 0; j < mapRef.heightInTiles; j++) {
          intensity[i][j] = START_DARK;
          benign[i][j]    = true;
        }
      }

      graphics.clear();
      //graphics.beginFill(0x000000, LIGHT_POWER);
      //graphics.drawRect(0, 0, width, height);

      // Send ray from every caster

      for each (var caster:ILightSource in casters) {
        // Cast rays in a spread in the direction they're looking
        var rayStartAngle:int = caster.angle() - SPREAD_ANGLE / 2;
        var rayEndAngle:int = caster.angle()   + SPREAD_ANGLE / 2;
        var step:int = SPREAD_ANGLE / RAY_COUNT;


        // Cast an individual ray
        for (var angle:int = rayStartAngle; angle < rayEndAngle; angle += step) {
          var curX:Number = caster.location().x;
          var curY:Number = caster.location().y;

          var dx:Number = Math.cos(radAngle) * LIGHT_PRECISION;
          var dy:Number = Math.sin(radAngle) * LIGHT_PRECISION;

          // So rad!
          var radAngle:Number = angle * Math.PI / 180;

          curX += dx;
          curY += dy;

          // Step
          for (j = 0; j < caster.power(); j++) {
            curX += dx;
            curY += dy;

            var tileX:int = Math.floor(curX / C.dim.x);
            var tileY:int = Math.floor(curY / C.dim.y);

            if (mapRef.outOfBoundsPt(tileX, tileY)) {
              break;
            }

            intensity[tileX][tileY] -= LIGHT_POWER;

            benign[tileX][tileY] = benign[tileX][tileY] && caster.isBenign();

            if (Fathom.anythingAt(tileX, tileY)) {
              break;
            }
          }
        }
      }

      // Draw grid

      for (i = 0; i < mapRef.widthInTiles; i++) {
        for (j = 0; j < mapRef.heightInTiles; j++) {
          graphics.beginFill(0x000000, intensity[i][j]);
          graphics.drawRect(i * C.dim.x, j * C.dim.y, C.dim.x, C.dim.y);
        }
      }


    }

    override public function groups():Set {
      return super.groups().concat("non-blocking");
    }
  }
}
