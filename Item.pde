
class Item {
  float px, py, l, sr;
  int type, col;
  
  Item(float px, float py, int type) {
    this.px=px;
    this.py=py;
    this.type=type;
    l=5;
    sr=150;
    col=100;
  }
  
  void display() {
    fill(col);
    rectMode(CENTER);
    stroke(sr);
    rect(px, py, l, l);
  }
}
