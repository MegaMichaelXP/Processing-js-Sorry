public class Card {
  
  private int value;
  private int specialPlayer;
  private String specialPlayer1;
  private String specialPlayer2;
  private String targetPlayer1;
  private String targetPlayer2;
  
  public final int[] VALUES =
    {1,2,3,4,5,7,8,10,11,12,13};
    
  public Card(int value, int specialPlayer) {
    this.value = value;
    this.specialPlayer = specialPlayer;
    switch (specialPlayer) {
      case 0:
        specialPlayer1 = "Red";
        specialPlayer2 = "Yellow";
        targetPlayer1 = "Blue";
        targetPlayer2 = "Green";
        break;
      case 1:
        specialPlayer1 = "Blue";
        specialPlayer2 = "Green";
        targetPlayer1 = "Red";
        targetPlayer2 = "Yellow";
        break;
      case 2:
        specialPlayer1 = "Yellow";
        specialPlayer2 = "Red";
        targetPlayer1 = "Blue";
        targetPlayer2 = "Green";
        break;
      case 3:
        specialPlayer1 = "Green";
        specialPlayer2 = "Blue";
        targetPlayer1 = "Red";
        targetPlayer2 = "Yellow";
        break;
      default:
        specialPlayer1 = "NONE";
        specialPlayer2 = "NONE";
        targetPlayer1 = "NONE";
        targetPlayer2 = "NONE";
        break;
    }
  }
  
  public String instruction() {
    String cardInstruction;
    switch(value) {
      case 1:
        cardInstruction = "Move from START\nor move forward 1.";
        break;
      case 2:
        cardInstruction = "Move from START\nor move forward 2.\nDRAW AGAIN";
        break;
      case 4:
        cardInstruction = "Move backward 4.";
        break;
      case 7:
        cardInstruction = "Move forward 7 or\nsplit between two pawns.";
        break;
      case 10:
        cardInstruction = "Move forward 10\nor move backward 1.";
        break;
      case 11:
        cardInstruction = "Move forward 11 or change\nplaces with an opponent.";
        break;
      case 13:
        cardInstruction = "Move from START and switch\nplaces with an opponent,\nwhom you bump back to START.";
        break;
      default:
        cardInstruction = "Move forward " + value + ".";
        break;
    }
    if (specialPlayer != -1) {
      switch(value) {
        case 3:
          cardInstruction = "If you're the " + specialPlayer1 + " player,\ndraw the top 3 cards, choose 1\nto play, then discard the other 2.\nOr, move forward 3.";
          break;
        case 5:
          cardInstruction = "If you're the " + specialPlayer1 + " player,\nmove your pawn ahead of any\n" + targetPlayer1 + " or " + targetPlayer2 + " pawn,\nor move forward 5.";
          break;
        case 8:
          cardInstruction = "If you're the " + specialPlayer1 + " or " + specialPlayer2 + "\nplayer, move 1 " + targetPlayer1 + " or\n" + targetPlayer2 + " pawn back 8 spaces,\nor move forward 8.";
          break;
        case 12:
          cardInstruction = "If you're the " + specialPlayer1 + " or " + specialPlayer2 + "\nplayer, move your lead\npawn directly to HOME,\nor move forward 12.";
          break;
      }
    }
    return cardInstruction;
  }
  
  public void show(float x_pos, float y_pos) {
    pushMatrix();
    translate(x_pos,y_pos);
    rectMode(CENTER);
    fill(120);
    stroke(50);
    strokeWeight(5);
    rect(0,0,120,160);
    switch(specialPlayer) {
      case 0:
        stroke(255,0,0);
        ellipse(0,0,80,80);
        fill(255,0,0);
        break;
      case 1:
        stroke(0,0,255);
        ellipse(0,0,80,80);
        fill(0,0,255);
        break;
      case 2:
        stroke(255,255,0);
        ellipse(0,0,80,80);
        fill(255,255,0);
        break;
      case 3:
        stroke(0,255,0);
        ellipse(0,0,80,80);
        fill(0,255,0);
        break;
      default:
        fill(0);
        break;
    }
    textAlign(CENTER,CENTER);
    if (value == 13) {
      textSize(28);
      text("SORRY!",0,-1);
    } else {
      textSize(50);
      text(value,0,-1);
    }
    popMatrix();
  }
  
  public int cardValue() {return value;}
  public int cardSpecialPlayer() {return specialPlayer;}
  
}
