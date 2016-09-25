//Winnie Trandinh
//Wednesday, June 6, 2016
//The program is a turn based RPG game. The player controls three characters and they
//must choose commands during their turn to defeat the enemies.


//Pseudocode
//See scratch game.

import processing.sound.*;  //imports sound library, created by processing team

//The following section is the declaration of all the global variables, 
//images, sound files, and fonts.

SoundFile title; //sound for the title and menu screen
SoundFile battle;  //sound for the battle screen
SoundFile victory;  //sound for the victory screen
SoundFile defeat;   //sound for the defeat screen
SoundFile swordSwing;  //sound effect for damage

//background image for the title screen
PImage titleScreen;    //https://i.ytimg.com/vi/Pq824AM9ZHQ/maxresdefault.jpg
//creates an array that stores three different images for the background during battle
PImage [] battleBackground = new PImage[3];
//background image for the menu screen
PImage menu;           //http://www.rpgmakervxace.net/uploads/monthly_06_2012/blogentry-496-0-08274900-1340837091.png


//the image for the black mage
PImage blackDefault;   //https://media.archonia.com/images/samples/22/18/52218_s0.jpg
//PImage blackCure;
//PImage blackDeath;
//PImage blackFire;
//PImage blackPoison;

//the image for the knight attacks
PImage knightAttack;    //http://www.game-art-hq.com/wp-content/uploads/2011/09/Final-Fantasy-Dissidia-Game-Character-Official-Artwork-Render-Cecil-Dark-Knight-2.jpg
//the image for the default knight (not attacking)
PImage knightDefault;   //http://vignette4.wikia.nocookie.net/finalfantasy/images/f/f0/Cecil_D_alt3.png/revision/latest?cb=20101218055321

//the image for the white mage
PImage whiteDefault;   //http://images3.wikia.nocookie.net/__cb20111202163450/finalfantasy/images/7/70/FFTWhiteMageFemale.png

//the image for the goblin enemy
PImage goblin;         //http://vignette3.wikia.nocookie.net/finalfantasy/images/d/d9/FFD_Goblin.png/revision/20150331202050


//the image for the bat enemy
PImage floatingEye;       //http://vignette3.wikia.nocookie.net/finalfantasy/images/1/14/Floating_Eye-enemy-ffx.png/revision/latest?cb=20130929112801


//the image for the golem boss
PImage golemBoss;      //http://asset.103.ggftw.net/wiki/to-w/images/6/6a/Golem_big.png
//the image for the fire golem
PImage fireGolem;      //http://wiki.metin2.co.uk/images/0/08/Ember_Flame_Golem.png
//the image for the ice golem
PImage iceGolem;       //http://vignette1.wikia.nocookie.net/dragonsoul/images/1/11/Ice-Golem.png/revision/latest?cb=20150708212157
//the image for the demon boss
PImage demon;          //http://vignette1.wikia.nocookie.net/unisonleague/images/2/2f/Gear-Demon_Lord_Diablos_Render.png/revision/latest?cb=20150806081429

//The following are images used in magic attacks.
PImage fire;      //used for fire attack
PImage blizzard;  //used for blizzard attack
PImage thunder;   //used for thunder attack
PImage poison;    //used for poison attack
PImage death;     //used for death attack
PImage holy;      //used for holy attack

//image used for the arrow during enemy selections
PImage arrow;      //https://openclipart.org/image/2400px/svg_to_png/154963/1313159889.png

//the three fonts used throughout the program
//These fonts only work if they are preprogrammed on the computer. Some fonts may not 
//work as a result. The most noticable change is the font for the title. It should
//be italicized. If it is not, it is likely that all the fonts do not work. As a result,
//the coordinates used for the mouseClicked funtion could be a bit off.
PFont titleFont;     //font used for the title
PFont headerFont;    //font used for sub titles
PFont normalFont;    //font used for normal text


//Two strings controlling the different game states.
//gameState is the primary state, and one of the states in the gameState is battleState
//battleState breaks down the different parts of the battle into smaller sections
String gameState = "titleScreen";
String battleState = "commands";

//keeps track of the battle number
int battleNo = 0;

//variable used for selection of the battle backgrounds (value is randomly generated
//each time a battle starts)
int battleBackgroundNumber;


//stats for characters
//first index is strength
//second index is vitality
//third index is intelligence
int [] blackStats = {3, 5, 7};
int [] whiteStats = {3, 5, 7};
int [] knightStats = {6, 5, 4};

//The available stat points, different indexes for each character.
//First index is for the knight.
//Second index is for the black mage.
//Third index is for the white mage.
int [] statPoints = {0, 0, 0};

//Array that stores the x and y coordinates of the individual characters for later use.
//Index are as followed:
// - first index is x coordinate of knight
// - second index is y coordinate of knight
// - third index is x coordinate of black mage
// - fourth index is y coordinate of black mage
// - fifth index is x coordinate of white mage
// - sixth index is y coordinate of white mage
int [] characterPositions = {335, 175, 405, 163, 369, 110};


//Three arrays that store the different status for each character.
//The first index stores the current HP, second stores the current MP, and third stores
//the current EXP.
int [] blackStatus = {blackStats[0] * 3 + blackStats[1] * 6, blackStats[2] * 5, 0};       //for the black mage
int [] whiteStatus = {whiteStats[0] * 3 + whiteStats[1] * 6, whiteStats[2] * 5, 0};       //for the white mage
int [] knightStatus = {knightStats[0] * 3 + knightStats[1] * 6, knightStats[2] * 5, 0};   //for the knight mage


//boolean that is true if one of the characters level up (EXP >= 100)
boolean levelUp = false;


//stores the amount of gold
int gold = 100;

//variable that stores the amount of enemies in the battle
int numberOfEnemies;


//Array that stores the different enemies. Indexs are as followed:
// - first index is for the first enemy
// - second index is for the second enemy
// - third index is for the third enemy
// - fourth index is for the fourth enemy
// - fifth index is for the fifth enemy
// - sixth index is for the sixth enemy
//The values represent the following:
// - 1 = goblin
// - 2 = bat
// - 3 = golem boss
// - 4 = fire golem
// - 5 = ice golem
// - 6 = demon (Xenoth)
int [] enemyTypes = new int [6];

//Arrays that store the x and y positions for enemies.
//Index are as followed:
// - first index is x coordinate of first enemy
// - second index is y coordinate of first enemy
// - third index is x coordinate of second enemy
// - fourth index is y coordinate of second enemy
// - fifth index is x coordinate of third enemy
// - sixth index is y coordinate of third enemy
// - seventh index is x coordinate of fourth enemy
// - eighth index is y coordinate of fourth enemy
// - ninth index is x coordinate of fifth enemy
// - tenth index is y coordinate of fifth enemy
// - eleventh index is x coordinate of sixth enemy
// - twelfth index is y coordinate of sixth enemy
int [] enemyPositions = {20, 157, 52, 223, 16, 293, 146, 160, 181, 233, 122, 297};        //coordinates of the image positions
int [] enemyNamePositions = {14, 424, 14, 458, 14, 492, 138, 424, 138, 458, 138, 492};    //coordinates of their names
int [] enemyStatusPositions = {9, 413, 9, 448, 9, 483, 135, 413, 135, 448, 135, 483};     //coordinates of their HP statuses

//Array that stores the HPs for each enemy. Indexes are as followed:
// - first index is the HP of the first enemy
// - second index is the HP of the second enemy
// - third index is the HP of the third enemy
// - fourth index is the HP of the fourth enemy
// - fifth index is the HP of the fifth enemy
// - sixth index is the HP of the sixth enemy
int [] enemyHP = new int [6];

//variable that stores the type of enemy attack 
int enemyAttackType;

//variable that stores the target if they use magic
int enemyMagicTarget;

//variable that counts each time the program runs for animation purposes
int drawCounter = 0;

//The string array stores the character's commands. Indexes are as followed:
// - command name for the knight
// - command name for the black mage
// - command name for the white mage
String [] commands = new String [3];

//This array stores the targets of the attacks. Indexes are as followed:
// - target for the knight
// - target for the black mage
// - target for the white mage
int [] commandTargets = new int [3];

//keeps track of which character's turn it is
int commandTurnNumber;  

//x and y increases used for animation
float xIncrease = 0;
float yIncrease = 0;

//stores the turn number of the battle
int turnNumber;


int damageDisplayTime;   //time when damage display is activated
int damage;              //the damage dealt

int attackDisplay;       //time when attack display is activated


boolean changeStateEnable = false;   //boolean to change the game state or not
int changeStateTimer;                //timer to control the above variable

//Array that stores the different display times for each enemy. Indexes are as followed:
// - timer for the first enemy
// - timer for the second enemy
// - timer for the third enemy
// - timer for the fourth enemy
// - timer for the fifth enemy
// - timer for the sixth enemy
int [] enemyMagicTargetDisplay = new int [6];

//an extra value sometimes used for commands
int extraValue = 0;




//Array that keeps track whether the skills are bought or not. False if not bought, true otherwise.
boolean [] kSkills = {false, false, false, false, false, false};   //skills for the knight
boolean [] bSkills = {false, false, false, false, false, false};   //skills for the black mage
boolean [] wSkills = {false, false, false, false, false, false};   //skills for the white mage

//The string array contains the different skills for each character.
//Each index is a different skill, and the skill name is stored in the array.
String [] kSkillNames = {"Piercing Strike", "Power Strike", "Armour Strike", 
                        "Vampiric Strike", "Berserk", "Cripple"};               //for the knight
String [] bSkillNames = {"Fire", "Fira", "Firaga", "Death", "Sleep", "Poison"}; //for the black mage
String [] wSkillNames = {"Cure", "Cura", "Curaga", "Protect", "Shell", "Holy"}; //for the white mage

//This is the explanation of each skill.
/*
Knight
Piercing Strike = physical damage that ignores opponent's defence.
Power Strike = does double normal attack damage.
Armour Strike = does damage equal to 8 times of physical defence.
Vampiric Strike = does normal physical damage but heals for damage dealt.
Berserk = doubles physical attack but halves physical defence for two turns.
Cripple = halves opponent's physical and magical defence for two turns.

Black Mage
Fire = low magical damage. 
Fira = moderate magical damage. 
Firaga = large magical damage. 
Death = 10% chance to do 999 damage, otherwise, does 0 damage.
Sleep = puts opponent to sleep for one turn, when asleep, skips their turn.
Poison = does damage over time for 3 turns. 

White Mage
Cure = heals for a small amount.
Cura = heals for a moderate amount.
Curaga = heals for a large amount.
Protect = doubles target's physical defence for three turns.
Shell = doubles target's magical defence for three turns.
Holy = does moderate magical damage.
*/



//Array that stores the different x and y positions for each skill command.
//Indexes are as followed:
// - first index is x coordinate of first skill
// - second index is y coordinate of first skill
// - third index is x coordinate of second skill
// - fourth index is y coordinate of second skill
// - fifth index is x coordinate of third skill
// - sixth index is y coordinate of third skill
// - seventh index is x coordinate of fourth skill
// - eighth index is y coordinate of fourth skill
// - ninth index is x coordinate of fifth skill
// - tenth index is y coordinate of fifth skill
// - eleventh index is x coordinate of sixth skill
// - twelfth index is y coordinate of sixth skill
int [] skillPositions = {14, 424, 14, 458, 14, 492, 138, 424, 138, 458, 138, 492};

//String that stores what the user chose, for use during shop and stat selection.
String charSelection;

//booleans to control whether the display is shown or not
boolean skillPurchased = false;     //controls skill purchased message
boolean insufficientGold = false;   //controls insufficient gold message
boolean alreadyPurchased = false;   //controls already purchased message
//timer to store the time at which it was activated
int skillPurchasedTimer = 0;        //time for skill purchased message
int insufficientGoldTimer = 0;      //time for insufficient gold message
int alreadyPurchasedTimer = 0;      //time for already purchased message


//The following arrays and booleans keep track of whether any of the characters
//or enemeis have a status effect on them.
//The different indexes represent the different enemies.
// - first index is first enemy
// - second index is second enemy
// - third index is third enemy
// - fourth index is fourth enemy
// - fifth index is fifth enemy
// - sixth index is sixth enemy
//The value of the int represents the turn number where it was inflicted
int [] crippleTimer = new int [6];
int [] sleepTimer = new int [6];
int [] poisonTimer = new int [6];

//The different indexes represent the different characters.
// - first index is knight
// - second index is black mage
// - third index is white mage
//The value of the int represents the turn number where it was inflicted
int [] protectTimer = new int [3];
int [] shellTimer = new int [3];
int [] guardTimer = new int [3];

int berserkTimer;    //turn at which berserk skill was casted

//whether the status effects are activated or not
//different indexes for each enemy
boolean [] crippleActivated = {false, false, false, false, false, false};
boolean [] sleepActivated = {false, false, false, false, false, false};
boolean [] poisonActivated = {false, false, false, false, false, false};

//different indexes for each character
boolean [] protectActivated = {false, false, false};
boolean [] shellActivated = {false, false, false};
boolean [] guardActivated = {false, false, false};

boolean berserkActivated = false;   //whether berserk is activated or not



//this is run once when the program starts
void setup() {
  size(600, 500);   //creates size of screen, 600 by 500 pixels
  
  //loads the sound files for later use
  battle = new SoundFile(this, "battle.WAV");
  defeat = new SoundFile(this, "defeat.WAV");
  swordSwing = new SoundFile(this, "SwordSwing.mp3");
  title = new SoundFile(this, "title.WAV");
  victory = new SoundFile(this, "victory.WAV");

  //the following loads all the images for later use
  titleScreen = loadImage("maxresdefault.jpg");
  battleBackground[0] = loadImage("battleBackground1.jpg");  //http://orig13.deviantart.net/ea6e/f/2011/338/c/6/battle_background_help_1_by_faria4-d4i6gca.jpg
  battleBackground[1] = loadImage("forest.png");  //https://illiaworld.files.wordpress.com/2011/12/forest.png
  battleBackground[2] = loadImage("iGLNb.png");  //http://i.imgur.com/iGLNb.png
  menu = loadImage("blogentry-496-0-08274900-1340837091.png");
  
  blackDefault = loadImage("blackDefault.png");
  
  knightAttack = loadImage("knightAttack.png");
  knightDefault = loadImage("knightDefault.png");
  
  whiteDefault = loadImage("whiteDefault.png");
  
  goblin = loadImage("goblin.png");
  
  floatingEye = loadImage("floatingEye.png");
  
  golemBoss = loadImage("golemBoss.png");
  fireGolem = loadImage("fireGolem.png");
  iceGolem = loadImage("Ice-Golem1.png");
  demon = loadImage("demon1.png");
  
  fire = loadImage("fire.png");
  blizzard = loadImage("blizzard.png");
  thunder = loadImage("thunder.png");
  poison = loadImage("poison.png");
  death = loadImage("death.png");
  holy = loadImage("holy.png");
  
  arrow = loadImage("arrow.png");
  
  titleFont = createFont("ACaslonPro-BoldItalic", 75);
  headerFont = createFont("ACaslonPro-Bold", 50);
  normalFont = createFont("ACaslonPro", 30);
  
  //plays the title music and loops
  title.loop();

}


//the function for the title screen
void titleScreen() {
  image(titleScreen, 0, 0, 600, 500);   //background image of title screen
  
  //text in the title screen
  fill(29, 72, 0);
  textFont(titleFont);
  text("Order of Xenoth", 33, 73);
  
  textFont(headerFont);
  textSize(50);
  text("Play", 226, 164);
  
  text("Instructions", 143, 244);
  
}

//function for the menu screen
void menuScreen() {
  image(menu, 0, 0, 600, 500);   //background image of the menu screen 
  
  fill(0, 0, 255);
  rect(200, 40, 225, 400);     //creates blue rectangle
  
  //text in menu screen
  fill(255);
  textSize(50);
  textFont(headerFont);
  text("Menu", 249, 96);
  
  textFont(normalFont);
  textSize(30);
  text("Next Battle", 240, 166);
  if (battleNo > 0) {   //if battle number is not 0, then show replay battle text
    text("Replay Battle", 223, 251);
  }
  text("Shop", 281, 333);
  text("Stats", 284, 406);
}


//function called during battle phase
void battlePhase() {
  image(battleBackground[battleBackgroundNumber], 0, 0, 600, 500);   //random image in array for background
  
  //two blue rectangles at bottom of screen
  fill(0, 0, 255);
  rect(0, 385, 258, 115);
  rect(262, 385, 600, 115);


}


//function that draws the enemies
void showEnemies() {
  for (int i = 0; i < numberOfEnemies * 2; i += 2) {    //repeats for each enemy
    if (enemyHP[i/2] != 0) {               //if enemy is not dead
      if (i == 4 || i == 10) {             //the position of the enemies, important since different positions have different sizes
        if (enemyTypes[i/2] == 1) {        //types of enemies to display different enemies
          image(goblin, enemyPositions[i], enemyPositions[i + 1], 85, 85);
        } else if (enemyTypes[i/2] == 2) {
          image(floatingEye, enemyPositions[i], enemyPositions[i + 1], 85, 85);
        } else if (enemyTypes[i/2] == 3) {
          image(golemBoss, enemyPositions[i], enemyPositions[i + 1], 85, 85);
        } else if (enemyTypes[i/2] == 4) {
          image(fireGolem, enemyPositions[i], enemyPositions[i + 1], 150, 150);
        } else if (enemyTypes[i/2] == 5) {
          image(iceGolem, enemyPositions[i], enemyPositions[i + 1], 150, 150);
        } else if (enemyTypes[i/2] == 6) {
          image(demon, enemyPositions[i], enemyPositions[i + 1], 85, 85);
        }
      } else if (i == 2 || i == 8) {  //see above
        if (enemyTypes[i/2] == 1) {
          image(goblin, enemyPositions[i], enemyPositions[i + 1], 80, 80);
        } else if (enemyTypes[i/2] == 2) {
          image(floatingEye, enemyPositions[i], enemyPositions[i + 1], 80, 80);
        } else if (enemyTypes[i/2] == 3) {
          image(golemBoss, enemyPositions[i], enemyPositions[i + 1], 80, 80);
        } else if (enemyTypes[i/2] == 4) {
          image(fireGolem, enemyPositions[i], enemyPositions[i + 1], 145, 145);
        } else if (enemyTypes[i/2] == 5) {
          image(iceGolem, enemyPositions[i], enemyPositions[i + 1], 145, 145);
        } else if (enemyTypes[i/2] == 6) {
          image(demon, enemyPositions[i], enemyPositions[i + 1], 80, 80);
        }
      } else {
        if (enemyTypes[i/2] == 1) {  //see above
          image(goblin, enemyPositions[i], enemyPositions[i + 1], 75, 75);
        } else if (enemyTypes[i/2] == 2) {
          image(floatingEye, enemyPositions[i], enemyPositions[i + 1], 75, 75);
        } else if (enemyTypes[i/2] == 3) {
          image(golemBoss, enemyPositions[i], enemyPositions[i + 1], 200, 200);
        } else if (enemyTypes[i/2] == 4) {
          image(fireGolem, enemyPositions[i], enemyPositions[i + 1], 140, 140);
        } else if (enemyTypes[i/2] == 5) {
          image(iceGolem, enemyPositions[i], enemyPositions[i + 1], 140, 140);
        } else if (enemyTypes[i/2] == 6) {
          image(demon, enemyPositions[i], enemyPositions[i + 1], 200, 200);
        }
        
      }
    }
  }
  
}

//function that shows the character's status
void characterStatus() {
  fill(0, 0, 255);
  rect(0, 385, 258, 115);
  rect(262, 385, 600, 115);    //creates two blue rectangles
  
  fill(255);
  textSize(15);
  //text for the character names
  text("Knight:", 276, 413);
  text("Black Mage:", 276, 448);
  text("White Mage:", 276, 483);
  
  //string that stores the different status (HP and MP) of each character
  //displays: HP: (currentHP) / (maxHP)      MP: (currentMP) / (maxMP)
  text("HP: " + knightStatus [0] + "/" + (knightStats[0] * 3 + knightStats[1] * 6) + "          " + "MP: " + knightStatus [1] + "/" + (knightStats[2] * 5), 384, 413);
  text("HP: " + blackStatus [0] + "/" + (blackStats[0] * 3 + blackStats[1] * 6) + "          " + "MP: " + blackStatus [1] + "/" + (blackStats[2] * 5), 384, 448);
  text("HP: " + whiteStatus [0] + "/" + (whiteStats[0] * 3 + whiteStats[1] * 6) + "          " + "MP: " + whiteStatus [1] + "/" + (whiteStats[2] * 5), 384, 483);
}


//fuction similar to characterStatus() but this is for the enemies
void enemyStatus() {
  textSize(12.5);
  
  for (int i = 0; i < numberOfEnemies * 2; i += 2) {     //repeats for each enemy
    if (enemyTypes[i/2] == 1) {     //checks enemyTypes array to see which text to display
      text("Goblin:  HP: " + enemyHP[i/2] + "/" + (battleNo * 10 + 5), enemyStatusPositions[i], enemyStatusPositions[i + 1]);
    } else if (enemyTypes[i/2] == 2) {
      text("Bat:       HP: " + enemyHP[i/2] + "/" + (battleNo * 10), enemyStatusPositions[i], enemyStatusPositions[i + 1]);
    } else if (enemyTypes[i/2] == 3) {
      text("Golem:  HP: " + enemyHP[i/2] + "/" + (battleNo * 40 + 10), enemyStatusPositions[i], enemyStatusPositions[i + 1]);
    } else if (enemyTypes[i/2] == 4) {
      text("FireGolem:HP: " + enemyHP[i/2] + "/" + (battleNo * 10 + 5), enemyStatusPositions[i], enemyStatusPositions[i + 1]);
    } else if (enemyTypes[i/2] == 5) {
      text("IceGolem:HP: " + enemyHP[i/2] + "/" + (battleNo * 10), enemyStatusPositions[i], enemyStatusPositions[i + 1]);
    } else if (enemyTypes[i/2] == 6) {
      text("Xenoth:    HP: " + enemyHP[i/2] + "/" + (battleNo * 80 + 20), enemyStatusPositions[i], enemyStatusPositions[i + 1]);
    } 
    
  }

}

//fuction that draws the characters
void showCharacters() {
  if (whiteStatus[0] != 0) {  //if HP of white mage is not 0, draw white mage
    image(whiteDefault, 369, 110, 110, 150);
  }
  if (blackStatus[0] != 0) {  //if HP of black mage is not 0, draw black mage
    image(blackDefault, 405, 163, 150, 150);
  }
  if (knightStatus[0] != 0) {  //if HP of knight is not 0, draw knight
    image(knightDefault, 335, 175, 225, 200);
  }
}

//function that displays the different commands for the characters 
void battleCommands() {
  
  fill(255);
  textFont(headerFont);
  textSize(40);
  if (commandTurnNumber == 1) {     //if it is the knight's turn, shows text knight
    text("Knight", 70, 421);
  } else if (commandTurnNumber == 2) {  //if it is the black mage's turn, shows text black mage
    text("Black Mage", 27, 421);
  } else if (commandTurnNumber == 3) {  //if it is the white mage's turn, shows text white mage
    text("White Mage", 24, 421);
  }
  
  //displays the different possible commands
  textFont(normalFont);
  textSize(30);
  text("Attack", 21, 457);
  text("Special", 21, 488);
  text("Guard", 153, 457);
}

//displays the different enemies for target selection
void enemySelections() {
  
  fill(255);
  textFont(normalFont);
  
  for (int i = 0; i < numberOfEnemies * 2; i += 2) {   //repeats for each enemy
    if (enemyHP[i/2] != 0) {         //if enemy's HP is not 0
      if (enemyTypes[i/2] == 1) {    //checks enemyTypes array to see which text to display
        text("Goblin", enemyNamePositions[i], enemyNamePositions[i + 1]);   //uses i value to choose value in the array
      } else if (enemyTypes[i/2] == 2) {
        text("Bat", enemyNamePositions[i], enemyNamePositions[i + 1]);
      } else if (enemyTypes[i/2] == 3 || enemyTypes[i/2] == 4 || enemyTypes[i/2] == 5) {
        text("Golem", enemyNamePositions[i], enemyNamePositions[i + 1]);
      } else if (enemyTypes[i/2] == 6) {
        text("Xenoth", enemyNamePositions[i], enemyNamePositions[i + 1]);
      }
      
    }
  }
  //Checks the mouse's x and y coordinates to see if an arrow appears over the selected enemy.
  //If the mouse is hovering over an enemy name when selecting the enemies and that 
  //enemy's HP is not equal to 0, draws an arrow over the selected enemy.
  if (mouseX < 100 && mouseX > 16 && mouseY < 423 && mouseY > 402 && enemyHP[0] != 0) {
    image(arrow, 47, 124, 20, 20);
  } else if (mouseX < 100 && mouseX > 16 && mouseY < 457 && mouseY > 437 && enemyHP[1] != 0) {
    image(arrow, 82, 194, 20, 20);
  } else if (mouseX < 100 && mouseX > 16 && mouseY < 492 && mouseY > 471 && enemyHP[2] != 0) {
    image(arrow, 36, 268, 20, 20);
  } else if (mouseX < 223 && mouseX > 139 && mouseY < 423 && mouseY > 402 && enemyHP[3] != 0) {
    image(arrow, 172, 128, 20, 20);
  } else if (mouseX < 223 && mouseX > 139 && mouseY < 457 && mouseY > 437 && enemyHP[4] != 0) {
    image(arrow, 222, 201, 20, 20);
  } else if ( mouseX < 223 && mouseX > 139 && mouseY < 492 && mouseY > 471 && enemyHP[5] != 0) {
    image(arrow, 155, 267, 20, 20);
  }
}

//function called for attack animations
void attacks() {
  
  if (whiteStatus[0] != 0) {   //draws the white mage if white mage's HP is not 0
    image(whiteDefault, 369, 110, 110, 150);
  }
  if (blackStatus[0] != 0) {   //draws the black mage if black mage's HP is not 0
    image(blackDefault, 405, 163, 150, 150);
  }
  
  //if it is the knight's turn and its commands is attack, piercing strike, power strike, 
  //armour strike, vampiric strike, or cripple
  if (commandTurnNumber == 1 && ( commands[0].equals("attack") || 
      commands[0].equals("Piercing Strike") || 
      commands[0].equals("Power Strike") || 
      commands[0].equals("Armour Strike") || 
      commands[0].equals("Vampiric Strike") || 
      commands[0].equals("Cripple") ) ) {
    
    if (drawCounter < 30) {  //if the draw counter is smaller than 30, increases xIncrease and yIncrease
      xIncrease += (enemyPositions[commandTargets [0] * 2 ] - 335) / 30.00;  //increase depends on distance from enemy
      yIncrease += (enemyPositions[commandTargets [0] * 2 + 1] + 160 - 335) / 30.00;

    } else {     //else it decreases xIncrease and yIncrease
      xIncrease -= (enemyPositions[commandTargets [0] * 2 ] - 335) / 30.00;
      yIncrease -= (enemyPositions[commandTargets [0] * 2 + 1] + 160 - 335) / 30.00;
    }
    
    //draws the knight but with the extra xIncrease and yIncrease values
    image(knightAttack, 335 + xIncrease, 175 + yIncrease, 225, 200);

    
  } else if (commandTurnNumber == 2) {  //if it is the black mage's turn
    if (commands[1].equals("attack")) {  //if command is attack
      mageAttack("black");   //calls another function with parameter of black
    } else if ( !(commands[1].equals("Guard")) ) {  //if commands is not Guard
      mageAttack(commands[1]);      //calls another function with the command name as parameter
    }
    
  } else if (commandTurnNumber == 3) {  //if it is the white mage's turn
    if (commands[2].equals("attack")) {   //if command is attack
      mageAttack("white");      //calls another function with parameter of white
    } else if (commands[2].equals("Holy")) {  //if command is Holy
      mageAttack("Holy");       //calls another function with parameter of Holy
    }
  }
  
  //if not the knight's turn and knight's HP is not 0, draws the knight
  if (commandTurnNumber != 1 && knightStatus[0] != 0) {
    image(knightDefault, 335, 175, 225, 200);
  }
}

//function that animates magic attacks
//parameter magicType controls which animation it runs
void mageAttack (String magicType) {

  //two PVectors storing x and y coordinates of the magic attack and the enemy
  PVector attackStart, enemy;  
  
  //initializes the two PVectors with values of (0, 0)
  attackStart = new PVector (0, 0);  
  enemy = new PVector (0, 0);
  
  pushMatrix();
  
  if (commandTurnNumber == 3) {  //if white mage's turn
    fill(255);    //fills object white
    translate(305, 117);   //translates the screen so that the magic attack is drawn correctly
    attackStart = new PVector (305, 117);   //PVector stores the amount it translated
    //this stores the white mage's target's coordinates into enemy PVector
    enemy = new PVector (enemyPositions[commandTargets [2] * 2 ] + 10 - 305, 
                         enemyPositions[commandTargets [2] * 2 + 1] + 120 - 117);
    //calculates distance between the two vectors, xIncrease increases by that amount
    xIncrease += -(attackStart.dist(enemy)) / 130.00; 

  } else if (commandTurnNumber == 2) {  //if black mage's turn
    fill(0);       //fills object black
    translate(329, 210);   //translates the screen so that the magic attack is drawn correctly
    attackStart = new PVector (329, 210);  //PVector stores the amount it translated
    //this stores the white mage's target's coordinates into enemy PVector
    enemy = new PVector (enemyPositions[commandTargets [1] * 2 ] + 10 - 329, 
                         enemyPositions[commandTargets [1] * 2 + 1] + 10 - 210);
    //calculates distance between the two vectors, xIncrease increases by that amount
    xIncrease += -(attackStart.dist(enemy)) / 190.00;

  }
  //stores the angle between the two points in the variable angleOfRotation  
  float angleOfRotation = atan2(enemy.y, enemy.x) - 
                                atan2(attackStart.y, attackStart.x);
  if (angleOfRotation < 0) {     //this ensures that the angle is between 0 and 360 degrees
    angleOfRotation += TWO_PI;   //opposed to 0 - 180 degrees
  }

  rotate(angleOfRotation - radians(150));  //rotates grid by that angle and rotates another -150 degrees
  
  //this section draws the images/objects but with the xIncrease variable to have it move
  //different commands draw different images, so the if statements check for the commands
  if (magicType.equals("black") || magicType.equals("white") )  {  //if the command is attack
    quad (-25 + xIncrease, 0, 15 + xIncrease, -7, 25 + xIncrease, 0, 15 + xIncrease, 7);
  
  } else if (magicType.equals("Fire")) {  //commands for the black mage
    rotate(radians(180));   //this and everything below rotates 180 degrees to flip image
    image(fire, -20 - xIncrease, -15, 40, 30);
  } else if (magicType.equals("Fira")) {
    rotate(radians(180));
    image(fire, -20 - xIncrease, -15, 50, 40);
  } else if (magicType.equals("Firaga")) {
    rotate(radians(180));
    image(fire, -20 - xIncrease, -15, 60, 50);
  } else if (magicType.equals("Death")) {
    rotate(radians(180));
    image(death, -20 - xIncrease, -15, 40, 30);
  } else if (magicType.equals("Sleep")) {
    rotate(radians(180));
    image(death, -20 - xIncrease, -15, 40, 30);
  } else if (magicType.equals("Poison")) {
    rotate(radians(180));
    image(poison, -20 - xIncrease, -15, 40, 30);

  } else if (magicType.equals("Holy")) {  //command for the white mage
    rotate(radians(180));
    image(holy, -20 - xIncrease, -15, 40, 30);
  }

  popMatrix();  //resets all translations and rotations

    
}

//function that calculates all the damages
//parameter attackType keeps track of which command was used
void damage(String attackType) {
  int enemyTarget = 0;  //creates and initializes enemyTarget variable, stores the enemy's target
  //takes attackType variable and splits on ",", creating two strings and storing into enemyAttack
  String [] enemyAttack = split(attackType, ","); 
  if (enemyAttack.length == 2) {   //if the command above split successfully, true
    //sets enemyTarget as second index of enemyAttack, changes string data into int
    enemyTarget = int(enemyAttack[1]);
  }
  
  //Creates the character's stats. Index are as followed:
  // - first index is physical attack
  // - second index is physical defence
  // - third index is magical attack
  // - fourth index is magical defence
  int [] blackBattleStats = {blackStats[0] * 5, blackStats[0] * 3 + blackStats[1], 
                             blackStats[2] * 5, blackStats[2] * 3};  //stats for black mage
  int [] whiteBattleStats = {whiteStats[0] * 5, whiteStats[0] * 3 + whiteStats[1], 
                             whiteStats[2] * 5, whiteStats[2] * 3};  //stats for white mage
  int [] knightBattleStats = {knightStats[0] * 5, knightStats[0] * 3 + knightStats[1], 
                              knightStats[2] * 5, knightStats[2] * 3}; //stats for knight
  
  
  //this section checks for any buffs/debuffs
  if (berserkActivated == true) {   //if berserk is true
    if (turnNumber - berserkTimer > 2) {  //if berserk has been activated for more than two turns
      berserkActivated = false;   //changes berserk to false
    } else {  //if two turns had not passed
      knightBattleStats[0] = knightBattleStats[0] * 2;  //doubles physical attack of knight
      knightBattleStats[1] = round(knightBattleStats[1]/2); //halves physical defence of knight
    }
  }
  
  for (int i = 0; i < 3; i ++) {  //repeats thrice, once for each character
    if (protectActivated[i] == true) {  //see berserk comments
      if (turnNumber - protectTimer[i] > 2) {  
        protectActivated[i] = false;
      } else {
        if (i == 0) {  //if protect true for knight
          knightBattleStats[1] = knightBattleStats[1] * 2;  //doubles physical defence
        } else if (i == 1) {  //if protect true for black mage
          blackBattleStats[1] = blackBattleStats[1] * 2;  //doubles physical defence
        } else if (i == 2) {  //if protect true for white mage
          whiteBattleStats[1] = whiteBattleStats[1] * 2;  //doubles physical defence
        }
      }
    } 
    if (shellActivated[i] == true) {  //see above
      if (turnNumber - shellTimer[i] > 2) {
        shellActivated[i] = false;
      } else {
        if (i == 0) {
          knightBattleStats[3] = knightBattleStats[3] * 2;  //doubles knight's magical defence
        } else if (i == 1) {
          blackBattleStats[3] = blackBattleStats[3] * 2;   //doubles black mage's magical defence
        } else if (i == 2) {
          whiteBattleStats[3] = whiteBattleStats[3] * 2;   //doubles white mage's magical defence
        }
      }
    } 
    if (guardActivated[i] == true) {  //see above
      if (turnNumber != guardTimer[i]) {  //if turn acivated is not equal to current turn
        guardActivated[i] = false;
      } else {
        if (i == 0) {  //if true for knight
          knightBattleStats[1] = knightBattleStats[1] * 2;  //doubles physical and magical defence
          knightBattleStats[3] = knightBattleStats[3] * 2;
        }
        if (i == 1) {  //if true for black mage
          blackBattleStats[1] = blackBattleStats[1] * 2;   //doubles physical and magical defence
          blackBattleStats[3] = blackBattleStats[3] * 2;
        }
        if (i == 2) {  //if true for white mage
          whiteBattleStats[1] = whiteBattleStats[1] * 2;   //doubles physical and magical defence
          whiteBattleStats[3] = whiteBattleStats[3] * 2;
        }
      }
      
    }
  }
  
  //array to store enemy's stats
  //first array stores enemy's number
  //Second stores stats. Indexes are as followed:
  // -Physical Attack
  // -Physical Defence
  // -Magical Attack
  // -Magical Defence
  int [] [] enemyStats = new int [6] [4];

  //repeats for each enemy
  //depending on the enemy type, it has different stats
  for (int i = 0; i < numberOfEnemies; i++) {
    if ( (enemyTypes[i] == 1) || (enemyTypes[i] == 4) ) {    //goblin
      enemyStats[i] [0] = battleNo * 3 + 15;
      enemyStats[i] [1] = battleNo * 2 + 5;
      enemyStats[i] [2] = battleNo * 3 + 15;
      enemyStats[i] [3] = battleNo * 2 + 5;
    } else if ( (enemyTypes[i] == 2) || (enemyTypes[i] == 5) ) {   //bat
      enemyStats[i] [0] = battleNo * 4 + 15;
      enemyStats[i] [1] = battleNo * 2;
      enemyStats[i] [2] = battleNo * 4 + 15;
      enemyStats[i] [3] = battleNo * 2;
    } else if (enemyTypes[i] == 3) {      //golem boss
      enemyStats[i] [0] = battleNo * 6 + 15;
      enemyStats[i] [1] = battleNo * 4 + 5;
      enemyStats[i] [2] = battleNo * 6 + 15;
      enemyStats[i] [3] = battleNo * 4 + 5;
    } else if (enemyTypes[i] == 6) {      //Xenoth (demon)
      enemyStats[i] [0] = battleNo * 12 + 15;
      enemyStats[i] [1] = battleNo * 8 + 5;
      enemyStats[i] [2] = battleNo * 12 + 15;
      enemyStats[i] [3] = battleNo * 8 + 5;
    }

    //halves Physcial Defence and Magical Defence if crippled
    if (crippleActivated[i] == true) {
      
      if (turnNumber - crippleTimer[i] > 1 ) {
      crippleActivated[i] = false;
      } else {
        enemyStats[i] [1] = round(enemyStats[i] [1] /2);
        enemyStats[i] [3] = round(enemyStats[i] [3] /2);
      }
    }

  }
  
  //this section is for player's attacks
  //depending on attackType variable, it runs different sections
  if (attackType.equals("kAttack")) {
    //knight Pysical Attack - Physical Defence of enemy
    damage = knightBattleStats[0] - enemyStats[commandTargets[0] ] [1];
    if (damage < 0) {  //if damage is lower than 0, sets to 0
      damage = 0;
    }
    enemyHP [commandTargets[0] ] -= damage;   //changes enemy's HP

  } else if (attackType.equals("bAttack")) {
    //black Mage Physical Attack - Pysical Dfence of enemy
    damage = blackBattleStats[0] - enemyStats[commandTargets[1] ] [1];
    if (damage < 0) {  //if damage is lower than 0, sets to 0
      damage = 0;
    }
    enemyHP [commandTargets[1] ] -= damage;  //changes enemy's HP

  } else if (attackType.equals("wAttack")) {
    //white Mage Pysical Attack - Pysical Dfence of enemy
    damage = whiteBattleStats[0] - enemyStats[commandTargets[2] ] [1];
    if (damage < 0) {  //if damage is lower than 0, sets to 0
      damage = 0;
    }
    enemyHP [commandTargets[2] ] -= damage;  //changes enemy's HP
    
  } else if (attackType.equals("Piercing Strike")) {
    //damage = physical attack
    damage = knightBattleStats[0];
    if (damage < 0) {  //if damage is lower than 0, sets to 0
      damage = 0;
    }
    enemyHP [commandTargets[0] ] -= damage;  //changes enemy's HP
    knightStatus[1] -= 5;    //decreases knight's MP by 5
    
  } else if (attackType.equals("Power Strike")) {
    //damage = (physical attack * 2) - physical defence of enemy
    damage = (knightBattleStats[0] * 2) - enemyStats[commandTargets[0] ] [1];
    if (damage < 0) {  //if damage is lower than 0, sets to 0
      damage = 0;
    }
    enemyHP [commandTargets[0] ] -= damage;  //changes enemy's HP
    knightStatus[1] -= 10;     //decreases knight's MP by 10
    
  } else if (attackType.equals("Armour Strike")) {
    //damage = (physical defence * 8) - physical defence of enemy
    damage = (knightBattleStats[1] * 8) - enemyStats[commandTargets[0] ] [1];
    if (damage < 0) {  //if damage is lower than 0, sets to 0
      damage = 0;
    }
    enemyHP [commandTargets[0] ] -= damage;   //changes enemy's HP
    knightStatus[1] -= 25;     //decreases knight's MP by 25
    
  } else if (attackType.equals("Vampiric Strike")) {
    //damage = physical attack - physical defence of enemy
    damage = knightBattleStats[0] - enemyStats[commandTargets[0] ] [1];
    if (damage < 0) {  //if damage is lower than 0, sets to 0
      damage = 0;
    }
    enemyHP [commandTargets[0] ] -= damage;    //changes enemy's HP
    knightStatus[0] += damage;   //heals for damage dealt
    knightStatus[1] -= 17;       //decreases knight's MP by 17
    
  } else if (attackType.equals("Cripple")) {
    crippleActivated [commandTargets[0] ] = true;  //activates cripple
    crippleTimer [commandTargets[0] ] = turnNumber;  //sets timer for cripple
    knightStatus[1] -= 17;       //decreases knight's MP by 17
    
  } else if (attackType.equals("Fire")) {
    //damage = magical attack - magical defence of enemy
    damage = blackBattleStats[2] - enemyStats[commandTargets[1] ] [3];
    if (damage < 0) {    //if damage is lower than 0, sets to 0
      damage = 0;
    }
    enemyHP [commandTargets[1] ] -= damage;  //changes enemy's HP
    blackStatus[1] -= 5;        //decreases black mage's MP by 5
    
  } else if (attackType.equals("Fira")) {
    //damage = (magical attack * 2) - magical defence of enemy
    damage = (blackBattleStats[2] * 2) - enemyStats[commandTargets[1] ] [3];
    if (damage < 0) {   //if damage is lower than 0, sets to 0
      damage = 0;
    }
    enemyHP [commandTargets[1] ] -= damage;    //changes enemy's HP
    blackStatus[1] -= 10;         //decreases black mage's MP by 10
    
  } else if (attackType.equals("Firaga")) {
    //damage = (magical attack * 3) - magical defence of enemy
    damage = (blackBattleStats[2] * 3) - enemyStats[commandTargets[1] ] [3];
    if (damage < 0) {  //if damage is lower than 0, sets to 0
      damage = 0;
    }
    enemyHP [commandTargets[1] ] -= damage;     //changes enemy's HP
    blackStatus[1] -= 25;       //decreases black mage's MP by 10
    
  } else if (attackType.equals("Death")) {
    int deathChance = int(random(1, 11)); //rolls a random number
    if (deathChance == 7) {  //if number is 7
      damage = 999;   //damage = 999
    } else {
      damage = 0;  //else damage is 0
    }
    enemyHP [commandTargets[1] ] -= damage;     //changes enemy's HP
    blackStatus[1] -= 17;     //decreases black mage's MP by 17
    
  } else if (attackType.equals("Sleep")) {
    sleepActivated [commandTargets[1] ] = true;    //activates sleep
    sleepTimer [commandTargets[1] ] = turnNumber;  //sets timer for sleep
    blackStatus[1] -= 17;      //decreases black mage's MP by 17
    
  } else if (attackType.equals("Poison")) {
    poisonActivated [commandTargets[1] ] = true;    //activates poison
    poisonTimer [commandTargets[1] ] = turnNumber;  //sets timer for poison
    blackStatus[1] -= 17;      //decreases black mage's MP by 17
    
  } else if (attackType.equals("Cure")) {
    //deals different characters depending on target chosen
    if (commandTargets[2] == 0) {
      knightStatus[0] += whiteBattleStats[2];  //knight heals for white mage's magical attack
    } else if (commandTargets[2] == 1) {
      blackStatus[0] += whiteBattleStats[2]; //black mage heals for white mage's magical attack
    } else if (commandTargets[2] == 2) {
      whiteStatus[0] += whiteBattleStats[2]; //white mage heals for white mage's magical attack
    }
    whiteStatus[1] -= 5;    //decreases white mage's MP by 5
    
  } else if (attackType.equals("Cura")) {
    //heals for white mage's magical attack * 2
    if (commandTargets[2] == 0) {
      knightStatus[0] += whiteBattleStats[2] * 2;
    } else if (commandTargets[2] == 1) {
      blackStatus[0] += whiteBattleStats[2] * 2;
    } else if (commandTargets[2] == 2) {
      whiteStatus[0] += whiteBattleStats[2] * 2;
    }
    whiteStatus[1] -= 10;   //decreases white mage's MP by 10
    
  } else if (attackType.equals("Curaga")) {
    //heals for white mage's magical attack * 3
    if (commandTargets[2] == 0) {
      knightStatus[0] += whiteBattleStats[2] * 3;
    } else if (commandTargets[2] == 1) {
      blackStatus[0] += whiteBattleStats[2] * 3;
    } else if (commandTargets[2] == 2) {
      whiteStatus[0] += whiteBattleStats[2] * 3;
    }
    whiteStatus[1] -= 25;   //decreases white mage's MP by 25
    
  } else if (attackType.equals("Protect")) {
    protectActivated[commandTargets[2] ] = true;  //activates protect
    protectTimer[commandTargets[2] ] = turnNumber;//sets timer for protect
    
    whiteStatus[1] -= 17;   //decreases white mage's MP by 17
    
  } else if (attackType.equals("Shell")) {
    shellActivated[commandTargets[2] ] = true;  //activates shell
    shellTimer[commandTargets[2] ] = turnNumber;//sets timer for shell
    
    whiteStatus[1] -= 17;   //decreases white mage's MP by 17
    
  } else if (attackType.equals("Holy")) {
    //damage = (magical attack * 2) - magical defence of enemy
    damage = (whiteBattleStats[2] * 2) - enemyStats[commandTargets[2] ] [3];
    if (damage < 0) {  //sets damage to 0 if damage is lower than 0
      damage = 0;
    }
    enemyHP [commandTargets[2] ] -= damage;  //changes enemy's HP
    whiteStatus[1] -= 17;   //decreases white mage's MP by 17


  //the next section is for enemy attacks
  } else if (enemyTarget == 0) {  //if target for enemy is 0, attacks knight
    if (enemyAttack[0].equals("enemyAttack")) {  
      //damage = physical attack - knight's physical defence
      damage = enemyStats[commandTurnNumber - 1] [0] - knightBattleStats[1];
    } else if (enemyAttack[0].equals("enemyMagic")) {
      //damage = physical attack - knight's magical defence
      damage = enemyStats[commandTurnNumber - 1] [2] - knightBattleStats[3];
    }
    
    if (damage < 0) {  //makes damage 0 if lower than 0
      damage = 0;
    }
    knightStatus[0] -= damage;  //changes knight's HP
    
  } else if (enemyTarget == 1) {  //if target for enemy is 0, attacks black mage
    if (enemyAttack[0].equals("enemyAttack")) {
      //damage = physical attack - black mage's physical defence
      damage = enemyStats[commandTurnNumber - 1] [0] - blackBattleStats[1];
    } else if (enemyAttack[0].equals("enemyMagic")) {
      //damage = physical attack - black mage's magical defence
      damage = enemyStats[commandTurnNumber - 1] [2] - blackBattleStats[3];
    }
    
    if (damage < 0) {  //makes damage 0 if lower than 0
      damage = 0;
    }
    blackStatus[0] -= damage;  //changes black mage's HP
    
  } else if (enemyTarget == 2) {  //if target for enemy is 0, attacks white mage
    if (enemyAttack[0].equals("enemyAttack")) {
      //damage = physical attack - white mage's physical defence
      damage = enemyStats[commandTurnNumber - 1] [0] - whiteBattleStats[1];
    } else if (enemyAttack[0].equals("enemyMagic")) {
      //damage = physical attack - white mage's magical defence
      damage = enemyStats[commandTurnNumber - 1] [2] - whiteBattleStats[3];
    }
  
    if (damage < 0) {  //makes damage 0 if lower than 0
      damage = 0;
    }
    whiteStatus[0] -= damage;  //changes white mage's HP
  }
  
  //makes HP 0 if negative
  //for each enemy
  for (int i = 0; i < numberOfEnemies; i++) {
    if (enemyHP [i] <= 0) {
      enemyHP [i] = 0;
    }
  }
  //for the characters
  if (knightStatus[0] <= 0) {
    knightStatus[0] = 0;
  }
  if (blackStatus[0] <= 0) {
    blackStatus[0] = 0;
  }  
  if (whiteStatus[0] <= 0) {
    whiteStatus[0] = 0;
  }
  
  //makes sure that the character's HP does not exceed their max HP
  if (knightStatus[0] > knightStats[0] * 3 + knightStats[1] * 6) {
    knightStatus[0] = knightStats[0] * 3 + knightStats[1] * 6;
  }
  if (blackStatus[0] > blackStats[0] * 3 + blackStats[1] * 6) {
    blackStatus[0] = blackStats[0] * 3 + blackStats[1] * 6;
  }
  if (whiteStatus[0] > whiteStats[0] * 3 + whiteStats[1] * 6) {
    whiteStatus[0] = whiteStats[0] * 3 + whiteStats[1] * 6;
  }

}


//this function is responsible for the enemy attacks
int enemyAttacks () {
  //array that stores magic used
  //first index is for fire
  //second index is for blizzard
  //third index is for thunder
  boolean [] enemyMagic = {false, false, false}; 
  int enemyTarget = 0;  //initializes enemyTarget variable
  
  //depending on value of enemyAttackType, enemyTarget gets different values
  if (enemyAttackType == 1 || enemyAttackType == 2) {
    enemyTarget = 0;  //knight
  } else if (enemyAttackType == 3 || enemyAttackType == 4) {
    enemyTarget = 1;  //black mage
  } else if (enemyAttackType == 5 || enemyAttackType == 6) {
    enemyTarget = 2;  //white mage
  } else if (enemyAttackType == 7) {
    enemyMagic[0] = true;  //fire
  } else if (enemyAttackType == 8) {
    enemyMagic[1] = true;  //blizzard
  } else if (enemyAttackType == 9) {
    enemyMagic[2] = true;  //thunder
  }
  
  //this runs once for each enemy
  for (int i = 0; i < numberOfEnemies * 2; i += 2) {
    if (i/2 != commandTurnNumber - 1) {  //if i is not equals to the enemy turn
      if (enemyHP[i/2] != 0) {  //if HP is not 0
        if (i == 4 || i == 10) {  //draws the images depending on enemyTypes and their positions
          if (enemyTypes[i/2] == 1) { 
            image(goblin, enemyPositions[i], enemyPositions[i + 1], 85, 85);
          } else if (enemyTypes[i/2] == 2) {
            image(floatingEye, enemyPositions[i], enemyPositions[i + 1], 85, 85);
          } else if (enemyTypes[i/2] == 3) {
            image(golemBoss, enemyPositions[i], enemyPositions[i + 1], 200, 200);
          } else if (enemyTypes[i/2] == 4) {
            image(fireGolem, enemyPositions[i], enemyPositions[i + 1], 150, 150);
          } else if (enemyTypes[i/2] == 5) {
            image(iceGolem, enemyPositions[i], enemyPositions[i + 1], 150, 150);
          } else if (enemyTypes[i/2] == 6) {
            image(demon, enemyPositions[i], enemyPositions[i + 1], 200, 200);
          }
        } else if (i == 2 || i == 8) {  //these images are smaller than the ones drawn above
          if (enemyTypes[i/2] == 1) {
            image(goblin, enemyPositions[i], enemyPositions[i + 1], 80, 80);
          } else if (enemyTypes[i/2] == 2) {
            image(floatingEye, enemyPositions[i], enemyPositions[i + 1], 80, 80);
          }  else if (enemyTypes[i/2] == 3) {
            image(golemBoss, enemyPositions[i], enemyPositions[i + 1], 200, 200);
          } else if (enemyTypes[i/2] == 4) {
            image(fireGolem, enemyPositions[i], enemyPositions[i + 1], 145, 145);
          } else if (enemyTypes[i/2] == 5) {
            image(iceGolem, enemyPositions[i], enemyPositions[i + 1], 145, 145);
          } else if (enemyTypes[i/2] == 6) {
            image(demon, enemyPositions[i], enemyPositions[i + 1], 200, 200);
          }
        } else {   //these images are smaller than the ones drawn above
          if (enemyTypes[i/2] == 1) {
            image(goblin, enemyPositions[i], enemyPositions[i + 1], 75, 75);
          } else if (enemyTypes[i/2] == 2) {
            image(floatingEye, enemyPositions[i], enemyPositions[i + 1], 75, 75);
          } else if (enemyTypes[i/2] == 3) {
            image(golemBoss, enemyPositions[i], enemyPositions[i + 1], 200, 200);
          } else if (enemyTypes[i/2] == 4) {
            image(fireGolem, enemyPositions[i], enemyPositions[i + 1], 140, 140);
          } else if (enemyTypes[i/2] == 5) {
            image(iceGolem, enemyPositions[i], enemyPositions[i + 1], 140, 140);
          } else if (enemyTypes[i/2] == 6) {
            image(demon, enemyPositions[i], enemyPositions[i + 1], 200, 200);
          }
          
        }
      }
      //if i is equal to enemy turn and not using magic
      //draws the different images but with xIncrease and yIncrease for movement
    } else if (i/2 == commandTurnNumber - 1 && enemyMagic[0] == false && 
               enemyMagic[1] == false && enemyMagic[2] == false) {
        if (enemyTypes[i/2] == 1) {
          image(goblin, enemyPositions[i] + xIncrease, 
                enemyPositions[i + 1] + yIncrease, 75, 75);
        } else if (enemyTypes[i/2] == 2) {
          image(floatingEye, enemyPositions[i] + xIncrease, 
                enemyPositions[i + 1] + yIncrease, 75, 75);
        } else if (enemyTypes[i/2] == 3) {
          image(golemBoss, enemyPositions[i] + xIncrease, 
                enemyPositions[i + 1] + yIncrease, 200, 200);
        } else if (enemyTypes[i/2] == 4) {
          image(fireGolem, enemyPositions[i] + xIncrease, 
                enemyPositions[i + 1] + yIncrease, 140, 140);
        } else if (enemyTypes[i/2] == 5) {
          image(iceGolem, enemyPositions[i] + xIncrease, 
                enemyPositions[i + 1] + yIncrease, 140, 140);
        } else if (enemyTypes[i/2] == 6) {
          image(demon, enemyPositions[i] + xIncrease, 
                enemyPositions[i + 1] + yIncrease, 200, 200);
        }

    }
  }
  //if not using magic
  if (enemyMagic[0] == false && enemyMagic[1] == false && enemyMagic[2] == false) {
    if (drawCounter < 30) {  //if draw didn't run 30 times
      //xIncrease and yIncrease increases by distance between enemy and target / 30
      xIncrease += (characterPositions[enemyTarget * 2 ] - 
                    enemyPositions[ (commandTurnNumber - 1) * 2] ) / 30.00;
      yIncrease += (characterPositions[enemyTarget * 2 + 1] + 160 - 335) / 30.00;
  
    } else {  //if draw runs more than 30 times
      //xIncrease and yIncrease decreases by distance between enemy and target / 30
      xIncrease -= (characterPositions[enemyTarget * 2 ] - 
                    enemyPositions[ (commandTurnNumber - 1) * 2] ) / 30.00;
      yIncrease -= (characterPositions[enemyTarget * 2 + 1] + 160 - 335) / 30.00;
    }
  } else {   //if magic attack, draws the enemies normally
    if (enemyTypes[commandTurnNumber - 1] == 1) {
      image(goblin, enemyPositions[ (commandTurnNumber - 1) * 2], 
            enemyPositions[ (commandTurnNumber - 1) * 2 + 1], 75, 75);
    } else if (enemyTypes[commandTurnNumber - 1] == 2) {
      image(floatingEye, enemyPositions[ (commandTurnNumber - 1) * 2], 
            enemyPositions[ (commandTurnNumber - 1) * 2 + 1], 75, 75);
    } else if (enemyTypes[commandTurnNumber - 1] == 3) {
      image(golemBoss, enemyPositions[ (commandTurnNumber - 1) * 2], 
            enemyPositions[ (commandTurnNumber - 1) * 2 + 1], 200, 200);
    } else if (enemyTypes[commandTurnNumber - 1] == 4) {
      image(fireGolem, enemyPositions[ (commandTurnNumber - 1) * 2], 
            enemyPositions[ (commandTurnNumber - 1) * 2 + 1], 140, 140);
    } else if (enemyTypes[commandTurnNumber - 1] == 5) {
      image(iceGolem, enemyPositions[ (commandTurnNumber - 1) * 2], 
            enemyPositions[ (commandTurnNumber - 1) * 2 + 1], 140, 140);
    } else if (enemyTypes[commandTurnNumber - 1] == 6) {
      image(demon, enemyPositions[ (commandTurnNumber - 1) * 2], 
            enemyPositions[ (commandTurnNumber - 1) * 2 + 1], 200, 200);
    }
    
    //creates to vectors to store x and y positions of magic attack and the target
    PVector attackStart, target;
    
    pushMatrix();
    
    //translates to enemy's position, but 80 pixel more to the right
    translate(enemyPositions[ (commandTurnNumber - 1) * 2] + 80, 
              enemyPositions[(commandTurnNumber - 1) * 2 + 1]);
    //attackStart gets amount translated
    attackStart = new PVector (enemyPositions[ (commandTurnNumber - 1) * 2] + 80, 
                               enemyPositions[(commandTurnNumber - 1) * 2 + 1]);
    //target gets x and y coordinates of the target (knight, black mage, or white mage)
    target = new PVector (characterPositions[enemyMagicTarget * 2], 
                          characterPositions[ (enemyMagicTarget * 2) + 1]);
    //xIncrease increases by distance between two vectors / 55
    xIncrease += (attackStart.dist(target)) / 55.00;  

    //finds angle between two points and stores into angleOfRotation variable
    float angleOfRotation = atan2(target.y, target.x) - 
                            atan2(attackStart.y, attackStart.x);
    if (angleOfRotation < 0) { 
      angleOfRotation += TWO_PI; //makes sure that angle is between 0 and 360 opposed to 0 - 180
    }
    
    rotate(angleOfRotation + radians(30));   //rotates grid for angle above + 30 degrees
    
    //changes image depending on which spell was casted
    //draws image with xIncrease, causing movement
    if (enemyMagic[0] == true) {
      image(fire, -20 + xIncrease, -15, 40, 30);
    } else if (enemyMagic[1] == true) {
      image(blizzard, -20 + xIncrease, -15, 40, 30);
    } else if (enemyMagic[2] == true) {
      image(thunder, -20 + xIncrease, -15, 40, 30);
    }
      
    popMatrix();  //resets all translations and rotations

  }
  
  return enemyTarget;   //returns enemyTarget value
}


//called once player completes a battle
void victory () {
  
  //draws a blue rect with text
  rect(0, 385, 600, 115);
  textSize(50);
  fill(255);  //white
  text("Victory!", 226, 425);
  textSize(20);
  //text shows how much gold was gained
  text("Gained " + ( (10 * battleNo) * numberOfEnemies) + " gold", 111, 456);
  //text shows how much EXP was gained
  text("Gained " + (10 * numberOfEnemies) + " EXP", 400, 456);
  
  //if true, displays level up text
  if (levelUp == true) {
    textSize(50);
    fill(0);  //black
    text("Level Up!", 150, 200);
  }
  
  textSize(20);
  fill(255);  //white
  text("Click anywhere to continue", 198, 488);
  
}


//called once player loses a battle
void defeat () {
  //black background, shows text
  background(0); //black
  textSize(50); 
  fill(255);  //white
  text("Defeat", 235, 158);

  textSize(25);
  text("Click anywhere to return to title screen", 74, 334);
  
}

//function that keeps track of which character the player selects in the stat and shop screen
void charSelection() {
  image(menu, 0, 0, 600, 500);  //background image
  
  fill(0, 0, 255);  //blue
  rect(200, 40, 225, 400);  //creates rectangle
  
  fill(255);  //white
  textSize(50);
  textFont(headerFont);
  
  //text for each character
  text("Knight", 241, 132);
  text("Black", 255, 219);
  text("Mage", 255, 269);
  text("White", 255, 362);
  text("Mage", 255, 412);
  
  //this creates the back button
  //draws rect with white outlines
  stroke(255);
  noFill();
  rect(209, 51, 60, 30);
  
  //shows text
  textSize(20);
  text("Back", 219, 72);
  stroke(0);
}

//called once inside stat screen
void statScreen() {
  background(0, 0, 255);  //blue background
  
  //shows status for characters depending on which character the player chose
  if (charSelection.equals("Knight")) {
    textSize(60);
    text("Knight", 218, 55);
    
    //displays:   HP: (currentHP) / (maxHP)
    //            MP: (currentMP) / (maxMP)
    textSize(40);
    text("HP: " + knightStatus[0] + "/" + (knightStats[0] * 3 + knightStats[1] * 6), 
         16, 132);
    text("MP: " + knightStatus[1] + "/" + knightStats[2] * 5, 348, 132);
    
    //displays physical attack, physical defence, magical attack, and magical defence
    //of knight
    textSize(20);
    text("Physical Attack: " + knightStats[0] * 5, 16, 198);
    text("Physical Defence: " + (knightStats[0] * 3 + knightStats[1]), 348, 198);
    text("Magical Attack: " + knightStats[2] * 5, 16, 240);
    text("Magical Defence: " + knightStats[2] * 3, 348, 240);
  
    //displays available stat points
    textSize(30);
    text("Available stat points: " + statPoints[0], 142, 303);
    
    //displays strength, vitality, and intelligence values
    text("Strength: " + knightStats[0], 180, 349);
    text("Vitality: " + knightStats[1], 180, 412);
    text("Intelligence: " + knightStats[2], 180, 471); 
    
    //runs if available stat points are higher than 0
    if (statPoints[0] != 0) {
      //creates three rectangles with a plus sign inside
      stroke(255);
      noFill();
      rect(351, 327, 25, 25);
      rect(334, 390, 25, 25);
      rect(401, 449, 25, 25);
      
      textSize(20);
      text("+", 359, 348);
      text("+", 342, 411);
      text("+", 409, 470);
    }

  }

  if (charSelection.equals("Black Mage")) {  //see above
    textSize(60);
    text("Black Mage", 141, 55);
    
    textSize(40);
    text("HP: " + blackStatus[0] + "/" + (blackStats[0] * 3 + blackStats[1] * 6), 16, 132);
    text("MP: " + blackStatus[1] + "/" + blackStats[2] * 5, 348, 132);
    
    textSize(20);
    text("Physical Attack: " + blackStats[0] * 5, 16, 198);
    text("Physical Defence: " + (blackStats[0] * 3 + blackStats[1]), 348, 198);
    text("Magical Attack: " + blackStats[2] * 5, 16, 240);
    text("Magical Defence: " + blackStats[2] * 3, 348, 240);
  
    textSize(30);
    text("Available stat points: " + statPoints[1], 142, 303);
    
    text("Strength: " + blackStats[0], 180, 349);
    text("Vitality: " + blackStats[1], 180, 412);
    text("Intelligence: " + blackStats[2], 180, 471); 
    
    if (statPoints[1] != 0) {
      stroke(255);
      noFill();
      rect(351, 327, 25, 25);
      rect(334, 390, 25, 25);
      rect(401, 449, 25, 25);
      
      textSize(20);
      text("+", 359, 348);
      text("+", 342, 411);
      text("+", 409, 470);
    }

  }
  
  if (charSelection.equals("White Mage")) {  //see above
    textSize(60);
    text("White Mage", 141, 55);
    
    textSize(40);
    text("HP: " + whiteStatus[0] + "/" + (whiteStats[0] * 3 + whiteStats[1] * 6), 16, 132);
    text("MP: " + whiteStatus[1] + "/" + whiteStats[2] * 5, 348, 132);
    
    textSize(20);
    text("Physical Attack: " + whiteStats[0] * 5, 16, 198);
    text("Physical Defence: " + (whiteStats[0] * 3 + whiteStats[1]), 348, 198);
    text("Magical Attack: " + whiteStats[2] * 5, 16, 240);
    text("Magical Defence: " + whiteStats[2] * 3, 348, 240);
  
    textSize(30);
    text("Available stat points: " + statPoints[2], 142, 303);
    
    text("Strength: " + whiteStats[0], 180, 349);
    text("Vitality: " + whiteStats[1], 180, 412);
    text("Intelligence: " + whiteStats[2], 180, 471); 
    
    if (statPoints[2] != 0) {
      stroke(255);
      noFill();
      rect(351, 327, 25, 25);
      rect(334, 390, 25, 25);
      rect(401, 449, 25, 25);
      
      textSize(20);
      text("+", 359, 348);
      text("+", 342, 411);
      text("+", 409, 470);
    }
  }
  
  //this creates the back button
  //blue rectangle with back text inside
  stroke(255);
  noFill();
  rect(19, 16, 60, 30);
  
  textSize(20);
  text("Back", 30, 37);   
  stroke(0);

}

//called once in shop
void shopScreen() {  
  image(menu, 0, 0, 600, 500);  //background
  
  fill(0, 0, 255);  //blue
  rect(200, 40, 225, 400);  //rectangle
  
  //another rectangle with a white outline
  stroke(255);
  noFill();
  rect(209, 51, 60, 30);
  
  line(205, 111, 422, 111);  //draws a line
  
  //part of the back button
  textSize(20);
  fill(255);
  text("Back", 219, 72);
  stroke(0);
  
  fill(255);  //white
  
  //displays text
  text("Your Gold: " + gold, 240, 419);  //current gold
  text("Skill Name", 205, 105);  
  text("Price", 375, 105);
  
  //runs differently for each character chosen
  //displays the character's available skills
  if (charSelection.equals("Knight")) {
    text("Piercing Strike", 205, 156);
    text("Power Strike", 205, 188);
    text("Armour Strike", 205, 220);
    text("Vampiric Strike", 205, 252);
    text("Berserk", 205, 284);
    text("Cripple", 205, 316);
  }
  
  if (charSelection.equals("Black Mage")) {
    text("Fire", 205, 156);
    text("Fira", 205, 188);
    text("Firaga", 205, 220);
    text("Death", 205, 252);
    text("Sleep", 205, 284);
    text("Poison", 205, 316);
  }
  
  if (charSelection.equals("White Mage")) {
    text("Cure", 205, 156);
    text("Cura", 205, 188);
    text("Curaga", 205, 220);
    text("Protect", 205, 252);
    text("Shell", 205, 284);
    text("Holy", 205, 316);
  }
  
  text("50", 380, 156);
  text("100", 380, 188);
  text("250", 380, 220);
  text("175", 380, 252);
  text("175", 380, 284);
  text("175", 380, 316);
  
  if (skillPurchased == true) {  //if skill successfully purchased, shows text
    text("Skill Purchased", 247, 344);
  }
  
  if (millis() - skillPurchasedTimer > 1000) {  //turn off display for above text
    skillPurchased = false;
  }
  
  if (insufficientGold == true) {  //if not enough gold, show text
    text("Insufficient Gold", 243, 364);
  }
  
  if (millis() - insufficientGoldTimer > 1000) {  //turn off display for above text
    insufficientGold = false;
  }
  
  if (alreadyPurchased == true) {   //if skill already purchased, shows text
    text("Already Purchased", 230, 384);
  }
  
  if (millis() - alreadyPurchasedTimer > 1000) {  //turn off display for above text
    alreadyPurchased = false;
  }
  
}


//function that is called once player selects "Special" during battle
void skillSelections() {
  fill(255);  //white
  textSize(20);
  
  //shows text
  text("Special", 5, 406);
  text("MP Cost", 181, 406);
  
  //creates a white line beneath above text
  stroke(255);
  line(5, 410, 253, 410);
  stroke(0);
  
  textSize(14);
  if (commandTurnNumber == 1) {  //if knight's turn
    for (int i = 0; i < 6; i++) {  //repeats six times
      if (kSkills[i] == true) {  //if skill is bought
        text(kSkillNames[i], 5, 427 + (14 * i));  //draws text for skill by using array
        if (i == 0) {  //draws the MP costs of the skills if they are bought
          text("50", 216, 427 + (14 * i));
        } else if (i == 1) {
          text("100", 216, 427 + (14 * i));
        } else if (i == 2) {
          text("250", 216, 427 + (14 * i));
        } else if (i == 3 || i == 4 || i == 5) {
          text("175", 216, 427 + (14 * i));
        }
      }
    }
  } else if (commandTurnNumber == 2) {  //if black mage's turn
    for (int i = 0; i < 6; i++) {  //see above
      if (bSkills[i] == true) {
        text(bSkillNames[i], 5, 427 + (14 * i));
        if (i == 0) {
          text("50", 216, 427 + (14 * i));
        } else if (i == 1) {
          text("100", 216, 427 + (14 * i));
        } else if (i == 2) {
          text("250", 216, 427 + (14 * i));
        } else if (i == 3 || i == 4 || i == 5) {
          text("175", 216, 427 + (14 * i));
        }
      }
    }
  } else if (commandTurnNumber == 3) {  //if white mage's turn
    for (int i = 0; i < 6; i++) {  //see above
      if (wSkills[i] == true) {
        text(wSkillNames[i], 5, 427 + (14 * i));
        if (i == 0) {
          text("5", 216, 427 + (14 * i));
        } else if (i == 1) {
          text("10", 216, 427 + (14 * i));
        } else if (i == 2) {
          text("25", 216, 427 + (14 * i));
        } else if (i == 3 || i == 4 || i == 5) {
          text("17", 216, 427 + (14 * i));
        }
      }
    }
  }
  
}


//called once user selects a buff skill for the characters
void alliedSelections() {
 textSize (30);
 fill(255);  //white
 
 //if character is not dead, displays character's name
 if (knightStatus[0] != 0) {
   text("Knight", enemyNamePositions[0], enemyNamePositions[1]);
 }
 if (blackStatus[0] != 0) {
   text("Black Mage", enemyNamePositions[2], enemyNamePositions[3]);
 }
 if (whiteStats[0] != 0) {
   text("White Mage", enemyNamePositions[4], enemyNamePositions[5]);
 }
  
}


//function that creates the introduction screen
void intro() {
  background(0, 0, 255);  //blue background
  textSize(30);
  //text
  text("For centuries, Xenoth has ruled this country,", 21, 59);
  text("turning this once peaceful and prosperious ", 21, 99);
  text("country to a country of suffering and despair.", 21, 149);
  text("As the prophecy stated long ago, a group of ", 21, 199);
  text("heros would finally end Xenoth's rule.", 21, 249);
  text("It is up to you to kill Xenoth, and to ", 21, 299);
  text("bring back the country as it was before.", 21, 349);
  
  text("Press anywhere to start your journey.", 30, 450);
  
  
}


void boss1Dialogue() {
  //creates a blue rectangle
  fill(0, 0, 255);
  rect(0, 385, 600, 115);

  //text
  fill(255);
  textSize(20);
  text("Knight: This one looks strong, we should be careful.", 60, 446);
  text("click to continue", 225, 484);
  
}


void boss2Dialogue() {
  //creates a blue rectangle
  fill(0, 0, 255);
  rect(0, 385, 600, 115);
  
  //text
  fill(255);
  textSize(20);
  text("I must commend you for making it this far.", 65, 426);
  text("However, this is as far as you get.", 70, 456);
  text("click to continue", 225, 496);
  
}


//called once player completes battle with Xenoth
void endGame() {
  background(0, 0, 255);  //blue background
  fill(255);  //white
  
  textSize(30);
  //text
  text("The heros have finally overthrown Xenoth's rule, ", 21, 59);
  text("and with it, they brought back peace and prosperity.", 21, 99);
  text("However, it is far from over. Darkness still lingers", 21, 149);
  text("in many parts of the country, and the heros must ", 21, 199);
  text("complete their task and rid the country of all darkness.", 21, 249);
  text("They quickly find out that light cannot exist without", 21, 299);
  text("darkness, and with the death of Xenoth, there is no", 21, 349);
  text("balance between light and dark, and so for the greater", 21, 399);
  text("good, the heros pursue the path of darkness. ", 21, 449);
  
  text("Click anywhere to play again.", 21, 549);
}


//part of the instructions
void instructions1() {
  background(0, 0, 255);
  fill(255);
  
  textSize(20);
  text("In the menu screen, there are four options.", 21, 59);
  text("Next battle proceeds into the next battle, with harder", 21, 99);
  text("enemies, and HP and MP is replenished", 21, 149);
  text("Replay battle starts the same battle again, but HP and", 21, 199);
  text("MP are not replenished.", 21, 249);
  text("Shop allows you to buy special attacks using gold, and", 21, 299);
  text("stats allow you to see the character's stats. If the ", 21, 349);
  text("character has levelled up, there are three new stat points", 21, 399);
  text("that you can allocate.", 21, 449);
  
  text("click anywhere to contine", 21, 489);
  
}

void instructions2() {
  background(0, 0, 255);
  fill(255);
  textSize(50);
  text("Battle", 240, 51);
  
  textSize(15);
  text("The box at the bottom right corner displays the character's", 21, 110);
  text("HP and MP. HP decreases as you get hit, and MP is needed to ", 21, 130);
  text("use special attacks. The box at the lower left corner is the", 21, 150);
  text("command box. Click on the commands to select it. Attack is a ", 21, 170);
  text("weak attack, but it does not cost mana. Special attacks require", 21, 190);
  text("you to buy them beforehand and they cost mana to use. Guard ", 21, 210);
  text("doubles the character's defence for one turn, but the character", 21, 230);
  text("does not get to attack that turn. In order to go back and redo a", 21, 250);
  text("commands, press the key 'b' to go back. You must defeat all the", 21, 270);
  text("enemies without dying.", 21, 290);
  
  text("The knight is a character with high physical attack and defence.", 21, 310);
  text("The black mage and white mage has high magical attack and defence.", 21, 330);
  text("However, the black mage focuses on offensive magic, whereas the ", 21, 350);
  text("white mage specializes in defensive magic.", 21, 370);
  
  text("press anywhere to continue", 21, 449);
  
}


void instructions3() {
  background(0, 0, 255);
  fill(255);
  textSize(50);
  text("Stats", 240, 51);
  
  textSize(15);
  text("Strength improves physical attack, physical defence,", 21, 110);
  text("and max HP", 21, 130);
  text("Vitality increases max HP and physical defence", 21, 150);
  text("Intelligence increases magical attack, magical ", 21, 170);
  text("defence, and max MP", 21, 190);
  
  text("press anywhere to continue", 21, 449);
}

void instructions4() {
  background(0, 0, 255);
  fill(255);
  textSize(50);
  text("Skills", 240, 51);
  
  textSize(30);
  text("Knight", 21, 110);
  
  textSize(15);
  text("Piercing Strike: ignores target's defence.", 21, 150);
  text("Power Strike: attack for double the normal damage.", 21, 170);
  text("Armour Strike: attacks using physical defence.", 21, 190);
  text("Vampiric Strike: heals for amount dealt.", 21, 210);
  text("Berserk: doubles attack but halves defence for two turns.", 21, 230);
  text("Cripple: halves target's defence for two turns.", 21, 250);
  
  textSize(30);
  text("Black Mage", 21, 300);
  
  textSize(15);
  text("Fire: deals low magic damage.", 21, 340);
  text("Fira: deals moderate magic damage.", 21, 360);
  text("Firaga: deals high magic damage.", 21, 380);
  text("Death: 1 in 10 chance to do 999 damage, otherwise does 0.", 21, 400);
  text("Sleep: puts target to sleep for one turn.", 21, 420);
  text("Poison: damages target over three turns.", 21, 440);
  
  text("click anywhere to continue", 21, 489);
  
}


void instructions5() {
  background(0, 0, 255);
  fill(255);
  textSize(50);
  text("Skills", 240, 51);
  
  textSize(30);
  text("White Mage", 21, 110);
  
  textSize(15);
  text("Cure: heals for a small amount.", 21, 150);
  text("Cura: heals for a moderate amount.", 21, 170);
  text("Curaga: heals for a large amount.", 21, 190);
  text("Protect: doubles target's physical defence for two turns.", 21, 210);
  text("Shell: doubles target's magical defence for two turns.", 21, 230);
  text("Holy: deals moderate damage.", 21, 250);
  
  text("click anywhere to continue", 21, 449);
  
}




//function is called whenever mouse is clicked
void mouseClicked () {
  if (gameState.equals("titleScreen")) {
    if (mouseX < 314 && mouseX > 230 && mouseY < 164 && mouseY > 132) { //play
      //if user clicks "Play"
      gameState = "intro";
    } else if (mouseX < 400 && mouseX > 147 && mouseY < 245 && mouseY > 213) {  //instructions
      //if user clicks "Instructions"
      gameState = "instructions1";
    }
    
  } else if (gameState.equals("menuScreen")) {
    if (mouseX < 386 && mouseX > 242 && mouseY < 165 && mouseY > 144) {  //next battle
      //if user clicks "Next Battle"
      battleNo ++;  //increases battle number by one
      
      //plays the music
      title.stop();
      battle.loop();
      
      if (battleNo == 5) {  //changes gameState according to which battle number it is
        gameState = "battlePhase";
        battleState = "boss1";
      } else if (battleNo == 10) {
        gameState = "battlePhase";
        battleState = "boss2";
      } else {
        gameState = "battlePhase";
        battleState = "commands";
      }
      
      //number of enemies, enemy types and enemy HPs change depending on which battle it is 
      if (battleNo == 5) {  //first boss battle
        numberOfEnemies = 1;
        enemyTypes[0] = 3;
        enemyHP[0] = battleNo * 40 + 10;
        
      } else if (battleNo == 10) {  //second boss battle
        numberOfEnemies = 1;
        enemyTypes[0] = 6;
        enemyHP[0] = battleNo * 80 + 20;
        
      } else if (battleNo < 5) {  //normal battle but battle number is smaller than 5
        numberOfEnemies = int(random(1, 7));  //number of enemies is 1 - 6
        
        //runs for each enemy
        //enemyTypes gets random value of 1 or 2
        for (int i = 0; i < numberOfEnemies; i++) { 
          enemyTypes[i] = int(random(1, 3));
          if (enemyTypes[i] == 1) {  
            enemyHP[i] = battleNo * 10 + 5;  //sets HP
          } else if (enemyTypes[i] == 2) {
            enemyHP[i] = battleNo * 10;   //sets HP
          }
        }
        
      } else if (battleNo > 5) {
        numberOfEnemies = int(random(1, 7));  //number of enemies is 1 - 6
        
        //runs for each enemy
        //enemyTypes gets random value of 4 or 5
        for (int i = 0; i < numberOfEnemies; i++) {
          enemyTypes[i] = int(random(4, 6));
          if (enemyTypes[i] == 4) {  
            enemyHP[i] = battleNo * 10 + 5;  //sets HP
          } else if (enemyTypes[i] == 5) {
            enemyHP[i] = battleNo * 10;   //sets HP
          }
        }
        
      }
        
      //generates a random number for the background, range is 0 - 2
      battleBackgroundNumber = int(random(0, 3));
      commandTurnNumber = 1;  //resets variable to 1
      turnNumber = 1;  //resets variable to 1
      
      //restores HP and MP of all allied characters
      blackStatus [0] = blackStats[0] * 3 + blackStats[1] * 6;
      blackStatus [1] = blackStats[2] * 5;
      whiteStatus [0] = whiteStats[0] * 3 + whiteStats[1] * 6;
      whiteStatus [1] = whiteStats[2] * 5;
      knightStatus [0] = knightStats[0] * 3 + knightStats[1] * 6;
      knightStatus [1] = knightStats[2] * 5;

      //this section sets all buffs and debuffs to false for each character/enemy
      for (int i = 0; i < 6; i ++) {
        sleepActivated[i] = false;
        poisonActivated[i] = false;
        crippleActivated[i] = false;
      }
      
      for (int i = 0; i < 3; i ++) {
        protectActivated[i] = false;
        shellActivated[i] = false;
        guardActivated[i] = false;
      }
      
      berserkActivated = false;
                  
    } else if (mouseX < 409 && mouseX > 225 && mouseY < 253 && mouseY > 232 && battleNo > 0) {  //replay battle
      //if user clicks "Replay Battle"
      gameState = "battlePhase";
      battleState = "commands";
      
      //plays the music
      title.stop();
      battle.loop();
      
      if (battleNo < 5) {  //if battle number is smaller than 5
        numberOfEnemies = int(random(1, 7));  //generates random number between 1 - 6
        
        //repeats for each enemy, produces random enemy type and sets HP of enemies
        for (int i = 0; i < numberOfEnemies; i++) {
          enemyTypes[i] = int(random(1, 3));
          if (enemyTypes[i] == 1) {  
            enemyHP[i] = battleNo * 10 + 5;
          } else if (enemyTypes[i] == 2) {
            enemyHP[i] = battleNo * 10;
          }
        }
        
      } else if (battleNo >= 5) {  //if battle number is 5 or larger than 5
        numberOfEnemies = int(random(1, 7));  //generates random number between 1 - 6
        
        //repeats for each enemy, produces random enemy type and sets HP of enemies
        for (int i = 0; i < numberOfEnemies; i++) {
          enemyTypes[i] = int(random(4, 6));
          if (enemyTypes[i] == 4) {  
            enemyHP[i] = battleNo * 10 + 5;
          } else if (enemyTypes[5] == 2) {
            enemyHP[i] = battleNo * 10;
          }
        }
        
      }

      //generates random number for background between 0 and 2
      battleBackgroundNumber = int(random(0, 3)); 
      //resets the two following variables to 1
      commandTurnNumber = 1; 
      turnNumber = 1;
      
      //this section gets rid of all the buffs and debuffs for each character and enemy
      for (int i = 0; i < 6; i ++) {
        sleepActivated[i] = false;
        poisonActivated[i] = false;
        crippleActivated[i] = false;
      }
      
      for (int i = 0; i < 3; i ++) {
        protectActivated[i] = false;
        shellActivated[i] = false;
        guardActivated[i] = false;
      }
      
      berserkActivated = false;

    } else if (mouseX < 349 && mouseX > 283 && mouseY < 332 && mouseY > 313) {
      //if user clicks "Shop"
      gameState = "shopSelection";
    } else if (mouseX < 353 && mouseX > 285 && mouseY < 405 && mouseY > 384) {
      //if user clicks "Stat"
      gameState = "statSelection";
    }
    
  } else if (gameState.equals("battlePhase")) {  //if in battle
    if (battleState.equals("commands")) {
      
      if (mouseX < 102 && mouseX > 22 && mouseY < 456 && mouseY > 434) {
        //if user clicks "Attack"
        commands[commandTurnNumber - 1] = "attack";  //sets command to attack
        battleState = "enemySelection";  //changes state
        
      } else if (mouseX < 118 && mouseX > 22 && mouseY < 487 && mouseY > 466) {
        //if user clicks "Special"
        battleState = "skillSelection";  //changes state
        
      } else if (mouseX < 233 && mouseX > 154 && mouseY < 456 && mouseY > 434) {
        //if user clicks "Guard"
        commands[commandTurnNumber - 1] = "Guard";  //sets command to guard
        battleState = "commands";  //changes battle state
        commandTurnNumber ++;  //increases commandTurnNumber by 1
        if (blackStatus[0] == 0 && commandTurnNumber == 1) { //if black mage is dead, skips turn
          commandTurnNumber ++;
        } 
        if (whiteStatus[0] == 0 && commandTurnNumber == 3) { //if white mage is dead
          battleState = "attacks";  //changes state to attacks
          //resets the following variables
          commandTurnNumber = 1;  
          xIncrease = 0;
          yIncrease = 0;
        }

      } 

    } else if (battleState.equals("enemySelection")) {
      
      if (mouseX < 100 && mouseX > 16) {
        if (mouseY < 423 && mouseY > 402 && enemyHP[0] != 0) {
          //if user clicks on the first enemy
          commandTargets[commandTurnNumber - 1] = 0;
        } else if (mouseY < 457 && mouseY > 437 && enemyHP[1] != 0) {
          //if user clicks on the second enemy
          commandTargets[commandTurnNumber - 1] = 1;
        } else if (mouseY < 492 && mouseY > 471 && enemyHP[2] != 0) {
          //if user clicks on the third enemy
          commandTargets[commandTurnNumber - 1] = 2;
        }
      } else if (mouseX < 223 && mouseX > 139) {
        if (mouseY < 423 && mouseY > 402 && enemyHP[3] != 0) {
          //if user clicks on the fourth enemy
          commandTargets[commandTurnNumber - 1] = 3;
        } else if (mouseY < 457 && mouseY > 437 && enemyHP[4] != 0) {
          //if user clicks on the fifth enemy
          commandTargets[commandTurnNumber - 1] = 4;
        } else if (mouseY < 492 && mouseY > 471 && enemyHP[5] != 0) {
          //if user clicks on the sixth enemy
          commandTargets[commandTurnNumber - 1] = 5;
        }
      }
      
      if ( (mouseX < 100 && mouseX > 16 && mouseY < 423 && mouseY > 402) && enemyHP[0] != 0
          || (mouseX < 100 && mouseX > 16 && mouseY < 457 && mouseY > 437) && enemyHP[1] != 0
          || (mouseX < 100 && mouseX > 16 && mouseY < 492 && mouseY > 471) && enemyHP[2] != 0 
          || (mouseX < 223 && mouseX > 139 && mouseY < 423 && mouseY > 402) && enemyHP[3] != 0
          || (mouseX < 223 && mouseX > 139 && mouseY < 457 && mouseY > 437) && enemyHP[4] != 0
          || (mouseX < 223 && mouseX > 139 && mouseY < 492 && mouseY > 471) && enemyHP[5] != 0) {
          //if user clicks on enemy and enemy is not dead, increases commandTurnNumber by 1
          commandTurnNumber ++;

        if (commandTurnNumber == 4) {  //starts attacks
          battleState = "attacks";  //changes state
          //resets the following variables
          commandTurnNumber = 1;
          xIncrease = 0;
          yIncrease = 0;
          
        } else { //repeats for other characters
          battleState = "commands";  //change of state
        }
        
      }
    } else if (battleState.equals("victory")) {
      //if user clicks anywhere during this state, switches to menu screen
      gameState = "menuScreen";
      gold += (10 * battleNo) * numberOfEnemies;  //increases gold
      
      //plays music
      victory.stop();
      title.loop();
      
      //checks whether the characters are dead or not
      //if not dead, increases EXP of character
      //if EXP exceeds 100, decreases EXP by 100 and increases stat points by 3
      if (knightStatus[0] != 0) {
        knightStatus[2] += 10 * numberOfEnemies;
        if (knightStatus[2] >= 100) {
          knightStatus[2] -= 100;
          statPoints[0] += 3;
        }
      } 
      if (blackStatus[0] != 0) {
        blackStatus[2] += 10 * numberOfEnemies;
        if (blackStatus[2] >= 100) {
          blackStatus[2] -= 100;
          statPoints[1] += 3;
        }
      } 
      if (whiteStatus[0] != 0) {
        whiteStatus[2] += 10 * numberOfEnemies;
        if (whiteStatus[2] >= 100) {
          whiteStatus[2] -= 100;
          statPoints[2] += 3;
        }
      }
      
    } else if (battleState.equals("defeat")) {
      //if user clicks anywhere in this state, returns to title screen
      gameState = "titleScreen";
      
      //plays defeat music
      defeat.stop();
      title.loop();
      
      //resets all variables so that the player starts anew
      gold = 100;
      battleNo = 0;
      
      blackStats[0] = 3;
      blackStats[1] = 5;
      blackStats[2] = 7;
      
      whiteStats[0] = 3;
      whiteStats[1] = 5;
      whiteStats[2] = 7;
      
      knightStats[0] = 6;
      knightStats[1] = 5;
      knightStats[2] = 4;
      
      blackStatus [0] = blackStats[0] * 3 + blackStats[1] * 6;
      blackStatus [1] = blackStats[2] * 5;
      blackStatus [2] = 0;
      
      whiteStatus [0] = whiteStats[0] * 3 + whiteStats[1] * 6;
      whiteStatus [1] = whiteStats[2] * 5;
      whiteStatus [2] = 0;
      
      knightStatus [0] = knightStats[0] * 3 + knightStats[1] * 6;
      knightStatus [1] = knightStats[2] * 5;
      knightStatus [2] = 0;
      
      //gets rid of all buffs and debuffs
      for (int i = 0; i < 6; i ++) {
        kSkills[i] = false;
        bSkills[i] = false;
        wSkills[i] = false;
        
        sleepActivated[i] = false;
        poisonActivated[i] = false;
        crippleActivated[i] = false;
      }
      
      for (int i = 0; i < 3; i ++) {
        protectActivated[i] = false;
        shellActivated[i] = false;
        guardActivated[i] = false;
      }
      
      berserkActivated = false;

    } else if (battleState.equals("skillSelection")) {
      if (commandTurnNumber == 1) {  //if knight's turn
        //these only run if the character's MP is higher or equal to MP required
        //and that the skills are already bought beforehand
        if (mouseX < 240 && mouseY > 5) {
          if (mouseY < 428 && mouseY > 417 && kSkills[0] == true && knightStatus[1] >= 5) {
            //if user clicks "Piercing Strike"
            commands[0] = "Piercing Strike";  //sets command to skill name
            battleState = "enemySelection";  //changes state
          } else if (mouseY < 441 && mouseY > 430 && kSkills[1] == true && knightStatus[1] >= 10) {
            //if user clicks "Power Strike"
            commands[0] = "Power Strike";  //sets command to skill name
            battleState = "enemySelection";  //change state
          } else if (mouseY < 455 && mouseY > 444 && kSkills[2] == true && knightStatus[1] >= 25) {
            //if user clicks "Armour Strike"
            commands[0] = "Armour Strike";  //sets command to skill name
            battleState = "enemySelection";  //change state
          } else if (mouseY < 470 && mouseY > 459 && kSkills[3] == true && knightStatus[1] >= 17) {
            //if user clicks "Vampiric Strike" 
            commands[0] = "Vampiric Strike";  //sets command to skill name
            battleState = "enemySelection";  //change state
          } else if (mouseY < 483 && mouseY > 472 && kSkills[4] == true && knightStatus[1] >= 17) {
            //if user clicks "Berserk"
            commands[0] = "Berserk";  //sets command to skill name
            battleState = "commands";  //change state
            commandTurnNumber ++;  //increases CommandTurnNumber by 1
            if (blackStatus[0] == 0) {  //if black mage is dead, skips turn
              commandTurnNumber ++;
            } 
            if (whiteStatus[0] == 0) {  //if white mage is dead
              battleState = "attacks";  //change state to start attacks
              //resets the following variables
              commandTurnNumber = 1;
              xIncrease = 0;
              yIncrease = 0;
            }
          } else if (mouseY < 497 && mouseY > 486 && kSkills[5] == true && knightStatus[1] >= 17) {
            //if user clicks on "Cripple"
            commands[0] = "Cripple";  //sets command to skill name
            battleState = "enemySelection";  //change state
          }
        }
        
      } else if (commandTurnNumber == 2) {  //if black mage's turn
        //see above, only difference is the skill names
        if (mouseX < 240 && mouseY > 5) {
          if (mouseY < 428 && mouseY > 417 && bSkills[0] == true && blackStatus[1] >= 5) {
            commands[1] = "Fire";
            battleState = "enemySelection";
          } else if (mouseY < 441 && mouseY > 430 && bSkills[1] == true && blackStatus[1] >= 10) {
            commands[1] = "Fira";
            battleState = "enemySelection";
          } else if (mouseY < 455 && mouseY > 444 && bSkills[2] == true && blackStatus[1] >= 25) {
            commands[1] = "Firaga";
            battleState = "enemySelection";
          } else if (mouseY < 470 && mouseY > 459 && bSkills[3] == true && blackStatus[1] >= 17) {
            commands[1] = "Death";
            battleState = "enemySelection";
          } else if (mouseY < 483 && mouseY > 472 && bSkills[4] == true && blackStatus[1] >= 17) {
            commands[1] = "Sleep";
            battleState = "enemySelection";
          } else if (mouseY < 497 && mouseY > 486 && bSkills[5] == true && blackStatus[1] >= 17) {
            commands[1] = "Poison";
            battleState = "enemySelection";
          }
        }
        
      } else if (commandTurnNumber == 3) {  //if white mage's turn
        //see above, only difference is skill names
        if (mouseX < 240 && mouseY > 5) {
          if (mouseY < 428 && mouseY > 417 && wSkills[0] == true && whiteStatus[1] >= 5) {
            commands[2] = "Cure";
            //whiteStatus[1] -= 5;
            battleState = "alliedSelection";
          } else if (mouseY < 441 && mouseY > 430 && wSkills[1] == true && whiteStatus[1] >= 10) {
            commands[2] = "Cura";
            //whiteStatus[1] -= 10;
            battleState = "alliedSelection";
          } else if (mouseY < 455 && mouseY > 444 && wSkills[2] == true && whiteStatus[1] >= 25) {
            commands[2] = "Curaga";
            //whiteStatus[1] -= 25;
            battleState = "alliedSelection";
          } else if (mouseY < 470 && mouseY > 459 && wSkills[3] == true && whiteStatus[1] >= 17) {
            commands[2] = "Protect";
            //whiteStatus[1] -= 17;
            battleState = "alliedSelection";
          } else if (mouseY < 483 && mouseY > 472 && wSkills[4] == true && whiteStatus[1] >= 17) {
            commands[2] = "Shell";
            //whiteStatus[1] -= 17;
            battleState = "alliedSelection";
          } else if (mouseY < 497 && mouseY > 486 && wSkills[5] == true && whiteStatus[1] >= 17) {
            commands[2] = "Holy";
            //whiteStatus[1] -= 17;
            battleState = "enemySelection";
          }
        }
        
      }
      
    } else if (battleState.equals("alliedSelection")) {
      if (mouseX < 100 && mouseX > 16 && mouseY < 424 && mouseY > 403 && knightStatus[0] != 0) {
        //if user clicks on "Knight"
        commandTargets[2] = 0;  //sets target to knight
        battleState = "attacks";  //changes state
      } else if (mouseX < 170 && mouseX > 16 && mouseY < 458 && mouseY > 435 && blackStatus[0] != 0) {
        //if user clicks on "Black Mage"
        commandTargets[2] = 1;  //sets target to black mage
        battleState = "attacks";  //changes state
      } else if (mouseX < 170 && mouseX > 16 && mouseY < 492 && mouseY > 471 && whiteStatus[0] != 0) {
        //if user clicks on "White Mage"
        commandTargets[2] = 2;  //sets target to white mage
        battleState = "attacks";  //changes state
      }
      //resets the following variables
      commandTurnNumber = 1;
      xIncrease = 0;
      yIncrease = 0;
      
    } else if (battleState.equals("boss1")) {
      //if user clicks anywhere in this state
      battleState = "commands";  //changes state
    } else if (battleState.equals("boss2")) {
      //if user clicks anywhere in this state
      battleState = "commands";  //changes state
    }

  } else if (gameState.equals("statSelection")) {
   
    if (mouseX < 380 && mouseX > 244 && mouseY < 138 && mouseY > 97) {
      //if user clicks on "Knight"
      charSelection = "Knight";
      gameState = "statScreen";  //changes state
    } else if (mouseX < 377 && mouseX > 261 && mouseY < 268 && mouseY > 184) {
      //if user clicks on "Black Mage"
      charSelection = "Black Mage";
      gameState = "statScreen";  //changes state
    } else if (mouseX < 377 && mouseX > 258 && mouseY < 412 && mouseY > 327) {
      //if user clicks on "White Mage
      charSelection = "White Mage";
      gameState = "statScreen";  //changes state
    } else if (mouseX < 268 && mouseX > 209 && mouseY < 81 && mouseY > 51) {
      //if user clicks on "Back"
      gameState = "menuScreen";  //changes state
    }
    
  } else if (gameState.equals("statScreen")) {
    if (charSelection.equals("Knight")) {
      if (statPoints[0] > 0) {  //if available stat points are higher than 0
        if (mouseX < 376 && mouseX > 352 && mouseY < 350 && mouseY > 328) {
          //if user clicks on "+" for strength
          knightStats[0] ++;  //increases strength
          statPoints[0] --;  //decreases available stat points
        } else if (mouseX < 359 && mouseX > 335 && mouseY < 415 && mouseY > 391) {
          //if user clicks on "+" for vitality
          knightStats[1] ++;  //increases vitality
          statPoints[0] --;  //decreases available stat points
        } else if (mouseX < 426 && mouseX > 401 && mouseY < 474 && mouseY > 450) {
          //if user clicks on "+" for intelligence
          knightStats[2] ++;  //increases intelligence
          statPoints[0] --;  //decreases available stat points
        }
      }
    } else if (charSelection.equals("Black Mage")) {
      if (statPoints[1] > 0) { //see above
        if (mouseX < 376 && mouseX > 352 && mouseY < 350 && mouseY > 328) {
          blackStats[0] ++;
          statPoints[1] --;
        } else if (mouseX < 359 && mouseX > 335 && mouseY < 415 && mouseY > 391) {
          blackStats[1] ++;
          statPoints[1] --;
        } else if (mouseX < 426 && mouseX > 401 && mouseY < 474 && mouseY > 450) {
          blackStats[2] ++;
          statPoints[1] --;
        }
      }
    } else if (charSelection.equals("White Mage")) {
      if (statPoints[2] > 0) {  //see above
        if (mouseX < 376 && mouseX > 352 && mouseY < 350 && mouseY > 328) {
          whiteStats[0] ++;
          statPoints[2] --;
        } else if (mouseX < 359 && mouseX > 335 && mouseY < 415 && mouseY > 391) {
          whiteStats[1] ++;
          statPoints[2] --;
        } else if (mouseX < 426 && mouseX > 401 && mouseY < 474 && mouseY > 450) {
          whiteStats[2] ++;
          statPoints[2] --;
        }
      }
    }
    
    if (mouseX < 79 && mouseX > 20 && mouseY < 44 && mouseY > 16) {
      //if user clicks on "Back"
      gameState = "statSelection";  //changes state
    }
    
  } else if (gameState.equals("shopSelection")) {
    if (mouseX < 380 && mouseX > 244 && mouseY < 138 && mouseY > 97) {
      //if user clicks on "Knight"
      charSelection = "Knight";
      gameState = "shopScreen";  //changes state
    } else if (mouseX < 377 && mouseX > 261 && mouseY < 268 && mouseY > 184) {
      //if user clicks on "Black Mage"
      charSelection = "Black Mage";
      gameState = "shopScreen";  //changes state
    } else if (mouseX < 377 && mouseX > 258 && mouseY < 412 && mouseY > 327) {
      //if user clicks on "White Mage"
      charSelection = "White Mage";
      gameState = "shopScreen";  //changes state

    } else if (mouseX < 268 && mouseX > 209 && mouseY < 81 && mouseY > 51) {
      //if user clicks on "Back"
      gameState = "menuScreen";  //changes state
    }
    
  } else if (gameState.equals("shopScreen")) {
    //it runs different sections depending on which character the player chose
    if (charSelection.equals("Knight")) {  //if chosen knight
      if (mouseX < 411 && mouseX > 204) {   //if user clicks on first skill
        if (mouseY < 156 && mouseY > 142) {
          if (kSkills[0] == false) {  //if skill not already bought
            if (gold >= 50) {  //if gold is higher than or equal to price
              gold -= 50;  //changes gold
              kSkills[0] = true;  //sets skill to true
              skillPurchased = true;  //sets skillPurchased to true
              skillPurchasedTimer = millis();  //sets variable to current time
            } else {
              insufficientGold = true;  //sets insufficientGold to true
              insufficientGoldTimer = millis();  //sets variable to current time
            }
          } else {
            alreadyPurchased = true;  //sets alreadyPurchased to true
            alreadyPurchasedTimer = millis();  //sets variable to current time
          }
          
        } else if (mouseY < 188 && mouseY > 173) {   //if user clicks on second skill
          if (kSkills[1] == false) {  //see above
            if (gold >= 100) {
              gold -= 100;
              kSkills[1] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
        
        } else if (mouseY < 219 && mouseY > 205) {   //if user clicks on third skill
          if (kSkills[2] == false) {  //see above
            if (gold >= 250) {
              gold -= 250;
              kSkills[2] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
          
        } else if (mouseY < 250 && mouseY > 237) {   //if user clicks on fourth skill
          if (kSkills[3] == false) {  //see above
            if (gold >= 175) {
              gold -= 175;
              kSkills[3] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
          
        } else if (mouseY < 283 && mouseY > 269) {   //if user clicks on fifth skill
          if (kSkills[4] == false) {  //see above
            if (gold >= 175) {
              gold -= 175;
              kSkills[4] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
          
        } else if (mouseY < 314 && mouseY > 300) {   //if user clicks on sixth skill
          if (kSkills[5] == false) {  //see above
            if (gold >= 175) {
              gold -= 175;
              kSkills[5] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
        }
        
      }
      
    } else if (charSelection.equals("Black Mage")) {
      //same as aove but with different skills and variables/indexes
      if (mouseX < 411 && mouseX > 204) {
        if (mouseY < 156 && mouseY > 142) {
          if (bSkills[0] == false) {
            if (gold >= 50) {
              gold -= 50;
              bSkills[0] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
          
        } else if (mouseY < 188 && mouseY > 173) {
          if (bSkills[1] == false) {
            if (gold >= 100) {
              gold -= 100;
              bSkills[1] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
        
        } else if (mouseY < 219 && mouseY > 205) {
          if (bSkills[2] == false) {
            if (gold >= 250) {
              gold -= 250;
              bSkills[2] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
          
        } else if (mouseY < 250 && mouseY > 237) {
          if (bSkills[3] == false) {
            if (gold >= 175) {
              gold -= 175;
              bSkills[3] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
          
        } else if (mouseY < 283 && mouseY > 269) {
          if (bSkills[4] == false) {
            if (gold >= 175) {
              gold -= 175;
              bSkills[4] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
          
        } else if (mouseY < 314 && mouseY > 300) {
          if (bSkills[5] == false) {
            if (gold >= 175) {
              gold -= 175;
              bSkills[5] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
        }
        
      }
      
    } else if (charSelection.equals("White Mage")) {
      //same as aove but with different skills and variables/indexes
      if (mouseX < 411 && mouseX > 204) {
        if (mouseY < 156 && mouseY > 142) {
          if (wSkills[0] == false) {
            if (gold >= 50) {
              gold -= 50;
              wSkills[0] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
          
        } else if (mouseY < 188 && mouseY > 173) {
          if (wSkills[1] == false) {
            if (gold >= 100) {
              gold -= 100;
              wSkills[1] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
        
        } else if (mouseY < 219 && mouseY > 205) {
          if (wSkills[2] == false) {
            if (gold >= 250) {
              gold -= 250;
              wSkills[2] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
          
        } else if (mouseY < 250 && mouseY > 237) {
          if (wSkills[3] == false) {
            if (gold >= 175) {
              gold -= 175;
              wSkills[3] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
          
        } else if (mouseY < 283 && mouseY > 269) {
          if (wSkills[4] == false) {
            if (gold >= 175) {
              gold -= 175;
              wSkills[4] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
          
        } else if (mouseY < 314 && mouseY > 300) {
          if (wSkills[5] == false) {
            if (gold >= 175) {
              gold -= 175;
              wSkills[5] = true;
              skillPurchased = true;
              skillPurchasedTimer = millis();
            } else {
              insufficientGold = true;
              insufficientGoldTimer = millis();
            }
          } else {
            alreadyPurchased = true;
            alreadyPurchasedTimer = millis();
          }
        }
        
      }
    }
    
    
    if (mouseX < 268 && mouseX > 209 && mouseY < 81 && mouseY > 51) {
      //if user clicks "back"
      gameState = "shopSelection";  //changes state
    }
    
  } else if (gameState.equals("intro")) {
    //if user clicks anywhere during this state
    gameState = "menuScreen";  //switches to menu screen
    
  } else if (gameState.equals("endGame")) {
    //if user clicks anywhere during this state
    gameState = "titleScreen";  //switches to title screen
    
    //resets all variables to start anew
    gold = 100;
    battleNo = 0;
    
    blackStats[0] = 3;
    blackStats[1] = 5;
    blackStats[2] = 7;
    
    whiteStats[0] = 3;
    whiteStats[1] = 5;
    whiteStats[2] = 7;
    
    knightStats[0] = 6;
    knightStats[1] = 5;
    knightStats[2] = 4;
    
    blackStatus [0] = blackStats[0] * 3 + blackStats[1] * 6;
    blackStatus [1] = blackStats[2] * 5;
    blackStatus [2] = 0;
    
    whiteStatus [0] = whiteStats[0] * 3 + whiteStats[1] * 6;
    whiteStatus [1] = whiteStats[2] * 5;
    whiteStatus [2] = 0;
    
    knightStatus [0] = knightStats[0] * 3 + knightStats[1] * 6;
    knightStatus [1] = knightStats[2] * 5;
    knightStatus [2] = 0;
    
    //gets rid of all buffs and debuffs
    for (int i = 0; i < 6; i ++) {
      kSkills[i] = false;
      bSkills[i] = false;
      wSkills[i] = false;
      
      sleepActivated[i] = false;
      poisonActivated[i] = false;
      crippleActivated[i] = false;
    }
    
    for (int i = 0; i < 3; i ++) {
      protectActivated[i] = false;
      shellActivated[i] = false;
      guardActivated[i] = false;
    }
    
    berserkActivated = false;

  } else if (gameState.equals("instructions1")) {
    //if user clicked anywhere during this state
    gameState = "instructions2";  //switches to second part of instructions
  } else if (gameState.equals("instructions2")) {
    gameState = "instructions3";
  } else if (gameState.equals("instructions3")) {
    gameState = "instructions4";
  } else if (gameState.equals("instructions4")) {
    gameState = "instructions5";
  } else if (gameState.equals("instructions5")) {
    gameState = "titleScreen";
  }
}


//called whenever key is pressed
void keyPressed() {
  if (key == 'b') {  //if key "b" is pressed
    if (battleState.equals("enemySelection")) {  //if selecting enemies
      battleState = "commands";  //changes to selecting commands screen
    } else if (battleState.equals("skillSelection")) {  //if selecting skills
      battleState = "commands";  //changes to selecting commands screen
    }
  }
}


//this function is continuously called
void draw() {
  cursor(HAND);  //changes mouse pointer to hand
  
  if (gameState.equals("titleScreen")) {
    //calls titleScreen function if gameState is titleScreen
    titleScreen();
  }
  
  if (gameState.equals("menuScreen")) {
    //calls menuScreen function if gameState is menuScreen
    menuScreen();
  }
  
  if (gameState.equals("battlePhase")) {
    //calls battlePhase function if gameState is battlePhase
    battlePhase();
    
        
    if (battleState.equals("commands")) {  //if selecting commands
      showEnemies();
      characterStatus();
      showCharacters();
      battleCommands();
      
      //checks to skip any turns if a character is dead
      if (commandTurnNumber == 1 && knightStatus[0] == 0) {  //if knight dead
        commandTurnNumber ++;  //increases commandTurnNumber
      }
      if (commandTurnNumber == 2 && blackStatus[0] == 0) {  //if black mage dead
        commandTurnNumber ++;  //increases commandTurnNumber
      }        
      if (commandTurnNumber == 3 && whiteStatus[0] == 0) {  //if white mage dead
        commandTurnNumber ++;  //increases commandTurnNumber
      }
      if (commandTurnNumber == 4) {  //if white mage is dead
        battleState = "attacks";  //change state
        //resets the following variables
        commandTurnNumber = 1;
        xIncrease = 0;
        yIncrease = 0;
      }
      
    } else if (battleState.equals("enemySelection")) {  //if selecting enemies
      showEnemies();
      characterStatus();
      enemySelections();
      showCharacters();
      
    } else if (battleState.equals("attacks")) {
      //checks to skip any turns if dead
      if (commandTurnNumber == 1 && knightStatus[0] == 0) {
        commandTurnNumber ++;
      }
      if (commandTurnNumber == 2 && blackStatus[0] == 0) {
        commandTurnNumber ++;
      }
      if (commandTurnNumber == 3 && whiteStatus[0] == 0) {
        commandTurnNumber ++;
      }
      if (drawCounter < 60) {
        if (commandTurnNumber < 4) {
          if (drawCounter == 1) {
            attackDisplay = millis();  //this runs once sets timer for display
            swordSwing.play();
          }
        }
        //this section if command is a buff on character
        if (drawCounter == 1 && commandTurnNumber == 1 && 
            commands[0].equals("Berserk")) {  //if command is Berserk and knight's turn
          //sets berserk to true, sets timer to turnNumber, and decreases MP by 17
          berserkActivated = true;
          berserkTimer = turnNumber;
          knightStatus[1] -= 17;
        } else if (drawCounter == 1 && commandTurnNumber == 1 && 
                   commands[0].equals("Guard")) {  //if command is guard and knight's turn
          //sets guard to true, and sets timer to turnNumber
          guardActivated[0] = true;
          guardTimer[0] = turnNumber;
        } else if (drawCounter == 1 && commandTurnNumber == 2 && 
                   commands[1].equals("Guard")) { //if command is guard and black mage's turn
          //sets guard to true, and sets timer to turnNumber
          guardActivated[1] = true;
          guardTimer[1] = turnNumber;
        } else if (drawCounter == 1 && commandTurnNumber == 3 &&
                   commands[2].equals("Guard")) { //if command is guard and white mage's turn
          //sets guard to true, and sets timer to turnNumber
          guardActivated[2] = true;
          guardTimer[2] = turnNumber;
        }
        
        //if knight's turn and midway  through animation
        if (commandTurnNumber == 1 && drawCounter == 30) { 
          if (commands[0].equals("attack")) {
            damage("kAttack");   //normal attack, calls function with kAttack as parameter
          } else if (commands[0].equals("Piercing Strike") 
                    || commands[0].equals("Power Strike")
                    || commands[0].equals("Armour Strike")
                    || commands[0].equals("Vampiric Strike")
                    || commands[0].equals("Cripple") ) {
            damage(commands[0]);  //calls damage fuction with command name as parameter
          }
          damageDisplayTime = millis();  //sets time to current time
        }
        showEnemies();
        attacks();
        if (commandTurnNumber == 1 && ( commands[0].equals("Berserk") 
            || commands[0].equals("Guard") ) ) {
          image(knightDefault, 335, 175, 225, 200);  //draws the knight (stationary)
        }
        characterStatus();
        enemyStatus();
        drawCounter ++;
      } else {
        if (commandTurnNumber == 2) {  //black mage's turn
          if (commands[1].equals("attack")) {
            damage("bAttack");  //normal attack, calls function with bAttack as parameter
          } else {
            damage(commands[1]);  //calls damage fuction with command name as parameter
          }
          damageDisplayTime = millis();  //sets time to current time
        } else if (commandTurnNumber == 3) {  //white mage's turn
          if (commands[2].equals("attack")) {
            damage("wAttack");  //normal attack, calls function with wAttack as parameter
          } else {
            damage(commands[2]);  //calls damage fuction with command name as parameter
          }
          damageDisplayTime = millis();  //sets time to current time
        }
        //increases commandTurnNumber and skips turns if character is dead
        commandTurnNumber ++;
        if (commandTurnNumber == 2 && blackStatus[0] == 0) {
          commandTurnNumber ++;
        }
        if (commandTurnNumber == 3 && whiteStatus[0] == 0) {
          commandTurnNumber ++;
        }
        //resets the following variables
        drawCounter = 0;
        xIncrease = 0;
        yIncrease = 0;
      }
      
      //this section controls the display of the damage and attack names
      if (commandTurnNumber < 5) {        
        if (millis() - damageDisplayTime < 600) {
          fill(196, 0, 0);  //red
          textSize(25);
          
          if (commandTurnNumber == 3 && (commands[2].equals("Cure") 
              || commands[2].equals("Cura") || commands[2].equals("Curaga") ) ) {
            //this is for healing
            fill(6, 137, 30);  //green
            textSize(40);
            //different positions depending on target of heal
            if (commandTargets[2] == 0) {
              text(damage, 401, 265);
            } else if (commandTargets[2] == 1) {
              text(damage, 513, 180);
            } else if (commandTargets[2] == 2) {
              text(damage, 391, 107);
            }
          } else { //this is for damages
            //positions change depending on targets
            if (commandTurnNumber == 3 || commandTurnNumber == 4) {
              text(damage, enemyPositions[commandTargets[commandTurnNumber - 2] * 2], 
                   enemyPositions[commandTargets[commandTurnNumber - 2] * 2 + 1] + 20);
            } else if (commandTurnNumber == 1) {
              text(damage, enemyPositions[commandTargets[commandTurnNumber - 1] * 2], 
              enemyPositions[commandTargets[commandTurnNumber - 1] * 2 + 1] + 20);
            }
          }

        //this displays the attack name
        } else if (millis() - attackDisplay < 1000) {
          textSize(40);
          fill(0);  //black
          
          if (commands[commandTurnNumber - 1].equals("attack")) {
            //prints "Attack"
            text("Attack", 222, 44);
          } else {
            //prints command name
            text(commands[commandTurnNumber - 1], 222, 44);
          }
        }
        
      //this section is for the enemies
      } else if (commandTurnNumber == 5) {
        //repeats for each enemy and checks for debuffs, if there is debuff, check for 
        //turn it was activated and if more than a set amount of passed, set to false,
        //if not, it inflict the effects of the debuff
        for (int i = 0; i < 6; i ++ ) { 
          if (sleepActivated[i] == true) {
            if (turnNumber - sleepTimer[i] > 0) {
              sleepActivated [i] = false;  //sets sleep to false
            }
          }
          if (poisonActivated[i] == true) {
            if (turnNumber - poisonTimer[i] > 3) {
              poisonActivated[i] = false;
            } else {
              enemyHP [i] -= blackStats[2] * 5;  //inflicts damage
              if (enemyHP [i] < 0) {
                enemyHP [i] = 0;  //checks if enemy is dead
              }
            }
          }
          
        }
        
        battleState = "enemyAttacks";  //change battle state
        //this section checks if enemy is dead or asleep, if yes, then skips turn
        if (enemyHP[0] == 0 || sleepActivated[0] == true) {
          if (enemyHP[1] == 0 || sleepActivated[1] == true) {
            if (enemyHP[2] == 0 || sleepActivated[2] == true) {
              if (enemyHP[3] == 0 || sleepActivated[3] == true) {
                if (enemyHP[4] == 0 || sleepActivated[4] == true) {
                  commandTurnNumber = 6;
                } else {
                  commandTurnNumber = 5;
                }
              } else {
                commandTurnNumber = 4;
              }
            } else {
              commandTurnNumber = 3;
            }
          } else {
            commandTurnNumber = 2;
          }
        } else {
          commandTurnNumber = 1;
        }
        enemyAttackType = int(random(1, 10));  //random number for attacks
        while (enemyAttackType == 1 && knightStatus[0] == 0 
              || enemyAttackType == 2 && knightStatus[0] == 0 
              || enemyAttackType == 3 && blackStatus[0] == 0 
              || enemyAttackType == 4 && blackStatus[0] == 0 
              || enemyAttackType == 5 && whiteStatus[0] == 0 
              || enemyAttackType == 6 && whiteStatus[0] == 0) {
          //picks another number if target is dead
          enemyAttackType = int(random(1, 6));
        }

        if (enemyAttackType > 6) { 
          enemyMagicTarget = int(random(0, 3));  //random target for magic
          
          while (enemyMagicTarget == 0 && knightStatus[0] == 0 
          || enemyMagicTarget == 1 && blackStatus[0] == 0 
          || enemyMagicTarget == 2 && whiteStatus[0] == 0) {
            //picks another number if target is dead
            enemyMagicTarget = int(random(0, 3));
          }
          
          //sets the value to the array
          enemyMagicTargetDisplay[0] = enemyMagicTarget;
        }
      }
      
    } else if (battleState.equals("enemyAttacks")) {
      //this section is for enemy attacks
    
      if (drawCounter < 60 && commandTurnNumber < 7) {
        if (drawCounter == 1) {
          attackDisplay = millis();  //runs once
        }
        if (drawCounter == 30 && enemyAttackType < 7) {
          //normal attack, calls damage with parameter "enemyAttack" and enemy target
          damage("enemyAttack" + "," + enemyAttacks() );
          damageDisplayTime = millis();  //sets timer to current time
        }
        enemyAttacks();
        showCharacters();
        characterStatus();
        enemyStatus();
        drawCounter ++;

      } else {

        if (enemyAttackType > 6 && commandTurnNumber < 7) {  //if enemy uses magic
          //magic attack, calls damage with parameter "enemyMagic" and enemy target
          damage("enemyMagic" + "," + enemyMagicTarget ); 
          damageDisplayTime = millis();  //sets timer to current time
        }

        commandTurnNumber ++; //increases commandTurnNumber by 1
       
        //skips any turns if enemy is dead
        if (commandTurnNumber < 7) {
          while (enemyHP[commandTurnNumber - 1] == 0) {
            commandTurnNumber ++;
            if (commandTurnNumber == 7) {
              battleState = "commands"; //changes state
              commandTurnNumber = 1;  //resets variable
              break;  //leaves while loop
            }
          }
        }
        
        enemyAttackType = int(random(1, 10));  //generates random number for attack type
        
        if ( !(knightStatus[0] == 0 && blackStatus[0] == 0 && whiteStatus[0] == 0) ) {
          while ( (enemyAttackType == 1 && knightStatus[0] == 0) 
                  || (enemyAttackType == 2 && knightStatus[0] == 0) 
                  || (enemyAttackType == 3 && blackStatus[0] == 0) 
                  || (enemyAttackType == 4 && blackStatus[0] == 0) 
                  || (enemyAttackType == 5 && whiteStatus[0] == 0) 
                  || (enemyAttackType == 6 && whiteStatus[0] == 0)) {
            //picks another number if target is dead
            enemyAttackType = int(random(1, 6));
          }
          
  
          if (enemyAttackType > 6 && commandTurnNumber < 7) {
            enemyMagicTarget = int(random(0, 3));

            while ( (enemyMagicTarget == 0 && knightStatus[0] == 0) 
                  || (enemyMagicTarget == 1 && blackStatus[0] == 0) 
                  || (enemyMagicTarget == 2 && whiteStatus[0] == 0) 
              )  {
                //picks another number if target is dead
                enemyMagicTarget = int(random(0, 3));
            }
            //sets the value to the array
            enemyMagicTargetDisplay [commandTurnNumber - 1] = enemyMagicTarget; 
          }
          
        }
        
        if (commandTurnNumber == 7) {  //if all enemies' turns passed
          changeStateTimer = millis();  //sets timer to current time
          changeStateEnable = true;    //sets variable to true
        }
        //resets the following variables
        drawCounter = 0;
        xIncrease = 0;
        yIncrease = 0;
      }

      //this section displays the damage
      if (commandTurnNumber < 7) {        
        if (millis() - damageDisplayTime < 600) {
          fill(196, 0, 0);  //red
          textSize(40);

          //different positions depending on target
          if (enemyAttackType < 7) {
            if (enemyAttackType == 1 || enemyAttackType == 2) {
              text(damage, 401, 265);
            } else if (enemyAttackType == 3 || enemyAttackType == 4) {
              text(damage, 513, 180);
            } else if (enemyAttackType == 5 || enemyAttackType == 6) {
              text(damage, 391, 107);
            }
          } else if (enemyAttackType > 6) {

            extraValue = 0;
            if (commandTurnNumber - 2 < 0) {
              extraValue = -1; //ensures that indexOutOfBounds error does not occur
            }
            //displays damage on different locations depending on targets
            if (enemyMagicTargetDisplay[commandTurnNumber - 2 - extraValue] == 0) {
              text(damage, 401, 265);
            } else if (enemyMagicTargetDisplay[commandTurnNumber - 2 - extraValue] == 1) {
              text(damage, 513, 180);
            } else if (enemyMagicTargetDisplay[commandTurnNumber - 2 - extraValue] == 2) {
              text(damage, 391, 107);
            }
          }
          
        //this displays the attack type
        } else if (millis() - attackDisplay < 1000) {
          textSize(40);
          fill(0);  //black
          
          //depending on enemyAttackType value, it displays different text
          if (enemyAttackType > 0 && enemyAttackType < 7) {
            text("Attack", 222, 44);
          } else if (enemyAttackType == 7) {
            text("Fire", 222, 44);
          } else if (enemyAttackType == 8) {
            text("Blizzard", 222, 44);
          } else if (enemyAttackType == 9) {
            text("Thunder", 222, 44);
          }
        }
      
      }
      if (commandTurnNumber >= 7) {  //if all enemies' turns finished
        showCharacters();
        characterStatus();
        enemyStatus();
        showEnemies();
        fill(196, 0, 0);  //red
        textSize(40);
        //displays damage, position depends on target
        if (millis() - damageDisplayTime < 600) {
          if (enemyMagicTargetDisplay[5] == 0) {
            text(damage, 401, 265);
          } else if (enemyMagicTargetDisplay[5] == 1) {
            text(damage, 513, 180);
          } else if (enemyMagicTargetDisplay[5] == 2) {
            text(damage, 391, 107);
          }
        } 
      }
      
      //if changeStateEnable is true and more than 600 milliseconds passed
      if ( (millis() - changeStateTimer) > 600 && changeStateEnable == true) {
        changeStateEnable = false;  //sets variable to false
        battleState = "commands";  //changes state
        commandTurnNumber = 1;  //resets variable
        turnNumber ++;  //increases turn number by 1
      }
      
      //if all enemies dead
      if (enemyHP[0] == 0 && enemyHP[1] == 0 && enemyHP[2] == 0 && 
          enemyHP[3] == 0 && enemyHP[4] == 0 && enemyHP[5] == 0) {
        battleState = "victory";  //change state to victory
        //plays music
        battle.stop();
        victory.loop();
        if ( (knightStatus[2] + (10 * numberOfEnemies) >= 100) 
            || (blackStatus[2] + (10 * numberOfEnemies) >= 100) 
            || (whiteStatus[2] + (10 * numberOfEnemies) >= 100) ) {
          //if EXP for a character exceeds 100
          levelUp = true;
        }
        if (battleNo == 10) {
          //last battle complete, change state
          gameState = "endGame";
        }
        
      }
      
      //if all characters dead
      if (knightStatus[0] == 0 && blackStatus[0] == 0 && whiteStatus[0] == 0) {
        //change state
        battleState = "defeat";
        //plays music
        battle.stop();
        defeat.loop();
      }


    } else if (battleState.equals("victory")) {
      //if won battle, call functions
      showCharacters();
      victory();
      
    } else if (battleState.equals("defeat")) {
      //if defeat, call defeat function
      defeat();
    
    } else if (battleState.equals("skillSelection")) {
      //if selecting skills, call functions
      characterStatus();
      showEnemies();
      showCharacters();
      skillSelections();

      
    } else if (battleState.equals("alliedSelection")) {
      //if selecting allied targets, call functions
      characterStatus();
      showEnemies();
      showCharacters();
      alliedSelections();
      
    } else if (battleState.equals("boss1")) {
      //if in boss1 state, calls these functions
      boss1Dialogue();
      showEnemies();
      showCharacters();
    
    } else if (battleState.equals("boss2")) {
      //if in boss2 state, calls these functions
      boss2Dialogue();
      showEnemies();
      showCharacters();
    }

  } else if (gameState.equals("statSelection")) {
    //if in this state, call charSelection
    charSelection();
  } else if (gameState.equals("statScreen")) {
    //if in this state, call statScreen
    statScreen();
    
  } else if (gameState.equals("shopSelection")) {
    //if in this state, call charSelection
    charSelection();
  } else if (gameState.equals("shopScreen")) {
    //if in this state, call shopScreen
    shopScreen();
  
  } else if (gameState.equals("intro")) {
    //if in this state, call intro
    intro();
  
  } else if (gameState.equals("endGame")) {
    //if in this state, call endGame
    endGame();
  
  } else if (gameState.equals("instructions1")) {
    //if in this state, call instructions1
    instructions1();
  } else if (gameState.equals("instructions2")) {
    instructions2();
  } else if (gameState.equals("instructions3")) {
    instructions3();
  } else if (gameState.equals("instructions4")) {
    instructions4();
  } else if (gameState.equals("instructions5")) {
    instructions5();
  }
  

}