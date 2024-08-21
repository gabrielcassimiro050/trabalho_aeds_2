class Player {
  PVector pos;
  float speed;
  int[][] grid;

  Player(float x, float y) {
    pos = new PVector(x, y);
    setGrid();
  }

  void setGrid() {
    grid = new int[searchingArea][searchingArea];
    for (int x = 0; x < searchingArea; ++x) {
      for (int y = 0; y < searchingArea; ++y) {
       grid[x][y] = map.getTileValue(-searchingArea/2+x+(int)pos.x, -searchingArea/2+y+(int)pos.y);
      }
    }
  }

  void show() {
    float screenX = pos.x * tileSize + offsetX;
    float screenY = pos.y * tileSize + offsetY;

    fill(#FF0000);
    rect(screenX, screenY, tileSize, tileSize);

    for (int x =  0; x < searchingArea; ++x) {
      for (int y = 0; y < searchingArea; ++y) {
        screenX = (pos.x+x-searchingArea/2) * tileSize + offsetX;
        screenY = (pos.y+y-searchingArea/2) * tileSize + offsetY;
        stroke(#FF0000);
        strokeWeight(2);
        //fill(colors.get(grid[x][y]));
        //rect(screenX, screenY, tileSize, tileSize);
        fill(0);
        text(grid[x][y], screenX+tileSize/2.0, screenY+tileSize/2.0);
      }
    }
  }
}
