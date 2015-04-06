import java.io.*;
import java.util.*;
import java.awt.Color;

public class MazeSolver
{
  public static void main (String[] args)
  {
    File f = null;
    Scanner sc = null;
    int rows, cols;
    int xstart, ystart, xend, yend;
    int x, y;
    GridDisplay disp;
    
    if ( args.length == 0 )
      f = new File ("mazeData1.txt");
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
    
    xstart = sc.nextInt();
    ystart = sc.nextInt();
    disp.setColor (xstart, ystart, Color.GREEN);
    
    xend = sc.nextInt();
    yend = sc.nextInt();
    disp.setColor (xend, yend, Color.BLUE);
    
    while (sc.hasNextInt())
    {
      x = sc.nextInt();
      y = sc.nextInt();
      
      disp.setColor (x, y, Color.RED);
    }
  }
}