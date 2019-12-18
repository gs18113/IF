
class BoostItem extends Item {
  public static final int itemType = 0;
  public static final int itemTime = 3000;
  
  BoostItem(int px, int py) {
    super(px,py,itemType);
    this.itemColor=255;
  }
  
  void applyItem(Player player){
    player.appliedBuffs.add(new ItemBuff(itemTime, 1.2));
  }
}
