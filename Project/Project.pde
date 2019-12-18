Cell[][] cells;
float[][] laplacian;
Player player;
int itr=10;
float dt=1.0/(60.0*(float)(itr));
float w=30.0;
int n,m;
char[] keys={'w','a','s','d'};
boolean[] keys_down=new boolean[keys.length];

void setup() {
  fullScreen();
  background(125);
  String[] lines=loadStrings("map.txt");
  n=lines.length; m=lines[0].length();
  cells=new Cell[n][m]; laplacian=new float[n][m];
  for(int i=0;i<n;i++) {
    for(int j=0;j<m;j++) {
      int celltype=lines[i].charAt(j)-'0';
      
      if(celltype==0) //free cell
        cells[i][j]=new Cell(j*w,i*w,w,10000.0,false);
      if(celltype==1) //not diffusive at all, 'wall'
        cells[i][j]=new Cell(j*w,i*w,w,0.0,false);
      if(celltype==2) //source cell
        cells[i][j]=new Cell(j*w,i*w,w,1.0,true);
      
    }
  }
  player=new Player(3*w,10*w,w);
}

void draw() {
  background(125);
  for(int i=0;i<n;i++) for(int j=0;j<m;j++)
    cells[i][j].show();
  for(int i=0;i<n;i++) for(int j=0;j<m;j++)
    if(cells[i][j].source) cells[i][j].drawcorners();
  player.show(); player.showstatus();
  for(int t=0;t<itr;t++) {
    for(int i=1;i<n-1;i++) for(int j=1;j<m-1;j++)
      laplacian[i][j]=(cells[i-1][j].getpoison(i-1,j,-1,0)+cells[i+1][j].getpoison(i+1,j,1,0)+cells[i][j-1].getpoison(i,j-1,0,-1)+cells[i][j+1].getpoison(i,j+1,0,1)-4*cells[i][j].poison)/(w*w);
    for(int i=1;i<n-1;i++) for(int j=1;j<m-1;j++)
      cells[i][j].update(laplacian[i][j],dt);
  }
  int pj=floor(player.x/w); float jw=(player.x/w-floor(player.x/w));
  int pi=floor(player.y/w); float iw=(player.y/w-floor(player.y/w));
  float avpoison=(cells[pi][pj].poison*jw*iw+cells[pi+1][pj].poison*jw*(1-iw)+cells[pi][pj+1].poison*(1-jw)*iw+cells[pi+1][pj+1].poison*(1-jw)*(1-iw));
  player.update(avpoison);
}

void keyPressed() {
  trackkeys(true);
}

void keyReleased() {
  trackkeys(false);
}

void trackkeys(boolean state) {
  for(int i=0;i<keys.length;i++)
    if(keys[i]==key) keys_down[i]=state;
}
