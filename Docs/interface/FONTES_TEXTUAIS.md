# Fontes Textuais e Paleta de Cores (HUD)

As decisões de fontes e textos no jogo dependem do sistema nativo do Processing. O tamanho dos textos é manipulado via `textSize()` com uma abordagem direta e limpa, para não poluir o aspecto Bullet Hell do jogo.

## Paleta de Cores e Identidade Visual
A identidade visual do texto e ícones se apoia em cores específicas criadas via `color()` para guiar a leitura do jogador no meio do caos:
- **Azul (`0, 150, 255`)**: Identidade do Jogador 1 (P1). Textos, vitórias e interface pendem a este tom.
- **Laranja (`255, 100, 0`)**: Identidade do Jogador 2 (P2). 
- **Vermelho Alerta (`255, 100, 100`)**: Usado para destacar contagens regressivas do cronômetro da batalha dos Bosses.
- **Verde/Branco**: Progresso padrão da partida.
- **Amarelo (`255, 255, 0`)**: Utilizado pesadamente nos menus (`drawMenu`, `drawClassSelection`, `drawPauseMenu`) para indicar seleção ativa, foco de cursor ou botões em destaque de texto.
