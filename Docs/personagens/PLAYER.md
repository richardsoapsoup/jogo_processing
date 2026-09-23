# Player (O Controlador)

| Atributo | Detalhe Inicial |
| -------- | --------------- |
| **Sprites** | ![[nave1.png]] (P1) e ![[nave2.png]] (P2) |
| **Vidas** | 3 Corações Iniciais |
| **Bombas** | 3 Usos Iniciais |
| **Velocidade (SPD)**| `4.0` pixels por frame |

O Player é o agente de entrada que detém toda a lógica de input mapeado, movimentação em grid contínuo, cooldowns de armas e processamento de Hitbox.

## Input e Controles

O motor lê `keyPressed` e `keyReleased` via booleanas simultâneas para garantir movimentação em 8-vias (Diagonais) flúida:

**Jogador 1 (Azul / Lado Esquerdo):**
- **[W, A, S, D]:** Movimentação omnidirecional.
- **[Shift]:** Engatilha o "Modo Foco". Reduz a Speed consideravelmente (fator * 0.4) para esquiva milimétrica.
- **[Q]:** Dispara a Bomba (Limpa tela de balas inimigas e da hit massivo).

**Jogador 2 (Laranja / Lado Direito):**
- **[Setas]:** Movimentação omnidirecional.
- **[NumPad 1]:** Modo Foco.
- **[NumPad 2]:** Bomba.

O tiro básico da arma (Main Weapon) é processado no `Update()` de forma **Automática**. Enquanto o Player não estiver pausado ou morto, a nave atira baseada apenas na contagem regressiva da variável de cadência (`shootTimer` vs `shootCooldown`).