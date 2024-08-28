class Boat{
  PVector pos;
  
  Boat(float x, float y){
    pos = new PVector(x, y);
  }
  
  void show() {
    float screenX = pos.x * tileSize + offsetX;
    float screenY = pos.y * tileSize + offsetY;
    noStroke();
    fill(#984712);
    rect(screenX, screenY, tileSize, tileSize);
  }
}
