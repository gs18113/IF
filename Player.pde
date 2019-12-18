
class Player {
  float x,y;
  float w;
  float v;
  float health;
  boolean killed;
  boolean forcemove;
  
  Player(float x,float y,float w) {
    this.x=x; this.y=y; this.w=w;
    health=100.0; killed=false;
    forcemove=false;
  }
    
  void show() {
    stroke(0); fill(0,0,125);
    if(killed) fill(125,0,125);
    rect(x,y,w,w);
  }
  
  void showstatus() {
    
  }
  
  void update(float avpoison) {
    if(killed) return;
    health-=avpoison/255.0;
    if(health<0) {
      health=0; killed=true;
    }
    v=health/20.0;
    if(keys_down[0]) {
      y-=v; if(cells[floor(y/w)][floor(x/w)].alpha==0) y+=v;
    }
    if(keys_down[1]) {
      x-=v; if(cells[floor(y/w)][floor(x/w)].alpha==0) x+=v;
    }
    if(keys_down[2]) {
      y+=v; if(cells[floor(y/w)+1][floor(x/w)].alpha==0) y-=v;
    }
    if(keys_down[3]) {
      x+=v; if(cells[floor(y/w)][floor(x/w)+1].alpha==0) x-=v;
    }
  }
}
