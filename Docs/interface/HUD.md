# Head-Up Display (HUD)

O HUD deste jogo foca em dividir as informações de cada jogador para as bordas externas superiores da tela, mantendo o centro visual focado no tiroteio. 

As seguintes informações estão dispostas e ancoradas no HUD (Função `drawHUD`):

1. **Vidas & Bombas (Vidas: X | Bombas: Y)**
   Texto numérico mostrando os recursos de sobrevivência do jogador correspondente. Fica no topo esquerdo para o P1 e no topo direito para o P2 (ou BOT).
   
2. **Nível (Lvl: Z)**
   Mostra o poder de fogo / classe atual. Cresce conforme o jogador obtém XP.

3. **Barra de XP Dinâmica**
   Abaixo dos contadores numéricos de vida, um sprite de barra de carregamento horizontal (`barraXP.png`) preenche proporcionalmente de acordo com o cálculo de ganho do orbe de XP (`100 * (xp / xpNeeded)`).

4. **Estado da Partida (Centro Topo)**
   - **FASE:** Indica a fase atual (1, 2 ou 3).
   - **Cronômetro Neutro:** Texto com coloração neutra que conta o tempo total e os triggers para o spawn dos minions normais.
   - **Cronômetro do BOSS:** Durante o encontro, substitui o cronômetro neutro para uma fonte cor vermelha, indicando o tempo limite de 120 segundos do embate. Quando bate zero, se o boss não for morto, a partida pune o jogador (hit automático) e encerra o boss forçadamente.
