/*
 * =====================================================================================
 *
 *       Filename:  dynamicArray.c
 *
 *    Description:  dynamically allocated space for an array 
 *    
 *        Version:  1.0
 *        Created:  03/01/2015 12:26:39
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */
#include "dynamicArray.h"

elemtype * makeDynamicArr(int *arrLength, int *totalAllocated, elemtype arr[], elemtype data){

  //check if the current array length is equal to the totalAllocated
  //space for the array
  if((*arrLength) == (*totalAllocated)){

    //allocated space for new arr
    elemtype *temp = (elemtype*)malloc(((*totalAllocated)*2+1)*sizeof(elemtype));

    //copy contents of arr to temp
    arrayCopy(temp, arr, *arrLength);
    
    //clear contents of arra and reassign to temp
    free(arr);
    arr = temp;
    *totalAllocated=((*totalAllocated)*2)+1;
    
  }//end dynamic allocation

  arr[*arrLength] = data;
  (*arrLength)++;

  return arr;
}//end dynamicArr

elemtype * cleanArr(int arrLength, int totalAllocated, elemtype *arr){

  elemtype *temp = (elemtype*)malloc(sizeof(elemtype)*arrLength);

  arrayCopy(temp, arr, arrLength); 

  free(arr);
  arr = temp;

  return arr;
}//end cleanArr

void arrayCopy(elemtype *toArr, elemtype *fromArr, int len){
  int i;
  for(i=0; i<len; i++){
    toArr[i] = fromArr[i];
  }
}//end arrayCopy

void printArray(elemtype arr[], int len){
  int i;
  for(i=0; i<len; i++){
    printf(" "FORMAT" ", arr[i]); 
  }
  printf("\n");
}

void destroyArr(elemtype *arr){
  free(arr);
}
