import java.io.*;
import java.lang.*;
import java.util.*;
import java.awt.Color;

public class bgolde5Proj6 {
    
    public static void main (String[] args) {
        
        int delayVal = 250;
        boolean debugMode = false;
        int numDoodlebugs = 5;
        int numAnts = 100;
        
        //setup debug mode
        if(args.length >= 2){
            System.out.print("Debug mode set - mySleep() set to ");
            
            //i.e. -d <sleepVal>
            if(args[0].equals("-d")){
                delayVal = Integer.parseInt(args[1]);
                System.out.println(delayVal);
            }
            
            //i.e. <sleepval> -d
            else if(args[1].equals("-d")){
                delayVal = Integer.parseInt(args[0]);
                System.out.println(delayVal);
            }
            debugMode = true;
        }//end debug mode
        
        //create the habitat
        Habitat habitat = new Habitat();
        
        //change sleep time based on debug value
        if(debugMode == true){
            habitat.setDelay(delayVal);
        }
        
        //create 5 doodlebugs
        for(int i=0; i<numDoodlebugs; i++){
            Doodlebug d = new Doodlebug(habitat);
        }
        
        //create 100 ants
        for(int i=0; i<numAnts; i++){
            Ant a = new Ant(habitat);
        }

        //habitat.numAnts();
        //habitat.numDoodlebugs();

        //ensure board is completely random
        for(int i=0; i<5; i++)
          habitat.randomizeHabitat();

        habitat.delay(2000); //allow board to initialize properly
        while(true){
          habitat.delay(delayVal);
          habitat.newDay();
        }

    }//end Main
}//end MainClass
