Board gameBoard;
Pawn thePawn;
Pawn checkedPawn;
Pawn movedPawn1;
Pawn movedPawn2;
Space space1;
Space space2;
Deck gameDeck;
Card card1;
Card card2;
Card card3;

int[] mouseCoords;
int[] selectedPawn;
int[] start;
int[] home;
int[][] boardData;
boolean[] ACTIVE_PLAYERS = {false,false,false,false};
boolean CARD_VALID;
boolean CARD1_VALID;
boolean CARD2_VALID;
boolean CARD3_VALID;
boolean SPECIAL_CARDS = false;
boolean TEAMS = false;
boolean VALID;
boolean VALID_MOVE;
boolean SPLIT;
boolean SKIPPABLE;
boolean MOVED_PAWN;
boolean PAWN_SELECTED;
boolean PAWN_HOME;
boolean DRAWN_CARD;
boolean DRAWN_THREE;
boolean SLIDE;
boolean CAN_SLIDE;
boolean WAITING;
boolean TURN_SKIPPED;
boolean TURN_SKIPPED2;
int players = 0;
int winner = -2;
int card;
int playerTurn;
int validMoves;
int splitSpaces;
int bumpedPawn;
int targetPawn;

void setup() {
  size(980,600);
  winner = -2;
  DRAWN_CARD = false;
  CAN_SLIDE = false;
  movedPawn1 = null;
  movedPawn2 = null;
  mouseCoords = new int[2];
  selectedPawn = new int[2];
  
  // START and HOME int arrays to keep track of pawns at START and HOME
  start = new int[4];
  home = new int[4];
  for (int i=0; i<4; i++) {
    start[i] = 3;
    home[i] = 0;
  }
  
  // 16x16 int array to help track the pawns
  boardData = new int[16][16];
  for (int i=0; i<boardData.length; i++) {
    for (int j=0; j<boardData[i].length; j++) {
      boardData[i][j] = -1;
    }
  }
  
  // Sets data for 1 pawn out of start
  boardData[0][4] = 0;
  boardData[4][15] = 1;
  boardData[15][11] = 2;
  boardData[11][0] = 3;
  
  // Board layout
  gameBoard = new Board(width/20,height/10,16,16,30);
  
  // START spaces
  space1 = new Space(1,4,1,0);
  gameBoard.addSpace(space1);
  space1 = new Space(4,14,1,1);
  gameBoard.addSpace(space1);
  space1 = new Space(14,11,1,2);
  gameBoard.addSpace(space1);
  space1 = new Space(11,1,1,3);
  gameBoard.addSpace(space1);
  
  // Safety Zones
  for (int i=0; i<4; i++) {
    for (int j=0; j<5; j++) {
      switch(i) {
        case 0:
          space1 = new Space(j+1,2,0,0);
          break;
        case 1:
          space1 = new Space(2,j+10,0,1);
          break;
        case 2:
          space1 = new Space(j+10,13,0,2);
          break;
        case 3:
          space1 = new Space(13,j+1,0,3);
      }
      gameBoard.addSpace(space1);
    }
  }
  
  // Normal Spaces
  for (int i=0; i<16; i++) {
    space1 = new Space(0,i,0,-1);
    space2 = new Space(15,i,0,-1);
    gameBoard.addSpace(space1);
    gameBoard.addSpace(space2);
  }
  for (int i=1; i<15; i++) {
    space1 = new Space(i,0,0,-1);
    space2 = new Space(i,15,0,-1);
    gameBoard.addSpace(space1);
    gameBoard.addSpace(space2);
  }
  
  // HOME spaces
  space1 = new Space(6,2,2,0);
  gameBoard.addSpace(space1);
  space1 = new Space(2,9,2,1);
  gameBoard.addSpace(space1);
  space1 = new Space(9,13,2,2);
  gameBoard.addSpace(space1);
  space1 = new Space(13,6,2,3);
  gameBoard.addSpace(space1);
  
  
  // Initializing Cards
  card1 = null;
  card2 = null;
  card3 = null;
}

void draw() {
  background(150);
  
  // In-game
  if (winner >= -1) {
    gameBoard.show();
    fill(0);
    textSize(30);
    textAlign(CENTER,CENTER);
    if (ACTIVE_PLAYERS[0]) {
      fill(0);
      text(start[0],185,141);
      if (winner == 0)
        fill(255,0,0);
      text(home[0],160,254);
    }
    if (ACTIVE_PLAYERS[1]) {
      fill(0);
      text(start[1],449,195);
      if (winner == 1)
        fill(0,0,255);
      text(home[1],335,171);
    }
    if (ACTIVE_PLAYERS[2]) {
      fill(0);
      text(start[2],394,458);
      if (TEAMS) {
        if (winner == 0)
          fill(255,255,0);
      } else {
        if (winner == 2)
          fill(255,255,0);
      }
      text(home[2],417,345);
    }
    if (ACTIVE_PLAYERS[3]) {
      fill(0);
      text(start[3],130,404);
      if (TEAMS) {
        if (winner == 1)
          fill(0,255,0);
      } else {
        if (winner == 3)
          fill(0,255,0);
      }
      text(home[3],244,428);
    }
    if (card1 != null) {
      textSize(16);
      fill(0);
      text(card1.instruction(),840,height/2);
      card1.show(640,height/2);
    } else {
      pushMatrix();
      translate(640,height/2);
      rectMode(CENTER);
      fill(50);
      stroke(50);
      strokeWeight(5);
      rect(0,0,120,160);
      popMatrix();
    }
    if (card2 != null) {
      textSize(16);
      fill(0);
      text(card2.instruction(),840,(height/2)-200);
      card2.show(640,(height/2)-200);
    }
    if (card3 != null) {
      textSize(16);
      fill(0);
      text(card3.instruction(),840,(height/2)+200);
      card3.show(640,(height/2)+200);
    }
    fill(0);
    textAlign(CENTER,CENTER);
    textSize(15);
    textSize(25);
    if (TEAMS)
      text("Team Game",290,565);
    else
      text("Solo Game",290,565);
    textSize(30);
    if (winner == -1) {
      if (DRAWN_CARD) {
        if (TURN_SKIPPED)
          text("Turn is invalid",290,height/2);
        else if (DRAWN_THREE)
          text("Choose a card",290,height/2);
        else
          text("Make your move",290,height/2);
      } else {
        text("Draw a card",290,height/2);
      }
      switch(playerTurn) {
        case 0:
          text("Red's turn",290,25);
          break;
        case 1:
          text("Blue's turn",290,25);
          break;
        case 2:
          text("Yellow's turn",290,25);
          break;
        case 3:
          text("Green's turn",290,25);
          break;
      }
    } else {
      
      // Displays the winner at the end of the game
      if (TEAMS) {
        if (winner == 0)
          text("Red and Yellow win!",300,25);
        else
          text("Green and Blue win!",300,25);
      } else {
        switch(winner) {
          case 0:
            text("Red wins!",300,25);
            break;
          case 1:
            text("Blue wins!",300,25);
            break;
          case 2:
            text("Yellow wins!",300,25);
            break;
          case 3:
            text("Green wins!",300,25);
            break;
        }
      }
    }
  
  // Main menu
  } else {
    fill(100);
    noStroke();
    rectMode(CENTER);
    rect(width/2,408,150,80);
    rect(650,240,230,50);
    rect(650,300,230,50);
    fill(0);
    textSize(50);
    textAlign(CENTER,CENTER);
    if (players < 2)
      text("---",width/2-1,405);
    else
      text("Start",width/2-1,405);
    text("Sorry!",width/2-1,50);
    textSize(25);
    text("Recreated by Michael Vollmer",width/2-1,110);
    textSize(20);
    text("* Teams: Red and Yellow vs Blue and Green (4 players required)",width/2,555);
    textSize(35);
    if (SPECIAL_CARDS)
      text("Enabled",650,239);
    else
      text("Disabled",650,239);
    if (players < 4){
        text("---",650,299);
    } else {
      if (TEAMS)
        text("Enabled",650,299);
      else
        text("Disabled",650,299);
    }
    textAlign(LEFT,CENTER);
    text("Players:",230,180);
    text("Special cards:",230,240);
    text("Teams*:",230,300);
    strokeWeight(5);
    stroke(255,0,0);
    if (ACTIVE_PLAYERS[0])
      fill(255,0,0);
    else
      fill(150);
    rect(560,180,45,45);
    stroke(0,0,255);
    if (ACTIVE_PLAYERS[1])
      fill(0,0,255);
    else
      fill(150);
    rect(620,180,45,45);
    stroke(255,255,0);
    if (ACTIVE_PLAYERS[2])
      fill(255,255,0);
    else
      fill(150);
    rect(680,180,45,45);
    stroke(0,255,0);
    if (ACTIVE_PLAYERS[3])
      fill(0,255,0);
    else
      fill(150);
    rect(740,180,45,45);
  }
}

void mousePressed() {
  mouseCoords = gameBoard.getCoords(mouseX,mouseY);
  
  // Makes sure the values in mouseCoords are ints, otherwise the game won't work in the browser
  if (mouseY >= height/10)
    mouseCoords[0] = (int)mouseCoords[0];
  if (mouseX >= width/20)
    mouseCoords[1] = (int)mouseCoords[1];
  
  
  if (winner == -1) {
    if (mouseButton == LEFT) {
      
      // Handling of cards
      if (mouseX >= 580 && mouseX <= 700) {
        if (mouseY >= (height/2)-80 && mouseY <= (height/2)+80) {
          if (!DRAWN_CARD) {
            drawOne();
            DRAWN_CARD = true;
            TURN_SKIPPED = false;
            TURN_SKIPPED2 = false;
            splitSpaces = 0;
            SPLIT = false;
            CARD_VALID = checkCard(card1);
          } else if (DRAWN_THREE) {
            if (CARD1_VALID) {
              card2 = null;
              card3 = null;
              DRAWN_THREE = false;
            }
          } else {
            if (card1.cardSpecialPlayer() == playerTurn && card1.cardValue() == 3) {
              drawThree();
              CARD_VALID = false;
              CARD1_VALID = checkCard(card1);
              CARD2_VALID = checkCard(card2);
              CARD3_VALID = checkCard(card3);
              if (CARD1_VALID || CARD2_VALID || CARD3_VALID)
               CARD_VALID = true;
            }
          }
        } else if (mouseY >= ((height/2)-80)-200 && mouseY <= ((height/2)+80)-200) {
          if (CARD2_VALID) {
            card1 = card2;
            card2 = null;
            card3 = null;
            DRAWN_THREE = false;
          }
        } else if (mouseY >= ((height/2)-80)+200 && mouseY <= ((height/2)+80)+200) {
          if (CARD3_VALID) {
            card1 = card3;
            card2 = null;
            card3 = null;
            DRAWN_THREE = false;
          }
        }
        
      // Handling of Pawn Movement
      } else {
        if (DRAWN_CARD && !DRAWN_THREE && CARD_VALID) {
          if (card1.cardValue() == 1 || card1.cardValue() == 2) {
            switch(playerTurn) {
              case 0:
                checkedPawn = gameBoard.findPawn(0,4);
                if (mouseCoords[0] == 1 && mouseCoords[1] == 4) {
                  if (checkedPawn == null || checkedPawn.getId() != 0) {
                    if (start[0] > 0) {
                      movedPawn1 = new Pawn(0,4,0,false);
                      gameBoard.addPawn(movedPawn1);
                      start[0]--;
                      MOVED_PAWN = true;
                    }
                  }
                }
                if (TEAMS && !MOVED_PAWN) {
                  checkedPawn = gameBoard.findPawn(15,11);
                  if (mouseCoords[0] == 14 && mouseCoords[1] == 11) {
                    if (checkedPawn == null || checkedPawn.getId() != 2) {
                      if (start[2] > 0) {
                        movedPawn1 = new Pawn(15,11,2,false);
                        gameBoard.addPawn(movedPawn1);
                        start[2]--;
                        MOVED_PAWN = true;
                      }
                    }
                  }
                }
                break;
              case 1:
                checkedPawn = gameBoard.findPawn(4,15);
                if (mouseCoords[0] == 4 && mouseCoords[1] == 14) {
                  if (checkedPawn == null || checkedPawn.getId() != 1) {
                    if (start[1] > 0) {
                      movedPawn1 = new Pawn(4,15,1,false);
                      gameBoard.addPawn(movedPawn1);
                      start[1]--;
                      MOVED_PAWN = true;
                    }
                  }
                }
                if (TEAMS && !MOVED_PAWN) {
                  checkedPawn = gameBoard.findPawn(11,0);
                  if (mouseCoords[0] == 11 && mouseCoords[1] == 1) {
                    if (checkedPawn == null || checkedPawn.getId() != 3) {
                      if (start[3] > 0) {
                        movedPawn1 = new Pawn(11,0,3,false);
                        gameBoard.addPawn(movedPawn1);
                        start[3]--;
                        MOVED_PAWN = true;
                      }
                    }
                  }
                }
                break;
              case 2:
                checkedPawn = gameBoard.findPawn(15,11);
                if (mouseCoords[0] == 14 && mouseCoords[1] == 11) {
                  if (checkedPawn == null || checkedPawn.getId() != 2) {
                    if (start[2] > 0) {
                      movedPawn1 = new Pawn(15,11,2,false);
                      gameBoard.addPawn(movedPawn1);
                      start[2]--;
                      MOVED_PAWN = true;
                    }
                  }
                }
                if (TEAMS && !MOVED_PAWN) {
                  checkedPawn = gameBoard.findPawn(0,4);
                  if (mouseCoords[0] == 1 && mouseCoords[1] == 4) {
                    if (checkedPawn == null || checkedPawn.getId() != 0) {
                      if (start[0] > 0) {
                        movedPawn1 = new Pawn(0,4,0,false);
                        gameBoard.addPawn(movedPawn1);
                        start[0]--;
                        MOVED_PAWN = true;
                      }
                    }
                  }
                }
                break;
              case 3:
                checkedPawn = gameBoard.findPawn(11,0);
                if (mouseCoords[0] == 11 && mouseCoords[1] == 1) {
                  if (checkedPawn == null || checkedPawn.getId() != 3) {
                    if (start[3] > 0) {
                      movedPawn1 = new Pawn(11,0,3,false);
                      gameBoard.addPawn(movedPawn1);
                      start[3]--;
                      MOVED_PAWN = true;
                    }
                  }
                }
                if (TEAMS && !MOVED_PAWN) {
                  checkedPawn = gameBoard.findPawn(4,15);
                  if (mouseCoords[0] == 4 && mouseCoords[1] == 14) {
                    if (checkedPawn == null || checkedPawn.getId() != 1) {
                      if (start[1] > 0) {
                        movedPawn1 = new Pawn(4,15,1,false);
                        gameBoard.addPawn(movedPawn1);
                        start[1]--;
                        MOVED_PAWN = true;
                      }
                    }
                  }
                }
                break;
            }
            if (!MOVED_PAWN) {
              movedPawn1 = gameBoard.findPawn(mouseCoords[0],mouseCoords[1]);
              VALID_MOVE = gameBoard.validateForward(mouseCoords[0],mouseCoords[1],card1.cardValue());
              if (VALID_MOVE)
                MOVED_PAWN = gameBoard.pawnForward(mouseCoords[0],mouseCoords[1],card1.cardValue(),playerTurn,TEAMS);
            }
          } else if (card1.cardValue() == 4) {
            movedPawn1 = gameBoard.findPawn(mouseCoords[0],mouseCoords[1]);
            VALID_MOVE = gameBoard.validateBackward(mouseCoords[0],mouseCoords[1],card1.cardValue());
            if (VALID_MOVE)
              MOVED_PAWN = gameBoard.pawnBackward(mouseCoords[0],mouseCoords[1],card1.cardValue(),playerTurn,TEAMS,true);
          } else if (card1.cardValue() == 7) {
            if (splitSpaces > 0) {
              movedPawn1 = gameBoard.findPawn(mouseCoords[0],mouseCoords[1]);
              MOVED_PAWN = gameBoard.splitMove(mouseCoords[0],mouseCoords[1],7-splitSpaces, playerTurn,TEAMS);
            } else {
              movedPawn1 = gameBoard.findPawn(mouseCoords[0],mouseCoords[1]);
              VALID_MOVE = gameBoard.validateForward(mouseCoords[0],mouseCoords[1],card1.cardValue());
              if (VALID_MOVE)
                MOVED_PAWN = gameBoard.pawnForward(mouseCoords[0],mouseCoords[1],card1.cardValue(), playerTurn,TEAMS);
            }
          } else if (card1.cardValue() == 11) {
            if (!gameBoard.selectedPawn()) {
              movedPawn1 = gameBoard.findPawn(mouseCoords[0],mouseCoords[1]);
              VALID_MOVE = gameBoard.validateForward(mouseCoords[0],mouseCoords[1],card1.cardValue());
              if (VALID_MOVE)
                MOVED_PAWN = gameBoard.pawnForward(mouseCoords[0],mouseCoords[1],card1.cardValue(),playerTurn,TEAMS);
            } 
          } else if (card1.cardValue() == 13) {
            movedPawn1 = gameBoard.sorry(mouseCoords[0],mouseCoords[1],playerTurn);
            if (movedPawn1 != null) {
              start[playerTurn]--;
              MOVED_PAWN = true;
            }
          } else {
            movedPawn1 = gameBoard.findPawn(mouseCoords[0],mouseCoords[1]);
            VALID_MOVE = gameBoard.validateForward(mouseCoords[0],mouseCoords[1],card1.cardValue());
            if (VALID_MOVE)
              MOVED_PAWN = gameBoard.pawnForward(mouseCoords[0],mouseCoords[1],card1.cardValue(),playerTurn,TEAMS);
          }
          bumpCheck(SPLIT);
          slidePawns();
        }
      }
      
      // Ending a player's turn
      if (TURN_SKIPPED) {
        validMoves = -1;
        nextTurn();
        TURN_SKIPPED = false;
        TURN_SKIPPED2 = true;
      }
      if (!CARD_VALID && !TURN_SKIPPED2) {
        if (card1 != null && card1.cardValue() == 2) {
          DRAWN_CARD = false;
        } else {
          TURN_SKIPPED = true;
        }
      }
      if (MOVED_PAWN && card1.cardValue() != 2) {
        checkHome(playerTurn);
        nextTurn();
      } else if (MOVED_PAWN && card1.cardValue() == 2) {
        MOVED_PAWN = false;
        DRAWN_CARD = false;
        gameBoard.checkLead();
        checkHome(playerTurn);
      }
    
    // Alternate functions of cards
    } else if (mouseButton == RIGHT) {
      if (DRAWN_CARD && validMoves > 0) {
        if (card1.cardValue() == 5) {
          if (gameBoard.opponentCount(playerTurn,true) > 0) {
            if (SPECIAL_CARDS && card1.cardSpecialPlayer() == playerTurn) {
              if (PAWN_SELECTED) {
                if (gameBoard.moveAhead(selectedPawn[0],selectedPawn[1],mouseCoords[0],mouseCoords[1])) {
                  bumpCheck(SPLIT);
                  slidePawns();
                  nextTurn();
                } else {
                  PAWN_SELECTED = gameBoard.selectPawn(mouseCoords[0],mouseCoords[1],playerTurn,TEAMS);
                  if (PAWN_SELECTED) {
                    selectedPawn[0] = mouseCoords[0];
                    selectedPawn[1] = mouseCoords[1];
                  }
                }
              } else {
                PAWN_SELECTED = gameBoard.selectPawn(mouseCoords[0],mouseCoords[1],playerTurn,TEAMS);
                if (PAWN_SELECTED) {
                  selectedPawn[0] = mouseCoords[0];
                  selectedPawn[1] = mouseCoords[1];
                }
              }
            }
          }
        } else if (card1.cardValue() == 7) {
          if (gameBoard.pawnCount(playerTurn,TEAMS) > 1) {
            gameBoard.splitPawn(mouseCoords[0],mouseCoords[1],playerTurn,TEAMS);
            if (gameBoard.splitValue() != 0) {
              SPLIT = true;
              if (gameBoard.findPawn(mouseCoords[0],mouseCoords[1]) != null)
                movedPawn2 = gameBoard.findPawn(mouseCoords[0],mouseCoords[1]);
              splitSpaces = gameBoard.splitValue();
            }
          }
        } else if (card1.cardValue() == 8) {
          if (SPECIAL_CARDS && card1.cardSpecialPlayer() % 2 == playerTurn % 2) {
            movedPawn1 = gameBoard.findPawn(mouseCoords[0],mouseCoords[1]);
            if (movedPawn1 != null)
              targetPawn = movedPawn1.getId();
            else
              targetPawn = -1;
            if (targetPawn != -1 && targetPawn % 2 != playerTurn % 2) {
              VALID_MOVE = gameBoard.validateBackward(mouseCoords[0],mouseCoords[1],8);
              if (VALID_MOVE)
                MOVED_PAWN = gameBoard.pawnBackward(mouseCoords[0],mouseCoords[1],8,targetPawn,TEAMS,false);
              bumpCheck(SPLIT);
              slidePawns();
            }
          }
        } else if (card1.cardValue() == 10) {
          movedPawn1 = gameBoard.findPawn(mouseCoords[0],mouseCoords[1]);
          VALID_MOVE = gameBoard.validateBackward(mouseCoords[0],mouseCoords[1],1);
          if (VALID_MOVE)
            MOVED_PAWN = gameBoard.pawnBackward(mouseCoords[0],mouseCoords[1],1,playerTurn,TEAMS,true);
          bumpCheck(SPLIT);
          slidePawns();
        } else if (card1.cardValue() == 11) {
          if (gameBoard.opponentCount(playerTurn,TEAMS) > 0) {
            if (PAWN_SELECTED) {
              if (gameBoard.switchPawns(selectedPawn[0],selectedPawn[1],mouseCoords[0],mouseCoords[1],TEAMS)) {
                nextTurn();
              } else {
                PAWN_SELECTED = gameBoard.selectPawn(mouseCoords[0],mouseCoords[1],playerTurn,TEAMS);
                if (PAWN_SELECTED) {
                  selectedPawn[0] = mouseCoords[0];
                  selectedPawn[1] = mouseCoords[1];
                }
              }
            } else {
              PAWN_SELECTED = gameBoard.selectPawn(mouseCoords[0],mouseCoords[1],playerTurn,TEAMS);
              if (PAWN_SELECTED) {
                selectedPawn[0] = mouseCoords[0];
                selectedPawn[1] = mouseCoords[1];
              }
            }
          }
        } else if (card1.cardValue() == 12) {
          if (SPECIAL_CARDS && card1.cardSpecialPlayer() % 2 == playerTurn % 2) {
            MOVED_PAWN = gameBoard.instantHome(mouseCoords[0],mouseCoords[1],playerTurn);
            if (MOVED_PAWN) {
              home[playerTurn]++;
              winCheck();
            }
          }
        }
      }
      if (MOVED_PAWN) {
        nextTurn();
      }
    }
  
  // Handling mouse clicks in the main menu
  } else if (winner == -2) {
    
    // Player selection
    if (mouseY >= 155 && mouseY <= 205) {
      if (mouseX >= 535 && mouseX <= 585) {
        if (!ACTIVE_PLAYERS[0]) {
          ACTIVE_PLAYERS[0] = true;
          players++;
        } else {
          ACTIVE_PLAYERS[0] = false;
          players--;
        }
      } else if (mouseX >= 595 && mouseX <= 645) {
        if (!ACTIVE_PLAYERS[1]) {
          ACTIVE_PLAYERS[1] = true;
          players++;
        } else {
          ACTIVE_PLAYERS[1] = false;
          players--;
        }
      } else if (mouseX >= 655 && mouseX <= 705) {
        if (!ACTIVE_PLAYERS[2]) {
          ACTIVE_PLAYERS[2] = true;
          players++;
        } else {
          ACTIVE_PLAYERS[2] = false;
          players--;
        }
      } else if (mouseX >= 715 && mouseX <= 765) {
        if (!ACTIVE_PLAYERS[3]) {
          ACTIVE_PLAYERS[3] = true;
          players++;
        } else {
          ACTIVE_PLAYERS[3] = false;
          players--;
        }
      }
      if (TEAMS && players < 4) {
        TEAMS = false;
      }
    
    // Team game option
    } else if (mouseY >= 275 && mouseY <= 325) {
      if (mouseX >= 535 && mouseX <= 765) {
        if (!TEAMS) {
          if (players == 4) {
            TEAMS = true;
          }
        } else {
          TEAMS = false;
        }
      }
    
    // Special cards option
    } else if (mouseY >= 215 && mouseY <= 265) {
      if (mouseX >= 535 && mouseX <= 765) {
        if (!SPECIAL_CARDS) {
          SPECIAL_CARDS = true;
        } else {
          SPECIAL_CARDS = false;
        }
      }
    
    // Starts the game
    } else if (mouseY >= 368 && mouseY <= 448) {
      if (mouseX >= 415 && mouseX <= 565) {
        gameDeck = new Deck(SPECIAL_CARDS);
        gameDeck.shuffleCards();
        gameBoard.purge();
        if (players >= 2) {
          if (ACTIVE_PLAYERS[0]) {
            thePawn = new Pawn(0,4,0,false);
            gameBoard.addPawn(thePawn);
          }
          if (ACTIVE_PLAYERS[1]) {
            thePawn = new Pawn(4,15,1,false);
            gameBoard.addPawn(thePawn);
          }
          if (ACTIVE_PLAYERS[2]) {
            thePawn = new Pawn(15,11,2,false);
            gameBoard.addPawn(thePawn);
          }
          if (ACTIVE_PLAYERS[3]) {
            thePawn = new Pawn(11,0,3,false);
            gameBoard.addPawn(thePawn);
          }
          pickFirstPlayer();
          gameBoard.checkLead();
          winner = -1;
        }
      }
    }
  
  // Returns to the main menu if there are any clicks after a player has won
  } else {
    setup();
  }
}

void keyPressed() {
  
  // Cancels any selections made with 7, 11, or Special 5 cards
  if (keyCode == 32) {
    if (card1 != null) {
      if (card1.cardValue() == 7) {
        SPLIT = false;
        movedPawn2 = null;
        splitSpaces = 0;
      } else if (card1.cardValue() == 11) {
        if (SKIPPABLE && !gameBoard.selectedPawn())
          nextTurn();
      }
      gameBoard.resetSelection();
    }
  }
  
}

// Chooses a player to go first at the start of the game
void pickFirstPlayer() {
  playerTurn = (int)random(4);
  if (!ACTIVE_PLAYERS[playerTurn]) {
    pickFirstPlayer();
  }
}

// Checks for any pawns on HOME
void checkHome(int player) {
  PAWN_HOME = false;
  if (TEAMS) {
    if (player % 2 == 0) {
      if (gameBoard.removePawn(6,2)) {
        home[0]++;
        PAWN_HOME = true;
      }
      if (gameBoard.removePawn(9,13)) {
        home[2]++;
        PAWN_HOME = true;
      }
    } else {
      if (gameBoard.removePawn(2,9)) {
        home[1]++;
        PAWN_HOME = true;
      }
      if (gameBoard.removePawn(13,6)) {
        home[3]++;
        PAWN_HOME = true;
      }
    }
  } else {
    switch(player) {
      case 0:
        if (gameBoard.removePawn(6,2)) {
          home[0]++;
          PAWN_HOME = true;
        }
        break;
      case 1:
        if (gameBoard.removePawn(2,9)) {
          home[1]++;
          PAWN_HOME = true;
        }
        break;
      case 2:
        if (gameBoard.removePawn(9,13)) {
          home[2]++;
          PAWN_HOME = true;
        }
        break;
      case 3:
        if (gameBoard.removePawn(13,6)) {
          home[3]++;
          PAWN_HOME = true;
        }
        break;
    }
  }
  winCheck();
  if (PAWN_HOME) {
    checkHome(player);
  }
}

// Checks if a player has won the game
void winCheck() {
  if (TEAMS) {
    if (home[0] + home[2] == 8)
      winner = 0;
    else if (home[1] + home[3] == 8)
      winner = 1;
  } else {
    if (home[0] == 4)
      winner = 0;
    else if (home[1] == 4)
      winner = 1;
    else if (home[2] == 4)
      winner = 2;
    else if (home[3] == 4)
      winner = 3;
  }
}

// Moves on to the next player's turn
void nextTurn() {
  MOVED_PAWN = false;
  SKIPPABLE = false;
  DRAWN_CARD = false;
  DRAWN_THREE = false;
  movedPawn1 = null;
  movedPawn2 = null;
  CARD1_VALID = false;
  CARD2_VALID = false;
  CARD3_VALID = false;
  card1 = null;
  card2 = null;
  card3 = null;
  gameBoard.checkLead();
  gameBoard.resetSelection();
  gameBoard.resetInspector();
  selectedPawn[0] = -1;
  selectedPawn[1] = -1;
  if (playerTurn == 3) {
    playerTurn = 0;
  } else {
    playerTurn++;
  }
  if (!ACTIVE_PLAYERS[playerTurn])
    nextTurn();
}

// Handles slides on the game side
void slidePawns() {
  gameBoard.slideCheck();
  SLIDE = gameBoard.slidingPawns();
  if (SLIDE) {
    bumpedPawn = gameBoard.slideMove();
    if (bumpedPawn > -1) {
      start[bumpedPawn]++;
      gameBoard.checkLead();
    }
  }
  gameBoard.slideCheck();
  SLIDE = gameBoard.slidingPawns();
  if (SLIDE) {
    slidePawns();
  }
}

// Draws a card to play
void drawOne() {
  if (!DRAWN_CARD) {
    DRAWN_CARD = true;
    card1 = gameDeck.drawCard(card);
    card++;
  }
  if (card == 45) {
    gameDeck.shuffleCards();
    card = 0;
  }
}

// Draws three cards in the event of a player using their special 3
void drawThree() {
  DRAWN_THREE = true;
  card1 = gameDeck.drawCard(card);
  card++;
  if (card == 45) {
    gameDeck.shuffleCards();
    card = 0;
  }
  card2 = gameDeck.drawCard(card);
  card++;
  if (card == 45) {
    gameDeck.shuffleCards();
    card = 0;
  }
  card3 = gameDeck.drawCard(card);
  card++;
  if (card == 45) {
    gameDeck.shuffleCards();
    card = 0;
  }
}

// Checks to see if a card can be played properly
boolean checkCard(Card theCard) {
  if (theCard.cardValue() == 1 || theCard.cardValue() == 2) {
    validMoves = gameBoard.validateTotalForward(playerTurn,theCard.cardValue(),TEAMS);
    if (TEAMS) {
      if (start[playerTurn % 2] > 0)
        validMoves++;
      if (start[(playerTurn % 2) + 2] > 0)
        validMoves++;
    } else {
      if (start[playerTurn] > 0)
        validMoves++;
    }
  } else if (theCard.cardValue() == 3) {
    if (SPECIAL_CARDS && card1.cardSpecialPlayer() == playerTurn) {
      validMoves = gameBoard.validateTotalForward(playerTurn,card1.cardValue(),TEAMS)+1;
    } else {
      validMoves = gameBoard.validateTotalForward(playerTurn,card1.cardValue(),TEAMS);
    }
  } else if (theCard.cardValue() == 4) {
    validMoves = gameBoard.validateTotalBackward(playerTurn,theCard.cardValue(),TEAMS);
  } else if (theCard.cardValue() == 7) {
    VALID = gameBoard.validateSeven(playerTurn,TEAMS);
    validMoves = gameBoard.validateTotalForward(playerTurn,theCard.cardValue(),TEAMS);
    if (VALID)
      validMoves += 1;
  } else if (theCard.cardValue() == 8) {
    validMoves = gameBoard.validateTotalForward(playerTurn,theCard.cardValue(),TEAMS);
    if (SPECIAL_CARDS && theCard.cardSpecialPlayer() % 2 == playerTurn % 2) {
      if (playerTurn % 2 == 0) {
        validMoves += gameBoard.validateTotalBackward(1,theCard.cardValue(),TEAMS);
        validMoves += gameBoard.validateTotalBackward(3,theCard.cardValue(),TEAMS);
      } else {
        validMoves += gameBoard.validateTotalBackward(0,theCard.cardValue(),TEAMS);
        validMoves += gameBoard.validateTotalBackward(2,theCard.cardValue(),TEAMS);
      }
    }
  } else if (theCard.cardValue() == 10) {
    validMoves = gameBoard.validateTotalForward(playerTurn,theCard.cardValue(),TEAMS);
    validMoves += gameBoard.validateTotalBackward(playerTurn,1,TEAMS);
  } else if (theCard.cardValue() == 11) {
    validMoves = gameBoard.validateTotalForward(playerTurn,theCard.cardValue(),TEAMS);
    if (validMoves == 0 && gameBoard.opponentCount(playerTurn,TEAMS) > 0)
      SKIPPABLE = true;
    else
      SKIPPABLE = false;
    if (gameBoard.boardPawnCount(playerTurn,TEAMS) > 0)
      validMoves += gameBoard.opponentCount(playerTurn,TEAMS);
  } else if (theCard.cardValue() == 12) {
    validMoves = gameBoard.validateTotalForward(playerTurn,card1.cardValue(),TEAMS);
    if (SPECIAL_CARDS && card1.cardSpecialPlayer() % 2 == playerTurn % 2 && gameBoard.pawnCount(playerTurn,false) > 0) {
      validMoves++;
    }
  } else if (theCard.cardValue() == 13) {
    if (start[playerTurn] == 0)
      validMoves = 0;
    else
      validMoves = gameBoard.opponentCount(playerTurn,false);
  } else {
    validMoves = gameBoard.validateTotalForward(playerTurn,theCard.cardValue(),TEAMS);
  }
  if (validMoves > 0)
    return true;
  return false;
}

// Checks for any pawns that have been bumped back to START
void bumpCheck(boolean sevenSplit) {
  if (movedPawn1 != null) {
    switch (movedPawn1.getId()) {
      case 0:
        bumpedPawn = gameBoard.bumpPawn(0);
        if (bumpedPawn > -1)
          start[bumpedPawn]++;
        break;
      case 1:
        bumpedPawn = gameBoard.bumpPawn(1);
        if (bumpedPawn > -1)
          start[bumpedPawn]++;
        break;
      case 2:
        bumpedPawn = gameBoard.bumpPawn(2);
        if (bumpedPawn > -1)
          start[bumpedPawn]++;
        break;
      case 3:
        bumpedPawn = gameBoard.bumpPawn(3);
        if (bumpedPawn > -1)
          start[bumpedPawn]++;
        break;
    }
    if (bumpedPawn > -1)
      gameBoard.checkLead();
  }
  if (sevenSplit) {
    if (movedPawn2 != null) {
      switch (movedPawn2.getId()) {
        case 0:
          bumpedPawn = gameBoard.bumpPawn(0);
          if (bumpedPawn > -1)
            start[bumpedPawn]++;
          break;
        case 1:
          bumpedPawn = gameBoard.bumpPawn(1);
          if (bumpedPawn > -1)
            start[bumpedPawn]++;
          break;
        case 2:
          bumpedPawn = gameBoard.bumpPawn(2);
          if (bumpedPawn > -1)
            start[bumpedPawn]++;
          break;
        case 3:
          bumpedPawn = gameBoard.bumpPawn(3);
          if (bumpedPawn > -1)
            start[bumpedPawn]++;
          break;
      }
      if (bumpedPawn > -1)
        gameBoard.checkLead();
    }
  }
}
