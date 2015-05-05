public class LinkedList {

  private Node head;
  private Node tail;
  private static int numItems;

  //used to test LinkedList
  public static void main (String [] args){
    //place test code here
    //LinkedList list = new LinkedList();

    /*
    list.push(10);
    list.push(9);
    list.push(8);
    list.enqueue(11);
    list.enqueue(12);
    list.print();
    list.addOrdered(13);
    list.addOrdered(12);
    list.addOrdered(11);
    list.addOrdered(14);
    list.addOrdered(12);
    list.addOrdered(20);
    list.print();
    list.addOrdered(16);
    list.addOrdered(21);
    list.addOrdered(14);
    list.addOrdered(10);
    //list.printReverse();
    list.print();
    //System.out.println("top: " + list.top());
    //System.out.println("back: " + list.back());
    */

  }//end main

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
    return this.top();
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

    if(head != null){
      head.prev = newNode;
    }
    else{ //head is null
      tail = newNode;
    }
    head = newNode;

    numItems++;
  }//end push

  //enqueue (add to back)
  public void enqueue(Object val){
    Node newNode = new Node(val);

    newNode.next = null;
    newNode.prev = tail;

    if(tail != null)
      tail.next = newNode;

    tail = newNode;

    numItems++;
  }//end enqueue

  //dequeue (same as pop, remove from front)
  public Object dequeue(){
    return this.pop();
  }//end dequeue

  //pop
  public Object pop(){

    Node ptr = head;

    if(ptr == null)
      return null; //list is empty

    head = head.next;
    head.prev = null;

    numItems--;

    return ptr.elem;
  }//end pop

  //pop back
  public Object popBack(){

    Node ptr = tail;

    if(tail == null)
      return null; //list is empty

    ptr = tail.prev;
    ptr.next = null;
    tail = ptr;

    numItems--;

    return ptr.elem;
  }//end popBack

  //push ith position, index starts at 1
  public void pushI(Object val, int index){

    if(index <= 1 || head == null){ //push to front of list
      this.push(val);
      return;
    }
    else if(index > numItems){ //push to back of list (enqueue)
      this.enqueue(val);
      return;
    }

    Node curr = head;
    Node prev = null; 
    Node next = head.next;

    int count = 1;

    //index must be in the middle of the list
    while( curr != null ){

      if(count == index){
        Node newNode = new Node(val);

        prev.next = newNode;
        newNode.prev = prev;

        newNode.next = curr;
        curr.prev = newNode;

        numItems++;

        return;
      }

      count++;
      prev = curr;
      curr = next;
      next = curr.next;
    }

    return;

  }//end pushI

  //pop ith position, index starts at 1
  public Object popI(int index){

    if(head == null)
      return null;//list is empty

    Node ptr = head;

    int count = 1;

    //check if index is out of range
    if(index <= 1){  
      return this.pop();
    }
    else if(index >= numItems){
      return this.popBack();
    }

    while(ptr != null && count <=numItems){

      if(count == index){
        ptr.prev.next = ptr.next;
        ptr.next.prev = ptr.prev;
        ptr.next = null;
        ptr.prev = null;
        numItems--;
        return ptr;
        //System.out.println("pop: " + count);
      }

      count++;
      ptr = ptr.next;
    }

    return null;

  }//end popI

  //add ordered
  public void addOrdered(Object val){

    Node ptr = head;

    int count = 1;

    while((ptr != null) && ((Integer)val >= (Integer)ptr.elem)){
      ptr = ptr.next;
      count++;
    }

    this.pushI(val, count);

  }//end addOrdered

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

    numItems = 0;

  }//end reset

}//end class LinkedList
