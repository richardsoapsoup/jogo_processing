# A Bomba (Screen Clear)

![[bomba.png]]

A Bomba é tratada como um consumível de ativação rápida para uso defensivo e ofensivo simultâneo. Fica salva no inventário do Player, visualizada no contador numérico da HUD.

## Acionamento
- Pode ser acionada a qualquer momento pressionando a tecla 'Q' (Jogador 1) ou 'Num2' (Jogador 2).

## Efeitos de Uso
Quando acionada, ela realiza as seguintes ações no lado da tela de quem a disparou:
- Dispara um clarão branco na tela correspondente (flash frame visual).
- Zera e limpa permanentemente **100% dos projéteis inimigos** naquele exato momento (`bullets.size() = 0`).
- Inflige um dano massivo direto no chefe da fase (se houver um Boss ativo na tela).
- Liquida e mata instantaneamente todos os inimigos menores (Minions normais do Tipo 0) presentes naquele frame.
- Concede ao jogador que a acionou cerca de **2 segundos** de I-Frames (Invencibilidade) instantâneos para reposicionamento seguro.
