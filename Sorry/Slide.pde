public class Slide extends BoardItem {
  
  protected int player;
  protected int type;
  protected int value;
  
  Slide(int rowAt, int colAt, int player, int type, int value) {
    super(rowAt,colAt);
    this.player = player;
    this.type = type;
    this.value = value;
  }
  
  void show(int xAt, int yAt, int cellSize) {
    pushMatrix();
    translate(xAt,yAt);
    stroke(0);
    strokeWeight(2);
    rectMode(CENTER);
    switch(player) {
      case 0:
        fill(120,0,0);
        if (type == 0) {
          if (value == 3) {
            rect(56,cellSize/2,100,10);
          } else if (value == 4) {
            rect(70,cellSize/2,125,10);
          }
          beginShape();
          vertex(5,5);
          vertex(5,cellSize-5);
          vertex(15,cellSize/2);
          endShape(CLOSE);
        } else {
          ellipse(cellSize/1.92,cellSize/1.92,cellSize/2,cellSize/2);
        }
        break;
      case 1:
        fill(0,0,120);
        if (type == 0) {
          if (value == 3) {
            rect(cellSize/2,56,10,100);
          } else if (value == 4) {
            rect(cellSize/2,70,10,125);
          }
          beginShape();
          vertex(5,5);
          vertex(cellSize-5,5);
          vertex(cellSize/2,15);
          endShape(CLOSE);
        } else {
          ellipse(cellSize/1.92,cellSize/1.92,cellSize/2,cellSize/2);
        }
        break;
      case 2:
        fill(120,120,0);
        if (type == 0) {
          if (value == 3) {
            rect(-30,cellSize/2,100,10);
          } else if (value == 4) {
            rect(-40,cellSize/2,125,10);
          }
          beginShape();
          vertex(cellSize-5,5);
          vertex(cellSize-5,cellSize-5);
          vertex(cellSize/2,cellSize-15);
          endShape(CLOSE);
        } else {
          ellipse(cellSize/1.92,cellSize/1.92,cellSize/2,cellSize/2);
        }
        break;
      case 3:
        fill(0,120,0);
        if (type == 0) {
          if (value == 3) {
            rect(cellSize/2,-30,10,100);
          } else if (value == 4) {
            rect(cellSize/2,-40,10,125);
          }
          beginShape();
          vertex(5,cellSize-5);
          vertex(cellSize-5,cellSize-5);
          vertex(cellSize/2,cellSize-15);
          endShape(CLOSE);
        } else {
          ellipse(cellSize/1.935,cellSize/1.92,cellSize/2,cellSize/2);
        }
        break;
    }
    popMatrix();
  }
  
  int getType() {return type;}
  int getValue() {return value;}
  int getPlayer() {return player;}
  
}
