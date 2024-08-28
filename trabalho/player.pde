import java.util.*; // Importa as classes necessárias
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

  ArrayList<PVector> aEstrela(PVector destino) {
    // Inicializa as listas de abertos e fechados
    HashMap<PVector, Float> gScore = new HashMap<>();
    HashMap<PVector, Float> hScore = new HashMap<>();
    HashMap<PVector, Float> fScore = new HashMap<>();
    HashMap<PVector, PVector> cameFrom = new HashMap<>();

    PriorityQueue<PVector> abertos = new PriorityQueue<>(new Comparator<PVector>() {
      public int compare(PVector p1, PVector p2) {
        return Float.compare(fScore.getOrDefault(p1, Float.MAX_VALUE), fScore.getOrDefault(p2, Float.MAX_VALUE));
      }
    }
    );

    HashSet<PVector> fechados = new HashSet<>();

    // Adiciona a posição inicial (centro da grid) aos abertos
    PVector inicio = new PVector(searchingArea / 2, searchingArea / 2);
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
        ArrayList<PVector> caminho = new ArrayList<>();
        while (cameFrom.containsKey(atual)) {
          caminho.add(atual);
          atual = cameFrom.get(atual);
        }
        caminho.add(inicio); // Adiciona o início ao caminho
        Collections.reverse(caminho); // Inverte o caminho para começar do início
        return caminho;
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
          
          if (vizinho.x < 0 || vizinho.x >= searchingArea || vizinho.y < 0 || vizinho.y >= searchingArea) continue;
          if (fechados.contains(vizinho)) continue;

          //PVector gridAtual = translateGridPosition(atual);
          
            float weight = map.getTileValue((int)gridVizinho.x, (int)gridVizinho.y);
          //float value = map.getTileValue((int)gridAtual.x, (int)gridAtual.y)+map.getTileValue((int)gridVizinho.x, (int)gridVizinho.y);
          float tentativeGScore = gScore.getOrDefault(atual, Float.MAX_VALUE) + dist(atual.x, atual.y, vizinho.x, vizinho.y)*weight;

          if (!abertos.contains(vizinho) || tentativeGScore < gScore.getOrDefault(vizinho, Float.MAX_VALUE)) {
            // Atualiza o caminho para o vizinho
            cameFrom.put(vizinho, atual);
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

    // Retorna uma lista vazia se não houver caminho
    return new ArrayList<>();

    // Função de distância Euclidiana (ou outra métrica apropriada)
  }
  float dist(float x1, float y1, float x2, float y2) {
    return (float) Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
  }

  PVector translateGridPosition(PVector d) {
    // Coordenadas globais no grid do mapa
    int globalX = (int)pos.x - searchingArea / 2 + (int) d.x;
    int globalY = (int)pos.y - searchingArea / 2 + (int) d.y;
    return new PVector(globalX, globalY);
  }

  PVector translateToGridPosition(PVector d) {
    // Calcula a posição local no grid do Player
    int localX = (int)d.x - (int) pos.x + searchingArea / 2;
    int localY = (int)d.y - (int) pos.y + searchingArea / 2;

    // Certifica-se de que as coordenadas estão dentro da área de busca
    localX = constrain(localX, 0, searchingArea - 1);
    localY = constrain(localY, 0, searchingArea - 1);

    return new PVector(localX, localY);
  }

  void show() {
    float screenX = pos.x * tileSize + offsetX;
    float screenY = pos.y * tileSize + offsetY;
    //stroke(0);
    //strokeWeight(1);
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
        //text(grid[x][y], screenX+tileSize/2.0, screenY+tileSize/2.0);
      }
    }
    // Desenhar o caminho em vermelho
    stroke(#FF0000);
    strokeWeight(2);
    for (int i = 0; i < caminho.size() - 1; i++) {
      //println(caminho.get(i));
      PVector pontoAtual = translateGridPosition(caminho.get(i));
      PVector proximoPonto = translateGridPosition(caminho.get(i+1));

      float screenXAtual = pontoAtual.x * tileSize + offsetX;
      float screenYAtual = pontoAtual.y * tileSize + offsetY;
      float screenXProx = proximoPonto.x * tileSize + offsetX;
      float screenYProx = proximoPonto.y * tileSize + offsetY;

      line(screenXAtual + tileSize / 2, screenYAtual + tileSize / 2,
        screenXProx + tileSize / 2, screenYProx + tileSize / 2);
    }
  }
}
