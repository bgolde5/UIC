import java.io.*;
import java.util.*;

public class Bgolde5Proj7 {


  //linked list to hold file names
  public static LinkedList flist = new LinkedList();

  public static void main (String[] args)
  {
    Scanner sc = new Scanner ( System.in );

    Airport airportData = new Airport();

    airportData.processCommandLoop (sc);

    System.out.println ("Goodbye");
  }//end main

}//end class Main
