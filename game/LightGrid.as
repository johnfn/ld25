package {
  import flash.filters.*;

  public class LightGrid extends Entity {
    private var SIZE:int = C.size;
    private var mapRef:Map;
    private var intensity:Array = [];
    private var benign:Array = [];

    public static var RESOLUTION:int = 20;

    private static var pixel_width:int;
    private static var pixel_height:int;


    public static var BEHAVIOR_STATIC:int = 0;
    public static var BEHAVIOR_ROTATE:int = 1;
    public static var BEHAVIOR_PATROL:int = 2;

    private static var SPREAD_ANGLE:int    = 45;
    private static var RAY_COUNT:int       = 9;
    private static var LIGHT_PRECISION:int = RESOLUTION; //smaller == more precise
    private static var START_DARK:Number   = 0.6;
    private static var LIGHT_POWER:Number  = 0.6; // could be a property of casters.

    function LightGrid(mapRef:Map) {
      super(0, 0, mapRef.width, mapRef.height);

      pixel_width = width / RESOLUTION;
      pixel_height = height / RESOLUTION;

      this.mapRef = mapRef;

      var myBlur:BlurFilter = new BlurFilter(90, 90);
      filters = [myBlur];

      loadNewMap();
    }

    private function loadNewMap():void {
      this.mapRef = mapRef;

      for (var i:int = 0; i < pixel_width; i++) {
        intensity[i] = [];
        benign[i] = [];

        for (var j:int = 0; j < pixel_height; j++) {
          intensity[i][j] = LIGHT_POWER;
          benign[i][j]    = true;
        }
      }
    }

    public function isBenign(x:int, y:int):Boolean {
      var xRel:int = Math.floor(x / RESOLUTION);
      var yRel:int = Math.floor(y / RESOLUTION);
      return benign[xRel][yRel];
    }

    public override function update(e:EntitySet):void {
      // Reset lights from last time
      var i:int;
      var j:int;

      raiseToTop();

      var casters:EntitySet = Fathom.entities.get("lightsource");

      for (i = 0; i < pixel_width; i++) {
        for (j = 0; j < pixel_height; j++) {
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

          // So rad!
          var radAngle:Number = angle * Math.PI / 180;

          var dx:Number = Math.cos(radAngle) * LIGHT_PRECISION;
          var dy:Number = Math.sin(radAngle) * LIGHT_PRECISION;

          curX += dx;
          curY += dy;

          // Step
          for (j = 0; j < caster.power(); j++) {
            curX += dx;
            curY += dy;

            var tileX:int = Math.floor(curX / RESOLUTION);
            var tileY:int = Math.floor(curY / RESOLUTION);

            if (tileX < 0 || tileX >= pixel_width || tileY < 0 || tileY >= pixel_height) {
              break;
            }

            intensity[tileX][tileY] -= LIGHT_POWER;

            benign[tileX][tileY] = benign[tileX][tileY] && caster.isBenign();

            if (! Fathom.mapRef.transparency[Math.floor(curX / 25)][Math.floor(curY / 25)]) {
              break;
            }
          }
        }
      }

      // Draw grid

      for (i = 0; i < pixel_width; i++) {
        for (j = 0; j < pixel_height; j++) {
          graphics.beginFill(0x000000, intensity[i][j]);
          graphics.drawRect(i * RESOLUTION, j * RESOLUTION, RESOLUTION, RESOLUTION);
        }
      }


    }

    override public function groups():Set {
      return super.groups().concat("non-blocking");
    }
  }
}
