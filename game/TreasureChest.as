package {
  public class TreasureChest extends Entity {
    private const SIZE:int = C.size;

    function TreasureChest(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }
  }
}
