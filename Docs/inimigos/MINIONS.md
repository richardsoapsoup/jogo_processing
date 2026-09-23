# Minions (Inimigos Normais)

| Atributo | Detalhe |
| -------- | ------- |
| **Sprite** | ![[inimigo.png]] |
| **HP Base** | 3 + Escalonamento de Fase/Level |
| **Drop** | 1 Orbe de XP |
| **Tipo Interno** | 0 |

## Comportamento
Os Minions são a força principal de ataque, aparecendo em grupos ao longo das fases. Eles se comportam de maneira diferente dependendo do estágio atual (Fase) do jogo:

* **Fase 1:** Realizam um mergulho vertical simples, descendo a tela enquanto atiram diretamente no jogador.
* **Fase 2:** Movimentam-se em **Zigue-Zague**, usando uma função de seno para oscilar no eixo X enquanto descem, dificultando a previsão do jogador. Ocasionalmente atiram dois tiros angulados em V.
* **Fase 3:** Assumem um comportamento **Kamikaze**, descendo em alta velocidade (2.5x). Caso não sejam destruídos antes de chegarem à metade da tela, eles explodem, atirando projéteis em 8 direções ao redor.

O objetivo principal dos Minions é atrapalhar a movimentação do jogador e servir como "bucha de canhão" para acumular XP.