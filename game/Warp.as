package {
  public class Warp extends Entity {
    private const SIZE:int = C.size;
    private var mapDest:Vec;
    private var isSourceWarp:Boolean = false;

    function Warp() {
      super(0, 0, SIZE, SIZE);

      loadSpritesheet(C.SpritesClass, C.dim);

      // Properly load this image from the data in C.
      var dest:Object = C.warps[Fathom.mapRef.getTopLeftCorner().divide(25).toString()];

      // It's possible there is no entry, in which case it was a one way exit warp.
      if (dest.dest) {
        setTile(dest.type.x, dest.type.y);
        mapDest = dest.dest;

        isSourceWarp = true;
  	  }
    }

    public function isSource():Boolean {
    	return isSourceWarp;
    }

    public function doWarp(c:Character):void {
    	if (!isSourceWarp) return;

    	Fathom.mapRef.loadNewMapAbs(mapDest);

    	var warpDest:Entity = Fathom.entities.get("warp").one();

    	c.x = warpDest.x;
    	c.y = warpDest.y;

	    Fathom.camera.snapTo(c);
    }

    public override function groups():Set {
      return super.groups().concat("warp", "non-blocking");
    }
  }
}
