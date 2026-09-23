# Bosses (Chefões)

| Atributo | Detalhe |
| -------- | ------- |
| **Sprite** | ![[boss.png]] |
| **HP Base** | 200x a vida base por nível/fase |
| **Drop** | 25 Orbes de XP + 50% de chance de Vida (Live++) ou 50% de Bomba (Bomb++) |
| **Música** | `boss_music.mp3` |
| **Tipo Interno** | 2 |

## Evento de Boss
O Chefão é "sumonado" a cada 60 segundos de jogo (3600 frames) de forma idêntica em ambos os lados da tela (para o P1 e P2). A fase só avança quando **ambos** os chefes forem destruídos (ou caso excedam o tempo limite de 120 segundos e fujam da batalha).
Durante a entrada (descendo do topo), os bosses ficam no `bossState = 0`, estando **completamente invencíveis** para evitar ataques surpresa. Ao atingirem a altura correta, a batalha inicia.

## Padrões de Ataque (Bullet Hell)
Cada chefe possui 3 padrões de ataque rotativos. Esses padrões mudam após um determinado número de frames e se tornam mais letais dependendo da Fase (Stage):

**Fase 1:**
- Padrão A: Disparo focado circular com rotação da base do ângulo, lançando balas em sentido horário e anti-horário.
- Padrão B: Cria ondas rápidas e densas (`speedWave`) que pulsam em 360 graus de acordo com a função seno.
- Padrão C: "Shotgun" direcional. O Boss pausa os tiros por um tempo e fuzila rajadas diretamente na posição calculada do jogador.

**Fase 2:**
- Padrão A: Disparos duplos em linha reta baseados em pilares em movimento, cobrindo corredores verticais.
- Padrão B: Invoca saraivadas que "caem" aleatoriamente do topo da tela, forçando movimentação irregular do jogador.
- Padrão C: Disparos em formato de 'X' e '+' rotativos, fechando áreas transversais da arena.

**Fase 3:**
- Padrão A: Padrão em Estrela (5 pontas) duplo em alta rotação, exigindo esquivas muito finas, ocasionalmente disparando uma argola explosiva de 12 balas.
- Padrão B: Combinação de tiros erráticos (angulações e velocidades totalmente aleatórias) acompanhados de um tiro central focado de alta velocidade que pune jogadores parados.
- Padrão C: Grid elíptico ao redor do chefe. Ele spawna balísticas nas beiradas do seu espaço e atrai os tiros para si, gerando armadilhas indiretas.