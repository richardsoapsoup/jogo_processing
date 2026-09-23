import processing.sound.*;

SoundFile sfxBomba;
SoundFile sfxBossMusic;
SoundFile sfxBullet;
SoundFile sfxEnemyHit;
SoundFile sfxGameMusic;
SoundFile sfxLaser;
int lastHitSoundFrame = 0;

int GAME_STATE_MENU = 0;
int GAME_STATE_PLAY = 1;
int GAME_STATE_OVER = 2;
int GAME_STATE_LEVELUP = 3;
int GAME_STATE_RESUMING = 4;
int GAME_STATE_CLASS_SELECTION = 5;
int GAME_STATE_PAUSE = 6;
int gameState = GAME_STATE_MENU;

int p1ClassSelection = 0;
int p2ClassSelection = 0;
boolean p1ClassReady = false;
boolean p2ClassReady = false;

int resumeTimer = 0;

boolean isBotMode = false;
int menuSelection = 0;
boolean debugInvincible = false;

Player p1;
Player p2;
GameManager gameManager;
String winner = "";
float bgY = 0;

int levelUpPlayerId = 0;
int levelUpTimer = 0;
int levelUpSelection = 0;
Upgrade[] currentUpgrades = new Upgrade[3];

PImage amuletoSprite;
PImage backgroundSprite;
PImage balaSprite;
PImage balaInimigaSprite;
PImage barraXPSprite;
PImage bolaXPSprite;
PImage bombaSprite;
PImage bossSprite;
PImage inimigoSprite;
PImage inimigoIntermSprite;
PImage lazerSprite;
PImage levelupSprite;
PImage menubutaoSprite;
PImage nave1Sprite;
PImage nave2Sprite;
PImage navebotSprite;

void setup() {
  size(1200, 800, P2D);
  imageMode(CENTER);
  amuletoSprite = loadImage("sprites/amuleto.png");
  backgroundSprite = loadImage("sprites/background.png");
  balaSprite = loadImage("sprites/bala.png");
  balaInimigaSprite = loadImage("sprites/balainimigabranca.png");
  barraXPSprite = loadImage("sprites/barraXP.png");
  bolaXPSprite = loadImage("sprites/bolaxp.png");
  bombaSprite = loadImage("sprites/bomba.png");
  bossSprite = loadImage("sprites/boss.png");
  inimigoSprite = loadImage("sprites/inimigo.png");
  inimigoIntermSprite = loadImage("sprites/inimigoInterm.png");
  lazerSprite = loadImage("sprites/lazer.png");
  levelupSprite = loadImage("sprites/levelup.png");
  menubutaoSprite = loadImage("sprites/menubutao.png");
  nave1Sprite = loadImage("sprites/nave1.png");
  nave2Sprite = loadImage("sprites/nave2.png");
  navebotSprite = loadImage("sprites/navebot.png");

  sfxBomba = new SoundFile(this, "sounds/bomba.mp3");
  sfxBossMusic = new SoundFile(this, "sounds/boss_music.mp3");
  sfxBossMusic.amp(0.005);
  sfxBullet = new SoundFile(this, "sounds/bullet.mp3");
  sfxEnemyHit = new SoundFile(this, "sounds/enemy_hit.mp3");
  sfxGameMusic = new SoundFile(this, "sounds/game_music.mp3");
  sfxGameMusic.amp(0.005);
  sfxLaser = new SoundFile(this, "sounds/laser.mp3");
}

void stopMusic() {
  if (sfxGameMusic.isPlaying()) sfxGameMusic.stop();
  if (sfxBossMusic.isPlaying()) sfxBossMusic.stop();
  if (sfxLaser.isPlaying()) sfxLaser.stop();
}

void resetGame() {
  p1 = new Player(1, width / 4, height - 100, color(0, 150, 255), p1ClassSelection);
  p2 = new Player(2, width * 3 / 4, height - 100, color(255, 100, 0), p2ClassSelection);
  gameManager = new GameManager();
  gameState = GAME_STATE_PLAY;

  stopMusic();
  sfxGameMusic.loop();
  sfxGameMusic.amp(0.05);
}

void draw() {
  if (gameState == GAME_STATE_MENU) {
    drawMenu();
  }
  else if (gameState == GAME_STATE_CLASS_SELECTION) {
    drawClassSelection();
  }
  else if (gameState == GAME_STATE_PLAY) {
    drawPlayState();
  }
  else if (gameState == GAME_STATE_PAUSE) {
    drawPlayState();
    drawPauseMenu();
  }
  else if (gameState == GAME_STATE_LEVELUP) {

    drawPlayState();
    drawLevelUpMenu();
    updateLevelUp();
  }
  else if (gameState == GAME_STATE_RESUMING) {
    drawPlayState();

    fill(0, 0, 0, 150);
    rect(0, 0, width, height);

    textAlign(CENTER, CENTER);
    fill(255); textSize(120);
    int secs = ceil(resumeTimer / 60.0);
    text(secs, width/2, height/2);

    resumeTimer--;
    if (resumeTimer <= 0) {
      gameState = GAME_STATE_PLAY;
    }
  }
  else if (gameState == GAME_STATE_OVER) {
    drawPlayState();
    drawGameOver();
  }
}

void drawPauseMenu() {
  fill(0, 150);
  rectMode(CORNER);
  rect(0, 0, width, height);

  fill(255); textAlign(CENTER, CENTER); textSize(40);
  text("PAUSADO", width/2, height/2 - 100);

  image(menubutaoSprite, width/2, height/2);
  image(menubutaoSprite, width/2, height/2 + 80);

  textSize(24);
  if (menuSelection == 0) fill(255, 255, 0); else fill(255);
  text("Continuar", width/2, height/2);

  if (menuSelection == 1) fill(255, 255, 0); else fill(255);
  text("Menu Principal", width/2, height/2 + 80);
}

void drawPlayState() {
  bgY += 1;
  if (bgY > height) bgY = 0;
  tint(80);
  image(backgroundSprite, width/2, bgY + height/2, width, height);
  image(backgroundSprite, width/2, bgY - height/2, width, height);
  noTint();

  p1.displayBombFlash();
  p2.displayBombFlash();

  stroke(255);
  strokeWeight(2);
  line(width / 2, 0, width / 2, height);

  if (gameState == GAME_STATE_PLAY) {
    gameManager.update();
    if (isBotMode) updateBot();
    p1.update();
    p2.update();
    checkCollisions();
    checkGameOver();
  }

  gameManager.display();
  p1.display();
  p2.display();
  drawHUD();

  boolean anyLaser = (p1 != null && p1.isFiringLaser) || (p2 != null && p2.isFiringLaser);
  if (anyLaser && !sfxLaser.isPlaying()) {
     sfxLaser.loop();
  } else if (!anyLaser && sfxLaser.isPlaying()) {
     sfxLaser.stop();
  }
}

void drawMenu() {
  bgY += 0.5;
  if (bgY > height) bgY = 0;
  tint(80);
  image(backgroundSprite, width/2, bgY + height/2, width, height);
  image(backgroundSprite, width/2, bgY - height/2, width, height);
  noTint();
  textAlign(CENTER, CENTER);

  textSize(80);
  fill(255);
  text("BULLET HELL ROGUELITE", width/2, height/3 - 50);

  textSize(32);
  if (menuSelection == 0) {
    tint(255, 255, 0); image(menubutaoSprite, width/2, height/2 + 30, 350, 80); noTint();
    fill(255, 255, 0); text("> 1v1 Multiplayer <", width/2, height/2 + 30);
    image(menubutaoSprite, width/2, height/2 + 130, 350, 80);
    fill(150); text("Solo vs Bot", width/2, height/2 + 130);
  } else {
    image(menubutaoSprite, width/2, height/2 + 30, 350, 80);
    fill(150); text("1v1 Multiplayer", width/2, height/2 + 30);
    tint(255, 255, 0); image(menubutaoSprite, width/2, height/2 + 130, 350, 80); noTint();
    fill(255, 255, 0); text("> Solo vs Bot <", width/2, height/2 + 130);
  }

  textSize(20); fill(150);
  text("Use W/S ou Cima/Baixo para selecionar. ENTER para começar.", width/2, height - 50);
}

void drawClassSelection() {
  background(20, 20, 40);
  textAlign(CENTER, CENTER);
  fill(255); textSize(40);
  text("SELECIONE SUA CLASSE", width/2, 100);

  textSize(24);
  if (p1ClassReady) fill(0, 255, 0); else fill(255);
  text("JOGADOR 1 (A/D para mudar, ESPAÇO para confirmar)", width/4, 250);
  textSize(32);
  if (p1ClassSelection == 0) tint(255, 255, 0); image(menubutaoSprite, width/4, 320, 350, 80); noTint();
  fill(p1ClassSelection == 0 ? color(255, 255, 0) : 150); text("1. Rastreador (Teleguiado)", width/4, 320);
  if (p1ClassSelection == 1) tint(255, 255, 0); image(menubutaoSprite, width/4, 420, 350, 80); noTint();
  fill(p1ClassSelection == 1 ? color(255, 255, 0) : 150); text("2. Destruidor (Laser)", width/4, 420);

  if (!isBotMode) {
    textSize(24);
    if (p2ClassReady) fill(0, 255, 0); else fill(255);
    text("JOGADOR 2 (Setas para mudar, ENTER para confirmar)", width*3/4, 250);
    textSize(32);
    if (p2ClassSelection == 0) tint(255, 255, 0); image(menubutaoSprite, width*3/4, 320, 350, 80); noTint();
    fill(p2ClassSelection == 0 ? color(255, 255, 0) : 150); text("1. Rastreador (Teleguiado)", width*3/4, 320);
    if (p2ClassSelection == 1) tint(255, 255, 0); image(menubutaoSprite, width*3/4, 420, 350, 80); noTint();
    fill(p2ClassSelection == 1 ? color(255, 255, 0) : 150); text("2. Destruidor (Laser)", width*3/4, 420);
  } else {
    fill(150); textSize(24);
    text("JOGADOR 2 (Bot - Aleatório)", width*3/4, 250);
  }
}

void drawGameOver() {
  fill(0, 0, 0, 150);
  rect(0, 0, width, height);
  textAlign(CENTER, CENTER);
  textSize(64); fill(255); text("FIM DE JOGO", width / 2, height / 2 - 50);
  textSize(40);
  if (winner.equals("Empate")) { fill(200); text("Empate!", width / 2, height / 2 + 20); }
  else {
    if (winner.equals("Jogador 1")) fill(p1.c); else fill(p2.c);
    text(winner + " Venceu!", width / 2, height / 2 + 20);
  }
  textSize(20); fill(255);
  image(menubutaoSprite, width / 2, height / 2 + 100, 350, 80);
  text("Pressione 'R' para reiniciar a partida", width / 2, height / 2 + 100);
  image(menubutaoSprite, width / 2, height / 2 + 190, 350, 80);
  text("Pressione 'M' para voltar ao Menu", width / 2, height / 2 + 190);
}

class Upgrade {
  String name;
  String desc;
  int type;

  Upgrade(int t) {
    type = t;
    if (t == 0) { name = "Bota de Hermes"; desc = "+Velocidade de Movimento"; }
    else if (t == 1) { name = "Tiro Espalhado"; desc = "Atira +1 projétil simultâneo"; }
    else if (t == 2) { name = "Dano Concentrado"; desc = "+Dano nos seus tiros"; }
    else if (t == 3) { name = "Ímã de XP"; desc = "Puxa XP de mais longe"; }
    else if (t == 4) { name = "Bala de Borracha (Debuff)"; desc = "Balas no lado inimigo podem quicar"; }
    else if (t == 5) { name = "Bala Gigante (Debuff)"; desc = "Algumas balas no inimigo ficam enormes"; }
    else if (t == 6) { name = "Aceleração (Debuff)"; desc = "Tiros no lado inimigo são mais rápidos"; }
    else if (t == 7) { name = "Amuleto Extra"; desc = "+2 Tiros Teleguiados (Rastreador)"; }
    else if (t == 8) { name = "Laser Penetrante"; desc = "Seus lasers perfuram +1 inimigo (Destruidor)"; }
    else if (t == 9) { name = "Aceleração Espiritual"; desc = "Teleguiados mais rápidos e ágeis (Rastreador)"; }
    else if (t == 10) { name = "Feixe Alargado"; desc = "Aumenta a espessura do seu Laser (Destruidor)"; }
  }
}

void triggerLevelUp(int playerId) {
  levelUpPlayerId = playerId;
  levelUpTimer = 300;
  levelUpSelection = 1;
  gameState = GAME_STATE_LEVELUP;

  if (p1 != null) { p1.up=false; p1.down=false; p1.left=false; p1.right=false; p1.shoot=false; p1.focus=false; }
  if (p2 != null) { p2.up=false; p2.down=false; p2.left=false; p2.right=false; p2.shoot=false; p2.focus=false; }

  Player p = (playerId == 1) ? p1 : p2;
  for (int i=0; i<3; i++) {
    int uType;
    do {
      uType = (int)random(11);
    } while ((uType == 7 && p.charClass != 0) || (uType == 8 && p.charClass != 1) ||
             (uType == 9 && p.charClass != 0) || (uType == 10 && p.charClass != 1) ||
             (uType == 1 && p.charClass == 1 && p.extraShots >= 3));
    currentUpgrades[i] = new Upgrade(uType);
  }
}

void updateLevelUp() {
  levelUpTimer--;

  if (isBotMode && levelUpPlayerId == 2) {
    if (levelUpTimer < 250) {
      applyUpgrade(2, currentUpgrades[(int)random(3)]);
      gameState = GAME_STATE_RESUMING;
      resumeTimer = 180;
    }
  }

  if (levelUpTimer <= 0) {
    applyUpgrade(levelUpPlayerId, currentUpgrades[levelUpSelection]);
    gameState = GAME_STATE_RESUMING;
    resumeTimer = 180;
  }
}

void applyUpgrade(int pid, Upgrade up) {
  Player p = (pid == 1) ? p1 : p2;

  p.invincibilityTimer = max(p.invincibilityTimer, 60);

  if (up.type == 0) p.normalSpeed += 1;
  else if (up.type == 1) p.extraShots += 1;
  else if (up.type == 2) p.shotDamage += 1;
  else if (up.type == 3) p.magnetRadius += 40;
  else if (up.type == 4) p.bounceLevel += 1;
  else if (up.type == 5) p.giantLevel += 1;
  else if (up.type == 6) p.fastLevel += 1;
  else if (up.type == 7) p.homingCount += 2;
  else if (up.type == 8) p.laserPierce += 1;
  else if (up.type == 9) p.homingAgility += 1;
  else if (up.type == 10) p.laserThickness += 1;
}

void drawLevelUpMenu() {
  fill(0, 0, 0, 200);
  rect(0, 0, width, height);

  float centerX = (levelUpPlayerId == 1) ? width / 4.0 : width * 3.0 / 4.0;

  textAlign(CENTER, CENTER);
  fill(255); textSize(40);
  text("LEVEL UP!", centerX, 150);

  textSize(25);
  text("Tempo Restante: " + ceil(levelUpTimer / 60.0) + "s", centerX, 200);

  float cardWidth = 185;
  float cardSpacing = 15;
  float totalWidth = (3 * cardWidth) + (2 * cardSpacing);
  float startX = centerX - (totalWidth / 2) + (cardWidth / 2);

  for (int i=0; i<3; i++) {
    float x = startX + (i * (cardWidth + cardSpacing));
    float y = height/2 + 20;

    if (levelUpSelection == i) { tint(255, 255, 0); }

    image(levelupSprite, x, y, cardWidth, cardWidth);
    noTint();

    fill(255, 255, 100); textSize(17);
    text("REWARD", x, y - 62);

    fill(255); textSize(16);

    text(currentUpgrades[i].name, x - 80, y - 35, 160, 60);

    fill(200); textSize(14);

    text(currentUpgrades[i].desc, x - 80, y + 25, 160, 60);
  }

  fill(255); textSize(18);
  String keyConfirm = (levelUpPlayerId == 1) ? "Espaço" : "ENTER";
  text("Use Esquerda/Direita e " + keyConfirm + " para escolher", centerX, height - 100);
}

class Player {
  int id;
  float x, y;
  float radius = 14;
  float hitboxRadius = 3;
  color c;

  int charClass = 0;
  int homingCount = 2;
  int laserPierce = 0;
  int homingAgility = 1;
  int laserThickness = 1;
  boolean isFiringLaser = false;
  float[] laserEnds = new float[7];

  int lives = 3;
  int bombs = 3;
  int level = 1;
  int xp = 0;
  int xpNeeded = 5;

  int normalSpeed = 5;
  float focusSpeed = 2.5;
  int shotDelay = 8;
  int shotTimer = 0;
  int homingShotDelay = 20;
  int homingShotTimer = 0;
  int extraShots = 0;
  int shotDamage = 1;
  int magnetRadius = 60;

  int bounceLevel = 0;
  int giantLevel = 0;
  int fastLevel = 0;

  int invincibilityTimer = 0;
  int bombFlashTimer = 0;

  boolean up, down, left, right, focus, shoot;

  Player(int id, float x, float y, color c, int charClass) {
    this.id = id; this.x = x; this.y = y;
    this.c = (isBotMode && id == 2) ? color(255, 50, 50) : c;
    this.charClass = charClass;
  }

  void update() {
    float speed = focus ? focusSpeed : normalSpeed;
    if (up) y -= speed;
    if (down) y += speed;
    if (left) x -= speed;
    if (right) x += speed;

    if (id == 1) x = constrain(x, radius, width / 2 - radius);
    else x = constrain(x, width / 2 + radius, width - radius);
    y = constrain(y, radius, height - radius);

    if (invincibilityTimer > 0) invincibilityTimer--;
    if (bombFlashTimer > 0) bombFlashTimer--;
    if (shotTimer > 0) shotTimer--;
    if (homingShotTimer > 0) homingShotTimer--;

    isFiringLaser = false;
    if (shoot) {
      if (charClass == 0) {
        if (shotTimer <= 0) {
          fireBullet();
          shotTimer = shotDelay;
        }
        if (homingShotTimer <= 0) {
          fireHoming();
          homingShotTimer = homingShotDelay;
        }
      } else if (charClass == 1) {
        isFiringLaser = true;
        updateLasers();
      }
    }

    for (XPOrb orb : gameManager.orbs) {
      if (orb.owner == this.id && orb.active) {
        float d = dist(x, y, orb.x, orb.y);
        if (d < magnetRadius) {
          orb.x += (x - orb.x) * 0.1;
          orb.y += (y - orb.y) * 0.1;
        }
      }
    }
  }

  void fireBullet() {
    sfxBullet.play();
    float bSpeed = -15;

    gameManager.playerBullets.add(new PlayerBullet(x, y - radius, 0, bSpeed, shotDamage, id, 0, 0));
    for (int i=1; i<=extraShots; i++) {
      float spread = focus ? i * 0.03 : i * 0.15;
      gameManager.playerBullets.add(new PlayerBullet(x, y - radius, bSpeed * sin(-spread), bSpeed * cos(-spread), shotDamage, id, 0, 0));
      gameManager.playerBullets.add(new PlayerBullet(x, y - radius, bSpeed * sin(spread), bSpeed * cos(spread), shotDamage, id, 0, 0));
    }
  }

  void fireHoming() {
    sfxBullet.play();
    for (int i=0; i<homingCount; i++) {
      float hAngle = map(i, 0, max(1, homingCount-1), -PI/4, PI/4) - PI/2;
      float offsetX = (homingCount > 1) ? map(i, 0, homingCount-1, -15, 15) : 0;
      gameManager.playerBullets.add(new PlayerBullet(x + offsetX, y - radius, cos(hAngle)*8, sin(hAngle)*8, shotDamage, id, 1, 0));
    }
  }

  void updateLasers() {
    int baseDmg = 2 + (int)((shotDamage - 1) * 1.5);
    laserEnds[0] = calculateLaserHit(x, 10 + laserThickness * 10, laserPierce, baseDmg);
    for (int i=1; i<=min(3, extraShots); i++) {
      float spreadDist = i * 20;
      laserEnds[i*2 - 1] = calculateLaserHit(x - spreadDist, 5 + laserThickness * 8, laserPierce, baseDmg);
      laserEnds[i*2] = calculateLaserHit(x + spreadDist, 5 + laserThickness * 8, laserPierce, baseDmg);
    }
  }

  float calculateLaserHit(float lX, float lW, int pierce, int dmg) {
    ArrayList<Enemy> hitCandidates = new ArrayList<Enemy>();
    for (Enemy e : gameManager.enemies) {
      if (!e.dead && e.owner == this.id && e.y < this.y) {
        if (e.type == 2 && e.bossState == 0) continue;
        float hitSize = (e.type == 2) ? 40 : ((e.type == 1) ? 25 : 15);
        if (lX + lW/2 > e.x - hitSize && lX - lW/2 < e.x + hitSize) {
          hitCandidates.add(e);
        }
      }
    }

    for (int i=0; i<hitCandidates.size(); i++) {
      for (int j=i+1; j<hitCandidates.size(); j++) {
        if (hitCandidates.get(j).y > hitCandidates.get(i).y) {
          Enemy temp = hitCandidates.get(i);
          hitCandidates.set(i, hitCandidates.get(j));
          hitCandidates.set(j, temp);
        }
      }
    }

    int hits = 0;
    float stopY = 0;
    for (Enemy e : hitCandidates) {
      int frameInterval = max(5, 20 - (pierce * 2));
      if (gameManager.frameCounter % frameInterval == 0) e.takeDamage(dmg);
      hits++;
      if (hits > pierce) { stopY = e.y; break; }
    }
    return stopY;
  }

  void addXP(int amount) {
    xp += amount;
    if (xp >= xpNeeded) {
      xp -= xpNeeded;
      level++;
      xpNeeded = (int)(xpNeeded * 1.5);
      triggerLevelUp(id);
    }
  }

  void display() {
    if (gameState == GAME_STATE_PLAY && invincibilityTimer > 0 && (invincibilityTimer / 5) % 2 == 0) {}
    else {
      if (isBotMode && id == 2) {
        image(navebotSprite, x, y, 32, 32);
      } else if (id == 1) {
        image(nave1Sprite, x, y, 32, 32);
      } else {
        image(nave2Sprite, x, y, 32, 32);
      }
    }
    if (focus) { fill(255, 50, 50); circle(x, y, hitboxRadius * 2); }

    if (isFiringLaser) {
      imageMode(CORNER);
      float mainW = 16 + laserThickness * 16;
      float lBot = y - radius;

      float lTop = laserEnds[0];

      image(lazerSprite, x - mainW/2, lTop, mainW, lBot - lTop, 0, 13, 18, 14);

      for (int i=1; i<=min(3, extraShots); i++) {
        float spreadDist = i * 20;
        float w = 12 + laserThickness * 10;
        float lTop1 = laserEnds[i*2 - 1];
        float lTop2 = laserEnds[i*2];
        image(lazerSprite, x - spreadDist - w/2, lTop1, w, lBot - lTop1, 0, 13, 18, 14);
        image(lazerSprite, x + spreadDist - w/2, lTop2, w, lBot - lTop2, 0, 13, 18, 14);
      }
      imageMode(CENTER);
    }
  }

  void displayBombFlash() {
    if (bombFlashTimer > 0) {
      tint(255, map(bombFlashTimer, 0, 15, 0, 255));
      if (id == 1) image(bombaSprite, width/4, height/2, width/2, height);
      else image(bombaSprite, width*3/4, height/2, width/2, height);
      noTint();
    }
  }

  void hit() {
    lives--;
    invincibilityTimer = 120;
  }

  void useBomb() {
    if (bombs > 0 && bombFlashTimer == 0) {
      bombs--;
      sfxBomba.play();
      gameManager.useBombAction(id);
      invincibilityTimer = max(invincibilityTimer, 60);
      bombFlashTimer = 15;
    }
  }

  boolean isInvincible() { return debugInvincible || invincibilityTimer > 0; }
}

class PlayerBullet {
  float x, y, vx, vy;
  int damage;
  int owner;
  int type;
  int pierceRemaining = 0;
  ArrayList<Enemy> hitEnemies = new ArrayList<Enemy>();
  boolean active = true;

  PlayerBullet(float x, float y, float vx, float vy, int dmg, int owner, int type, int pierce) {
    this.x = x; this.y = y; this.vx = vx; this.vy = vy; this.damage = dmg; this.owner = owner;
    this.type = type; this.pierceRemaining = pierce;
  }

  void update() {
    if (type == 1) {
      Enemy closest = null;
      float minDist = 99999;
      for (Enemy e : gameManager.enemies) {
        if (!e.dead && e.y > 0 && e.owner == this.owner) {
          float d = dist(x, y, e.x, e.y);
          if (d < minDist) { minDist = d; closest = e; }
        }
      }
      if (closest != null) {
        int ownerAgility = (owner == 1) ? p1.homingAgility : (p2 != null ? p2.homingAgility : 1);
        float angleToEnemy = atan2(closest.y - y, closest.x - x);
        float currentAngle = atan2(vy, vx);
        float steer = min(0.85, 0.25 + (ownerAgility * 0.04));
        float diff = angleToEnemy - currentAngle;
        while(diff < -PI) diff += TWO_PI;
        while(diff > PI) diff -= TWO_PI;
        currentAngle += diff * steer;

        float currentSpeed = dist(0, 0, vx, vy);
        currentSpeed = min(12 + ownerAgility, currentSpeed + 0.5);
        vx = cos(currentAngle) * currentSpeed;
        vy = sin(currentAngle) * currentSpeed;
      }
    }
    x += vx; y += vy;
  }

  void display() {
    if (type == 0) {
      image(balaSprite, x, y, 8, 24);
    } else if (type == 1) {
      image(amuletoSprite, x, y, 16, 16);
    } else if (type == 2) {
      image(lazerSprite, x, y, 16, 32);
    }
  }

  boolean isOffScreen() {
    return (y < -20 || x < -20 || x > width + 20 || y > height ||
            (owner == 1 && x > width/2) ||
            (owner == 2 && x < width/2));
  }
}

class Enemy {
  float x, y;
  float hp;
  float maxHp;
  float speed;
  int owner;
  int type;
  int shootTimer = 0;
  int shootDelay;
  boolean dead = false;
  float baseAngle = 0;
  int bossState = 0;
  int attackPattern = 0;
  int patternTimer = 0;

  Enemy(float x, float y, float hp, int owner, int type) {
    this.x = x; this.y = y; this.owner = owner; this.type = type;

    if (type == 1) {
      this.maxHp = hp * 20 * gameManager.currentStage;
      this.speed = random(0.3, 0.6);
      this.shootDelay = 60;
    } else if (type == 2) {
      this.maxHp = hp * 200 * gameManager.currentStage;
      this.speed = 1.5;
      this.shootDelay = 30;
    } else {
      this.maxHp = hp * gameManager.currentStage;
      this.speed = random(0.5, 1.5) * (1 + (gameManager.currentStage-1)*0.2);
      this.shootDelay = (int)random(60, 120);
    }
    this.hp = this.maxHp;
    this.shootTimer = this.shootDelay;
  }

  void update() {
    if (type == 2) {
      if (bossState == 0) {
        y += speed;
        if (y >= height / 4) {
          y = height / 4;
          bossState = 1;
        }
      } else if (bossState == 1) {
        patternTimer++;
        int maxTimer = 300;
        if (gameManager.currentStage == 1 && attackPattern == 2) maxTimer = 360;

        if (gameManager.currentStage == 1 && attackPattern == 2 && patternTimer == 1) {
           gameManager.clearBullets(owner);
        }

        if (patternTimer > maxTimer) {
          patternTimer = 0;
          attackPattern = (attackPattern + 1) % 3;
          if (gameManager.currentStage == 1) {
             if (attackPattern == 0) shootDelay = 8;
             else if (attackPattern == 1) shootDelay = 40;
             else if (attackPattern == 2) shootDelay = 4;
          } else if (gameManager.currentStage == 2) {
             if (attackPattern == 0) shootDelay = 6;
             else if (attackPattern == 1) shootDelay = 6;
             else if (attackPattern == 2) shootDelay = 12;
          } else if (gameManager.currentStage == 3) {
             if (attackPattern == 0) shootDelay = 3;
             else if (attackPattern == 1) shootDelay = 15;
             else if (attackPattern == 2) shootDelay = 25;
          }
        }
        shootTimer--;
        if (shootTimer <= 0) {
          boolean pause = false;
          if (gameManager.currentStage == 1 && attackPattern == 2 && patternTimer > 300) pause = true;

          if (!pause) shoot();
          shootTimer = shootDelay;
        }
      }
    } else {
      if (gameManager.currentStage == 1) {
         y += speed;
      } else if (gameManager.currentStage == 2) {
         if (type == 0) {
            y += speed;
            x += sin(y * 0.05) * 2;
         } else if (type == 1) {
            if (y < height/3) y += speed;
         }
      } else if (gameManager.currentStage == 3) {
         if (type == 0) {
            y += speed * 2.5;
            if (y > height/2 && !dead) {
               for (int i=0; i<8; i++) {
                 float a = i * TWO_PI/8;
                 gameManager.spawnSingleBullet(x, y, cos(a)*5, sin(a)*5, color(255,100,100), owner);
               }
               takeDamage(99999);
            }
         } else if (type == 1) {
            y += speed * 0.5;
            Player p = (owner == 1) ? p1 : p2;
            if (x < p.x - 10) x += speed * 1.5;
            else if (x > p.x + 10) x -= speed * 1.5;
         }
      }

      shootTimer--;
      if (shootTimer <= 0) {
        shoot();
        shootTimer = shootDelay;
      }
    }
  }

  void shoot() {
    float dx = (owner == 1) ? p1.x - x : p2.x - x;
    float dy = (owner == 1) ? p1.y - y : p2.y - y;
    float dist = sqrt(dx*dx + dy*dy);
    float angleToPlayer = atan2(dy, dx);

    if (gameManager.currentStage == 1) {
      if (type == 0) {
        float vx = (dx / dist) * 4;
        float vy = (dy / dist) * 4;
        gameManager.spawnSingleBullet(x, y, vx, vy, color(255, 100, 100), owner);
      }
      else if (type == 1) {
        for (int i = -1; i <= 1; i++) {
          float a = angleToPlayer + i * 0.3;
          gameManager.spawnSingleBullet(x, y, cos(a)*4, sin(a)*4, color(255, 150, 0), owner);
        }
      }
      else if (type == 2) {
        if (attackPattern == 0) {
          baseAngle += 0.2;
          for (int i = 0; i < 8; i++) {
            float a = baseAngle + i * (TWO_PI / 8);
            gameManager.spawnSingleBullet(x, y, cos(a)*4, sin(a)*4, color(200, 0, 255), owner);
            float aRev = -baseAngle + i * (TWO_PI / 8);
            gameManager.spawnSingleBullet(x, y, cos(aRev)*4, sin(aRev)*4, color(255, 0, 200), owner);
          }
        } else if (attackPattern == 1) {
          int ringBullets = 45;
          for (int i = 0; i < ringBullets; i++) {
            float a = i * (TWO_PI / ringBullets) + baseAngle;
            float speedWave = 2.5 + sin(a * 6) * 1.5;
            gameManager.spawnSingleBullet(x, y, cos(a)*speedWave, sin(a)*speedWave, color(0, 255, 255), owner);
          }
          baseAngle += 0.1;
        } else if (attackPattern == 2) {
          for (int i = -4; i <= 4; i++) {
            float a = angleToPlayer + i * 0.08;
            gameManager.spawnSingleBullet(x, y, cos(a)*6.0, sin(a)*6.0, color(255, 255, 0), owner);
          }
        }
      }
    }
    else if (gameManager.currentStage == 2) {
       if (type == 0) {
         float a1 = angleToPlayer - 0.2;
         float a2 = angleToPlayer + 0.2;
         gameManager.spawnSingleBullet(x, y, cos(a1)*4, sin(a1)*4, color(255, 100, 100), owner);
         gameManager.spawnSingleBullet(x, y, cos(a2)*4, sin(a2)*4, color(255, 100, 100), owner);
       } else if (type == 1) {
         int ring = 18;
         for(int i=0; i<ring; i++){
            float a = i * TWO_PI/ring;
            gameManager.spawnSingleBullet(x, y, cos(a)*2.5, sin(a)*2.5, color(255, 150, 0), owner);
         }
       } else if (type == 2) {
         if (attackPattern == 0) {
            baseAngle += 0.15;
            for (int i=-3; i<=3; i++) {
               gameManager.spawnSingleBullet(x + i*50 + sin(baseAngle)*30, y, 0, 5.0, color(150, 255, 50), owner);
               gameManager.spawnSingleBullet(x + i*50 + cos(baseAngle)*30, y, 0, 5.0, color(50, 255, 150), owner);
            }
         } else if (attackPattern == 1) {
            for (int j=0; j<6; j++) {
               float dropX = (owner == 1) ? random(0, width/2) : random(width/2, width);
               float spd = random(4, 8);
               gameManager.spawnSingleBullet(dropX, 0, random(-1.5, 1.5), spd, color(50, 50, 255), owner);
            }
         } else if (attackPattern == 2) {
            baseAngle += 0.05;
            for (int i=0; i<4; i++) {
               float a = PI/4 + i * (PI/2) + baseAngle;
               gameManager.spawnSingleBullet(x, y, cos(a)*7, sin(a)*7, color(255, 50, 255), owner);
               float a2 = i * (PI/2) - baseAngle;
               gameManager.spawnSingleBullet(x, y, cos(a2)*7, sin(a2)*7, color(255, 50, 255), owner);
            }
         }
       }
    }
    else if (gameManager.currentStage == 3) {
       if (type == 0) {

       } else if (type == 1) {
         for(int i=-2; i<=2; i++) {
            float a = angleToPlayer + i * 0.1;
            gameManager.spawnSingleBullet(x, y, cos(a)*6, sin(a)*6, color(255, 150, 0), owner);
         }
       } else if (type == 2) {
         if (attackPattern == 0) {
            baseAngle += 0.3;
            for(int i=0; i<5; i++) {
               float a = baseAngle + i * TWO_PI/5;
               gameManager.spawnSingleBullet(x, y, cos(a)*5.5, sin(a)*5.5, color(255, 0, 0), owner);
               float a2 = -baseAngle + i * TWO_PI/5;
               gameManager.spawnSingleBullet(x, y, cos(a2)*5.5, sin(a2)*5.5, color(0, 0, 255), owner);
            }

            if (patternTimer % 20 == 0) {
               for (int j=0; j<12; j++) {
                  float ra = j * TWO_PI/12;
                  gameManager.spawnSingleBullet(x, y, cos(ra)*3.5, sin(ra)*3.5, color(255, 255, 255), owner);
               }
            }
         } else if (attackPattern == 1) {
            for(int j=0; j<3; j++) {
               float a = random(TWO_PI);
               float spd = random(4, 7);
               Bullet b = new Bullet(x, y, cos(a)*spd, sin(a)*spd, color(255, 255, 0), owner, 5, 10);
               gameManager.bullets.add(b);
            }
            gameManager.spawnSingleBullet(x, y, cos(angleToPlayer)*7, sin(angleToPlayer)*7, color(255, 50, 50), owner);
         } else if (attackPattern == 2) {
            int pts = 24;
            float r = 400;
            for(int i=0; i<pts; i++) {
               float a = i * TWO_PI/pts + baseAngle;
               float bx = x + cos(a) * r;
               float by = y + (sin(a) * r) * 0.7;
               gameManager.spawnSingleBullet(bx, by, -cos(a)*2.5, -sin(a)*2.5, color(200, 0, 200), owner);
               float aOut = a + 0.1;
               gameManager.spawnSingleBullet(x, y, cos(aOut)*3.5, sin(aOut)*3.5, color(255, 100, 200), owner);
            }
            baseAngle += 0.08;
         }
       }
    }
  }

  void takeDamage(int dmg) {
    if (!dead && (gameManager.frameCounter - lastHitSoundFrame) > 5) {
       sfxEnemyHit.play();
       lastHitSoundFrame = gameManager.frameCounter;
    }
    hp -= dmg;
    if (hp <= 0) {
      dead = true;
      int orbsToDrop = (type == 0) ? 1 : (type == 1 ? 5 : 25);
      for (int i=0; i<orbsToDrop; i++) {
        gameManager.orbs.add(new XPOrb(x + random(-20, 20), y + random(-20, 20), owner));
      }
      if (type == 2) {
        Player p = (owner == 1) ? p1 : p2;
        if (random(1) < 0.5) p.lives++;
        else p.bombs++;

      }
    }
  }

  void display() {
    if (type == 0) {
      image(inimigoSprite, x, y, 32, 32);
      fill(0); rect(x-15, y-20, 30, 4);
      fill(0, 255, 0); rect(x-15, y-20, 30 * (hp/maxHp), 4);
    } else if (type == 1) {
      image(inimigoIntermSprite, x, y, 64, 64);
      fill(0); rect(x-25, y-40, 50, 6);
      fill(0, 255, 0); rect(x-25, y-40, 50 * (hp/maxHp), 6);
    } else if (type == 2) {
      image(bossSprite, x, y, 96, 96);
      fill(0); rect(x-40, y-55, 80, 8);
      fill(0, 255, 0); rect(x-40, y-55, 80 * (hp/maxHp), 8);
    }
  }
}

class XPOrb {
  float x, y;
  int owner;
  boolean active = true;
  XPOrb(float x, float y, int owner) { this.x = x; this.y = y; this.owner = owner; }
  void update() { y += 1.5; }
  void display() { image(bolaXPSprite, x, y, 16, 16); }
}

class Bullet {
  float x, y, vx, vy;
  float radius;
  color c;
  int owner;
  int bouncesLeft;

  Bullet(float x, float y, float vx, float vy, color c, int owner, int bounces, float radius) {
    this.x = x; this.y = y; this.vx = vx; this.vy = vy; this.c = c; this.owner = owner;
    this.bouncesLeft = bounces;
    this.radius = radius;
  }

  void update() {
    x += vx; y += vy;
    if (bouncesLeft > 0) {
      if (owner == 1 && (x - radius <= 0 || x + radius >= width/2)) { vx *= -1; bouncesLeft--; }
      if (owner == 2 && (x - radius <= width/2 || x + radius >= width)) { vx *= -1; bouncesLeft--; }
    }
  }

  void display() {
    tint(c);
    image(balaInimigaSprite, x, y, radius * 2.5, radius * 2.5);
    tint(255);
    image(balaInimigaSprite, x, y, radius, radius);
    noTint();
  }

  boolean isOffScreen() {
    return (y > height + radius || x < -radius || x > width + radius ||
            (owner == 1 && x > width/2 + radius) ||
            (owner == 2 && x < width/2 - radius));
  }
}

class GameManager {
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  ArrayList<PlayerBullet> playerBullets = new ArrayList<PlayerBullet>();
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  ArrayList<XPOrb> orbs = new ArrayList<XPOrb>();
  int frameCounter = 0;
  int phase = 1;
  boolean bossActive = false;
  int currentStage = 1;

  void update() {
    frameCounter++;
    if (frameCounter % 600 == 0) phase++;

    boolean foundBoss = false;
    for (Enemy e : enemies) {
      if (e.type == 2 && !e.dead) foundBoss = true;
    }

    if (bossActive && !foundBoss) {
      currentStage = min(3, currentStage + 1);
      frameCounter = 0;
      clearAllBullets();
      if (sfxBossMusic.isPlaying()) sfxBossMusic.stop();
      if (!sfxGameMusic.isPlaying() && gameState == GAME_STATE_PLAY) {
         sfxGameMusic.loop();
         sfxGameMusic.amp(0.05);
      }
    }

    if (bossActive && frameCounter >= 7200) {
      for (Enemy e : enemies) {
        if (e.type == 2 && !e.dead) {
          e.dead = true;
          Player p = (e.owner == 1) ? p1 : p2;
          p.lives = max(0, p.lives - 1);
        }
      }

    }

    bossActive = foundBoss;

    if (frameCounter > 0 && frameCounter % 3600 == 0 && !bossActive) {
      spawnBoss();
    }

    else if (!bossActive && frameCounter % max(20, 240 - (phase*30)) == 0) {
      int highestLevel = max(p1.level, p2.level);
      float hp = 3 + (highestLevel / 5) * 3;

      int type = (random(1) < 0.1) ? 1 : 0;

      float ex = random(30, width/2 - 30);
      enemies.add(new Enemy(ex, -30, hp, 1, type));
      float ex2 = width * 3/4 + (ex - width/4);
      enemies.add(new Enemy(ex2, -30, hp, 2, type));
    }

    spawnGlobalBullets();

    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet b = bullets.get(i);
      b.update();
      if (b.isOffScreen()) bullets.remove(i);
    }

    for (int i = playerBullets.size() - 1; i >= 0; i--) {
      PlayerBullet pb = playerBullets.get(i);
      pb.update();
      if (pb.isOffScreen() || !pb.active) playerBullets.remove(i);
    }

    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      e.update();
      if (e.y > height + 50 || e.dead) enemies.remove(i);
    }

    for (int i = orbs.size() - 1; i >= 0; i--) {
      XPOrb o = orbs.get(i);
      o.update();
      if (o.y > height + 20 || !o.active) orbs.remove(i);
    }
  }

  void display() {
    for (XPOrb o : orbs) o.display();
    for (Enemy e : enemies) e.display();
    for (PlayerBullet pb : playerBullets) pb.display();
    for (Bullet b : bullets) b.display();
  }

  void spawnBoss() {
    if (bossActive) return;
    bossActive = true;
    clearAllBullets();

    if (sfxGameMusic.isPlaying()) sfxGameMusic.stop();
    if (!sfxBossMusic.isPlaying()) {
       sfxBossMusic.loop();
       sfxBossMusic.amp(0.05);
    }
    int highestLevel = max(p1.level, p2.level);
    float hp = 3 + (highestLevel / 5) * 3;
    float ex = width/4;
    enemies.add(new Enemy(ex, -50, hp, 1, 2));
    float ex2 = width * 3/4;
    enemies.add(new Enemy(ex2, -50, hp, 2, 2));
    for (Enemy e : enemies) {
      if (e.type != 2 && !e.dead) e.takeDamage(99999);
    }
  }

  void useBombAction(int ownerId) {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      if (bullets.get(i).owner == ownerId) bullets.remove(i);
    }
    for (Enemy e : enemies) {
      if (e.owner == ownerId && !e.dead) {
        if (e.type == 2) {
          if (e.bossState == 1) e.takeDamage((int)(e.maxHp / 3.0));
        } else {
          e.takeDamage(99999);
        }
      }
    }
  }

  void clearBullets(int ownerId) {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      if (bullets.get(i).owner == ownerId) bullets.remove(i);
    }
  }

  void clearAllBullets() {
    bullets.clear();
  }

  void spawnSingleBullet(float x, float y, float vx, float vy, color c, int owner) {
    Player opponent = (owner == 1) ? p2 : p1;

    int bounces = 0;
    if (opponent.bounceLevel > 0 && random(1) < min(1.0f, opponent.bounceLevel * 0.2f)) {
      bounces = opponent.bounceLevel;
    }

    float bulletRadius = 7;
    if (opponent.giantLevel > 0 && random(1) < min(1.0f, opponent.giantLevel * 0.2f)) {
      bulletRadius += opponent.giantLevel * 4.0f;
    }

    float speedMult = 1.0f;
    if (opponent.fastLevel > 0 && random(1) < min(1.0f, opponent.fastLevel * 0.2f)) {
      speedMult += opponent.fastLevel * 0.2f;
    }

    float finalVx = vx * speedMult;
    float finalVy = vy * speedMult;

    bullets.add(new Bullet(x, y, finalVx, finalVy, c, owner, bounces, bulletRadius));
  }

  void spawnGlobalBullets() {
    float bSpeed = 3 + (phase * 0.3);

    if (phase >= 2 && frameCounter % 40 == 0) {
      float angle = map(sin(frameCounter * 0.05), -1, 1, -PI/4, PI/4);
      float x1 = width/4; float vx1 = bSpeed * sin(angle); float vy1 = bSpeed * cos(angle);
      spawnSingleBullet(x1, 0, vx1, vy1, color(255, 120, 0), 1);
      spawnSingleBullet(width * 3/4 + (x1 - width/4), 0, vx1, vy1, color(255, 120, 0), 2);
    }
  }
}

void checkCollisions() {

  for (XPOrb o : gameManager.orbs) {
    if (!o.active) continue;
    Player p = (o.owner == 1) ? p1 : p2;
    if (dist(o.x, o.y, p.x, p.y) < p.radius + 10) {
      o.active = false;
      p.addXP(1);
    }
  }

  for (PlayerBullet pb : gameManager.playerBullets) {
    if (!pb.active) continue;
    for (Enemy e : gameManager.enemies) {
      if (!e.dead && pb.owner == e.owner) {
        if (e.type == 2 && e.bossState == 0) continue;

        float hitSize = (e.type == 2) ? 40 : ((e.type == 1) ? 25 : 15);
        if (pb.x > e.x-hitSize && pb.x < e.x+hitSize && pb.y > e.y-hitSize && pb.y < e.y+hitSize) {
          if (pb.type == 2) {
             if (!pb.hitEnemies.contains(e)) {
                pb.hitEnemies.add(e);
                e.takeDamage(pb.damage);
                pb.pierceRemaining--;
                if (pb.pierceRemaining < 0) { pb.active = false; break; }
             }
          } else {
             e.takeDamage(pb.damage);
             pb.active = false;
             break;
          }
        }
      }
    }
  }

  for (int i = gameManager.bullets.size() - 1; i >= 0; i--) {
    Bullet b = gameManager.bullets.get(i);
    Player p = (b.owner == 1) ? p1 : p2;
    if (!p.isInvincible() && dist(b.x, b.y, p.x, p.y) < b.radius + p.hitboxRadius) {
      p.hit();
      gameManager.bullets.remove(i);
    }
  }

  for (Enemy e : gameManager.enemies) {
    if (e.type == 2 && e.bossState == 0) continue;

    Player p = (e.owner == 1) ? p1 : p2;
    float hitSize = (e.type == 2) ? 40 : ((e.type == 1) ? 25 : 15);

    if (!p.isInvincible() && !e.dead && dist(e.x, e.y, p.x, p.y) < p.radius + hitSize) {
      p.hit();
      if (e.type != 2) e.takeDamage(9999);
    }
  }
}

void drawHUD() {

  textAlign(LEFT, TOP); fill(p1.c); textSize(20);
  text("P1 Vidas: " + p1.lives + " | Bombas: " + p1.bombs + " | Lvl: " + p1.level, 20, 20);

  imageMode(CORNER);
  float xpW1 = 100 * ((float)p1.xp / p1.xpNeeded);
  if (xpW1 > 0) image(barraXPSprite, 20, 45, xpW1, 10);
  imageMode(CENTER);

  textAlign(RIGHT, TOP); fill(p2.c); textSize(20);
  text((isBotMode?"BOT":"P2") + " Vidas: " + p2.lives + " | Bombas: " + p2.bombs + " | Lvl: " + p2.level, width - 20, 20);

  imageMode(CORNER);
  float xpW2 = 100 * ((float)p2.xp / p2.xpNeeded);
  if (xpW2 > 0) image(barraXPSprite, width - 120, 45, xpW2, 10);
  imageMode(CENTER);

  if (debugInvincible) {
    textAlign(CENTER, TOP); fill(255, 255, 0); textSize(20);
    text("DEBUG: INVENCÍVEL", width/2, 20);
  }

  textAlign(CENTER, TOP); fill(255); textSize(24);
  text("FASE " + gameManager.currentStage, width/2, 50);

  if (gameManager.bossActive) {
    int timeLeft = 120 - (gameManager.frameCounter / 60);
    String timeStr = "BOSS: " + nf(timeLeft / 60, 2) + ":" + nf(timeLeft % 60, 2);
    textSize(32); fill(255, 100, 100);
    text(timeStr, width/2, 80);
  } else {
    int seconds = gameManager.frameCounter / 60;
    String timeStr = nf(seconds / 60, 2) + ":" + nf(seconds % 60, 2);
    textSize(32); fill(200, 255, 200);
    text(timeStr, width/2, 80);
  }
}

void checkGameOver() {
  if (p1.lives <= 0 && p2.lives <= 0) { winner = "Empate"; gameState = GAME_STATE_OVER; stopMusic(); }
  else if (p1.lives <= 0) { winner = isBotMode ? "BOT" : "Jogador 2"; gameState = GAME_STATE_OVER; stopMusic(); }
  else if (p2.lives <= 0) { winner = "Jogador 1"; gameState = GAME_STATE_OVER; stopMusic(); }
}

void updateBot() {
  if (p2.lives <= 0 || gameState != GAME_STATE_PLAY) return;

  p2.up = false; p2.down = false; p2.left = false; p2.right = false; p2.focus = false;
  p2.shoot = true;

  Bullet closestBullet = null;
  float minDistBullet = 99999;
  for (Bullet b : gameManager.bullets) {
    if (b.owner == 2) {
      float d = dist(p2.x, p2.y, b.x, b.y);
      if (d < minDistBullet) { minDistBullet = d; closestBullet = b; }
    }
  }

  Enemy closestEnemy = null;
  float minDistEnemy = 99999;
  for (Enemy e : gameManager.enemies) {
    if (e.owner == 2) {
      float d = dist(p2.x, p2.y, e.x, e.y);
      if (d < minDistEnemy) { minDistEnemy = d; closestEnemy = e; }
    }
  }

  if (closestBullet != null && minDistBullet < 120) {
    p2.focus = true;
    if (minDistBullet < 35 && p2.bombs > 0 && !p2.isInvincible()) p2.useBomb();

    float dx = p2.x - closestBullet.x; float dy = p2.y - closestBullet.y;
    if (dx == 0 && dy == 0) { dx = random(-1,1); dy = random(-1,1); }
    if (p2.y < height / 2) dy += 1;
    if (p2.x < width/2 + 50) dx += 1;
    if (p2.x > width - 50) dx -= 1;

    if (dx > 2) p2.right = true; else if (dx < -2) p2.left = true;
    if (dy > 2) p2.down = true; else if (dy < -2) p2.up = true;
  } else {

    if (closestEnemy != null) {
      if (p2.x < closestEnemy.x - 10) p2.right = true;
      else if (p2.x > closestEnemy.x + 10) p2.left = true;

      if (p2.y < height - 100) p2.down = true;
      else if (p2.y > height - 80) p2.up = true;
    } else {
      float targetX = width * 3 / 4; float targetY = height - 100;
      if (p2.x < targetX - 5) p2.right = true; else if (p2.x > targetX + 5) p2.left = true;
      if (p2.y < targetY - 5) p2.down = true; else if (p2.y > targetY + 5) p2.up = true;
    }
  }
}

void keyPressed() {
  if (gameState == GAME_STATE_MENU) {
    if (keyCode == UP || key == 'w' || key == 'W') menuSelection = 0;
    else if (keyCode == DOWN || key == 's' || key == 'S') menuSelection = 1;
    else if (keyCode == ENTER || keyCode == RETURN || key == ' ') {
      isBotMode = (menuSelection == 1);
      p1ClassReady = false; p2ClassReady = false;
      p1ClassSelection = 0; p2ClassSelection = 0;
      gameState = GAME_STATE_CLASS_SELECTION;
    }
    return;
  }

  if (gameState == GAME_STATE_CLASS_SELECTION) {
    if (key == 'a' || key == 'A') { if (!p1ClassReady) p1ClassSelection = 0; }
    if (key == 'd' || key == 'D') { if (!p1ClassReady) p1ClassSelection = 1; }
    if (key == ' ') { p1ClassReady = true; }

    if (!isBotMode) {
      if (keyCode == LEFT) { if (!p2ClassReady) p2ClassSelection = 0; }
      if (keyCode == RIGHT) { if (!p2ClassReady) p2ClassSelection = 1; }
      if (keyCode == ENTER || keyCode == RETURN) { p2ClassReady = true; }
    }

    if (p1ClassReady && (p2ClassReady || isBotMode)) {
      if (isBotMode) p2ClassSelection = (int)random(2);
      resetGame();
    }
    return;
  }

  if (gameState == GAME_STATE_OVER) {
    if (key == 'r' || key == 'R') resetGame();
    if (key == 'm' || key == 'M') gameState = GAME_STATE_MENU;
    return;
  }

  if (gameState == GAME_STATE_LEVELUP) {
    if (levelUpPlayerId == 1) {
      if (key == 'a' || key == 'A') levelUpSelection = max(0, levelUpSelection - 1);
      else if (key == 'd' || key == 'D') levelUpSelection = min(2, levelUpSelection - -1);
      else if (key == ' ') {
        applyUpgrade(levelUpPlayerId, currentUpgrades[levelUpSelection]);
        gameState = GAME_STATE_RESUMING;
        resumeTimer = 180;
      }
    } else if (levelUpPlayerId == 2) {
      if (keyCode == LEFT) levelUpSelection = max(0, levelUpSelection - 1);
      else if (keyCode == RIGHT) levelUpSelection = min(2, levelUpSelection - -1);
      else if (keyCode == ENTER || keyCode == RETURN) {
        applyUpgrade(levelUpPlayerId, currentUpgrades[levelUpSelection]);
        gameState = GAME_STATE_RESUMING;
        resumeTimer = 180;
      }
    }
    return;
  }

  if (gameState == GAME_STATE_PAUSE) {
    if (keyCode == UP || key == 'w' || key == 'W') menuSelection = max(0, menuSelection - 1);
    else if (keyCode == DOWN || key == 's' || key == 'S') menuSelection = min(1, menuSelection + 1);
    else if (keyCode == ENTER || keyCode == RETURN || key == ' ') {
      if (menuSelection == 0) gameState = GAME_STATE_PLAY;
      else { gameState = GAME_STATE_MENU; menuSelection = 0; stopMusic(); }
    }
    else if (key == 'p' || key == 'P' || keyCode == ESC) {
      gameState = GAME_STATE_PLAY;
      key = 0;
    }
    return;
  }

  if (gameState == GAME_STATE_PLAY || gameState == GAME_STATE_RESUMING) {
    if (key == 'p' || key == 'P' || keyCode == ESC) {
      gameState = GAME_STATE_PAUSE;
      menuSelection = 0;
      key = 0;
      return;
    }
  }

  if (key == 'w' || key == 'W') p1.up = true;
  if (key == 's' || key == 'S') p1.down = true;
  if (key == 'a' || key == 'A') p1.left = true;
  if (key == 'd' || key == 'D') p1.right = true;
  if (keyCode == SHIFT) p1.focus = true;
  if (key == ' ') p1.shoot = true;
  if (key == 'q' || key == 'Q') p1.useBomb();
  if (key == '0' || keyCode == 96) debugInvincible = !debugInvincible;
  if (key == '9') gameManager.spawnBoss();
  if (key == '8') { p1.xp = p1.xpNeeded; p1.addXP(0); }
  if (key == '7') { p2.xp = p2.xpNeeded; p2.addXP(0); }

  if (!isBotMode) {
    if (keyCode == UP) p2.up = true;
    if (keyCode == DOWN) p2.down = true;
    if (keyCode == LEFT) p2.left = true;
    if (keyCode == RIGHT) p2.right = true;
    if (key == '1' || keyCode == 97 || keyCode == 35) p2.focus = true;
    if (keyCode == ENTER || keyCode == RETURN) p2.shoot = true;
    if (key == '2' || keyCode == 98) p2.useBomb();
  }
}

void keyReleased() {
  if (p1 == null || p2 == null) return;
  if (gameState != GAME_STATE_PLAY && gameState != GAME_STATE_RESUMING) return;

  if (key == 'w' || key == 'W') p1.up = false;
  if (key == 's' || key == 'S') p1.down = false;
  if (key == 'a' || key == 'A') p1.left = false;
  if (key == 'd' || key == 'D') p1.right = false;
  if (keyCode == SHIFT) p1.focus = false;
  if (key == ' ') p1.shoot = false;

  if (!isBotMode) {
    if (keyCode == UP) p2.up = false;
    if (keyCode == DOWN) p2.down = false;
    if (keyCode == LEFT) p2.left = false;
    if (keyCode == RIGHT) p2.right = false;
    if (key == '1' || keyCode == 97 || keyCode == 35) p2.focus = false;
    if (keyCode == ENTER || keyCode == RETURN) p2.shoot = false;
  }
}
