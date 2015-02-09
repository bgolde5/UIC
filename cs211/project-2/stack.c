/*
 * =====================================================================================
 *
 *       Filename:  stack.c
 *
 *    Description:  client file for a stack implementation
 *
 *        Version:  1.0
 *        Created:  12/16/2014 13:40:53
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
  Elemtype val;
  struct stack_struct *next;
  struct stack_struct *prev;
} NODE ;

struct list_struct {
  NODE *front;
  NODE *back;
} ;

LIST * stk_create(){

  LIST *l= malloc(sizeof(LIST));
  l->front = NULL;
  l->back = NULL;
  
  return l;
}//end stk_create

void stk_push_front(LIST *l, Elemtype val){
  NODE *stk = malloc(sizeof(NODE));

  stk->next = l->front;
  stk->prev = NULL;
  stk->val = val;
  l->front = stk;
}//end stk_push_front

void stk_print(LIST *l){
  NODE *stk = l->front;

  if(stk == NULL)
    printf("[ ]");
  while(stk != NULL){
    printf("[ ");
    printf(FORMAT, stk->val);
    stk = stk->next;
    printf(" ]");
  }
  printf("\n");
}//end stk_print

Elemtype stk_pop_front(LIST *l){
  Elemtype ret;

  NODE *stk = l->front;

  if(stk == NULL) { //no elements
    printf("Error: Cannot pop empty stack\n");
    return DEFAULT;
  }
  else if(l->front == l->back){ //one element
    ret = l->front->val;
    free(l->front);
    l->front = NULL;
    l->back = NULL;
  }
  else{ //more than one element
    ret = l->front->val;
    stk = stk->next;
    free(l->front);
    l->front = stk;
  }

  return ret;
}//end stk_pop_front

void stk_destroy(LIST *l){
  NODE *stk = l->front;
  NODE *stkNext;
  while(stk != NULL){
    stkNext = stk->next;
    free(stk); 
    stk = stkNext;
  } 
  free(l);
}//end stk_destroy
