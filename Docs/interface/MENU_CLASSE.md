# Menu: Seleção de Classe (Configuração da Build)

O Menu classe neste projeto é inteiramente destinado à **tela de escolha tática (Classe)** antes da partida (`GAME_STATE_CLASS_SELECTION`).

## Fluxo
Assim que os jogadores definem o modo de jogo na tela inicial, são direcionados a uma tela azul escura (`background(20, 20, 40)`). O jogo não começa até que o Jogador 1 (e o Jogador 2, se não for IA) confirmem as classes desejadas usando seus botões de confirmar dedicados.

## Classes
Cada jogador pode escolher de forma independente as seguintes armas/estilos:

1. **Rastreador (Teleguiado)**
   - Tiros que saem espalhados.
   - Possui projéteis secundários passivos (`amuletoSprite`) que procuram automaticamente o alvo no raio próximo, aplicando algoritmos de "steer" (curvatura) nas balas.
2. **Destruidor (Laser)**
   - O jogador paralisa parte dos controles (movimento reduzido) e conjura um "Feixe" estático centralizado que varre do fundo até o topo.
   - O laser aplica dano a cada janela de frames, possuindo atributo base de "Perfuração" (`pierce`) ao subir de nível.

Se o modo escolhido for **Solo vs Bot**, a seleção de classe do Jogador 2 será mascarada e escolhida de forma aleatória internamente (`random(2)`).
