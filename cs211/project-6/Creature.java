public class Creature {
    private Habitat hab;
    protected int m;
    protected int n;
    protected int dayLastMoved;
    protected int spawnCount;
    private int north = 0;
    private int east = 1;
    private int south = 2;
    private int west = 3;

    
    
    public Creature(Habitat habitat){
        hab = habitat;

        //m = hab.random()[0];
        //n = hab.random()[1];

        dayLastMoved = 0;
        spawnCount = 0;

        hab.addCreatureInOrder(this);
    }

    public Creature(Habitat habitat, int newM, int newN){
      hab = habitat;
      m = newM;
      n = newN;
      dayLastMoved = 0;
      spawnCount = 0;

      hab.addCreature(this, m, n);
    }

    public boolean move(int dayCount){

      //check if creature already moved
      if(dayCount == dayLastMoved)
        return false;

      //determine direction creature wants to move
      int nextM = -1;
      int nextN = -1;

      int direction = (int)(Math.random() * 4);
      if (direction == north) // attempt to move up
      {
        nextM = m-1; nextN = n;
      }

      if (direction == east){ //attempt to move right
        nextM = m; nextN = n+1;
      }

      if (direction == south) { //atempt to move down
        nextM = m+1; nextN = n;
      }

      if (direction == west) { //attempt to move left
        nextM = m; nextN = n-1;
      }

      //try to move creature, if successful, update creatures X,Y coordinaties
      if (hab.moveCreature (this, nextM, nextN) == true){
        dayLastMoved = dayCount;
        m = nextM;
        n = nextN;

        return true;
      }
      //if creature didn't move
      return false;
    }

    public boolean spawn(int dayCount){

      //spawn creature
      //creature is an ant, spawn after being alive for 3 days or more
      if(this instanceof Ant){
        if(spawnCount > 2 && hab.spawnCreature(this) == true){
          spawnCount = 0;
          return true;
        }
      }
      //creature is a doodlebug, spawn after being alive for 8 days or more
      else if(this instanceof Doodlebug){
        if(spawnCount > 7 && hab.spawnCreature(this) == true){
          spawnCount = 0;
          return true;
        }
      }

      //increment spawnCount if unable to spawn or spawn count less than specified amount
      spawnCount++;

      //creature did not spawn
      return false;
    }//end spawn

    public void setDayLastMoved(int dlm){
      dayLastMoved = dlm;
    }

    public int getDayLastMoved(){
      return dayLastMoved;
    }

    public int getM(){
      return m;
    }

    public int getN(){
      return n;
    }

    public void setM(int newM){
      m = newM;
    }

    public void setN(int newN){
      n = newN;
    }

}//end Creature
