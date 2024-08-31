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
        

        if (noise < currentConfig.water) {
          tiles[x][y] = WATER; // água
        } else if (noise < currentConfig.shallow_water) {
          tiles[x][y] = SHALLOW_WATER; // água rasa
        } else if (noise < currentConfig.sand) {
          tiles[x][y] = SAND; // areia
        } else if (noise < currentConfig.grass) {
          tiles[x][y] = GRASS; // grama
        } else {
          tiles[x][y] = SAND; // areia
        }

        // Adicionar obstáculos

        switch(tiles[x][y]) {
        case 0:
          if (random(1) < .01) tiles[x][y] = CORAL;
          break;
        case 1:
          if (random(1) < .03) tiles[x][y] = random(1) < .85 ? TREE : STONE;
          break;
        case 2:
          if (random(1) < .01) tiles[x][y] = random(1) < .3 ? STONE : CACTUS;
          break;
        }
      }
    }


    //for (int x = 0; x < chunkSize / tileSize; x++) {
    //  for (int y = 0; y < chunkSize / tileSize; y++) {
    //    int noise = round(noise((chunkX * chunkSize + x * tileSize + 10000) * noiseScale, (chunkY * chunkSize + y * tileSize + 10000) * noiseScale, treeSeed));
    //   if(tiles[x][y].id == 1) tiles[x][y].id = noise==0 ? GRASS : TREE;
    //  }
    //}
  }

  int getTile(int localX, int localY) {
    if (localX >= 0 && localX < tiles.length && localY >= 0 && localY < tiles[0].length) {
      return tiles[localX][localY];
    } else {
      return -1;
    }
  }



  void display() {
    for (int x = 0; x < chunkSize / tileSize; x++) {
      for (int y = 0; y < chunkSize / tileSize; y++) {
        float screenX = chunkX * chunkSize + x * tileSize + offset.x;
        float screenY = chunkY * chunkSize + y * tileSize + offset.y;

        if (screenX + tileSize < 0 || screenX > width || screenY + tileSize < 0 || screenY > height) {
          continue;
        }

        noStroke();
        fill(colors.get(tiles[x][y]));
        rect(screenX, screenY, tileSize+1, tileSize+1);
      }
    }
  }

  // ...
}
