import java.util.Iterator;

Cell[][] cells;
float[][] laplacian;
ArrayList<Player> players;
float dt;
int rows, cols;
Boolean gameover=false;

ArrayList<Item> items;

void setup() {
  
  dt = 1.0/(frameRate*(float)(Config.itr));
  loadMap();
  
  items = new ArrayList();
  players = new ArrayList();
  players.add(new Player(200, 200, Config.playerSize, 'w', 'a', 's', 'd', '`'));
  players.add(new Player(200, 200, Config.playerSize, UP, LEFT, DOWN, RIGHT, 'm'));
  for(int i=0;i<players.size();i++){
    String[] args = {"Player"};
    PApplet.runSketch(args, players.get(i));
    players.get(i).getSurface().setTitle("Player"+(i+1));
  }
}

void loadMap(){
  String[] _lines=loadStrings("1F.txt");
  rows = _lines.length;
  cols = _lines[0].length();
  for(int i=2;i<=Config.floors;i++){
    String[] lines=loadStrings(i+"F.txt");
    rows += lines.length;
    if(cols != lines[0].length()){
      println("Wrong input file, dimension not matching:" + i + ".txt");
      exit();
    }
  }
  
  cells = new Cell[rows][cols];
  laplacian=new float[rows][cols];
  
  
  int s = (int)Config.cellSize;
  
  int currentRow = 0;
  int i;
  for(int k=1;k<=Config.floors;k++){
    String[] lines=loadStrings(k+"F.txt");
    int _rows = lines.length;
    for(int ii=0;ii<_rows;ii++) {
      for(int j=0;j<cols;j++) {
        int celltype=lines[ii].charAt(j)-'0';
        i = ii+currentRow;
        if(celltype==0) //free cell
          cells[i][j]=new Cell(j*s,(i)*s,10000.0,false);
        if(celltype==1){ //not diffusive at all, 'wall'
          if(cells[i][j] == null) cells[i][j]=new Cell(j*s,(i)*s,0.0,false);
        }
        if(celltype==2) //source cell
          cells[i][j]=new Cell(j*s,i*s,1.0,true);
        if(celltype==3){
          cells[i][j]=new Cell(j*s,i*s,10000.0,false);
          if(i+1<rows) cells[i+1][j]=new Cell(j*s,(i+1)*s,2300.0,false);
          if(i+2<rows) cells[i+2][j]=new Cell(j*s,(i+2)*s,2300.0,false);
          if(i+3<rows) cells[i+3][j]=new Cell(j*s,(i+3)*s,2300.0,false);
          if(i+4<rows) cells[i+4][j]=new Cell(j*s,(i+4)*s,2300.0,false);
        }
        
      }
    }
    currentRow += _rows;
  }
}

int lastGeneration, lastHealthGen;

void draw() {
  background(125);
  for(int t=0;t<Config.itr;t++) {
    for(int i=1;i<rows-1;i++) for(int j=1;j<cols-1;j++)
      laplacian[i][j]=(cells[i-1][j].getpoison(i-1,j,-1,0)+cells[i+1][j].getpoison(i+1,j,1,0)+cells[i][j-1].getpoison(i,j-1,0,-1)+cells[i][j+1].getpoison(i,j+1,0,1)-4*cells[i][j].poison) / (Config.cellSize*Config.cellSize);
    for(int i=1;i<rows-1;i++) for(int j=1;j<cols-1;j++)
      cells[i][j].update(laplacian[i][j],dt);
  }
  synchronized(items){
    if(millis()/Config.itemInterval != lastGeneration){
      lastGeneration = millis()/Config.itemInterval;
      float minY = Config.panelHeight;
      for(Player player : players) if(!player.killed) minY = min(minY, player.y);
      int py = (int)map(constrain(randomGaussian()*Config.itemDeviation + minY, 0, Config.panelHeight), 0, Config.panelHeight, 1, rows-1-Config.eps);
      int px = (int)(Math.random()*(cols-2))+1;
      items.add(createItem(px, py, (int)(Math.random()*Config.itemTypes)));
    }
    if(millis()/Config.healthInterval != lastHealthGen){
      lastHealthGen = millis()/Config.healthInterval;
      float maxY = 0;
      for(Player player : players) if(!player.killed) maxY = max(maxY, player.y);
      int py = (int)map(constrain(randomGaussian()*Config.itemDeviation + maxY, 0, Config.panelHeight), 0, Config.panelHeight, 1, rows-1-Config.eps);
      int px = (int)(Math.random()*(cols-2))+1;
      items.add(createItem(px, py, HealthItem.itemType));
    }
  }
  boolean flag=false;
  for(Player player : players) flag=flag||player.win;
  if(flag){
    gameover = true;
    noLoop();
  }
  for(Player player : players){
    int pj=floor(player.x/Config.cellSize); float jw=(player.x/Config.cellSize-floor(player.x/Config.cellSize));
    int pi=floor(player.y/Config.cellSize); float iw=(player.y/Config.cellSize-floor(player.y/Config.cellSize));
    float avpoison=(cells[pi][pj].poison*jw*iw+cells[pi+1][pj].poison*jw*(1-iw)+cells[pi][pj+1].poison*(1-jw)*iw+cells[pi+1][pj+1].poison*(1-jw)*(1-iw));
    player.update(avpoison);
    synchronized(items){
    Iterator<Item> it = items.iterator();
      while(it.hasNext()){
        Item item = it.next();
        if((item.x==pj&&item.y==pi)
        ||(item.x==pj&&item.y==pi+1)
        ||(item.x==pj+1&&item.y==pi)
        ||(item.x==pj+1&&item.y==pi+1)){
          item.applyItem(player);
          it.remove();
        }
      }
    }
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
