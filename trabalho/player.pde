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
  
  ArrayList<PVector> aEstrela(PVector destino) {
  // Inicializa as listas de abertos e fechados
  ArrayList<PVector> abertos = new ArrayList<PVector>();
  HashSet<PVector> fechados = new HashSet<PVector>();

  // Adiciona a posição inicial (centro da grid) aos abertos
  PVector inicio = new PVector(searchingArea / 2, searchingArea / 2);
  abertos.add(inicio);

  // Mapas para armazenar os custos g, h e f
  HashMap<PVector, Float> gScore = new HashMap<PVector, Float>();
  HashMap<PVector, Float> hScore = new HashMap<PVector, Float>();
  HashMap<PVector, Float> fScore = new HashMap<PVector, Float>();
  HashMap<PVector, PVector> cameFrom = new HashMap<PVector, PVector>();

  // Inicializa os scores
  gScore.put(inicio, 0.0);
  hScore.put(inicio, dist(inicio.x, inicio.y, destino.x, destino.y));
  fScore.put(inicio, hScore.get(inicio));

  while (!abertos.isEmpty()) {
    // Encontra o nodo com o menor fScore
    PVector atual = abertos.get(0);
    for (PVector node : abertos) {
      if (fScore.getOrDefault(node, Float.MAX_VALUE) < fScore.getOrDefault(atual, Float.MAX_VALUE)) {
        atual = node;
      }
    }

    // Se o nodo atual é o destino, reconstruir o caminho
    if (atual.equals(destino)) {
      ArrayList<PVector> caminho = new ArrayList<PVector>();
      while (cameFrom.containsKey(atual)) {
        caminho.add(atual);
        atual = cameFrom.get(atual);
      }
      Collections.reverse(caminho); // Inverte o caminho para começar do início
      return caminho;
    }

    // Move o nodo atual dos abertos para os fechados
    abertos.remove(atual);
    fechados.add(atual);

    // Verifica os vizinhos
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue;

        PVector vizinho = new PVector(atual.x + i, atual.y + j);
        if (vizinho.x < 0 || vizinho.x >= searchingArea || vizinho.y < 0 || vizinho.y >= searchingArea) continue;
        if (fechados.contains(vizinho)) continue;

        float tentativeGScore = gScore.getOrDefault(atual, Float.MAX_VALUE) + dist(atual.x, atual.y, vizinho.x, vizinho.y);

        if (!abertos.contains(vizinho)) {
          abertos.add(vizinho);
        } else if (tentativeGScore >= gScore.getOrDefault(vizinho, Float.MAX_VALUE)) {
          continue;
        }

        // Este é o melhor caminho até o vizinho
        cameFrom.put(vizinho, atual);
        gScore.put(vizinho, tentativeGScore);
        hScore.put(vizinho, dist(vizinho.x, vizinho.y, destino.x, destino.y));
        fScore.put(vizinho, gScore.get(vizinho) + hScore.get(vizinho));
      }
    }
  }

  // Retorna uma lista vazia se não houver caminho
  return new ArrayList<PVector>();
}

}
