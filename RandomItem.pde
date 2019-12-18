
class RandomItem extends Item {
  int rnd;
  public static final int itemType = 1;
  
  RandomItem(int x, int y) {
    super(x, y, itemType);
    rnd=int(random(-1,2));
    itemColor=0;
  }
  
  void applyItem(Player player){
    
  }
}
