# Sistema de Progressão e Experiência

A mecânica de RPG no jogo ocorre puramente em combate e é resetada a cada partida (padrão de jogos roguelite em arena). 

## 1. Experiência e Escalonamento
Para subir de nível (Level Up), o jogador precisa preencher a barra de XP (`xp >= xpNeeded`).
O cálculo base requer um escalonamento geométrico para não quebrar a partida no endgame:
- A cada novo Level alcançado, o limite `xpNeeded` é multiplicado por `1.5`, exigindo progressivamente que o jogador colete mais e sobreviva a inimigos mais difíceis.

## 2. A Pausa de Escolha (The Level-Up State)
Quando o orbe final encosta na Hitbox, o jogo imediatamente:
1. Altera o macro-estado para `GAME_STATE_LEVEL_UP`.
2. O sistema de colisão e rendering dos tiros pausa (as balas param no ar).
3. Uma interface de cards aparece no centro do lado daquele jogador, sorteando 3 Cartas (melhorias) usando funções estáticas de shuffle (Mistura).

### Sistema de Timer Punitivo
O jogador tem exatos **5 Segundos** (cronômetro visível `levelUpTimer`) para decidir sua melhoria.
- Isso mantém o fluxo acelerado.
- Se não apertar um dos botões (1, 2 ou 3) a tempo, o jogo escolhe automaticamente o primeiro e encerra o estado (Ou aplica um pass-through de não escolher nada).

## 3. Lista de Upgrades (Melhorias)
O sistema possui 8 melhorias distintas cadastradas (`upgrades.add()`) que podem ser roladas nos cartões:
- **Movement Speed:** (Speed++) Aumenta a mobilidade.
- **Shot Cooldown:** (AtkSpeed) Reduz em -2 os frames necessários antes de puxar o gatilho.
- **Damage:** (+Dano Bruto).
- **Magnet Radius:** O raio de sucção das orbes cresce em 40 pixels (facilita muito as próximas rodadas).
- **Class Specific 1:** (Tiro Extra/MultiShot). Adiciona novos tiros ao pente do ataque básico.
- **PvP Debuff (Balas de Borracha):** Modifica a boolean do adversário de modo que tiros normais dele agora rebatem (`bounce`) nas quinas da arena.
- **PvP Debuff (Bala Gigante):** Os tiros inimigos pro outro player duplicam de tamanho.
- **PvP Debuff (Speed Shot):** As balas normais que o inimigo tem que desviar passam a mover muito mais rápido.