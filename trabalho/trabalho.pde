int tileSize = 15;
int chunkSize = 90;
int offsetX, offsetY;
float diffX, diffY;
float zoom;

HashMap<String, Chunk> chunks;
float seed, treeSeed;
float noiseScale = .003;

PVector previousMouse;

//final int WATER = #40BCFC, GRASS = #0FCB06, SAND = #FFF8B4, CORAL = #8590F0, STONE = #6F816F, CACTUS = #008000, SHALLOW_WATER = #98F7FF, TREE = #048E0E;
final int WATER = 0, GRASS = 1, SAND = 2, CORAL = 3, STONE = 4, CACTUS = 5, SHALLOW_WATER = 6, TREE = 7;
ArrayList<Integer> colors;
ArrayList<Integer> obstacles;

HashMap<String, Config> configs;
Config currentConfig;

Map map;

Player player;
int searchingArea = 150;

boolean isObstacle(int x) {
  for (int o : obstacles) {
    if (x==o) return true;
  }
  return false;
}

void updateScreen() {
  filter(GRAY);
  map.display();
  player.show();
}

void setup() {
  size(1750, 750);

  //Seeds
  seed = random(1000);
  treeSeed = random(1000);

  //Map Configs
  configs = new HashMap<String, Config>();
  configs.put("Ocean", new Config(.5, .6, .65, .99));
  configs.put("Desert", new Config(.2, .3, .9, .99));
  configs.put("Normal", new Config(.3, .4, .5, .8));

  currentConfig = configs.get("Normal");

  //Colors
  colors = new ArrayList<Integer>();
  colors.add(#40BCFC); //water
  colors.add(#0FCB06); //grass
  colors.add(#FFF8B4); //sand
  colors.add(#8590F0); //coral
  colors.add(#3B523A); //stone
  colors.add(#008000); //cactus
  colors.add(#98F7FF); //shallow_water
  colors.add(#048E0E); //tree

  //Map
  chunks = new HashMap<String, Chunk>();
  map = new Map();


  player = new Player(10000, 10000);
  offsetX = width/2-(int)player.pos.x*tileSize;
  offsetY = height/2-(int)player.pos.y*tileSize;

  updateScreen();
  previousMouse = new PVector(mouseX, mouseY);
}

void keyReleased() {
  switch(key) {
  case 'p':
    //println(player.pos);
    offsetX = width/2-(int)player.pos.x*tileSize;
    offsetY = height/2-(int)player.pos.y*tileSize;
    updateScreen();
    break;
  }
}

void mouseWheel(MouseEvent event) {
  float scroll = constrain(zoom+event.getCount()/10.0, .01, 2);
  zoom = scroll;
  //updateScreen();
}

void mousePressed() {
  previousMouse = new PVector(mouseX, mouseY);
}

void draw() {
  //println(offsetX +","+offsetY);

  //println(zoom);
  if (mousePressed) {
    map.drag((width/2.0-mouseX)/10.0, (height/2.0-mouseY)/10.0);
    player.setGrid();
    updateScreen();
  }

  fill(255);
  text(frameRate, width-20, 20);
}
