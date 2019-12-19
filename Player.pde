import java.util.*;
import controlP5.*;

class Player extends PApplet{
  float x,y;
  float w;
  float v;
  float health;
  boolean killed;
  Object[] keys; // ={'w','a','s','d'}
  boolean[] keys_down;
  boolean forcemove;
  LinkedList<Buff> appliedBuffs=new LinkedList<Buff>();
  int lastAttack;
  ControlP5 cp5;
  Slider _health, _attackTime;
  int begin;
  boolean win=false;
  boolean lose=false;
  //ControlP5 cp5=new ControlP5(this);
  
  public void settings() {
    size(Config.panelWidth, Config.panelHeight);
    begin=millis();
  }
  
  public void draw() {
    if(cp5 == null){
      cp5 = new ControlP5(this);
      _health = cp5.addSlider("health").setPosition(Config.panelWidth-150, 10).setRange(0,Config.health).setSize(100, 20).setValue(Config.health);
      _health.setLock(true);
      _attackTime = cp5.addSlider("attackTime").setPosition(Config.panelWidth-150, 30).setRange(0,Config.attackInterval).setSize(100, 20).setValue(Config.health);
      _attackTime.setLock(true);
    }
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
    //Controller c=cp5.getController("health");
    //Slider slider=cp5.get(Slider.class, "health");
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
    if(killed) {
      player.fill(125,0,125);
      gameover=true;
      for(Player p : players) if( player != this ) player.win=true;
      finish(win);
    }
    else if (gameover) {
      finish(win);
    }
    player.pushMatrix();
    player.translate((Config.panelWidth-w)/2, (Config.panelHeight-w)/2);
    player.rect(x-player.x, y-player.y, w, w);
    player.popMatrix();
  }
  
  void showstatus(Player player) {
    
  }
  
  void update(float avpoison) {
    if(killed) return;
    if (millis()-begin>=Config.immortalTime) health-=avpoison/255.0;
    if(health<0) {
      health=0; killed=true;
    }
    v=health/150.0+5; //change later
    if(_attackTime != null){
      _health.setValue(health);
      _attackTime.setValue(constrain(Config.attackInterval-millis()+lastAttack, 0, Config.attackInterval));
    }
    
    forcemove=false;
    for (Buff buff:appliedBuffs) {
      if (buff.type==0) {
        forcemove=true;
        Pair fv=buff.applyBuff(0,0);
        applyMovement(fv);
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
      if(cnt1 != cnt2 || cnt2 != 0){
        fv.fi /= sqrt((float)cnt1*cnt1+cnt2*cnt2);
        fv.se /= sqrt((float)cnt1*cnt1+cnt2*cnt2);
        for (Buff buff:appliedBuffs) {
          fv=buff.applyBuff(fv.fi,fv.se);
        }
        applyMovement(fv);
      }
    }
    
    int nTime=millis();
    Iterator<Buff> it=appliedBuffs.iterator();
    while (it.hasNext()) {
      Buff buff=it.next();
      if (buff.t<=nTime-buff.sTime) it.remove();
    }
    
    if(keys_down[4]){
      if(millis() - lastAttack > Config.attackInterval){
        lastAttack = millis();
        for(Player p : players){
          if(p != this) attack(p);
        }
      }
    }
    if(y > rows*Config.cellSize-Config.playerSize-30) win=true;
  }
  
  void applyMovement(Pair fv){
    x+=fv.fi;
    y+=fv.se;
    x -= 15;
    y -= 15;
    if (fv.fi<0&&cells[floor(y/Config.cellSize)][floor(x/Config.cellSize)].alpha==0) x=Config.cellSize*floor((x+Config.cellSize)/Config.cellSize)+Config.eps;
    else if (fv.fi<0&&cells[floor((y+w)/Config.cellSize)][floor(x/Config.cellSize)].alpha==0) x=Config.cellSize*floor((x+Config.cellSize)/Config.cellSize)+Config.eps;
    
    if (fv.fi>0&&cells[floor(y/Config.cellSize)][floor((x+w)/Config.cellSize)].alpha==0) x=Config.cellSize*floor(x/Config.cellSize)-Config.eps;
    else if (fv.fi>0&&cells[floor((y+w)/Config.cellSize)][floor((x+w)/Config.cellSize)].alpha==0) x=Config.cellSize*floor(x/Config.cellSize)-Config.eps;
    
    if (fv.se<0&&cells[floor(y/Config.cellSize)][floor(x/Config.cellSize)].alpha==0) y=Config.cellSize*floor((y+Config.cellSize)/Config.cellSize)+Config.eps;
    else if (fv.se<0&&cells[floor(y/Config.cellSize)][floor((x+w)/Config.cellSize)].alpha==0) y=Config.cellSize*floor((y+Config.cellSize)/Config.cellSize)+Config.eps;
    
    if (fv.se>0&&cells[floor((y+w)/Config.cellSize)][floor(x/Config.cellSize)].alpha==0) y=Config.cellSize*floor((y+w)/Config.cellSize)-w-Config.eps;
    else if (fv.se>0&&cells[floor((y+w)/Config.cellSize)][floor((x+w)/Config.cellSize)].alpha==0) y=Config.cellSize*floor((y+w)/Config.cellSize)-w-Config.eps;
    
    x += 15;
    y += 15;
  }
  
  void attack(Player player){
    float dist = sqrt((float)(x-player.x)*(x-player.x)+(y-player.y)*(y-player.y));
    println(dist);
    if(dist > Config.attackDist || dist == 0) return;
    float rad = atan2(player.y-y, player.x-x);
    if(-PI*3/4 < rad && rad < -PI/4) return;
    float fv = constrain(Config.attackMag / dist, 0, Config.attackMax);
    player.appliedBuffs.add(new ForceBuff(Config.attackTime, rad, fv));
  }
  
  void finish(boolean asdf){
    textSize(30);
    if(asdf) text("YOU WIN!", Config.panelWidth/2-30, Config.panelHeight/2);
    else text("YOU LOSE!", Config.panelWidth/2-40, Config.panelHeight/2);
  }
}
