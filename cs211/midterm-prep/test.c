/*
 * =====================================================================================
 *
 *       Filename:  test.c
 *
 *    Description:  test ADT stack
 *
 *        Version:  1.0
 *        Created:  02/27/2015 19:47:15
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

#include "stack.h"
#include "dynamicArray.h"

int main(int argc, char** argv){

  if(argv[1] != NULL)
    checkDebugMode(argv[1]); 

  LIST *stk = stk_create();

  int i;
  for(i=0; i<5; i++)
    stk_push(stk, i);

  //printf("%i has been popped\n", stk_pop(stk));

  stk_print(stk);
  stk_reset(stk);

  for(i=0; i<5; i++)
    stk_push(stk, i);

  stk_print(stk);

  stk_destroy(stk);

  printf("Check dynamic array\n");

  int curr = 0;
  int end = 10;
  int totalAllocated = 1;
  int *arr = malloc(sizeof(int));
  int arrLength = 0;
  while(curr != end){
    arr = makeDynamicArr(&arrLength, &totalAllocated, arr, curr);
    curr++;
  } 

  printArray(arr, arrLength);
  arr = cleanArr(arrLength, totalAllocated, arr);
  printArray(arr, arrLength);

  destroyArr(arr);

}//end main
