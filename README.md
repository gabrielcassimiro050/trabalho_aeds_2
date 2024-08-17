# Trabalho 2: Implementação de Player com Algoritmo de Dijkstra

## Objetivo

O objetivo deste trabalho é implementar um player que se movimenta pelo caminho mais rápido no mapa utilizando o algoritmo de Dijkstra. O player deve ser capaz de se mover por diferentes tipos de terreno (grama, areia, água) e evitar obstáculos (pedras, cactos, corais). Um barco será colocado aleatoriamente no mapa, permitindo que o player navegue na água com velocidade dobrada. A implementação do algoritmo A* para a movimentação do player será recompensada com pontos extras.

## Estrutura do Trabalho

O trabalho será realizado em grupos de 4 alunos e será avaliado em três aspectos: código, apresentação e relatório. A distribuição de pontos é a seguinte:

- **Código**: 5 pontos
- **Apresentação**: 5 pontos
- **Relatório**: 5 pontos
- **Implementação do Algoritmo A***: 1 ponto extra
- **Implementação de um objetivo para o jogo**: 1 ponto extra

## Requisitos do Trabalho

### Implementação do Player

1. **Criação da Classe `Player`**
   - Atributos: posição, velocidade, indicador de posse do barco.
   - Inicialize o player em uma posição padrão no mapa (ex.: no centro).

2. **Movimentação**
   - O player deve se mover do ponto inicial até o ponto clicado no mapa, utilizando o algoritmo de Dijkstra.
   - O player pode andar na grama e na areia, com velocidade reduzida na areia pela metade.
   - O player pode viajar na água apenas quando está de posse de um barco, com velocidade dobrada.

   **Velocidades:**
   - Grama: 1 bloco/segundo
   - Areia: 0,5 blocos/segundo
   - Água com barco: 2 blocos/segundo

3. **Obstáculos**
   - O player não pode atravessar obstáculos (pedras, cactos, corais).

### Implementação do Algoritmo de Dijkstra

1. **Algoritmo de Dijkstra**
   - Implemente o algoritmo para calcular o caminho mais curto.
   - Utilize pesos para os diferentes tipos de terreno. O peso de uma aresta é a média dos pesos dos dois vértices que formam a aresta.
   
   **Pesos:**
   - Água: 1 com barco, infinito sem barco
   - Grama: 2
   - Areia: 3

### Adicionar um Barco

1. **Colocação do Barco**
   - Coloque um barco em uma posição aleatória do mapa, não mais distante do que 100 blocos do ponto inicial do player.
   - Se o player pegar o barco, ele pode se mover na água.

### Ações no Mapa

1. **Centralização**
   - Ao apertar a tecla 'P', o mapa deve ser centralizado no player.

## Relatório

O relatório deve incluir:

1. **Introdução**
   - Descrição do problema e das funcionalidades implementadas.

2. **Implementação**
   - Descrição detalhada da implementação do algoritmo de Dijkstra e suas adaptações.
   - Explicação de como a centralização foi implementada.
   - Explicação de trechos relevantes do código.

3. **Capturas de Tela**
   - Mostrando o funcionamento do código.

4. **Reflexão**
   - Sobre os desafios encontrados e como foram superados.

## Apresentação

A apresentação deve ser feita por todos os membros do grupo, com duração de 10 minutos e deve incluir:

1. **Visão Geral**
   - Do projeto e funcionalidades implementadas.

2. **Demonstração**
   - Do código funcionando.

3. **Algoritmos**
   - Explicação do algoritmo de Dijkstra e, se implementado, do algoritmo
