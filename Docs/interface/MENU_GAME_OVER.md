# Tela Final: Game Over

A partida entra no estado `GAME_STATE_GAME_OVER` quando um dos seguintes critérios for atendido de modo permanente na checagem do frame:
1. Jogador 1 atinge `0` vidas.
2. Jogador 2 atinge `0` vidas (no modo 1v1 ou BOT).
3. A fase limite é concluída.

## Funcionalidades
A tela sobrepõe um banner avermelhado no centro e pausa qualquer update lógico das classes `Player`, `Enemy`, etc.

**Indicador de Vitória:**
A tela informa visualmente, através de formatações em strings de grandes tamanhos (`textAlign(CENTER, CENTER)`):
- *"JOGADOR 1 VENCEU!"* (Azul)
- *"JOGADOR 2 VENCEU!"* (Laranja)
- *"EMPATE / AMBOS PERDERAM"* (Cinza Neutro)

**Hotkeys:**
- Pressione **[R]** para fazer o reset absoluto e reviver os dois na mesma configuração.
- Pressione **[M]** para forçar o hard-reset de todas as variáveis e voltar ao state `GAME_STATE_MENU`.
