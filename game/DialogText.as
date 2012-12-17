package {
  public class DialogText extends Entity {
    import flash.filters.DropShadowFilter;

    private var text:Text;
    private var dialogsLeft:Array;

    private static const BOX_WIDTH:int = 250;
    private static const BOX_HEIGHT:int = 50;

    //[Embed(source = "../data/dialogbox.png")] static public var DialogClass:Class;

    function DialogText(args:Array) {
      args = args.slice(); //clone array so we dont destroy it.

      super(0, 0, 50, 50);
      //loadSpritesheet(DialogClass);
      centerOnScreen();

      visible = true;

      filters = [new DropShadowFilter()];

      // Stick it right under the inventory box so they don't overlap.
      setPos(new Vec(250 - BOX_WIDTH/2, 250 - BOX_HEIGHT/2 + 25));

      text = new Text("", C.fontName);
      text.setPos(new Vec(45, 8));
      text.width = BOX_WIDTH - 60;

      text.size = 14;

      text.color = 0xffffff;
      Fathom.pushMode(C.MODE_TEXT);

      dialogsLeft = args;

      text.addGroups("no-camera");

      nextDialog();

      addChild(text);
    }

    private function nextDialog():void {
      var nextText:String = dialogsLeft.shift();

      if (nextText == "FADEHALFWAY") {
        LightGrid.singleton.dimTo(0.9, 0.1);
        LightGrid.singleton.update(Fathom.entities);
        nextText = dialogsLeft.shift();
      }

      if (nextText == "FADEALLTHEWAY") {
        LightGrid.singleton.dimTo(1.0, 0.0);
        LightGrid.singleton.update(Fathom.entities);
        nextText = dialogsLeft.shift();
      }

      if (nextText == "FADENORMAL") {
        LightGrid.singleton.dimTo(LightGrid.NORMAL_START_DARK, LightGrid.NORMAL_LIGHT_POWER);
        nextText = dialogsLeft.shift();
      }

      text.text = nextText;
    }

    override public function groups():Set {
      return super.groups().concat("no-camera");
    }

    override public function update(e:EntitySet):void {
      if (Util.KeyJustDown.Z) {
        if (dialogsLeft.length == 0) {
          this.destroy();

          Fathom.popMode();
        } else {
          nextDialog();
        }
      }
    }

    // Should be active in all modes.
    override public function modes():Array {
      return [C.MODE_TEXT, C.MODE_NORMAL];
    }
  }
}
