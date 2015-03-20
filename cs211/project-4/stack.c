/*
 * =====================================================================================
 *
 *       Filename:  stack.c
 *
 *    Description:  stack ADT
 *
 *        Version:  1.0
 *        Created:  02/27/2015 19:25:51
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

#include "stack.h"

typedef struct stack_struct {
  elemtype data;
  struct stack_struct *next;
} NODE;

struct list_struct {
  NODE *front;
}; 

int debugMode = 0;

void checkDebugMode(char *mode){

  if(strcmp(mode, "-d") == 0){
    debugMode = 1;
    printf("\nDebug mode enabled\n\n");
  }

}//end checkDebugMode

LIST * stk_create(){
  LIST *l = (LIST*)malloc(sizeof(LIST));

  if(l == NULL){
    printf("Error, couldn't allocate space for the stack pointer\n");
    exit(-1);
  }
  NODE *dummy = (NODE*)malloc(sizeof(NODE));

  if(dummy == NULL){
    printf("Error, couldn't allocate space for the dummy node\n");
    exit(-1);
  }

  dummy->data = -1;
  dummy->next = NULL;

  l->front = dummy;

  return l;
}//end stk_create

void stk_push(LIST *l, elemtype val){

  NODE *curr = l->front;

  NODE *newNode = (NODE*)malloc(sizeof(NODE));

  /* insert new node just after the dummy node */
  newNode->next = l->front->next;
  l->front->next = newNode;

  newNode->data = val;
}//end stk_push

int stk_pop(LIST *l){
  int val;

  NODE *tmp = l->front; //point tmp at the dummy node
  NODE *curr = l->front->next; //point curr at the node to be popped

  tmp->next = curr->next; //point dummy next to node after node to be popped

  val = curr->data;
  free(curr);

  return val;
}//end stk_pop

void stk_reset(LIST *l){

  NODE *curr = l->front->next;
  NODE *tmp = curr;

  while(curr != NULL){
    tmp = curr->next;
    free(curr);
    curr = tmp;
  }

  l->front->next = NULL; //reset dummy node next to point to null

  if(debugMode == 1)
    printf("Stack reset\n");

}//end stk_reset

void stk_destroy(LIST *l){

  NODE *curr = l->front; //remove dummy node at front as well
  NODE *tmp;

  while(curr != NULL){
    tmp = curr->next;
    free(curr);
    curr = tmp;
  }
  free(l);

  if(debugMode == 1)
    printf("Stack erased from memory\n");

}//end stk_destroy

void stk_print(LIST *l){

  NODE *curr = l->front->next; //skip the dummy node

  if(curr != NULL)
    if(debugMode == 1)
      printf("Contents of the stack: \n");

  while(curr != NULL){
    printf("[");
    printf(FORMAT, curr->data);
    printf("] ");
    curr = curr->next;
  }
  printf("\n");

}//end stk_print 

elemtype stk_top(LIST *l){

  NODE *curr = l->front->next;

  if(curr != NULL)
    return curr->data; 
  else{
    return -1;
  }
}//end stk_pop_back

elemtype stk_pop_back(LIST *l){

  elemtype val;

  NODE *curr = l->front;
  NODE *prev = NULL;

  while(curr->next != NULL){
    prev = curr;
    curr = curr->next; 
  }
  //retrieve value from back of stack
  val = curr->data;
  free(curr);
  prev->next = NULL;

  return val;
}//end stk_pop_back

int stk_isempty(LIST *l){

  NODE *stk = l->front;

  if(stk->next == NULL)
    return 1;
  return 0;

}//end stk_isempty
