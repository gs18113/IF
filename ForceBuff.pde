
public class ForceBuff extends Buff {
  float angle;
  float fv;
  
  ForceBuff(int t, float angle) {
    super(t, 0);
    this.angle=angle;
    fv=15;
  }
  
  Pair applyBuff(float dx, float dy) {
    Pair v=new Pair(fv*cos(angle), fv*sin(angle)); //change later
    return v;
  }
}
