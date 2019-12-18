import java.util.Iterator;

Cell[][] cells;
float[][] laplacian;
ArrayList<Player> players;
float dt;
int rows, cols;

ArrayList<Item> items;

void setup() {
  
  dt = 1.0/(frameRate*(float)(Config.itr));
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
  items = new ArrayList();
  players = new ArrayList();
  players.add(new Player(100, 100, Config.cellSize, 'w', 'a', 's', 'd', '`'));
  players.add(new Player(100, 100, Config.cellSize, UP, LEFT, DOWN, RIGHT, 'm'));
  for(int i=0;i<players.size();i++){
    String[] args = {"Player"};
    PApplet.runSketch(args, players.get(i));
    players.get(i).getSurface().setTitle("Player"+(i+1));
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
