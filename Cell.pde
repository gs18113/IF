
class Cell {
  float x,y;
  float w;
  float poison;
  float alpha;
  boolean source;
  
  Cell(float x,float y,float w,float alpha,boolean source) {
    this.x=x; this.y=y; this.w=w;
    this.alpha=alpha;
    this.source=source;
    if(source) poison=255.0;
    else poison=0.0;
  }
  
  void update(float laplacian,float dt) {
    if(!source) poison=poison+alpha*laplacian*dt;
  }
  
  void show() {
    if(alpha==0) {
      stroke(0); fill(0);
      rect(x,y,w,w);
    }
    else {
      noStroke(); fill(0,255,0,poison);
      rect(x,y,w,w);
    }
  }
  
  void drawcorners() {
    if(source) stroke(255,0,0);
    noFill();
    rect(x,y,w,w);
  }
  
  float getpoison(int i,int j,int di,int dj) {
    if(alpha>0) return poison;
    else return cells[i-2*di][j-2*dj].poison;
  }
}
