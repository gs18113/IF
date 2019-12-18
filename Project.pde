Cell[][] cells;
float[][] laplacian;
ArrayList<Player> players;
float dt;
int rows, cols;
float pix;

void setup() {
  
  dt = 1.0/(60.0*(float)(Config.itr));
  String[] lines=loadStrings("map.txt");
  rows = lines.length;
  cols = lines[0].length();
  
  cells = new Cell[rows][cols];
  laplacian=new float[rows][cols];
  
  int s = (int)Config.cellSize;
  
  for(int i=0;i<rows;i++) {
    for(int j=0;j<cols;j++) {
      int celltype=lines[i].charAt(j)-'0';
      
      if(celltype==0) //free cell
        cells[i][j]=new Cell(j*s,i*s,10000.0,false);
      if(celltype==1) //not diffusive at all, 'wall'
        cells[i][j]=new Cell(j*s,i*s,0.0,false);
      if(celltype==2) //source cell
        cells[i][j]=new Cell(j*s,i*s,1.0,true);
      
    }
  }
  players = new ArrayList();
  players.add(new Player(100, 100, Config.cellSize, 'w', 'a', 's', 'd'));
  players.add(new Player(100, 100, Config.cellSize, UP, LEFT, DOWN, RIGHT));
  for(Player player : players){
    String[] args = {"Player"};
    PApplet.runSketch(args, player);
  }
  frame.requestFocus();
}

void draw() {
  background(125);
  //for(int i=0;i<rows;i++) for(int j=0;j<cols;j++) cells[i][j].show();
  //for(int i=0;i<rows;i++) for(int j=0;j<cols;j++)
  //  if(cells[i][j].source) cells[i][j].drawcorners();
  //player.show(); player.showstatus();
  for(int t=0;t<Config.itr;t++) {
    for(int i=1;i<rows-1;i++) for(int j=1;j<cols-1;j++)
      laplacian[i][j]=(cells[i-1][j].getpoison(i-1,j,-1,0)+cells[i+1][j].getpoison(i+1,j,1,0)+cells[i][j-1].getpoison(i,j-1,0,-1)+cells[i][j+1].getpoison(i,j+1,0,1)-4*cells[i][j].poison) / (Config.cellSize*Config.cellSize);
    for(int i=1;i<rows-1;i++) for(int j=1;j<cols-1;j++)
      cells[i][j].update(laplacian[i][j],dt);
  }
  for(Player player : players){
    int pj=floor(player.x/Config.cellSize); float jw=(player.x/Config.cellSize-floor(player.x/Config.cellSize));
    int pi=floor(player.y/Config.cellSize); float iw=(player.y/Config.cellSize-floor(player.y/Config.cellSize));
    float avpoison=(cells[pi][pj].poison*jw*iw+cells[pi+1][pj].poison*jw*(1-iw)+cells[pi][pj+1].poison*(1-jw)*iw+cells[pi+1][pj+1].poison*(1-jw)*(1-iw));
    player.update(avpoison);
  }
}

void keyPressed() {
  trackkeys(true);
}

void keyReleased() {
  trackkeys(false);
}

void trackkeys(boolean state) {
  for(Player player : players){
    for(int i=0;i<player.keys.length;i++){
      if(key==CODED){
        try{
          if((int)player.keys[i]==keyCode) player.keys_down[i]=state;
        } catch(Exception e){}
      }
      else{
        try{
          if((char)player.keys[i]==key) player.keys_down[i]=state;
        } catch(Exception e){}
      }
    }
  }
}
