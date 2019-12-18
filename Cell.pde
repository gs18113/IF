
public class Cell {
  int x, y;
  float poison;
  float alpha;
  boolean source;
  
  Cell(int x,int y,float alpha,boolean source) {
    this.x=x; this.y=y;
    this.alpha=alpha;
    this.source=source;
    if(source) poison=255.0;
    else poison=0.0;
  }
  
  void update(float laplacian,float dt) {
    if(!source) poison=poison+alpha*laplacian*dt;
  }
  
  void show(Player player) {
    player.pushMatrix();
    player.translate((Config.panelWidth-Config.cellSize)/2, (Config.panelHeight-Config.cellSize)/2);
    if(alpha==0) {
      player.stroke(0); player.fill(0);
      player.rect(x-player.x,y-player.y,Config.cellSize,Config.cellSize);
    }
    else {
      player.noStroke(); player.fill(0,255,0,poison);
      player.rect(x-player.x,y-player.y,Config.cellSize,Config.cellSize);
    }
    player.popMatrix();
  }
  
  void drawcorners(Player player) {
    player.pushMatrix();
    player.translate((Config.panelWidth-Config.cellSize)/2, (Config.panelHeight-Config.cellSize)/2);
    if(source) player.stroke(255,0,0);
    player.noFill();
    player.rect(x-player.x,y-player.y,Config.cellSize,Config.cellSize);
    player.popMatrix();
  }
  
  float getpoison(int i,int j,int di,int dj) {
    if(alpha>0) return poison;
    else return cells[i-2*di][j-2*dj].poison;
  }
}
