# Menu Inicial (Tela de Título)

O Menu Inicial (`GAME_STATE_MENU`) é a primeira porta de entrada. Possui um fundo animado estrelado que rola de baixo para cima indefinidamente, além do toque sonoro que se interliga caso configurado.

## Modos de Jogo Selecionáveis
No menu principal, o usuário interage via cursor para selecionar uma de duas opções de gamemode:

1. **1v1 MULTIPLAYER (Local)**
   O jogo seta as variáveis globais para requerer inputs de dois humanos no mesmo teclado. (Esquerda WASD x Direita Setas).
   
2. **SOLO vs BOT**
   Uma IA competitiva agressiva assume o controle do Jogador 2, reagindo instantaneamente a frames. Ideal para treinos.

As cores de destaque (Amarelo) saltam aos olhos do jogador quando uma opção é validada para seleção. Um texto inferior no estilo "*Pressione [ESPAÇO] para Selecionar*" serve de tutorial básico de entrada.
