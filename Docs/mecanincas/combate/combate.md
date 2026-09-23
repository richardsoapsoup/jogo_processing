# Sistema de Combate

O fluxo de combate foi programado em cima de colisão por Hitbox precisa em um esquema Bullet Hell competitivo.

## Colisões e Hitboxes
Diferente da maioria dos jogos, onde a arte (o sprite da nave) serve de colisão inteira, aqui, apenas o "núcleo" visível na cor do player funciona como a colisão verdadeira.
- **Motor de Colisão:** É calculado através de distâncias radiais `dist(px, py, bx, by) < radius`.
- Permite "Raspar" balas de raspão com as "asas" das naves sem sofrer dano (Graze effect implícito).

## O Duelo e "Debuffs" Cruzados
Ao invés dos dois jogadores atirarem uns nos outros com armas, eles progridem lutando contra o PVE simultaneamente. 
A interação de embate acontece via envio passivo de mecânicas letais: **sempre que um dos dois sobe de nível (Level Up)** e pega um *Upgrade* negativo pro inimigo, ele envia esse pacote para o lado inimigo.
Exemplos de "Debuffs" programados que escalonam o combate:
- Fazer os tiros inimigos normais quicarem em 90 graus nas bordas.
- Fazer os tiros se tornarem 50% maiores ou 50% mais rápidos do outro lado da tela.

## I-Frames (Stunlock Block)
- Bater de frente com o inimigo ou tiro engatilha os Invincibility-Frames. 
- O Player perde sua Hitbox e pisca seu sprite na tela (verificado usando o booleano de frame `frameCount % 10 < 5`).
- Usar uma **Bomba** concede I-Frames adicionais ao invés de perder corações.

## Modo "FOCO"
Segurando `Shift` (ou `NumPad 1`), a nave do jogador reduz sua velocidade em **-60%**, e a cor da Hitbox dele acende brilhante. Isso é fundamental no combate de final de Boss, para ter precisão cirúrgica no zigue-zague.