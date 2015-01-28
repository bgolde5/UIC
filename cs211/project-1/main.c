/*
 * =====================================================================================
 *
 *       Filename:  main.c
 *
 *    Description:  Utilizes arr.c and arr.h
 *
 *        Created:  01/20/2015 14:38:17
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

#include "arr.h"

int main(int argc, char** argv){
  int size = 0;
  int numComparisons = 0;
  int searchVal;
  int temp;

  printf("\n");
  printf("Step 1: Getting file information...\n");
  int *data = readFile(&size);
  //printArray(data, size);
  printf("\n");

  int *arr1 = data;
  int arr2[size];

  printf("Step 2: Copying array....\n"); 
  arrayCopy(arr1, arr2, &size);
  //printArray(arr2, size);
  printf("\n");

  printf("Step 3: Sorting array...\n");
  sort(arr1, size);
  //printArray(arr1, size);
  printf("\n");

  while(searchVal != -999){
    printf("Enter an integer to search for, or enter -999 to terminate the program: ");
    scanf("%i", &searchVal);
    if(searchVal == -999){
      printf("\nGoodbye!\n\n");
      break;
    }
    printf("\n");

    printf("Step 4: Performing linear search...\n");
    if(lsearch(arr2, size, searchVal, &numComparisons) > 0)
      printf("Search successful, %i found after %i comparisons!\n", searchVal, numComparisons);
    else
      printf("Search failed after %i comparisons!\n", numComparisons);
    printf("\n");

    numComparisons = 0;
    printf("Step 5: Performing binary search...\n");
    if(bisearch(arr1, size, searchVal, &numComparisons) > 0)
      printf("Search successful, %i found after %i comparisons!\n", searchVal, numComparisons);
    else
      printf("Search failed after %i comparisons!\n", numComparisons);
    printf("\n");
  }

}//end main
