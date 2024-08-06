class Chunk {
  // ...
  int chunkX, chunkY;
  int[][] tiles;


  Chunk(int x, int y) {
    chunkX = x;
    chunkY = y;
    tiles = new int[chunkSize/tileSize][chunkSize/tileSize];
  }

  void generateChunk() {
    tiles = new int[chunkSize/tileSize][chunkSize/tileSize];
    
    for (int x = 0; x < chunkSize / tileSize; x++) {
      for (int y = 0; y < chunkSize / tileSize; y++) {
        float noise = noise((chunkX * chunkSize + x * tileSize) * noiseScale, (chunkY * chunkSize + y * tileSize) * noiseScale, seed);
        if (noise < 0.3) {
          tiles[x][y] = 0; // água
        } else if (noise < 0.6) {
          tiles[x][y] = 1; // grama
        } else {
          tiles[x][y] = 2; // areia
        }

        // Adicionar obstáculos

        if (random(1) < .005) {
          if (tiles[x][y] == 0) tiles[x][y] = 3; // coral
          else if (tiles[x][y] == 1) tiles[x][y] = 4; // pedra
          else if (tiles[x][y] == 2) tiles[x][y] = 5; // cacto
        }
      }
    }
  }

  int getTile(int localX, int localY) {
    if (localX >= 0 && localX < tiles.length && localY >= 0 && localY < tiles[0].length) {
      return tiles[localX][localY];
    } else {
      return -1;
    }
  }

  int getTileValue(int gridX, int gridY) {
    int chunkX = floor(gridX * tileSize / (float) chunkSize);
    int chunkY = floor(gridY * tileSize / (float) chunkSize);
    String key = chunkX + "," + chunkY;

    if (!chunks.containsKey(key)) {
      chunks.put(key, new Chunk(chunkX, chunkY));
    }
    Chunk chunk = (Chunk)chunks.get(key);
    int localX = gridX % (chunkSize / tileSize);
    int localY = gridY % (chunkSize / tileSize);
    return chunk.getTile(localX, localY);
  }

  void display(float offsetX, float offsetY) {
    for (int x = 0; x < chunkSize / tileSize; x++) {
      for (int y = 0; y < chunkSize / tileSize; y++) {
        float screenX = chunkX * chunkSize + x * tileSize + offsetX;
        float screenY = chunkY * chunkSize + y * tileSize + offsetY;

        if (screenX + tileSize < 0 || screenX > width || screenY + tileSize < 0 || screenY > height) {
          continue;
        }
        
        noStroke();
        
        rectMode(CENTER);
        
        fill(colors.get(tiles[x][y]));
        rect(screenX, screenY, tileSize+1, tileSize+1);
       
        rectMode(CORNER);
      }
    }
  }

  // ...
}
