import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class Habitat {
    private int rows, cols;
    private int dayCount;
    private char[] directions = {'N', 'E', 'S', 'W'};
    GridDisplay disp;
    private Creature[][] grid;
    private int delayVal;
    
    public Habitat() {
        rows = 20;
        cols = 20;
        disp = new GridDisplay(rows, cols);
        grid = new Creature[rows][cols];
        
        for(int i=0; i<rows; i++){
            for(int j=0; j<cols; j++){
                grid[i][j] = null;
                disp.setColor(i,j,Color.WHITE);
            }
        }
    }
    
    public void randomizeHabitat(){
        
        int randX, randY, maxX = rows-1, maxY = cols-1, currAnt = 0, currDoodlebug = 0;
        char tempState;
        
        Creature temp;
        int count = 0;
        
        for(int i=0; i<rows; i++){
            //reset maxY position
            maxY = cols-1;
            for(int j=0; j<cols; j++){
                
                //generate random cooridnates
                randX = (int)(Math.random()*maxX);
                randY = (int)(Math.random()*maxY);
                
                temp = grid[randX][randY];
                if(temp != null){
                  temp.setM(randX);
                  temp.setN(randY);
                }
                grid[randX][randY] = grid[maxX][maxY];
                if(grid[randX][randY] != null){
                  grid[randX][randY].setM(maxX);
                  grid[randX][randY].setN(maxY);
                }
                grid[maxX][maxY] = temp;
                if(grid[maxX][maxY] != null){
                  grid[maxX][maxY].setM(maxX);
                  grid[maxX][maxY].setN(maxY);
                }
                
                //decrement maxY position
                maxY--;
            }
            //decrement maxX position
            maxX--;
        }

        updateColors();
    }//end randomizeHabitat

    public boolean addCreatureInOrder(Creature c){
      for(int i=0; i<rows; i++){
        for(int j=0; j<cols; j++){
          if(grid[i][j] == null){
            //insert creature into empty location
            grid[i][j] = c;
            c.setM(i);
            c.setN(j);
            updateColors();
            return true; //inserted into habitat successfully
          }
        }
      }
      return false; //habitat may be full
    }

    public Creature getCreature(int m, int n){
        if(validMN(m,n) == false)
            return null;
        
        if(grid[m][n] != null){
          return grid[m][n];
        }

        return null;
    }

    public void numAnts(){
      int count = 0;
      for(int i=0; i<rows; i++){
        for(int j=0; j<cols; j++){
          if(grid[i][j] instanceof Ant){
            count++;
          }
        }
      }
      System.out.println("Num ants: " + count);
    }

    public void numDoodlebugs(){
      int count = 0;
      for(int i=0; i<rows; i++){
        for(int j=0; j<cols; j++){
          if(grid[i][j] instanceof Doodlebug){
            count++;
          }
        }
      }
      System.out.println("Num doodlebugs: " + count);

    }

    public void addCreature (Creature c, int m, int n){
      // make sure m and n are valid
      if (m < 0 || m >= rows || n < 0 || n >= cols)
        return;

      // make sure no creature is already at that space
      if (grid[m][n] != null)
        return;

      grid[m][n] = c;

      //color doodlebug red
      if(c instanceof Doodlebug){
        disp.setColor(m,n, Color.RED);
        return;
      }
      //color ant black
      else if(c instanceof Ant){
        disp.setColor(m,n, Color.GRAY);
        return;
      }

      //color all blank spaces white
      disp.setColor (m, n, Color.WHITE);
    }

    public void delay(int delay){
      disp.mySleep(delay);
    }

    public void setDelay(int delay){
      delayVal = delay;
    }

    public boolean spawnCreature(Creature c){
      
      int north = 0, east = 1, south = 2, west = 3;
      int m = c.getM();
      int n = c.getN();

      int nextM = -1 , nextN = -1;

      if(validMN(m,n) == false)
        return false;

      int direction = (int)(Math.random()*4);

      if(direction == north){
        nextM = m-1;
        nextN = n;
      }
      else if(direction == east){
        nextM = m;
        nextN = n+1;
      }
      else if(direction == south){
        nextM = m+1;
        nextN = n;
      }
      else if(direction == west){
        nextM = m;
        nextN = n-1;
      }
      else {
        return false; //incorrect direction
      }

      //check if direction chosen is empty
      if(isEmpty(nextM, nextN)){
        if(c instanceof Doodlebug){
          Doodlebug d = new Doodlebug(this, nextM, nextN);
          return true; //doodle bug added to habitat
        }
        else if(c instanceof Ant){
          Ant a = new Ant(this, nextM, nextN);
          return true; //ant added to habitat
        }
      }
      

      //incorrect direction or erroneous error
      return false;
    }

    public boolean isAnt(int m, int n){
      if(validMN(m,n) == false)
        return false;

      if(grid[m][n] == null)
        return false;

      if(grid[m][n] instanceof Ant)
        return true;

      return false;
    }

    public int[] random(){

      int[] coords = {-1,-1};
      int m, n;

      do{

        m = (int)(Math.random()*20);
        n = (int)(Math.random()*20);

      }while(grid[m][n] != null || grid[m][n] instanceof Creature);

      coords[0] = m;
      coords[1] = n;

      if(coords[0] == -1 || coords[1] == -1){
        System.out.println("Error - incorrect random location assigned");
        return null;
      }

      return coords;
    }//end random

    public void moveAllDoodleBugs(){
      delay(50);
      for(int i=0; i<rows; i++){
        for(int j=0; j<cols; j++){
          //make sure grid location contains a doodlebug
          if(grid[i][j] != null && grid[i][j] instanceof Doodlebug){
            Doodlebug d = (Doodlebug) grid[i][j];

            //doodlebug hunts
            if(antNearby(d) == true){
              d.hunt(dayCount);
            }
            //doodlebug does a regular move
            else{
              d.move(dayCount);
            }
            //doodlebug spawns every 8 days
            if(d.spawn(dayCount) == true){
              //doodlebug spawns
            }
            if(d.starve(dayCount) == true){
              //doodlbug starves
            }
          }
        }
      }
    }

    public void moveAllAnts(){
      delay(50);
      for(int i=0; i<rows; i++){
        for(int j=0; j<cols; j++){

          if(grid[i][j] != null && grid[i][j] instanceof Ant){
            Ant a = (Ant) grid[i][j];

            //ant moves
            a.move(dayCount); 
            if (a.spawn(dayCount) == true){
              //ant spawns
            }
          }
        }
      }
    }

    public void newDay(){
      dayCount++;
      System.out.println("Day Count: " + dayCount);

      //move all doodlebugs first
      moveAllDoodleBugs();

      //move all ants second
      moveAllAnts();

    }//end newDay

    public void killCreature(Creature c){

      int m = c.getM();
      int n = c.getN();

      if(validMN(m,n) == false)
        return;

      grid[m][n] = null;
      c = null;

      updateColors();
    }

    public boolean moveCreature (Creature c, int nextM, int nextN){
      if(validMN(nextM,nextN) == false) //attempts to move creature off board
        return false;

      if(grid[nextM][nextN] != null) //can't move creature, space is occupied
        return false;

      //get creaturees current m,n location
      int m = c.getM();
      int n = c.getN();

      //put creature to next location
      grid[nextM][nextN] = c;
      grid[m][n] = null;

      updateColors();

      return true;
    }//end moveCreature

    public void updateColors(){
      for(int i=0; i<rows; i++){
        for(int j=0; j<cols; j++){
          if(grid[i][j] == null){
            disp.setColor(i,j,Color.WHITE);
          }
          else if(grid[i][j] instanceof Doodlebug){
            disp.setColor(i,j,Color.RED);
          }
          else if(grid[i][j] instanceof Ant){
            disp.setColor(i,j,Color.GRAY);
          }
        }
      }
    }

    public void removeCreature(Creature c){

      int m = c.getM();
      int n = c.getN();

      //check that creature is on the board
      if(validMN(m,n) == false)
        return;

      //can't remove a creature that doesn't exists
      if(grid[m][n] == null)
        return;

      //set grid position to null
      grid[m][n] = null;

      //color grid position white
    }

    public boolean antIsDirection(Creature c, int direction){
      int m = c.getM();
      int n = c.getN();

      if(direction == 1) //north
        m--;
      else if(direction == 2) //east
        n++;
      else if(direction == 3) //south
        m++;
      else if(direction == 4) //west
        n--;
      else //wrong direction input
        return false;

      if(validMN(m,n) == true && grid[m][n] instanceof Ant){
        return true;
      }

      return false;
    }//end antIsDirection

    public boolean validMN(int nextM, int nextN){

      //check that nextM is in grid bounds
      if(nextM >= rows || nextM < 0)
        return false;

      //check that nextN is in grid bounds
      if(nextN >= cols || nextN < 0)
        return false;

      return true;
    }//end validMN

    public boolean isEmpty(int m, int n){
      if(validMN(m,n) == false)
        return false;

      if(grid[m][n] == null)
        return true;

      return false;
    }

    public boolean antNearby(Creature c){

      int m = c.getM();
      int n = c.getN();

      //check that ant is at north position
      if(validMN(m-1,n) == true && grid[m-1][n] instanceof Ant){
        return true;
      }

      //check that ant is at east position
      if(validMN(m,n+1) == true && grid[m][n+1] instanceof Ant){
        return true;
      }

      //check that ant is at south position
      if(validMN(m+1,n) == true && grid[m+1][n] instanceof Ant){
        return true;
      }

      //check that ant is at west position
      if(validMN(m,n-1) == true && grid[m][n-1] instanceof Ant){
        return true;
      }

      return false;
    }//end antNearby
}//end Habitat
