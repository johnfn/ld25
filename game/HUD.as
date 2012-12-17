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

      this.addChild(text);
  	}

  	override public function update(e:EntitySet):void {
  		text.text = "";

  		if (Fathom.currentMode == C.MODE_TEXT) {
  			text.text = "Z to continue";
  		}

      maybeMentionSwitch();
      maybeMentionChest();
      maybeMentionDarts();

  		super.update(e);

      this.raiseToTop();
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

    public function maybeMentionDarts():void {
      if (c.canShootNeedle() && !c.canPressSwitch() && !c.canOpenChest()) {
        if (Character.needles == Character.POISON_NEEDLE) {
          text.text = "Z to shoot poison dart";
        }
        if (Character.needles == Character.TRANQ_NEEDLE) {
          text.text = "Z to shoot sleeping dart";
        }
      }
    }

    override public function groups():Set {
      return super.groups().concat("no-camera", "non-blocking", "persistent");
    }

    override public function modes():Array {
    	return [0, 1, 2];
    }
  }
}