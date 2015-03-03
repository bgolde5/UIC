/*
 * =====================================================================================
 *
 *       Filename:  arr.c
 *
 *    Description:  Programming Project 1 for CS211
 *
 *        Created:  01/14/2015 14:42:31
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

#include "arr.h"

//reads data from a file of type int and allocates memory dynamically
int *readFile(int *totalAllocated){
  int tempData = 0;
  int length = 0;
  *totalAllocated = 0;
  int *arr = (int*)malloc((*totalAllocated)*sizeof(int));
  int num_ints = 0;
  int *temp;

  char fileName[100];

  //open file and read
  FILE *ifp;
  char *mode = "r";

  //prompt user for file name
  printf("What is the name of the file you wish to read from? >> ");
  scanf("%s", fileName);
  ifp = fopen(fileName, mode);

  if (ifp == NULL) {
    fprintf(stderr, "Can't open input file %s!\n", fileName);
    exit(1);
  }

  //read integers from file
  while(fscanf(ifp, "%i", &tempData) && tempData != -999){ 
    num_ints++;

    //dynamically allocate space for new array of size (n*2)+1
    if(length == *totalAllocated){
      temp = (int*)malloc((((*totalAllocated)*2)+1)*sizeof(int));

      //copy contents of arr into newly resized temp
      arrayCopy(arr, temp, &length);

      //clear contents of arr and reassign to temp
      free(arr);
      arr = temp;
      (*totalAllocated)=((*totalAllocated)*2)+1;
    }//end dynamic allocated

    arr[length] = tempData;
    (length)++;
  }//end while

  //close file
  fclose(ifp);

  //delete extra space allocated
  temp = (int*)malloc(num_ints*sizeof(int));
  arrayCopy(arr, temp, &num_ints);
  free(arr);
  arr = temp;

  //resize array based on total number of integers not including blank space
  *totalAllocated = num_ints;

  return arr; //reached EOF or -999
}//end readFile


void addToArray(int *length, int *arr1, int *totalAllocated, int *tempData){
  if(*length == *totalAllocated){
    int *temp = (int*)malloc((((*totalAllocated)*2)+1)*sizeof(int));
    (*totalAllocated)=((*totalAllocated)*2)+1;
    //printf("\nallocated %i\n", *totalAllocated);
    arrayCopy(arr1, temp, length);
    //free contents of arr1
    free(arr1);
    arr1 = temp;
  }
  arr1[*length] = *tempData;
  (*length)++;
}//end addToArray

void arrayCopy(int *fromArray, int *toArray, int *length){
  int i;
  for(i=0; i<*length; i++){
    toArray[i]=fromArray[i];
  }
}//end arrayCopy

void sort(int arr[], int size){

  //sortType is defined
  switch(sortType){
    case 1:
      bubbleSort(arr, size);
    case 2:
      selectionSort(arr, size);
  }
}//end sort

int lsearch(int arr[], int size, int target, int *numComparisons){
  int i;
  *numComparisons = 0;
  for(i=0; i<size; i++){
    (*numComparisons)++;
    if(arr[i] == target){
      return i;
    }
  }
  return -1;
}//end lsearch

int bisearch (int arr[], int size, int target, int *numComparisons){
  int i,j,hi,lo,mid;

  lo = 0;
  hi = size-1;

  *numComparisons = 0;
  while(lo <= hi){
    mid = (hi+lo)/2;

    (*numComparisons)++;
    if(arr[mid] == target){
      return mid;
    }
    else if(arr[mid] > target){
      hi = mid - 1;
    }
    else if(arr[mid] < target){ //else if used instead of else for readability
      lo = mid + 1;
    }
  }

  return -1;
}//end bisearch

void bubbleSort(int arr[], int size){
  int i, j, temp;

  for(i=0; i<size; i++){
    for(j=size; j>i; j--){
      if(arr[j-1] < arr[j]){
        temp = arr[j];
        arr[j] = arr[j-1];
        arr[j-1] = temp;
      }
    }
  }
}//end bubbleSort

void selectionSort(int arr[], int size){
  int i, j, temp;
  int smallestNum;

  for(i=0; i<size; i++){
    smallestNum = findSmallestNum(arr, size, i); //find index of smallest number in array after given index
    for(j=i; j<size; j++){
      temp = arr[smallestNum];
      arr[smallestNum] = arr[j];
      arr[j] = temp;
    }
  }
}//end selectionSort

//prints given array contents
void printArray(int* arr, int size){
  int i;
  for(i=0; i<size; i++){
    printf(" ""%i"" ", *arr); 
    arr++;
  }
  printf("\n");
}//end printArray

//finds the smallest number in a given array of size n at given start index
int findSmallestNum(int arr[], int size, int start){
  int index, temp, i, j;

  for(i=start; i<size; i++){
    for(j=i+1; j<size; j++){
      if(arr[j] < arr[i]){
        index = j;
      }
    }
  }
  //printf("smallest number: %i\n", index);
  return index;
}//end findSmallestNum
