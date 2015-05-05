import java.io.*;
import java.util.*;

public class AirportNode {
  Node head;
  AirportNode next;
  int aNum;
  boolean visited;

  public AirportNode(){
    head = null;
    next = null;
    aNum = 0;
    visited = false;
  }

  public AirportNode(int num){
    head = new Node(num);
    next = null;
    aNum = num;
    visited = false;
  }

  public void setVisited(boolean visit){
    visited = visit;
  }
}
