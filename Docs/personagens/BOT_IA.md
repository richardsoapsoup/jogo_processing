# Inteligência Artificial (BOT)

O **BOT** no jogo (ativado ao escolher a opção `Solo vs Bot`) é uma instância herdada e adaptada da classe base do Player. Ele existe para ser um adversário formidável que reage em tempo real no mesmo espaço do P2 (![[navebot.png]]).

## A Rotina (Cérebro do Bot)
O Bot não joga scripts predefinidos; ele opera via rotinas reativas processadas por Frame na função `updateBot()` da classe Player:

### 1. Esquiva Primária (`Evasão de Área`)
O código cria um vetor de análise com raio de verificação de **150 pixels**. 
Ele varre toda a lista `bullets` iterando uma a uma. Quando percebe a primeira bala no seu raio, reverte a matemática, calcula o vetor do projétil, e manda um input artificial que vai exatamente 180 graus na direção oposta ao centro da bala para fugir.

### 2. Micro-Esquiva e Foco (`Panic Threshold 1`)
Se uma bala atravessa a área perigosa secundária de **70 pixels** do centro da sua hitbox, o código define a booleana `isFocus = true`.
O Bot virtualmente "Segura o Shift" para diminuir a sua velocidade de escape. Isso é crucial para que a IA não saia batendo em outras balas por estar fugindo muito rápido (Overshooting the safe-zone).

### 3. Sistema de Sobrevivência Imediata (`Panic Threshold 2`)
Se a bala inimiga encosta a exatos **20 pixels** (praticamente raspando na nave), o código ativa a Bomba automaticamente `useBomb()`, imitando o reflexo de desespero ("Panic Bomb") típico de grandes jogadores de Bullet Hell para salvar uma Vida.

### 4. Caça e Movimentação Base (`Alinhamento X`)
Se o radar de perigo (`closestBulletDist > 150`) constatar que o perímetro está limpo, o Bot passa para a ofensiva:
Ele percorre o vetor global `enemies`. Acha o oponente mais perto no eixo `y`, extrai seu valor `x`, e insere inputs de mover para a esquerda/direita com a intenção de cravar a sua própria coordenada `x` na do inimigo, não errando tiros atoa e triturando minions na mesma coluna.