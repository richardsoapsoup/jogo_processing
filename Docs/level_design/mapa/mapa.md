# Mapa e Level Design

A arquitetura do level de combate foi programada para dar foco total na mecânica PvPvE (Player vs Player vs Environment). 

## Divisão de Espaço (Split-Screen Tático)
A tela retangular (em `P2D`) é separada virtualmente ao meio (no eixo `width/2`), demarcada por uma linha reta desenhada verticalmente e iluminada no processamento final do frame. 

- O **Jogador 1** não pode cruzar o limite esquerdo. O eixo `X` dele colide e trava estritamente na fronteira central, confinamento idêntico ao de uma arena.
- O **Jogador 2 (ou BOT)** é confinado de forma espelhada na borda direita.

Essa limitação impõe as dinâmicas clássicas de *Danmaku*, obrigando os jogadores a ler as matrizes de tiro no seu lado da tela para encontrar buracos e "micro-dodge" sem cruzar a linha.

## Cenário
- **Fundo**: `background.png` que realiza uma rolagem de scroll vertical contínua usando a lógica de `bgY = (bgY + bgSpeed) % height`. Dá a noção de viagem de nave espacial.
- **Fases/Estágios**: A transição de Fases ocorre a cada queda de um "Boss". Cada Fase altera o padrão de spawn e velocidade dos inimigos base (Fase 1 = descer rápido; Fase 2 = descer em Zig-Zag; Fase 3 = Kamikaze em 8-ways). O espaço na tela e a cor de fundo não mudam, mantendo o ambiente escuro constante.