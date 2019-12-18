
class RandomItem extends Item {
  int rnd;
  public static final int itemType = 1;
  public static final int itemTime = Config.RandomItemTime;
  
  RandomItem(int x, int y) {
    super(x, y, itemType);
    rnd=int(random(-1,2));
    itemColor=0;
  }
  
  void applyItem(Player player){
    if (rnd>0) player.appliedBuffs.add(new ItemBuff(itemTime, 1.2));
    else if (rnd<0) player.appliedBuffs.add(new ItemBuff(itemTime, 0.8));
  }
}
