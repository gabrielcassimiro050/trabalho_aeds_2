class Player {
  PVector pos;
  float speed;
  
  Player(float x, float y) {
    pos = new PVector(x, y);
  }

  void show() {
    float screenX = pos.x * tileSize + offsetX;
    float screenY = pos.y * tileSize + offsetY;
    
    fill(#FF0000);
    rect(screenX, screenY, tileSize, tileSize);
  }
}
