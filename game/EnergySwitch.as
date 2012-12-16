package {
  public class EnergySwitch extends Entity {
    private const SIZE:int = C.size;

    function EnergySwitch(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }

    public function flip() {
      setTile(0, 1);
    }

    override public function groups():Set {
      return super.groups().concat("switch");
    }
  }
}
