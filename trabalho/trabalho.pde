int tileSize = 15;
int chunkSize = 90;
float zoom = 1;

float seed;
float noiseScale = .003;
PVector previousMouse;

HashMap<String, Chunk> chunks;

final int WATER = #40BCFC, GRASS = #0FCB06, SAND = #FFF8B4, CORAL = #8590F0, STONE = #808080, CACTUS = #008000, SHALLOW_WATER = #98F7FF, TREE = #0A3B24;
ArrayList<Integer> colors;

Map map;

float diffX, diffY;


void setup() {
  size(1650, 750);
  //fullScreen();
  seed = random(1000);
  
  colors = new ArrayList<Integer>();
  colors.add(WATER);
  colors.add(GRASS);
  colors.add(SAND);
  colors.add(CORAL);
  colors.add(STONE);
  colors.add(CACTUS);
  colors.add(SHALLOW_WATER);
  colors.add(TREE);
  
  chunks = new HashMap<String, Chunk>();
  map = new Map();
  
  previousMouse = new PVector(mouseX, mouseY);
  
  map.display();
}



void mouseWheel(MouseEvent event) {
  float scroll = event.getCount()/10.0;
  if (zoom+scroll > .2 && zoom+scroll < 1.8) zoom += scroll;
}


void mousePressed(){
   previousMouse = new PVector(mouseX, mouseY);
}

void draw() {
  if(mousePressed){
    map.drag((previousMouse.x-mouseX)/10.0, (previousMouse.y-mouseY)/10.0);
    map.display();
  }
  
  fill(255);
  text(frameRate, width-20, 20);
}
