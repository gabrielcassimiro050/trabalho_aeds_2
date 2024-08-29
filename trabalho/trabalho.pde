import java.util.HashSet;
import java.util.Collections;

int time = 0;

int tileSize = 20;
int chunkSize = 100;
PVector offset;

HashMap<String, Chunk> chunks;
float seed, treeSeed;
float noiseScale = .003;


final int WATER = 0, GRASS = 1, SAND = 2, CORAL = 3, STONE = 4, CACTUS = 5, SHALLOW_WATER = 6, TREE = 7;
ArrayList<Integer> colors;
ArrayList<Integer> obst;

HashMap<String, Config> configs;
Config currentConfig;

Map map;
Player player;
Boat boat;

int areaDeBusca = 100;
int toleranceRange = 30;

boolean isObstacle(int x) {
  for (int o : obst) {
    if (x == o) return true;
  }
  return false;

  //falta dizer que águe não é obstáculo quando tá com barco
}

void updateScreen() {
  map.display();
  player.show();
  boat.show();
}

void setup() {
  size(1750, 750);

  // Seeds
  seed = random(1000);
  treeSeed = random(1000);

  // Map Configs
  configs = new HashMap<String, Config>();
  configs.put("Ocean", new Config(.5, .6, .65, .99));
  configs.put("Desert", new Config(.2, .3, .9, .99));
  configs.put("Normal", new Config(.3, .4, .5, .8));

  currentConfig = configs.get("Normal");

  // Colors
  colors = new ArrayList<Integer>();
  colors.add(#40BCFC); // water
  colors.add(#0FCB06); // grass
  colors.add(#FFF8B4); // sand
  colors.add(#8590F0); // coral
  colors.add(#3B523A); // stone
  colors.add(#008000); // cactus
  colors.add(#98F7FF); // shallow_water
  colors.add(#048E0E); // tree

  // obst
  obst = new ArrayList<Integer>();
  obst.add(CORAL);
  obst.add(STONE);
  obst.add(CACTUS);
  obst.add(TREE);
  obst.add(WATER);
  obst.add(SHALLOW_WATER);

  // Map
  chunks = new HashMap<String, Chunk>();
  map = new Map();

  int pX, pY;
  do {
    pX = (int) random(100) + 10000;
    pY = (int) random(100) + 10000;
  } while (isObstacle(map.getTileValue(pX, pY)));
  player = new Player(pX, pY);
  boat = new Boat(pX+(int)random(10), pY+(int)random(10));

  offset = new PVector(width / 2 - (int) player.pos.x * tileSize, height / 2 - (int) player.pos.y * tileSize);


  updateScreen();
}

void keyReleased() {
  switch (key) {
  case 'p':
    offset.x = width / 2 - (int) player.pos.x * tileSize;
    offset.y = height / 2 - (int) player.pos.y * tileSize;
    updateScreen();
    break;
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    int deltaX = (int) abs(player.pos.x - map.gridPosX(mouseX));
    int deltaY = (int) abs(player.pos.y - map.gridPosY(mouseY));

    areaDeBusca = ((deltaX > deltaY) ? deltaX : deltaY) * 2 + toleranceRange;

    player.setGrid();
    PVector m = player.translateToGridPosition(new PVector(map.gridPosX(mouseX), map.gridPosY(mouseY)));
    player.destino = new PVector(map.gridPosX(mouseX), map.gridPosY(mouseY));
    player.caminho = player.aEstrela(m);

    updateScreen();
  }
}

void draw() {
  if (mousePressed && mouseButton == RIGHT) {
    map.drag((width / 2.0 - mouseX) / 10.0, (height / 2.0 - mouseY) / 10.0);
    updateScreen();
  }
  
  player.show();
  if (time%player.velocidade==0) player.update();

  fill(255);
  text(frameRate, width - 20, 20);
  ++time;
}
