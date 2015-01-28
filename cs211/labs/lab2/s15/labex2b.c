#include <stdio.h>
#include <stdlib.h>

int main (int argc, char** argv)
{
 int* arr1;
 int size1 = 100;
 int arr2[100];

 /* QUESTION 6  and 7 */
 /* some information about the sizeof() function */
 printf ("Sizeof int:   %d\n", sizeof(int) );
 printf ("Sizeof size1: %d\n", sizeof(size1) );
 printf ("Sizeof int*:  %d\n", sizeof(int*) );
 printf ("Sizeof arr1:  %d\n", sizeof(arr1) );
 printf ("Sizeof arr2:  %d\n", sizeof(arr2) );

 printf ("Initial address of arr1: %d\n", arr1);

 /* allocate an array of "size1" values */
 arr1 = (int *) malloc (sizeof(int) * size1);

 printf ("New address of arr1: %d\n", arr1);

 /* QUESTION 8 */
 /* store values into the dynamically allocated array                     */
 /* - NOTE: we would normally just use the value in "size1" and not "max" */
 /*    "max" is used to correspond to Question 8 in the lab exercise      */
 int max = 100;
 int i;
 for (i = 0 ; i < max ; i++)
  {
   arr1[i] = i;
  }

 /* print out the values just stored into the array */
 printf ("\nThe original values in the array:\n");
 for (i = 0 ; i < max; i++)
  {
   printf ("%d ", arr1[i]);
   if ((i+1)%10 == 0)
     printf ("\n");
  }
 printf ("\n");

 int originalSize = size1;

 /* QUESTIO 10 */
 /* code from Programming Project 1 description to "grow the array" */
 /* - modified so the variable names match the above code           */
 /* - this code will double the size of the current array           */ 
 
 /* allocate new space for the larger array */
 int *temp;
 temp = (int *) malloc ( size1 * 2 * sizeof(int) );
 
 /* copy the existing values from the original array to the larger array */
 for ( i = 0 ; i < size1 ; i++)
   temp[i] = arr1[i];

 /* return the allocated memory from the original array back to the OS */
 free (arr1);

 /* have the variable arr1 refer to the location in memory of the larger array */
 arr1 = temp;

 /* update the size1 variable to properly reflect the current size of the array */ 
 size1 = size1 * 2;

 /* add some new values into the array */
 for (i = originalSize ; i < size1 ; i++)
  {
   arr1[i] = 1000 + i;
  }

 /* print out the values just stored into the array */
 printf ("\nThe current values in the array:\n");
 for (i = 0 ; i < size1; i++)
  {
   printf ("%d ", arr1[i]);
   if ((i+1)%10 == 0)
     printf ("\n");
  }
 printf ("\n");


 return 1;
}
