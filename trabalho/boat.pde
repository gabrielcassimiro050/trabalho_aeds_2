class Boat{
  PVector pos;
  
  Boat(float x, float y){
    pos = new PVector(x, y);
  }
  
  void show() {
    float screenX = pos.x * tileSize + offset.x;
    float screenY = pos.y * tileSize + offset.y;
    noStroke();
    fill(#984712);
    rect(screenX, screenY, tileSize, tileSize);
  }
}
