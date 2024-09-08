import java.util.*; // Importa as classes necessárias
class Player {
  PVector pos, origem, destino;
  Stack<PVector> caminho;

  int caminhoIndex;
  float velocidade, velocidadeFator = 5;
  int[][] grid;
  boolean hasBoat, hasMap, flipped;
  PImage sprite, boatSprite;
  int woodsGotten = 0;
  float animation = 0;

  Player(float x, float y) {
    pos = new PVector(x, y);
    destino = new PVector(x, y);
    origem = new PVector(x, y);
    hasBoat = false;
    hasMap = false;
    caminho = new Stack<PVector>();
    setGrid();
    velocidade = map.getTileValue((int)x, (int)y)*velocidadeFator;
    sprite = loadImage("player.png");
    boatSprite = loadImage("player_boat.png");
  }

  //Cria a grid para o funcionamento do aEstrela
  void setGrid() {
    grid = new int[areaDeBusca][areaDeBusca];
    origem = new PVector(pos.x, pos.y);
    for (int x = 0; x < areaDeBusca; ++x) {
      for (int y = 0; y < areaDeBusca; ++y) {
        grid[x][y] = map.getTileValue(-areaDeBusca/2+x+(int)origem.x, -areaDeBusca/2+y+(int)origem.y);
      }
    }
  }

  Stack<PVector> aEstrela(PVector destino) {
    if (hasBoat && obst.contains(WATER) && obst.contains(SHALLOW_WATER)) {
      obst.set(obst.indexOf(WATER), -1);
      obst.set(obst.indexOf(SHALLOW_WATER), -1);
    }
    caminhoIndex = 0;
    caminho = new Stack<PVector>();

    //Valor do peso
    HashMap<PVector, Float> gScore = new HashMap<>();
    //Valor da distância
    HashMap<PVector, Float> hScore = new HashMap<>();
    //Soma do peso e a distância (valor final)
    HashMap<PVector, Float> fScore = new HashMap<>();
    //Nó que leva ao outro
    HashMap<PVector, PVector> pais = new HashMap<>();

    // Inicializa as listas de abertos e fechados
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

          float vizinhoValue = map.getTileValue((int)gridVizinho.x, (int)gridVizinho.y);

          if (hasBoat && (vizinhoValue == WATER || vizinhoValue == SHALLOW_WATER)) {
            vizinhoValue = 0.5;
          }



          float tentativeGScore = dist(atual, vizinho)*vizinhoValue;

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

    int t = 0;
    for (Wood w : woods) {
      if (w!=null) {
        float d = dist(pos, w.pos);
        if (d<=0) {
          woods.set(t, null);
          updateScreen();
          ++woodsGotten;
        }
      }
      ++t;
    }

    if (dist(pos, paper.pos)<=0 && paper.visible) {
      paper.visible = false;
      hasMap = true;
    }
    
    if (dist(pos, treasure.pos)<=0 && treasure.visible) {
      treasure.visible = false;
      endGame = true;;
    }

    //if(woodsGotten==nWood-1) hasBoat = true;
    //if(hasBoat) println("ok");
    //println(woodsGotten);

    if (caminhoIndex<caminho.size()) {
      PVector aux = translateGridPosition(caminho.get(caminhoIndex));
      caminho.set(constrain(caminhoIndex-1, 0, caminho.size()), new PVector(-1, -1));
      float value = map.getTileValue((int)aux.x, (int)aux.y);
      if (value==WATER || value==SHALLOW_WATER) value = .5;

      if (pos.x-aux.x < 0) flipped = true;
      else if (pos.x-aux.x > 0)flipped = false;

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

    for (int i = 0; i < caminho.size() - 1; i++) {

      if (caminho.get(i).x >= 0 && caminho.get(i).y >= 0) {
        //println(caminho.get(i));
        PVector pontoAtual = translateGridPosition(caminho.get(i));
        PVector proximoPonto = translateGridPosition(caminho.get(i+1));

        float screenXAtual = pontoAtual.x * tileSize + offset.x;
        float screenYAtual = pontoAtual.y * tileSize + offset.y;
        float screenXProx = proximoPonto.x * tileSize + offset.x;
        float screenYProx = proximoPonto.y * tileSize + offset.y;
        stroke(100);
        strokeWeight(10);
        //line(screenXAtual + tileSize / 2, screenYAtual + tileSize / 2, screenXProx + tileSize / 2, screenYProx + tileSize / 2);

        PVector lineOffset = new PVector(tileSize/2.0, tileSize/2.0);
        stroke(#F05252);
        strokeWeight(5);
        line(screenXAtual + lineOffset.x, screenYAtual + lineOffset.y, screenXProx + lineOffset.x, screenYProx + lineOffset.y);
      }
    }


    pushMatrix();
    translate(screenX+tileSize/2.0, screenY+tileSize/10.0);
    if (flipped) scale(-1, 1);
    else scale(1, 1);
    imageMode(CENTER);

    if (map.getTileValue((int)pos.x, (int)pos.y) == SHALLOW_WATER || map.getTileValue((int)pos.x, (int)pos.y) == WATER) {
      image(boatSprite, 0, cos(animation)*2, tileSize*2, tileSize*2);
    } else {
      image(sprite, 0, cos(animation), tileSize*2, tileSize*2);
    }

    popMatrix();

    if (PVector.sub(destino, pos).mag()>0) {
      stroke(#F05252);
      strokeWeight(5);
      noFill();
      screenX = destino.x * tileSize + offset.x;
      screenY = destino.y * tileSize + offset.y;
      rect(screenX, screenY, tileSize, tileSize);
    }

    animation+=.1;
  }
}
