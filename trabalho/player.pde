import java.util.*; // Importa as classes necessárias
class Player {
  PVector pos, origem;
  Stack<PVector> caminho;

  int caminhoIndex;
  float velocidade, velocidadeFator = 5;
  int[][] grid;
  boolean hasBoat, flipped;
  PImage sprite;

  Player(float x, float y) {
    pos = new PVector(x, y);
    origem = new PVector(x, y);
    hasBoat = false;
    caminho = new Stack<PVector>();
    setGrid();
    velocidade = map.getTileValue((int)x, (int)y)*velocidadeFator;
    sprite = loadImage("player.png");
  }

  void setGrid() {
    grid = new int[areaDeBusca][areaDeBusca];
    origem = new PVector(pos.x, pos.y);
    for (int x = 0; x < areaDeBusca; ++x) {
      for (int y = 0; y < areaDeBusca; ++y) {
        grid[x][y] = map.getTileValue(-areaDeBusca/2+x+(int)origem.x, -areaDeBusca/2+y+(int)origem.y);
      }
    }
  }

  Stack<PVector> dijkstra(PVector destino) {
    caminhoIndex = 0;
    caminho = new Stack<PVector>();

    if (hasBoat && (obst.contains(WATER) || obst.contains(SHALLOW_WATER))) {
      obst.remove(obst.indexOf(WATER));
      obst.remove(obst.indexOf(SHALLOW_WATER));
    }


    HashMap<PVector, Float> distancias = new HashMap<>();
    HashMap<PVector, PVector> pais = new HashMap<>();

    // Inicializa as listas de abertos e fechados
    PriorityQueue<PVector> abertos = new PriorityQueue<>(new Comparator<PVector>() {
      public int compare(PVector p1, PVector p2) {
        return Float.compare(distancias.getOrDefault(p1, Float.MAX_VALUE), distancias.getOrDefault(p2, Float.MAX_VALUE));
      }
    }
    );
    HashSet<PVector> fechados = new HashSet<>();

    // Adiciona a posição inicial (centro da grid) aos abertos
    PVector inicio = new PVector(areaDeBusca / 2, areaDeBusca / 2);
    abertos.add(inicio);
    distancias.put(inicio, 0.0f);

    while (!abertos.isEmpty()) {
      // Encontra o nodo com a menor distância (PriorityQueue faz isso automaticamente)
      PVector atual = abertos.poll();

      // Se o nodo atual é o destino, reconstruir o caminho
      if (atual.equals(destino)) {
        Stack<PVector> caminhoAux = new Stack<PVector>();
        while (pais.containsKey(atual)) {
          caminhoAux.add(atual);
          atual = pais.get(atual);
        }
        caminhoAux.add(inicio); // Adiciona o início ao caminho
        Collections.reverse(caminhoAux); // Inverte o caminho para começar do início
        return caminhoAux;
      }

      // Move o nodo atual dos abertos para os fechados
      fechados.add(atual);

      // Verifica os vizinhos ortogonais (não diagonais)
      int[] dx = { -1, 1, 0, 0 };
      int[] dy = { 0, 0, -1, 1 };

      for (int k = 0; k < 4; k++) {
        PVector vizinho = new PVector(atual.x + dx[k], atual.y + dy[k]);
        PVector gridVizinho = translateGridPosition(vizinho);

        if (vizinho.x < 0 || vizinho.x >= areaDeBusca || vizinho.y < 0 || vizinho.y >= areaDeBusca) continue;
        if (fechados.contains(vizinho)) continue;

        // Verifica se o vizinho é um obstáculo
        if (isObstacle(map.getTileValue((int)gridVizinho.x, (int)gridVizinho.y))) continue;

        // Calcula o peso do vizinho
        float value = map.getTileValue((int)gridVizinho.x, (int)gridVizinho.y);
        if (value == WATER || value == SHALLOW_WATER) value = 0;

        // Calcula a distância até o vizinho
        float tentativeDistancia = distancias.getOrDefault(atual, Float.MAX_VALUE) + value;

        if (!abertos.contains(vizinho) || tentativeDistancia < distancias.getOrDefault(vizinho, Float.MAX_VALUE)) {
          // Atualiza o caminho para o vizinho
          pais.put(vizinho, atual);
          distancias.put(vizinho, tentativeDistancia);

          // Adiciona o vizinho à lista de abertos
          if (!abertos.contains(vizinho)) {
            abertos.add(vizinho);
          }
        }
      }
    }

    setGrid();
    caminhoIndex = caminho.size();
    // Retorna uma lista vazia se não houver caminho
    return new Stack<>();
  }

  Stack<PVector> aEstrela(PVector destino) {
    caminhoIndex = 0;
    caminho = new Stack<PVector>();

    if (hasBoat && (obst.contains(WATER) || obst.contains(SHALLOW_WATER))) {
      obst.remove(obst.indexOf(WATER));
      obst.remove(obst.indexOf(SHALLOW_WATER));
    }

    // Inicializa as listas de abertos e fechados
    HashMap<PVector, Float> gScore = new HashMap<>();
    HashMap<PVector, Float> hScore = new HashMap<>();
    HashMap<PVector, Float> fScore = new HashMap<>();
    HashMap<PVector, PVector> pais = new HashMap<>();

    PriorityQueue<PVector> abertos = new PriorityQueue<>(new Comparator<PVector>() {
      public int compare(PVector p1, PVector p2) {
        return Float.compare(fScore.getOrDefault(p1, Float.MAX_VALUE), fScore.getOrDefault(p2, Float.MAX_VALUE));
      }
    }
    );

    HashSet<PVector> fechados = new HashSet<>();

    // Adiciona a posição inicial (centro da grid) aos abertos
    PVector inicio = new PVector(areaDeBusca / 2, areaDeBusca / 2);
    abertos.add(inicio);

    // Mapas para armazenar os custos g, h e f


    // Inicializa os scores
    gScore.put(inicio, 0.0f);
    hScore.put(inicio, dist(inicio.x, inicio.y, destino.x, destino.y));
    fScore.put(inicio, hScore.get(inicio));

    while (!abertos.isEmpty()) {
      // Encontra o nodo com o menor fScore (PriorityQueue faz isso automaticamente)
      PVector atual = abertos.poll();

      // Se o nodo atual é o destino, reconstruir o caminho
      if (atual.equals(destino)) {
        Stack<PVector> caminhoAux = new Stack<PVector>();
        while (pais.containsKey(atual)) {
          caminhoAux.add(atual);
          atual = pais.get(atual);
        }
        caminhoAux.add(inicio); // Adiciona o início ao caminho
        Collections.reverse(caminhoAux); // Inverte o caminho para começar do início
        return caminhoAux;
      }

      // Move o nodo atual dos abertos para os fechados
      fechados.add(atual);

      // Verifica os vizinhos ortogonais (não diagonais)
      int[] dx = { -1, 1, 0, 0 };
      int[] dy = { 0, 0, -1, 1 };

      for (int k = 0; k < 4; k++) {
        PVector vizinho = new PVector(atual.x + dx[k], atual.y + dy[k]);
        PVector gridVizinho = translateGridPosition(vizinho);
        if (!isObstacle(map.getTileValue((int)gridVizinho.x, (int)gridVizinho.y))) {

          if (vizinho.x < 0 || vizinho.x >= areaDeBusca || vizinho.y < 0 || vizinho.y >= areaDeBusca) continue;
          if (fechados.contains(vizinho)) continue;

          //PVector gridAtual = translateGridPosition(atual);

          float value = map.getTileValue((int)gridVizinho.x, (int)gridVizinho.y);
          if (value==WATER || value==SHALLOW_WATER) value = 0;

          float peso = (value+gScore.get(atual))/2.0;
          float tentativeGScore = dist(atual.x, atual.y, vizinho.x, vizinho.y)*peso;

          if (!abertos.contains(vizinho) || tentativeGScore < gScore.getOrDefault(vizinho, Float.MAX_VALUE)) {
            // Atualiza o caminho para o vizinho
            pais.put(vizinho, atual);
            gScore.put(vizinho, tentativeGScore);
            hScore.put(vizinho, dist(vizinho.x, vizinho.y, destino.x, destino.y));
            fScore.put(vizinho, gScore.get(vizinho) + hScore.get(vizinho));

            // Adiciona o vizinho à lista de abertos
            if (!abertos.contains(vizinho)) {
              abertos.add(vizinho);
            }
          }
        }
      }
    }

    setGrid();
    caminhoIndex = caminho.size();
    // Retorna uma lista vazia se não houver caminho
    return new Stack<>();

    // Função de distância Euclidiana (ou outra métrica apropriada)
  }
  float dist(float x1, float y1, float x2, float y2) {
    return (float) Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
  }

  PVector translateGridPosition(PVector gridPosition) {
    // Coordenadas globais no grid do mapa
    int globalX = (int)origem.x - areaDeBusca / 2 + (int) gridPosition.x;
    int globalY = (int)origem.y - areaDeBusca / 2 + (int) gridPosition.y;
    return new PVector(globalX, globalY);
  }

  PVector translateToGridPosition(PVector mapPosition) {
    // Calcula a posição local no grid do Player
    int localX = (int)mapPosition.x - (int) origem.x + areaDeBusca / 2;
    int localY = (int)mapPosition.y - (int) origem.y + areaDeBusca / 2;

    // Certifica-se de que as coordenadas estão dentro da área de busca
    localX = constrain(localX, 0, areaDeBusca - 1);
    localY = constrain(localY, 0, areaDeBusca - 1);

    return new PVector(localX, localY);
  }

  void update() {
    if (caminhoIndex<caminho.size()) {
      PVector aux = translateGridPosition(caminho.get(caminhoIndex));
      float value = map.getTileValue((int)aux.x, (int)aux.y);
      if (value==WATER || value==SHALLOW_WATER) value = .5;

      if (pos.x-aux.x < 0) flipped = true;
      else if(pos.x-aux.x > 0)flipped = false;

      pos = aux;
      updateScreen();
      velocidade = value*velocidadeFator;
      ++caminhoIndex;
    } else {
      setGrid();
      caminhoIndex = 0;
      caminho = new Stack<PVector>();
    }
  }

  void show() {
    float screenX = pos.x * tileSize + offset.x;
    float screenY = pos.y * tileSize + offset.y;

    // Desenhar o caminho em vermelho
    stroke(#FF0000);
    strokeWeight(2);

    for (int i = 0; i < caminho.size() - 1; i++) {
      //println(caminho.get(i));
      PVector pontoAtual = translateGridPosition(caminho.get(i));
      PVector proximoPonto = translateGridPosition(caminho.get(i+1));

      float screenXAtual = pontoAtual.x * tileSize + offset.x;
      float screenYAtual = pontoAtual.y * tileSize + offset.y;
      float screenXProx = proximoPonto.x * tileSize + offset.x;
      float screenYProx = proximoPonto.y * tileSize + offset.y;

      line(screenXAtual + tileSize / 2, screenYAtual + tileSize / 2, screenXProx + tileSize / 2, screenYProx + tileSize / 2);
    }
    pushMatrix();
    translate(screenX+tileSize/2.0, screenY+tileSize/3.5);
    if (flipped) scale(-1, 1);
    else scale(1, 1);
    imageMode(CENTER);
    image(sprite, 0, 0, tileSize*2, tileSize*2);
    //rect(screenX, screenY, tileSize, tileSize);
    popMatrix();
  }
}
