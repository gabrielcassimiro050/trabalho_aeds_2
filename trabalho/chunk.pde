class Chunk {
  // ...
  int chunkX, chunkY;
  Tile[][] tiles;


  Chunk(int x, int y) {
    chunkX = x;
    chunkY = y;
    tiles = new Tile[chunkSize/tileSize][chunkSize/tileSize];
  }

  void generateChunk() {
    tiles = new Tile[chunkSize/tileSize][chunkSize/tileSize];

    for (int x = 0; x < chunkSize / tileSize; x++) {
      for (int y = 0; y < chunkSize / tileSize; y++) {
        float noise = noise((chunkX * chunkSize + x * tileSize + 10000) * noiseScale, (chunkY * chunkSize + y * tileSize + 10000) * noiseScale, seed);
        tiles[x][y] = new Tile(x, y);

        if (noise < currentConfig.water) {
          tiles[x][y].id = WATER; // água
        } else if (noise < currentConfig.shallow_water) {
          tiles[x][y].id = SHALLOW_WATER; // água rasa
        } else if (noise < currentConfig.sand) {
          tiles[x][y].id = SAND; // areia
        } else if (noise < currentConfig.grass) {
          tiles[x][y].id = GRASS; // grama
        } else {
          tiles[x][y].id = SAND; // areia
        }

        // Adicionar obstáculos

        switch(tiles[x][y].id) {
        case 0:
          if (random(1) < .01) tiles[x][y].id = CORAL;
          break;
        case 1:
          if (random(1) < .03) tiles[x][y].id = random(1) < .85 ? TREE : STONE;
          break;
        case 2:
          if (random(1) < .01) tiles[x][y].id = random(1) < .3 ? STONE : CACTUS;
          break;
        }
      }
    }


    //for (int x = 0; x < chunkSize / tileSize; x++) {
    //  for (int y = 0; y < chunkSize / tileSize; y++) {
    //    int noise = round(noise((chunkX * chunkSize + x * tileSize + 10000) * noiseScale, (chunkY * chunkSize + y * tileSize + 10000) * noiseScale, treeSeed));
    //    if(tiles[x][y].id == 1) tiles[x][y].id = noise==0 ? GRASS : TREE;
    //  }
    //}
  }

  int getTile(int localX, int localY) {
    if (localX >= 0 && localX < tiles.length && localY >= 0 && localY < tiles[0].length) {
      return tiles[localX][localY].id;
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
        fill(colors.get(tiles[x][y].id));
        rect(screenX, screenY, tileSize+1, tileSize+1);
      }
    }
  }

  // ...
}
