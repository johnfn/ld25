package {
  public class Block extends Entity {
    private const SIZE:int = C.size;

    function Block(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }

    override public function groups():Set {
      return super.groups().concat("transparent");
    }
  }
}
