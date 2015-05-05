public class Doodlebug extends Creature {
    
    private Habitat hab;
    private int north = 0;
    private int east = 1;
    private int south = 2;
    private int west = 3;
    private int dayLastEaten;

    public Doodlebug(Habitat habitat){
        super(habitat);
        hab = habitat;
        dayLastEaten = 1;
    }

    public Doodlebug(Habitat habitat, int newM, int newN){
      super(habitat, newM, newN);
      hab = habitat;
      dayLastEaten = 1;
    }
    
    public boolean starve(int dayCount){
        //doodle bug hasn't eaten in 3 days
        if((dayCount - dayLastEaten) > 2){
            hab.killCreature(this);
            return true;
        }
        return false;
        
    }//end starve
    
    public boolean hunt(int dayCount){

        if(dayCount == dayLastMoved)
          return false;
        
        //determine direction creature wants to move
        int nextM = -1;
        int nextN = -1;

        if(hab.isAnt(m-1, n) == true){
            nextM = m-1; nextN = n;
        }
        else if(hab.isAnt(m, n+1) == true){
            nextM = m; nextN = n+1;
        }
        else if(hab.isAnt(m+1, n) == true){
            nextM = m+1; nextN = n;
        }
        else if(hab.isAnt(m, n-1) == true){
            nextM = m; nextN = n-1;
        }
        else{
          return false; //no ant nearby
        }

        Ant ant = (Ant)hab.getCreature(nextM, nextN);
        hab.killCreature(ant);

        hab.moveCreature (this, nextM, nextN);
        dayLastMoved = dayCount;
        dayLastEaten = dayCount;

        m = nextM;
        n = nextN;

        return true;
    }//end hunt

}//end class Doodlebug
