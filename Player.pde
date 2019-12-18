
class Player extends PApplet{
  float x,y;
  float w;
  float v;
  float health;
  boolean killed;
  Object[] keys; // ={'w','a','s','d'}
  boolean[] keys_down;
  boolean forcemove;
  ArrayList<Buff> appliedBuffs=new ArrayList<Buff>();
  int lastAttack;
  
  public void settings() {
    size(Config.panelWidth, Config.panelHeight);
  }
  
  public void draw() {
    background(125);
    rectMode(CENTER);
    int s1=max((int)(y/Config.cellSize-Config.panelHeight/Config.cellSize), 0);
    int s2=max((int)(x/Config.cellSize-Config.panelWidth/Config.cellSize), 0);
    float e1=y/Config.cellSize+Config.panelHeight/Config.cellSize;
    float e2=x/Config.cellSize+Config.panelWidth/Config.cellSize;
    for(int i=s1;i<e1&&i<rows;i++){
      for(int j=s2;j<e2&&j<cols;j++){
        cells[i][j].show(this);
      }
    }
    synchronized(items){
      for(Item item : items){
        if(s2< item.x && item.x < e2 && s1 < item.y && item.y < e1) item.display(this);
      }
    }
    for(int i=0;i<rows;i++){
      for(int j=0;j<cols;j++){
        if(cells[i][j].source) cells[i][j].drawcorners(this);
      }
    }
    for(Player player : players){
      player.show(this); player.showstatus(this);
    }
  }
  
  Player(float x,float y,float w, Object... keys) {
    super();
    this.x=x; this.y=y; this.w=w;
    health=200.0; killed=false;
    this.keys = keys;
    keys_down = new boolean[Config.playerKeys];
    forcemove=false;
  }
    
  void show(Player player) {
    player.stroke(0); player.fill(0,0,125);
    if(killed) player.fill(125,0,125);
    player.pushMatrix();
    player.translate((Config.panelWidth-w)/2, (Config.panelHeight-w)/2);
    player.rect(x-player.x, y-player.y, w, w);
    player.popMatrix();
  }
  
  void showstatus(Player player) {
    
  }
  
  void update(float avpoison) {
    if(killed) return;
    //health-=avpoison/255.0;
    if(health<0) {
      health=0; killed=true;
    }
    v=health/20.0; //change later
    
    forcemove=false;
    for (int i=0; i<appliedBuffs.size(); i++) {
      if (appliedBuffs.get(i).type==0) {
        forcemove=true;
        Pair fv=appliedBuffs.get(i).applyBuff(0,0);
        x+=fv.fi;
        y+=fv.se;
        if (fv.fi<0&&cells[floor(y/w)][floor(x/w)].alpha==0) x-=fv.fi;
        else if (fv.fi>0&&cells[floor(y/w)][floor(x/w)+1].alpha==0) x-=fv.fi;
        if (fv.se<0&&cells[floor(y/w)][floor(x/w)].alpha==0) y-=fv.se;
        else if (fv.se>0&&cells[floor(y/w)+1][floor(x/w)].alpha==0) y-=fv.se;
        break;
      }
    }
    
    if (!forcemove) {
      Pair fv=new Pair();
      int cnt1=0, cnt2=0;
      if(keys_down[0]) {
        fv.se+=-1*v;
        cnt1++;
      }
      if(keys_down[1]) {
        fv.fi+=-1*v;
        cnt2++;
      }
      if(keys_down[2]) {
        fv.se+=v;
        cnt1--;
      }
      if(keys_down[3]) {
        fv.fi+=v;
        cnt2--;
      }
      fv.fi /= sqrt((float)cnt1*cnt1+cnt2*cnt2);
      fv.se /= sqrt((float)cnt1*cnt1+cnt2*cnt2);
      for (int i=0; i<appliedBuffs.size(); i++) {
        fv=appliedBuffs.get(i).applyBuff(fv.fi,fv.se);
      }
      x+=fv.fi;
      y+=fv.se;
      if (fv.fi<0&&cells[floor(y/w)][floor(x/w)].alpha==0) x-=fv.fi;
      else if (fv.fi>0&&cells[floor(y/w)][floor(x/w)+1].alpha==0) x-=fv.fi;
      if (fv.se<0&&cells[floor(y/w)][floor(x/w)].alpha==0) y-=fv.se;
      else if (fv.se>0&&cells[floor(y/w)+1][floor(x/w)].alpha==0) y-=fv.se;
    }
    if(keys_down[4]){
      if(millis() - lastAttack > Config.attackInterval){
        lastAttack = millis();
        for(Player p : players){
          if(p != this) attack(p);
        }
      }
    }
  }
  void attack(Player player){
    float dist = sqrt((float)(x-player.x)*(x-player.x)+(y-player.y)*(y-player.y)) * Config.cellSize;
    if(dist > Config.attackDist || dist == 0) return;
    float rad = atan2(player.y-y, player.x-x);
    float fv = constrain(Config.attackMag / dist, 0, Config.attackMax);
    player.appliedBuffs.add(new ForceBuff(Config.attackTime, rad, fv));
  }
}
