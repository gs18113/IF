
class Item {
  float px, py, l, sr;
  int type;
  
  Item(float px, float py, int type) {
    this.px=px;
    this.py=py;
    this.type=type;
    l=5;
    sr=150;
  }
  
  void display() {
    fill(100);
    rectMode(CENTER);
    stroke(sr);
    rect(px, py, l, l);
  }
}
