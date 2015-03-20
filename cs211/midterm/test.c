/*
 * =====================================================================================
 *
 *       Filename:  test.c
 *
 *    Description:  tests queue implemetation
 *
 *        Version:  1.0
 *        Created:  03/04/2015 09:17:38
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

#include "queue.h"

int main(int argc, char** argv){

  int i = 0;

  LIST *queue = queue_create();
  LIST *stack = queue_create();

  readFile(stack, argv[1]);

  //print_queue(stack);

  while( isSEmpty(stack) != TRUE ){
    if(i%6 == 0)
      printf("\n");

    data d = top(stack);

    printf("%0.3f\t", d);

    pop(stack);

    i++;
  }
  printf("\n\n");

  return 0;
}//end main
