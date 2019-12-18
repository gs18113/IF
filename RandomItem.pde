
class RandomItem extends Item {
  int rnd;
  
  RandomItem(float px, float py) {
    super(px, py, 1);
    rnd=int(random(-1,2));
  }
  
  void display() {
    super.display();
  }
}
