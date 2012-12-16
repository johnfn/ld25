package {
  import flash.filters.*;

  public class HUD extends Entity {
    private var text:Text;
    private var c:Character;

  	public function HUD(c:Character):void {
      text = new Text("HUD txt", C.fontName);
      text.setPos(new Vec(8, 8));
      text.width = 200;
      text.size = 16;
      text.color = 0xffffff;

      this.c = c;
  	}

  	override public function update(e:EntitySet):void {
  		text.text = "";

  		if (Fathom.currentMode == C.MODE_TEXT) {
  			text.text = "Z to continue";
  		}

      maybeMentionSwitch();
      maybeMentionChest();

  		super.update(e);
  	}

    public function maybeMentionSwitch():void {
      if (c.canPressSwitch()) {
        text.text = "Z to press switch";
      }
    }

    public function maybeMentionChest():void {
      if (c.canOpenChest()) {
        text.text = "Z to open chest";
      }
    }

    override public function groups():Set {
      return super.groups().concat("no-camera", "non-blocking");
    }

    override public function modes():Array {
    	return [0, 1, 2];
    }
  }
}