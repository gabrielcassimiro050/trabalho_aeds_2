class Treasure {
  PVector pos;
  boolean visible;

  Treasure(float x, float y) {
    pos = new PVector(x, y);
    visible = true;
  }

  void show() {
    if (visible) {
      float screenX = pos.x * tileSize + offset.x;
      float screenY = pos.y * tileSize + offset.y;

      fill(0);
      PVector icon = new PVector(constrain(screenX, tileSize, width-tileSize*2), constrain(screenY, tileSize, height-tileSize*2));
      imageMode(CENTER);
      image(treasureSprite, icon.x+tileSize/2.0, icon.y+tileSize/2.0, tileSize*1.5, tileSize*1.5);

      if (screenX < 0 || screenX > width || screenY < 0 || screenY > height) {
        noFill();
        stroke(255);
        strokeWeight(3);
        ellipse(icon.x+tileSize/2.0, icon.y+tileSize/2.0, tileSize*2.0, tileSize*2.0);
      }
      // rect(icon.x, icon.y, tileSize, tileSize);
    }
  }
}
