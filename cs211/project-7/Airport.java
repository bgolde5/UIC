import java.io.*;
import java.util.*;

public class Airport
{
  int numAirports;

  AirportNode[] list;

  public Airport(){

    list = new AirportNode[11];

    for(int i=0; i<11; i++){
      list[i] = null;
    }

    numAirports = 10;

  }

  public Airport(int num){

    list = new AirportNode[num];

    for(int i=0; i<num; i++){
      list[i] = null;
    }

    numAirports = num;
    if(numAirports > 10){
      System.out.println("Error: number of airports must be 10 or less");
      System.out.println("Setting number of airports to 10");
      numAirports = 10;
    }
    if(numAirports < 2){
      System.out.println("Error: there must be at least 2 airports to fly between");
      System.out.println("Setting number of airports to 2");
      numAirports = 2;
    }

  }

  public void processCommandLoop (Scanner sc)
  {
    // loop until all integers are read from the file
    while (sc.hasNext())
    {

      String command = sc.next();
      System.out.println ("*" + command + "*");

      if (command.equals("q") == true)
        System.exit(1);

      else if (command.equals("?") == true)
        showCommands();

      else if (command.equals("t") == true)
        doTravel(sc);

      else if (command.equals("r") == true)
        doResize(sc);

      else if (command.equals("i") == true)
        doInsert(sc);

      else if (command.equals("d") == true)
        doDelete(sc);

      else if (command.equals("l") == true)
        doList(sc);

      else if (command.equals("f") == true)
        doFile(sc);

      else if (command.equals("#") == true)
        ;

      else
        System.out.println ("Command is not known: " + command);

      sc.nextLine();

    }

  }

  public void showCommands()
  {
    System.out.println ("The commands for this project are:");
    System.out.println ("  q ");
    System.out.println ("  ? ");
    System.out.println ("  # ");
    System.out.println ("  t <int1> <int2> ");
    System.out.println ("  r <int> ");
    System.out.println ("  i <int1> <int2> ");
    System.out.println ("  d <int1> <int2> ");
    System.out.println ("  l ");
    System.out.println ("  f <filename> ");
  }

  public void doTravel(Scanner sc)
  {
    int val1 = 0;
    int val2 = 0;

    if ( sc.hasNextInt() == true )
      val1 = sc.nextInt();
    else
    {
      System.out.println ("Integer value expected");
      return;
    }

    if ( sc.hasNextInt() == true )
      val2 = sc.nextInt();
    else
    {
      System.out.println ("Integer value expected");
      return;
    }

    if (val1 > numAirports || val1 < 1 || val2 > numAirports || val2 < 1){
      System.out.println ("Incorrect airport number entered.");
      return;
    }

    System.out.println ("Performing the Travel Command from " + val1 +
        " to " + val2);

    dfsHelper(val1, val2);

  }

  public void doResize(Scanner sc)
  {
    int val1 = 0;

    if ( sc.hasNextInt() == true )
      val1 = sc.nextInt();
    else
    {
      System.out.println ("Integer value expected");
      return;
    }

    System.out.println ("Performing the Resize Command with " + val1 );

    if(val1 > 10){
      System.out.println("Error: the number of airports must be 10 or less");
      return;
    }

    if(val1 < 2){
      System.out.println("There must be at least 2 airports to fly between");
      return;
    }

    //perform resize
    list = new AirportNode[val1+1];

    //set each new airport to null
    for(int i=0; i<list.length; i++){
      list[i] = null;
    }

    numAirports = val1;
  }//end doResize

  public void doInsert(Scanner sc)
  {
    int val1 = 0;
    int val2 = 0;

    if ( sc.hasNextInt() == true )
      val1 = sc.nextInt();
    else
    {
      System.out.println ("Integer value expected");
      return;
    }

    if ( sc.hasNextInt() == true )
      val2 = sc.nextInt();
    else
    {
      System.out.println ("Integer value expected");
      return;
    }

    if (val1 > numAirports || val1 < 1 || val2 > numAirports || val2 < 1){
      System.out.println ("Incorrect airport number entered.");
      return;
    }

    System.out.println ("Performing the Insert Command from " + val1 +
        " to " + val2);

    AirportNode newAirport = new AirportNode(val2);
    AirportNode curr = list[val1];
    AirportNode prev = null;

    while (curr != null && curr.aNum < newAirport.aNum) {
      prev = curr;
      curr = curr.next;
    }

    //check for duplicates
    if (curr != null && curr.aNum == newAirport.aNum)
      return;

    newAirport.next = curr;

    if (prev == null){
      list[val1] = newAirport;
    }
    else {
      prev.next = newAirport;
    }

  }//end doInsert

  public void doDelete(Scanner sc)
  {
    int val1 = 0;
    int val2 = 0;

    if ( sc.hasNextInt() == true )
      val1 = sc.nextInt();
    else
    {
      System.out.println ("Integer value expected");
      return;
    }

    if ( sc.hasNextInt() == true )
      val2 = sc.nextInt();
    else
    {
      System.out.println ("Integer value expected");
      return;
    }

    if (val1 > numAirports || val1 < 1 || val2 > numAirports || val2 < 1){
      System.out.println ("Incorrect airport number entered.");
      return;
    }

    System.out.println ("Performing the Delete Command from " + val1 +
        " to " + val2);

    AirportNode curr = list[val1];
    AirportNode prev = null;

    //list is empty
    if (curr == null)
      return;

    while (curr.next != null && curr.aNum != val2){
      prev = curr;
      curr = curr.next;
    }

    if (curr.next == null && curr.aNum != val2)
      return;

    //at front of the list
    if (prev == null){
      list[val1] = curr.next;
      curr = null;
    }
    else {
      prev.next = curr.next;
      curr = null;
    }

  }//end doDelete

  public void doList(Scanner sc)
  {
    System.out.println("Performing the Display Command");

    AirportNode temp;

    for(int i=1; i<=numAirports; i++){
      temp = list[i];

      //check if line ins the adj list is empty
      if(temp == null)
        System.out.println(i + ": Nothing"); //TODO - Delete this line
      //print each line in the adj list 
      else{
        System.out.print(i + ": ");
        while(temp != null){
          System.out.print("->");
          System.out.print(temp.aNum);
          temp = temp.next;
        }
        System.out.println();
      }
    }

  }//end doList

  public void doFile(Scanner sc)
  {
    String fname = null;
    String newFname = null;
    int val2 = 0;

    if ( sc.hasNext() == true )
      fname = sc.next();
    else
    {
      System.out.println ("Filename expected");
      return;
    }

    System.out.println ("Performing the File command with file: " + fname);

    //open file
    File file = new File(fname);

    //check if the file is current in use
    if(Bgolde5Proj7.flist.find(fname) == true)
      return; //file already open
    //push file to list if not in use
    else
      Bgolde5Proj7.flist.push(fname);

    try {

      Scanner scanner = new Scanner(file);

      while (scanner.hasNextLine()) {
        String line = scanner.nextLine();
        //System.out.println(line);
        processCommandLoop(scanner);
      }
      scanner.close();
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    }

    Bgolde5Proj7.flist.pop(); //file no longer in use, pop from stack

    return;

  }//end doFile

  public void dfsHelper(int x, int y){
    //mark all airports as unvisited
    AirportNode temp;
    for(int i=0; i<numAirports; i++){
      temp = list[i];
      while(temp != null){
        temp.visited = false;
        temp = temp.next;
      }
    }

    if(dfs(x,y) == true)
      System.out.println("You can get from airport " + x + " to airport " + y + " in one or more flights");
    else
      System.out.println("You can NOT get from airport " + x + " to airport " + y + " in one or more flights");
  }

  public boolean dfs(int a, int b){
    AirportNode temp;
    int c;

    for(int i=0; i<numAirports; i++){
      temp = list[i]; 
      while(temp != null){
        c = temp.aNum;
        if(c == b)
          return true; 
        if(temp.visited == false){
          temp.visited = true;
          if(dfs(c,b) == true)
            return true;
        }
        temp = temp.next;
      }
    }
    return false;
  }

}//end Class Airports
