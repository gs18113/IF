
public abstract class Buff {
  int t, type;
  
  Buff(int t, int type) {
    this.t=t;
    this.type=type;
  }
  
  abstract Pair applyBuff(float dx, float dy);
}
