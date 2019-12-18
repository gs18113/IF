
public abstract class Item {
  int x, y;
  float strk;
  int type, itemColor;
  
  Item(int x, int y, int type) {
    this.x=x;
    this.y=y;
    this.type=type;
    strk=150;
    itemColor=100;
  }
  
  void display(Player player) {
    player.pushMatrix();
    player.translate((Config.panelWidth-Config.cellSize)/2, (Config.panelHeight-Config.cellSize)/2);
    player.fill(itemColor);
    player.rectMode(CENTER);
    player.stroke(strk);
    player.rect(x*Config.cellSize-player.x, y*Config.cellSize-player.y, Config.cellSize, Config.cellSize);
    player.popMatrix();
  }
  
  abstract void applyItem(Player player);
}

Item createItem(int x, int y, int type){
  switch(type){
    case(RandomItem.itemType):
      return new RandomItem(x, y);
    case(BoostItem.itemType):
      return new BoostItem(x, y);
    case(HealthItem.itemType):
      return new HealthItem(x, y);
  }
  return null;
}
