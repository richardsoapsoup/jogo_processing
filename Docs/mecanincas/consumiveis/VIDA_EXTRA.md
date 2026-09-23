# Extra "Vidas"

Em jogos tradicionais de Bullet Hell não há pacotes de vida  no chão por ser um gameplay letal e de ritmo acelerado. 

No entanto, há uma forma indireta de recuperar fôlego na partida equivalente ao consumível clássico:

## Recompensa pós-Boss
Ao invés de deixar um item de cura flutuando de maneira aleatória:
1. Quando a classe do *Boss* tem seu HP zerado (`hp <= 0`), ele gera os fragmentos (Orbes XP) normais, avança a variável de progressão de cenário (`stage++`) e faz uma checagem aleatória do tipo *coinflip*:
   - `if (random(1) > 0.5)` → **Restaura 1 Vida (Coração) ao Player que matou!**
   - Caso o `random` dê a outra face (<= 0.5) → **Concede 1 Bomba (Item de Fuga) extra!**

Esse sistema amarra as mecânicas curativas à performance no chefe, obrigando o Player a suar para conquistar a cura, em vez de esperar drops de minions fracos.
