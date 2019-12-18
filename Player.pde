
class Player extends PApplet{
  float x,y;
  float w;
  float v;
  float health;
  boolean killed;
<<<<<<< HEAD
  Object[] keys; // ={'w','a','s','d'}
  boolean[] keys_down;
=======
  boolean forcemove;
>>>>>>> 3328917220c9eece4ea365e3df4e8c4d46407b5f
  
  public void settings() {
    size(Config.panelWidth, Config.panelHeight);
  }
  
  public void draw() {
    background(125);
    int s1=max((int)(y/Config.cellSize-Config.panelHeight/Config.cellSize), 0);
    int s2=max((int)(x/Config.cellSize-Config.panelWidth/Config.cellSize), 0);
    float e1=y/Config.cellSize+Config.panelHeight/Config.cellSize;
    float e2=x/Config.cellSize+Config.panelWidth/Config.cellSize;
    for(int i=s1;i<e1&&i<rows;i++){
      for(int j=s2;j<e2&&j<cols;j++){
        cells[i][j].show(this);
      }
    }
    for(int i=0;i<rows;i++){
      for(int j=0;j<cols;j++){
        if(cells[i][j].source) cells[i][j].drawcorners(this);
      }
    }
    show(); showstatus();
  }
  
  Player(float x,float y,float w, Object... keys) {
    super();
    this.x=x; this.y=y; this.w=w;
<<<<<<< HEAD
    health=200.0; killed=false;
    this.keys = keys;
    keys_down = new boolean[Config.playerKeys];
=======
    health=100.0; killed=false;
    forcemove=false;
>>>>>>> 3328917220c9eece4ea365e3df4e8c4d46407b5f
  }
    
  void show() {
    stroke(0); fill(0,0,125);
    if(killed) fill(125,0,125);
    rect((Config.panelWidth-Config.cellSize)/2, (Config.panelHeight-Config.cellSize)/2 , w, w);
  }
  
  void showstatus() {
    
  }
  
  void update(float avpoison) {
    if(killed) return;
    //health-=avpoison/255.0;
    if(health<0) {
      health=0; killed=true;
    }
    v=health/20.0; //change later
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
