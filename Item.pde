
public class Item {
  float x, y, w, strk;
  int type, itemColor;
  
  Item(float x, float y, int type) {
    this.x=x;
    this.y=y;
    this.type=type;
    w=5;
    strk=150;
    itemColor=100;
  }
  
  void display() {
    fill(itemColor);
    rectMode(CENTER);
    stroke(strk);
    rect(x, y, w, w);
  }
}
