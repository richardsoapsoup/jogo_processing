# Menu de Pausa

Quando o jogador pressionar o botão genérico de escape mapeado no código (`P`), a mecânica principal do jogo engatilha o estado de interrupção (`GAME_STATE_PAUSE`).

## Efeitos Gráficos
Para garantir que o jogador perceba de imediato o congelamento:
- A engine aciona uma sobreposição na matriz visual inteira. O Processing gera um rect preenchido com alfa `fill(0, 0, 0, 150)`. 
- Todo o movimento, tempo (`frameCount` ignorado) e física congelam em seu frame estático perfeitamente.

## Botões e Voltas
O menu mostra duas opções cruciais no centro:
- **CONTINUAR:** Retoma as físicas de colisão de onde exatamente estavam.
- **VOLTAR AO MENU:** Aciona a quebra do Loop global e reseta o jogo para a tela de Título, limpando toda e qualquer variável que não tenha recebido `save()` no buffer, como se o jogo estivesse recém aberto.
