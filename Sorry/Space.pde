public class Space extends BoardItem {
  
  protected int spaceType;
  protected int spaceColor;
  
  Space (int rowAt, int colAt, int spaceType, int spaceColor) {
    super(rowAt,colAt);
    this.spaceType = spaceType;
    this.spaceColor = spaceColor;
  }
  
  public void show (int xAt, int yAt, int cellSize) {
    pushMatrix();
    stroke(0);
    strokeWeight(2.5);
    switch (spaceColor) {
      case 0:
        stroke(255,0,0);
        if (spaceType != 0)
          fill(255,0,0);
        else
          fill(100,0,0);
        break;
      case 1:
        stroke(0,0,255);
        if (spaceType != 0)
          fill(0,0,255);
        else
          fill(0,0,100);
        break;
      case 2:
        stroke(255,255,0);
        if (spaceType != 0)
          fill(255,255,0);
        else
          fill(100,100,0);
        break;
      case 3:
        stroke(0,255,0);
        if (spaceType != 0)
          fill(0,255,0);
        else
          fill(0,100,0);
        break;
      default:
        stroke(0);
        noFill();
        break;
    }
    translate(xAt,yAt);
    rectMode(CORNER);
    rect(0,0,cellSize,cellSize);
    textAlign(CENTER,CENTER);
    textSize(20);
    fill(0);
    switch (spaceType) {
      case 1:
        text("S",(cellSize/1.92)-0.5,cellSize/2);
        break;
      case 2:
        text("H",(cellSize/1.92)-0.5,cellSize/2);
        break;
    }
    popMatrix();
  }
  
}
