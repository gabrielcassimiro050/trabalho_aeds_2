class Map {
  // ...


  void drag(float _offsetX, float _offsetY) {
    offset.x += _offsetX;
    offset.y += _offsetY;
  }

  int gridPosX(float xScreen) {
    return floor((-offset.x + xScreen) / tileSize);
  }

  int gridPosY(float yScreen) {
    return floor((-offset.y + yScreen) / tileSize);
  }

  int screenPosX(int gridX) {
    return (gridX * tileSize + (int)offset.x) + tileSize/2;
  }

  int screenPosY(int gridY) {
    return (gridY * tileSize + (int)offset.y) + tileSize/2;
  }

  int getTileValue(int gridX, int gridY) {
    int chunkX = floor(gridX * tileSize / (float) chunkSize);
    int chunkY = floor(gridY * tileSize / (float) chunkSize);
    String key = chunkX + "," + chunkY;

    if (!chunks.containsKey(key)) {
      chunks.put(key, new Chunk(chunkX, chunkY));
      chunks.get(key).generateChunk();
    }

    Chunk chunk = (Chunk)chunks.get(key);
    int localX = gridX % (chunkSize / tileSize);
    int localY = gridY % (chunkSize / tileSize);
    return chunk.getTile(localX, localY);
  }

  void display() {
    int startX = floor(-offset.x / chunkSize) - 1;
    int startY = floor(-offset.y / chunkSize) - 1;
    int endX = startX + ceil(width / chunkSize) + 2;
    int endY = startY + ceil(height / chunkSize) + 2;
  
    for (int x = startX; x < endX+1; x++) {
      for (int y = startY; y < endY+1; y++) {
        String key = x + "," + y;
        if (!chunks.containsKey(key)) {
          chunks.put(key, new Chunk(x, y));
          chunks.get(key).generateChunk();
        }
        Chunk chunk = (Chunk)chunks.get(key);
        chunk.display();
      }
    }
  
    
    //Ta desenhando em algum lugar longe, mas tá desenhando
  }


  // ...
}
