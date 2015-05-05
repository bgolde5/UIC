public class Node {
  public Object elem;
  public Node next;
  public Node prev;

  public Node (Object val) {
    elem = val;
    next = null;
    prev = null;
  }
}
