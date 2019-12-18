
class HealthItem extends Item {
  public static final int itemType = 2;
  public static final int itemTime = Config.HealthItemTime;
  
  HealthItem(int px, int py) {
    super(px,py,itemType);
    this.itemColor=255;
  }
  
  void applyItem(Player player){
    player.appliedBuffs.add(new ItemBuff(itemTime, 0.8));
    player.health+=Config.heal;
  }
}
