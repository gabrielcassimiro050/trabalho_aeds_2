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

boolean cameraSeguindo;

PImage woodSprite, paperSprite, treasureSprite;

int nWood = 5, woodRange = 150;
ArrayList<Wood> woods;

int paperRange = 100;
Paper paper;

int treasureRange = 100;
Treasure treasure;

int areaDeBusca = 100;
int toleranceRange = 30;

PFont pixelFont;

boolean endGame;

float dist(PVector p1, PVector p2) {
  return dist(p1.x, p1.y, p2.x, p2.y);
}

boolean isObstacle(int x) {
  for (int o : obst) {
    if (x == o) return true;
  }
  return false;

  //falta dizer que águe não é obstáculo quando tá com barco
}

void updateScreen() {
  map.display();
  showWoods();
  player.show();
}

void setWoods(float x, float y, float range) {
  for (int i = 0; i < nWood; ++i) {
    PVector aux = new PVector(x+(int)random(-range/2.0, range/2.0), y+(int)random(-range/2.0, range/2.0));
    int value = map.getTileValue((int)aux.x, (int)aux.y);


    while (isObstacle(value)) {
      aux = new PVector(x+(int)random(-range/2.0, range/2.0), y+(int)random(-range/2.0, range/2.0));
      int auxX = (int)aux.x;
      int auxY = (int)aux.y;
      value = map.getTileValue(auxX, auxY);
    }

    woods.add(new Wood(aux.x, aux.y));
  }
}

void showWoods() {
  for (Wood w : woods) if (w!=null) w.show();
}

void setup() {
  size(1200, 500);

  // Seeds
  seed = random(1000);
  treeSeed = random(1000);
  pixelFont = createFont("Minecraft.ttf", 20);
  textFont(pixelFont);
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

  woods = new ArrayList<Wood>();
  woodSprite = loadImage("wood.png");
  setWoods(pX, pY, woodRange);

  PVector paperPos = new PVector(pX+(int)random(-paperRange/2.0, paperRange/2.0), pY+(int)random(-paperRange/2.0, paperRange/2.0));
  paperSprite = loadImage("paper.png");


  while (isObstacle(map.getTileValue((int)paperPos.x, (int)paperPos.y))) {
    paperPos = new PVector(pX+(int)random(-paperRange/2.0, paperRange/2.0), pY+(int)random(-paperRange/2.0, paperRange/2.0));
  }

  paper = new Paper(paperPos.x, paperPos.y);

  player = new Player(pX, pY);

  treasureSprite = loadImage("treasure.png");

  PVector treasurePos = new PVector(pX+(int)random(-treasureRange/2.0, treasureRange/2.0), pY+(int)random(-treasureRange/2.0, treasureRange/2.0));
  while (map.getTileValue((int)treasurePos.x, (int)treasurePos.y)!=WATER) {
    treasurePos = new PVector(pX+(int)random(-treasureRange/2.0, treasureRange/2.0), pY+(int)random(-treasureRange/2.0, treasureRange/2.0));
  }
  treasure = new Treasure(treasurePos.x, treasurePos.y);

  //for(int i = 0; i < nWoods; ++i) woods.add(new Wood(player.pos.x+(int)random(-50, 50), player.pos.y+(int)random(-50, 50)));
  offset = new PVector(width / 2 - (int) player.pos.x * tileSize, height / 2 - (int) player.pos.y * tileSize);

  endGame = false;
  updateScreen();
}

void keyReleased() {
  switch (key) {
  case 'p':
    if (cameraSeguindo) cameraSeguindo = false;
    else cameraSeguindo = true;
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
  if (!endGame) {
    updateScreen();

    if (mousePressed && mouseButton == RIGHT) {
      map.drag((width / 2.0 - mouseX) / 10.0, (height / 2.0 - mouseY) / 10.0);
    }

    if (time%player.velocidade==0) player.update();

    if (cameraSeguindo) {
      offset.x = width / 2 - (int) player.pos.x * tileSize;
      offset.y = height / 2 - (int) player.pos.y * tileSize;
    }

    if (player.woodsGotten == nWood) {
      player.hasBoat = true;
      player.woodsGotten = 0;
    }

    if (player.hasBoat) {
      paper.show();
    }

    if (player.hasMap) {
      treasure.show();
    }

    fill(#063439);
    textSize(20);
    text(player.woodsGotten+"/"+nWood, width-width/15.0, 37);
    image(woodSprite, width-width/10.0, 30, 50, 50);
  }else{
    background(#110B27);
    fill(255);
    image(treasureSprite, width/2.0, height/2.0-width/15.0, width/10.0, width/10.0);
    text("VOCE ENCONTROU O TESOURO!", width/2.0-width/7.0, height/2.0);
  }
  ++time;
}
