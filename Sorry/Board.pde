public class Board {
  
  Inspector inspector1;
  Inspector inspector2;
  Slide theSlide;
  
  int x_pos, y_pos;
  int xAt, yAt;
  int cellSize;
  int rows, cols;
  int[][] layer;
  ArrayList<Space> spaces;
  ArrayList<Pawn> pawns;
  ArrayList<Slide> slides;
  
  // Initialization of Game Board
  public Board(int x, int y, int numRows, int numCols, int cellSize) {
    x_pos = x;
    y_pos = y;
    rows = numRows;
    cols = numCols;
    this.cellSize = cellSize;
    inspector1 = new Inspector(-1,-1,-1,false);
    inspector2 = new Inspector(-1,-1,-1,false);
    layer = null;
    spaces = new ArrayList<Space>();
    pawns = new ArrayList<Pawn>();
    slides = new ArrayList<Slide>();
    
    // Slide spaces
    theSlide = new Slide(0,1,0,0,3);
    slides.add(theSlide);
    theSlide = new Slide(0,4,0,1,0);
    slides.add(theSlide);
    theSlide = new Slide(0,10,0,0,4);
    slides.add(theSlide);
    theSlide = new Slide(0,14,0,1,0);
    slides.add(theSlide);
    theSlide = new Slide(1,15,1,0,3);
    slides.add(theSlide);
    theSlide = new Slide(4,15,1,1,0);
    slides.add(theSlide);
    theSlide = new Slide(10,15,1,0,4);
    slides.add(theSlide);
    theSlide = new Slide(14,15,1,1,0);
    slides.add(theSlide);
    theSlide = new Slide(15,14,2,0,3);
    slides.add(theSlide);
    theSlide = new Slide(15,11,2,1,0);
    slides.add(theSlide);
    theSlide = new Slide(15,5,2,0,4);
    slides.add(theSlide);
    theSlide = new Slide(15,1,2,1,0);
    slides.add(theSlide);
    theSlide = new Slide(14,0,3,0,3);
    slides.add(theSlide);
    theSlide = new Slide(11,0,3,1,0);
    slides.add(theSlide);
    theSlide = new Slide(5,0,3,0,4);
    slides.add(theSlide);
    theSlide = new Slide(1,0,3,1,0);
    slides.add(theSlide);
  }
  
  public void show() {
    pushMatrix();
    translate(x_pos,y_pos);
    for (int j=0; j<rows; j++) {
      for (int i=0; i<cols; i++) {
        xAt = i*cellSize;
        yAt = j*cellSize;
        noStroke();
        fill(150);
        rect(xAt,yAt,cellSize,cellSize);
        
        drawLayerCell(j,i,xAt,yAt);
        
      }
    }
    xAt = inspector1.col()*cellSize;
    yAt = inspector1.row()*cellSize;
    xAt = inspector2.col()*cellSize;
    yAt = inspector2.row()*cellSize;
    for (Space s: spaces) {
      xAt = s.col()*cellSize;
      yAt = s.row()*cellSize;
      s.show(xAt,yAt,cellSize);
    }
    for (Slide s: slides) {
      xAt = s.col()*cellSize;
      yAt = s.row()*cellSize;
      s.show(xAt,yAt,cellSize);
    }
    for (Pawn p: pawns) {
      xAt = p.col()*cellSize;
      yAt = p.row()*cellSize;
      p.show(xAt,yAt,cellSize);
    }
    popMatrix();
  }
  
  // Adds spaces to board
  public void addSpace(Space s) {
    spaces.add(s);
  }
  
  // Adds pawns to board
  public void addPawn(Pawn p) {
    pawns.add(p);
  }
  
  protected void drawLayerCell(int rowId, int colId, int xPos, int yPos) {
    if (layer != null) {
      if (layer.length > rowId) {
        if (layer[rowId].length > colId) {
          rectMode(CORNER);
          int cellColor = layer[rowId][colId];
          fill(cellColor);
          rect(xPos,yPos,cellSize,cellSize);
        }
      }
    }
  }
  
  public void addLayer(int[][] theLayer) {
    this.layer = theLayer;
  }
  
  // Returns the number of pawns a player or team has active (Safety zone included)
  public int pawnCount(int player, boolean teams) {
    int count = 0;
    for (Pawn p: pawns) {
      if (teams) {
        if (p.getId() % 2 == player % 2)
          count++;
      } else {
        if (p.getId() == player)
          count++;
      }
    }
    return count;
  }
  
  // Returns the number of pawns a player or team has active (Safety zone not included)
  public int boardPawnCount(int player, boolean teams) {
    int count = 0;
    for (Pawn p: pawns) {
      if (teams) {
        if (p.getId() % 2 == player % 2 && !p.inSafetyZone())
        count++;
      } else {
      if (p.getId() == player && !p.inSafetyZone())
        count++;
      }
    }
    return count;
  }
  
  // Returns the number of pawns the opposing players or team has active (Safety zone not included)
  public int opponentCount(int player, boolean teams) {
    int count = 0;
    for (Pawn p: pawns) {
      if (teams) {
        if (p.getId() % 2 != player % 2 && !p.inSafetyZone())
          count++;
      } else {
        if (p.getId() != player && !p.inSafetyZone())
          count++;
      }
    }
    return count;
  }
  
  // Checks if the pawn is selected
  public boolean selectedPawn() {
    for (Pawn p: pawns) {
      if (p.isSelected())
        return true;
    }
    return false;
  }
  
  // Checks if the pawn can move forward legally
  public boolean validateForward(int row, int col, int value) {
    Pawn checkedPawn1 = findPawn(row,col);
    if (checkedPawn1 != null && checkedPawn1.spacesRemaining() >= value) {
      inspector1 = new Inspector(row,col,checkedPawn1.getId(),checkedPawn1.inSafetyZone());
      inspector1.moveForward(value);
      Pawn checkedPawn2 = findPawn(inspector1.row(),inspector1.col());
      if (checkedPawn2 == null) {
        if ((inspector1.row() == 6 && inspector1.col() == 2) && checkedPawn1.getId() == 0) {
          inspector1.updateRow(-1);
          inspector1.updateCol(-1);
        } else if ((inspector1.row() == 2 && inspector1.col() == 9) && checkedPawn1.getId() == 1) {
          inspector1.updateRow(-1);
          inspector1.updateCol(-1);
        } else if ((inspector1.row() == 9 && inspector1.col() == 13) && checkedPawn1.getId() == 2) {
          inspector1.updateRow(-1);
          inspector1.updateCol(-1);
        } else if ((inspector1.row() == 13 && inspector1.col() == 6) && checkedPawn1.getId() == 3) {
          inspector1.updateRow(-1);
          inspector1.updateCol(-1);
        }
        checkedPawn1.validateForward();
        return true;
      }
      if (checkedPawn2.isActive() || checkedPawn2.getId() != checkedPawn1.getId()) {
        checkedPawn1.validateForward();
        return true;
      }
    }
    return false;
  }
  
  // Checks if the pawn can move backward legally
  public boolean validateBackward(int row, int col, int value) {
    Pawn checkedPawn1 = findPawn(row,col);
    if (checkedPawn1 != null) { 
      inspector1 = new Inspector(row,col,checkedPawn1.getId(),checkedPawn1.inSafetyZone());
      inspector1.moveBackward(value);
      Pawn checkedPawn2 = findPawn(inspector1.row(),inspector1.col());
      if (checkedPawn2 == null) {
        checkedPawn1.validateBackward();
        return true;
      }
      if (checkedPawn2.getId() != checkedPawn1.getId()) {
        checkedPawn1.validateBackward();
        return true;
      }
    }
    return false;
  }
  
  // Returns the number of pawns that can move forward legally
  public int validateTotalForward(int player, int value, boolean teams) {
    int validPawns = 0;
    for (Pawn p: pawns) {
      if (teams) {
        if (p.getId() % 2 == player % 2) {
          if (validateForward(p.row(),p.col(),value))
            validPawns++;
        }
      } else {
        if (p.getId() == player) {
          if (validateForward(p.row(),p.col(),value))
            validPawns++;
        }
      }
    }
    return validPawns;
  }
  
  // Returns the number of pawns that can move backward legally
  public int validateTotalBackward(int player, int value, boolean teams) {
    int validPawns = 0;
    for (Pawn p: pawns) {
      if (teams) {
        if (p.getId() % 2 == player % 2) {
          if (validateBackward(p.row(),p.col(),value))
            validPawns++;
        }
      } else {
        if (p.getId() == player) {
          if (validateBackward(p.row(),p.col(),value))
            validPawns++;
        }
      }
    }
    return validPawns;
  }
  
  // Checks if a legal move can be made with a 7 card
  public boolean validateSeven(int player, boolean teams) {
    int spaces = 0;
    int one = 0;
    int two = 0;
    int three = 0;
    int four = 0;
    int high = 0;
    int pawnsActive = pawnCount(player,teams);
    for (Pawn p: pawns) {
      if (teams) {
        if (p.getId() % 2 == player % 2) {
          spaces += p.spacesRemaining();
          switch(p.spacesRemaining()) {
            case 1:
              one++;
              break;
            case 2:
              two++;
              break;
            case 3:
              three++;
              break;
            case 4:
              four++;
              break;
            default:
              high++;
              break;
          }
        }
      } else {
        if (p.getId() == player)
          spaces += p.spacesRemaining();
      }
    }
    if (spaces >= 7) {
      if (four == 0 && high == 0)
        return false;
      if (three == 0 && high == 0) {
        if (one == 2) {
          return false;
        }
      }
      if (spaces == 7 && pawnsActive > 2)
        return false;
      return true;
    }
    return false;
  }
  
  // Resets any selections made with a 7, 11, or special 5
  public void resetSelection() {
    for (Pawn p: pawns) {
      p.deactivate();
      p.deselect();
    }
  }
  
  // Sets each active player's leading pawn
  public void checkLead() {
    for (int i=0; i<4; i++) {
      int leadSpaces = 100;
      Pawn leadPawn = null;
      if (pawnCount(i,false) > 0) {
        for (Pawn p: pawns) {
          if (p.getId() == i) {
            p.setLead(false);
            if (p.spacesRemaining() < leadSpaces) {
              leadSpaces = p.spacesRemaining();
              leadPawn = p;
            }
          }
        }
        leadPawn.setLead(true);
      }
    }
  }
  
  // Selects a pawn for use with an 11 or special 5
  public boolean selectPawn(int row, int col, int player, boolean teams) {
    Pawn p1 = findPawn(row,col);
    for (Pawn p2: pawns) {
      p2.deselect();
    }
    if (p1 == null)
      return false;
    if (teams) {
      if (p1.getId() % 2 != player % 2 || p1.inSafetyZone())
        return false;
    } else {
      if (p1.getId() != player || p1.inSafetyZone())
        return false;
    }
    p1.select();
    return true;
  }
  
  // Swaps the positions of 2 pawns on the board
  public boolean switchPawns(int row1, int col1, int row2, int col2, boolean teams) {
    Pawn pawn1 = findPawn(row1,col1);
    Pawn pawn2 = findPawn(row2,col2);
    if (pawn1 == null || pawn2 == null)
      return false;
    if (pawn1.inSafetyZone() || pawn2.inSafetyZone())
      return false;
    if (teams) {
      if (pawn1.getId() % 2 == pawn2.getId() % 2)
        return false;
    } else {
      if (pawn1.getId() == pawn2.getId())
        return false;
    }
    pawn1.updateRow(row2);
    pawn1.updateCol(col2);
    pawn2.updateRow(row1);
    pawn2.updateCol(col1);
    pawn1.deselect();
    pawn2.deselect();
    pawn1.updateSpaces();
    pawn2.updateSpaces();
    return true;
  }
  
  // "Sorry" function - puts a player's pawn in the place of another player, sending them back to start
  public Pawn sorry(int row, int col, int player) {
    Pawn sorryPawn = findPawn(row,col);
    if (sorryPawn == null)
      return null;
    if (sorryPawn.inSafetyZone())
      return null;
    if (sorryPawn.getId() == player)
      return null;
    Pawn thePawn = new Pawn(row,col,player,false);
    pawns.add(thePawn);
    return thePawn;
  }
  
  // Returns the pawn at the given space
  public Pawn findPawn(int row, int col) {
    for (int i=0; i<pawns.size(); i++) {
      Pawn checkedPawn = pawns.get(i);
      if (checkedPawn.row() == row && checkedPawn.col() == col) {
        return checkedPawn;
      }
    }
    return null;
  }
  
  // Clears the ArrayList of pawns on the board
  public void purge() {pawns.clear();}
  
  // Removes a pawn from the board
  public boolean removePawn(int row, int col) {
    for (int i=0; i<pawns.size(); i++) {
      Pawn checkedPawn = pawns.get(i);
      if (checkedPawn.row() == row && checkedPawn.col() == col) {
        pawns.remove(i);
        return true;
      }
    }
    return false;
  }
  
  // Moves a pawn forward
  public boolean pawnForward(int row, int col, int spaces, int id, boolean teams) {
    for (int i=0; i<pawns.size(); i++) {
      Pawn movingPawn = pawns.get(i);
      if (teams) {
        if ((movingPawn.row() == row && movingPawn.col() == col) && (movingPawn.getId() % 2 == id % 2 && movingPawn.isValidForward())) {
          if (!movingPawn.isActive() && !movingPawn.isSelected()) {
            movingPawn.moveForward(spaces,true);
            return true;
          }
        }
      } else {
        if ((movingPawn.row() == row && movingPawn.col() == col) && (movingPawn.getId() == id && movingPawn.isValidForward())) {
          if (!movingPawn.isActive() && !movingPawn.isSelected()) {
            movingPawn.moveForward(spaces,true); //<>//
            return true;
          }
        }
      }
    }
    return false;
  }
  
  // Moves a pawn backward
  public boolean pawnBackward(int row, int col, int spaces, int id, boolean teams, boolean isPlayerTurn) {
    for (int i=0; i<pawns.size(); i++) {
      Pawn movingPawn = pawns.get(i);
      if (teams) {
        if ((movingPawn.row() == row && movingPawn.col() == col) && (movingPawn.getId() % 2 == id % 2) && movingPawn.isValidBackward()) {
          movingPawn.moveBackward(spaces,isPlayerTurn);
          return true;
        }
      } else {
        if ((movingPawn.row() == row && movingPawn.col() == col) && (movingPawn.getId() == id) && movingPawn.isValidBackward()) {
          movingPawn.moveBackward(spaces,isPlayerTurn);
          return true;
        }
      }
    }
    return false;
  }
  
  // Checks for sliding pawns on the board
  public void slideCheck() {
    for (Pawn p: pawns) {
      for (Slide s: slides) {
        if (p.row() == s.row() && p.col() == s.col()) {
          if (s.getType() == 0 && s.getPlayer() != p.getId())
            p.startSlide();
        }
      }
    }
  }
  
  // Places your pawn one space ahead of an opponent's pawn
  public boolean moveAhead(int row1, int col1, int row2, int col2) {
    Pawn pawn1 = findPawn(row1,col1);
    Pawn pawn2 = findPawn(row2,col2);
    if (pawn1 == null || pawn2 == null) {
      return false;
    }
    if (pawn1.inSafetyZone() || pawn2.inSafetyZone()) {
      return false;
    }
    if (pawn1.getId() % 2 == pawn2.getId() % 2) {
      return false;
    }
    if (!validateForward(row2,col2,pawn1.getId())) {
      return false;
    }
    pawn1.updateRow(row2);
    pawn1.updateCol(col2);
    pawn1.moveForward(1,false);
    return true;
  }
  
  // Moves a pawn to home instantly
  public boolean instantHome(int row, int col, int id) {
    for (int i=0; i<pawns.size(); i++) {
      Pawn movingPawn = pawns.get(i);
      if (movingPawn.row() == row && movingPawn.col() == col) {
        if (movingPawn.getId() == id && movingPawn.isLead()) {
          pawns.remove(i);
          return true;
        }
      }
    }
    return false;
  }
  
  // Moves a sliding pawn forward
  public int slideMove() {
    int pawnHit = -1;
    for (int i=0; i<pawns.size(); i++) {
      Pawn p1 = pawns.get(i);
      if (p1.slideActive()) {
        p1.moveForward(1,true);
        for (Slide s: slides) {
          if (p1.row() == s.row() && p1.col() == s.col()) {
            if (s.getType() == 1)
              p1.endSlide();
          }
        }
        for (int j=0; j<pawns.size(); j++) {
          Pawn p2 = pawns.get(j);
          if (p1 != p2) {
            if (p1.row() == p2.row() && p1.col() == p2.col()) {
              pawnHit = p2.getId();
              pawns.remove(j);
              return pawnHit;
            }
          }
        }
      }
    }
    return pawnHit;
  }
  
  // Checks if the board has any sliding pawns
  public boolean slidingPawns() {
    for (Pawn p: pawns) {
      if (p.slideActive())
        return true;
    }
    return false;
  }
  
  // Bumps a pawn back to start
  public int bumpPawn(int player) {
    int pawnId = -1;
    for (int i=0; i<pawns.size(); i++) {
      Pawn p1 = pawns.get(i);
      if (p1.getId() == player) {
        for (int j=0; j<pawns.size(); j++) {
          Pawn p2 = pawns.get(j);
          if (p1.getId() != p2.getId()) {
            if (p1.row() == p2.row() && p1.col() == p2.col()) {
              pawnId = p2.getId();
              pawns.remove(j);
              return pawnId;
            }
          }
        }
      }
    }
    return pawnId;
  }
  
  // Special move code for the 7 card
  public boolean splitMove(int row, int col, int spaces, int id, boolean teams) {
    Pawn pawn1 = findPawn(row,col);
    Pawn pawn2 = null;
    int split = 0;
    if (pawn1 == null)
      return false;
    pawn1.activate();
    if (teams) {
      if (pawn1.getId() % 2 != id % 2)
        return false;
    } else {
      if (pawn1.getId() != id)
        return false;
    }
    for (Pawn p: pawns) {
      if (p.getValue() != 0) {
        pawn2 = p;
        split = p.getValue();
      }
    }
    if (pawn1 == pawn2)
      return false;
    if (pawn2 == null)
      return false;
    if (!validateForward(row,col,spaces) || !validateForward(pawn2.row(),pawn2.col(),split)) {
        return false;
    }
    Inspector inspector1 = new Inspector(row,col,id,pawn1.inSafetyZone());
    Inspector inspector2 = new Inspector(pawn2.row(),pawn2.col(),pawn2.getId(),pawn2.inSafetyZone());
    inspector1.moveForward(spaces);
    inspector2.moveForward(split);
    if ((inspector1.row() == inspector2.row()) && (inspector1.col() == inspector2.col())) {
      if (pawn1.getId() == pawn2.getId()) {
        if (inspector1.spacesRemaining() != 0 && inspector2.spacesRemaining() != 0) {
          pawn1.deactivate();
          return false;
        }
      }
    }
    pawn1.moveForward(spaces,true);
    pawn2.moveForward(split,true);
    for (Slide s: slides) {
      if (pawn1.row() == s.row() && pawn1.col() == s.col()) {
        if (s.getType() == 0 && s.getPlayer() != pawn1.getId())
          pawn1.startSlide();
      }
      if (pawn2.row() == s.row() && pawn2.col() == s.col()) {
        if (s.getType() == 0 && s.getPlayer() != pawn2.getId())
          pawn2.startSlide();
      }
    }
    return true;
  }
  
  // Gets the value a pawn has been assigned with a 7 card
  public int splitValue() {
    for (Pawn p: pawns) {
      if (p.getValue() != 0)
        return p.getValue();
    }
    return 0;
  }
  
  // Assigns a split value to a pawn with a 7 card
  public void splitPawn(int row, int col, int player, boolean teams) {
    Pawn targetPawn = findPawn(row,col);
    for (Pawn p: pawns) {
      if (targetPawn != null && p != targetPawn) {
        p.deactivate();
      }
    }
    if (targetPawn != null) {
      if (teams) {
        if (targetPawn.getId() % 2 == player % 2)
          targetPawn.setValue();
      } else {
        if (targetPawn.getId() == player)
          targetPawn.setValue();
      }
    }
  }
  
  // Resets the inspectors
  public void resetInspector() {
    inspector1.updateRow(-1);
    inspector1.updateCol(-1);
  }
  
  // Returns a 2-int array of the coordinates clicked on the game board
  public int[] getCoords(int xClicked, int yClicked) {
    int[] coords = new int[2];
    xClicked -= x_pos;
    yClicked -= y_pos;
    coords[0] = yClicked/cellSize;
    coords[1] = xClicked/cellSize;
    return coords;
  }
  
  public int getRows() {return rows;}
  public int getCols() {return cols;}
  
}
