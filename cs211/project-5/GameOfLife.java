import java.io.*;
import java.util.*;
import java.awt.Color;

public class GameOfLife 
{
  public static void main (String[] args)
  {
    File f = null;
    Scanner sc = null;
    int alive;
    int generation;
    int rows, cols;
    int[][] gridA;
    int[][] gridB;
    int x, y;
    GridDisplay disp;

    if ( args.length == 0 )
      f = new File ("lifeData1.txt");
    else
      f = new File (args[0]);

    try
    {
      sc = new Scanner (f);
    }
    catch (FileNotFoundException fnfe)
    {
      System.out.println ("File did not exist");
      return;
    }

    rows = sc.nextInt();
    cols = sc.nextInt();

    //check that rows and columns are within the correct bounds
    while(rows < 1 || cols < 1){
      System.err.println(rows + " " + cols + " " + "\t" + "Invalid: Grid sizes must be greater than 0");
      rows = sc.nextInt();
      cols = sc.nextInt();
    }
    gridA = new int[rows][cols];
    gridB = new int[rows][cols];

    System.out.println(rows + " " + cols + " " + "\t" + "Grid becomes size " + rows + " x " + cols);

    disp = new GridDisplay (rows+2, cols+2);

    for (x = 0 ; x < rows+2 ; x++ )
    {
      disp.setColor (x, 0, Color.MAGENTA);
      disp.setColor (x, cols+1, Color.MAGENTA);
    }

    for (y = 0 ; y < cols+2 ; y++ )
    {
      disp.setColor (0, y, Color.MAGENTA);
      disp.setColor (rows+1, y, Color.MAGENTA);
    }

    for (x = 0; x < rows; x++)
      for(y = 0; y < cols; y++){
        {
          disp.setColor (x+1, y+1, Color.WHITE);
        }
      }

    int[][] gridArray = new int[0][0];
    //read each x and y 
    int newRow = 0;
    while (sc.hasNextInt())
    {
      x = sc.nextInt();
      y = sc.nextInt();
      //check that x any y are in correct bounds, if not, read new x and y
      while((x < 1 || x > rows) || (y < 1 || y > cols)){
        if(x < 1 || x > rows)
          System.err.println(x + " " + y + "\t" + "Invalid: row " + x + " is outside range from " + rows + " to " + cols);
        if(y < 1 || y > cols)
          System.err.println(x + " " + y + "\t" + "Invalid: column " + y + " is outside range from " + rows + " to " + cols);
        x = sc.nextInt();
        y = sc.nextInt();
      }

      //dynamically resize array note: + 3 includes the dimensionw, start and end position obtained earlier
      int[][] temp = new int[++newRow][2];
      temp[newRow-1][0] = x;
      temp[newRow-1][1] = y;

      for(int i=0; i<newRow-1; i++){
        temp[i][0] = gridArray[i][0];
        temp[i][1] = gridArray[i][1];
      }
      gridArray = temp;

      /*
         System.err.println("<<start debug");
         for(int i=0; i<newRow-1; i++){
         System.out.println("Debug: " + temp[i][0] + " " + temp[i][1]);
         }
         System.err.println("<<end debug");
         */

      //check that existing row/col hasn't been used prior
      int j = 0;
      while(j < newRow-1){
        while(gridArray[j][0] == x && gridArray[j][1] == y){
          System.err.println(x + " " + y + "\t" + "Invalid: position already specified");
          x = sc.nextInt();
          y = sc.nextInt();
        }
        j++;
      }
      //the correct x and y are ready to be displayed
      disp.setColor (x, y, Color.BLACK);
      //mark x any y on the corresponding grids
      gridA[x-1][y-1] = 1;
    }
    for(int i=0; i<newRow; i++){
      System.out.println(gridArray[i][0] + " " + gridArray[i][1]);
    }

    //begin Game of Life algorithm
    alive = 0;
    generation = 0;
    disp.mySleep(2000);
    for(;;){
      for(int i=0; i<rows; i++){
        for(int j=0; j<cols; j++){
          alive = 0;
          //current cell is alive
          if(gridA[i][j] == 1){
            if(i > 0 && gridA[i-1][j] == 1) //check north 
              alive++;
            if(i > 0 && j < cols-1 && gridA[i-1][j+1] == 1) //check northeast
              alive++;
            if(j < cols-1 && gridA[i][j+1] == 1) //check east 
              alive++;
            if(i < rows-1 && j < cols-1 && gridA[i+1][j+1] == 1) //check southeast
              alive++;
            if(i < rows-1 && gridA[i+1][j] == 1) //check south 
              alive++;
            if(i < rows-1 && j>0 && gridA[i+1][j-1] == 1) //check southwest
              alive++;
            if(j > 0 && gridA[i][j-1] == 1) //check west 
              alive++;
            if(j > 0 && i > 0 && gridA[i-1][j-1] == 1) //check northwest
              alive++;
            //cell dies - underpopulation
            if(alive < 2)
              gridB[i][j] = 0;
            //cell lives on
            else if(alive == 2 || alive == 3)
              gridB[i][j] = 1;
            //cell dies, overcrowding
            else
              gridB[i][j] = 0;
          }
          //current cell must be dead
          else if(gridA[i][j] == 0){
            if(i > 0 && gridA[i-1][j] == 1) //check north 
              alive++;
            if(i > 0 && j < cols-1 && gridA[i-1][j+1] == 1) //check northeast
              alive++;
            if(j < cols-1 && gridA[i][j+1] == 1) //check east 
              alive++;
            if(i < rows-1 && j < cols-1 && gridA[i+1][j+1] == 1) //check southeast
              alive++;
            if(i < rows-1 && gridA[i+1][j] == 1) //check south 
              alive++;
            if(i < rows-1 && j>0 && gridA[i+1][j-1] == 1) //check southwest
              alive++;
            if(j > 0 && gridA[i][j-1] == 1) //check west 
              alive++;
            if(j > 0 && i > 0 && gridA[i-1][j-1] == 1) //check northwest
              alive++;
            //dead cell becomes alive
            if(alive == 3)
              gridB[i][j] = 1;
            else
              gridB[i][j] = 0;
          }
        }
      }
      for(int i=0; i<rows; i++){
        for(int j=0; j<cols; j++){
          gridA[i][j] = gridB[i][j];
        }
      }
      for(int i=0; i<rows; i++){
        for(int j=0; j<cols; j++){
          if(gridA[i][j] == 1){
            disp.setColor(i+1,j+1,Color.BLACK);
          }
          if(gridA[i][j] == 0){
            disp.setColor(i+1,j+1, Color.WHITE);
          }
        }
      }
      disp.mySleep(200);
      generation++;
    }
  }
}
