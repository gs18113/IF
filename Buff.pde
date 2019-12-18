
public abstract class Buff {
  int t, type, sTime;
  
  Buff(int t, int type) {
    this.t=t;
    this.type=type;
    sTime=millis();
  }
  
  abstract Pair applyBuff(float dx, float dy);
}
