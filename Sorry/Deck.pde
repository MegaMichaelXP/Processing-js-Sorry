public class Deck {
  
  private Card[] theDeck;
  private boolean specialCards;
  
  public Deck(boolean specialCards) {
    theDeck = new Card[45];
    this.specialCards = specialCards;
    int cardIndex = 0;
    for(int i=1; i<=13; i++) {
      if (i != 6 && i != 9) {
        for (int j=0; j<4; j++) {
          if (specialCards) {
            if (i==3 || i==5 || i==8 || i==12) {
              theDeck[cardIndex] = new Card(i,j);
              cardIndex++;
            } else {
              theDeck[cardIndex] = new Card(i,-1);
              cardIndex++;
            }
          } else {
            theDeck[cardIndex] = new Card(i,-1);
            cardIndex++;
          }
        }
        if (i==1) {
          theDeck[cardIndex] = new Card(i,-1);
          cardIndex++;
        }
      }
    }
  }
  
  public void shuffleCards() {
    for (int i=0; i<theDeck.length; i++) {
      Card theCard = theDeck[i];
      int swapPosition = (int)random(45);
      Card swapCard = theDeck[swapPosition];
      theDeck[swapPosition] = theCard;
      theDeck[i] = swapCard;
    }
  }
  
  public Card drawCard(int card) {
    return theDeck[card];
  }
  
}
