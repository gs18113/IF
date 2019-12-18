
class ItemBuff extends Buff {
  float rate;
  
  ItemBuff(int t, float rate) {
    super(t, 1);
    this.rate=rate;
  }
  
  Pair applyBuff(float dx, float dy) {
    Pair v=new Pair(dx*rate, dy*rate);
    return v;
  }
}
