public class LinkedList {
  
  //used to test LinkedList
  public static void main (String [] args){
    //place test code here
    //LinkedList list = new LinkedList();

    /*
    list.push(5);
    list.push("test");
    list.push(45);
    list.print();
    list.pop();
    list.print();
    System.out.println(list.isElem(6));
    */

  }//end main

  private Node head;
  private Node tail;
  private int numItems;

  public LinkedList(){
    head = null;
    tail = null;
    numItems = 0;
  } 

  //top
  public Object top(){
    return head.elem;
  }//end top

  //front (same as top)
  public Object front(){
    return top();
  }//end front

  //back
  public Object back(){
    return tail.elem;
  }//end back
  
  //isEmpty
  public boolean isEmpty(){
    if (numItems == 0){
      return true;
    }
    return false;
  }//end isEmpty
  
  //print
  public void print(){
    Node ptr = head;

    while(ptr != null){
      System.out.print("[ " + ptr.elem + " ]");
      ptr = ptr.next;
    }
    System.out.println();
  }//end print

  //print reverse
  public void printReverse(){
    Node ptr = tail;

    while(ptr != null){
      System.out.print("[ " + ptr.elem + " ]");
      ptr = ptr.prev;
    }
    System.out.println();
  }//end printReverse
  
  //push
  public void push(Object val){
    Node newNode = new Node(val);

    newNode.next = head;
    newNode.prev = null;
    
    if(head != null)
      head.prev = newNode;

    head = newNode;
  }//end push

  //enqueue (add to back)
  public void enqueue(Object val){
    Node newNode = new Node(val);

    newNode.next = null;
    newNode.prev = tail;

    if(tail != null)
      tail.next = newNode;

    tail = newNode;
  }//end enqueue

  //dequeue (same as pop, remove from front)

  //pop
  public Object pop(){

    Node ptr = head;

    if(ptr == null)
      return null; //list is empty

    head = head.next;

    return ptr.elem;
  }//end pop

  //pop back
  public Object popBack(){

    Node ptr = tail;

    if(tail == null)
      return null; //list is empty

    tail = tail.prev;

    return ptr.elem;
  }//end popBack

  //pop ith position, index starts at 1

  //add ordered

  //add at ith position
  
  //find
  public boolean find(Object elem){
    Node ptr = head;

    while(ptr !=null){
      if(ptr.elem.equals(elem))
        return true;
      ptr = ptr.next;
    }
    return false;
  }//end isElem

  //reset
  public void reset(){
    //reset head
    head = null;

    //reset tail
    tail = null;

  }//end reset

}//end class LinkedList
