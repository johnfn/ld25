package {
  import flash.filters.*;

  public class HUD extends Entity {
    private var text:Text;

  	public function HUD():void {
      text = new Text("HUD txt", C.fontName);
      text.setPos(new Vec(8, 8));
      text.width = 200;
      text.size = 16;
      text.color = 0xffffff;
  	}

  	override public function update(e:EntitySet):void {
  		text.text = "";

  		if (Fathom.currentMode == C.MODE_TEXT) {
  			text.text = "Z to continue";
  		}
  		super.update(e);
  	}

    override public function groups():Set {
      return super.groups().concat("no-camera", "non-blocking");
    }

    override public function modes():Array {
    	return [0, 1, 2];
    }
  }
}