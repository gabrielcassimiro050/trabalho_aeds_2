class Map {
  // ...


  void drag(float _offsetX, float _offsetY) {
    offsetX += _offsetX;
    offsetY += _offsetY;
  }

  int gridPosX(float xScreen) {
    return floor((-offsetX + xScreen) / tileSize);
  }

  int gridPosY(float yScreen) {
    return floor((-offsetY + yScreen) / tileSize);
  }

  int screenPosX(int gridX) {
    return (gridX * tileSize + (int)offsetX) + tileSize/2;
  }

  int screenPosY(int gridY) {
    return (gridY * tileSize + (int)offsetY) + tileSize/2;
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

  void display(ArrayList<PVector> caminho) {
    int startX = floor(-offsetX / chunkSize) - 1;
    int startY = floor(-offsetY / chunkSize) - 1;
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
        chunk.display(offsetX, offsetY);
      }
    }
  
    // Desenhar o caminho em vermelho
    stroke(#FF0000);
    strokeWeight(2);
    for (int i = 0; i < caminho.size() - 1; i++) {
      PVector pontoAtual = caminho.get(i);
      PVector proximoPonto = caminho.get(i + 1);
  
      float screenXAtual = pontoAtual.x * tileSize + offsetX;
      float screenYAtual = pontoAtual.y * tileSize + offsetY;
      float screenXProx = proximoPonto.x * tileSize + offsetX;
      float screenYProx = proximoPonto.y * tileSize + offsetY;
  
      line(screenXAtual + tileSize / 2, screenYAtual + tileSize / 2,
           screenXProx + tileSize / 2, screenYProx + tileSize / 2);
    }
    //Ta desenhando em algum lugar longe, mas tá desenhando
  }


  // ...
}
