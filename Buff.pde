
class Buff {
  int t, type;
  
  Buff(int t, int type) {
    this.t=t;
    this.type=type;
  }
  
  Pair applyBuff(float dx, float dy) {
    Pair v=new Pair(dx, dy);
    return v;
  }
}
