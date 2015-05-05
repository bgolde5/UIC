import java.io.*;
import java.util.*;

public class Bgolde5Exam2 {

  public static LinkedList list = new LinkedList();

  public static void main(String[] args){

    if(args.length < 2){
      System.out.println("Incorrect input, please enter 2 command line args");
      return;
    }

    LinkedList temp = new LinkedList();
    String fname = args[0];
    String bStr = args[1];

    int bDepth = Integer.parseInt(bStr);
    int input_size;
    int input_max;
    int input_min;

    //step 1
    doFile(fname);
    input_size = list.getSize();
    input_min = list.getMin();
    input_max = list.getMax();

    //step 2
    int bucket_width = bucketWidth(bDepth);
    //System.out.println(bucket_width);
    int buckets_needed = bucketsNeeded(bDepth);
    //System.out.println(buckets_needed);
    int input_range = inputRange();
    //System.out.println(input_range);
    
    //step 3
    int step = 20;
    int bucketSteps = buckets_needed+step;
    LinkedList[] arr = new LinkedList[bucketSteps];

    for(int i = 0;i < buckets_needed+step; i++)
      arr[i] = new LinkedList();

    //step 4
    Node lptr = list.head;

    int index;
    int value;
    while(lptr != null){
      index = ((Integer)lptr.elem - input_min) / bucket_width;
      value = (Integer)lptr.elem;
      arr[index].insertInOrder(value);
      lptr = lptr.next;
    }

    //step 5
    System.out.println("--==Bucket Contents==--");
    printList(arr, buckets_needed+1);

    //step 6
    int intArr[] = new int[input_size];
    int j = 0;
    Node ptr = null;
    for(int i = 0; i < bucketSteps; i++){
      ptr = arr[i].head;
      while(ptr != null){
        value = (Integer)ptr.elem;
        intArr[j] = value;
        j++;
        ptr = ptr.next;
      }
    }

    //step 7
    System.out.println("--==Array Contents==--");
    for(int i = 0; i < input_size; i++)
      System.out.print(intArr[i] + " ");
    System.out.println();
  }//end main

  public static void doFile(String fname){

    int val;
    int max = 0;
    int min = 99;

    //open file
    File file = new File(fname);

    try {

      Scanner scanner = new Scanner(file);

      //while (scanner.hasNextLine()) {
      while (scanner.hasNextInt()) {
        val = scanner.nextInt();
        //String line = scanner.nextLine();
        //val = Integer.parseInt(line);

        if(val > max){
          max = val;
        }
        if(val < min){
          min = val;
        }
        list.push(val);
      }
      scanner.close();
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    }

    list.setMax(max);
    list.setMin(min);

  }//end doFile

  public static void printList(LinkedList[] arr, int size){
    LinkedList ptr;
    for(int i=0; i<size; i++){
      ptr = arr[i];
      ptr.print();
    }
  }//end printList

  public static int bucketsNeeded(int desired_bucket_depth){
    int input_size = list.getSize();
    return (input_size / desired_bucket_depth);
  }//end bucketsNeeded

  public static int inputRange(){
    return ((list.getMax() - list.getMin()) + 1);
  }//end inputRange

  public static int bucketWidth(int num_buckets){
    return inputRange() / bucketsNeeded(num_buckets);
  }//end bucketWidth

}//end class Final
