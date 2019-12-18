
class Player extends PApplet{
  float x,y;
  float w;
  float v;
  float health;
  boolean killed;
  Object[] keys; // ={'w','a','s','d'}
  boolean[] keys_down;
  boolean forcemove;
  
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
    for(Item item : items){
      if(s2*Config.cellSize< item.x && item.x < e2*Config.cellSize && s1*Config.cellSize< item.y && item.y < e1*Config.cellSize) item.display(this);
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
    health-=avpoison/255.0;
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
