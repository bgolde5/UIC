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

//original stack structs... not used...
typedef struct stack_struct {
  Elemtype val;
  struct stack_struct *next;
  struct stack_struct *prev;
} NODE ;

struct list_struct {
  NODE *front;
  NODE *back;
} ;

//modified stack structs for the purpose of maze.c
typedef struct xy_stack_struct{
  Elemtype mval;
  Elemtype nval;
  struct xy_stack_struct *next;
  struct xy_stack_struct *prev;
} XYNODE ;

struct xy_list_struct {
  XYNODE *front;
  XYNODE *back;
} ;


LIST * stk_create(){

  LIST *l= malloc(sizeof(LIST));
  l->front = NULL;
  l->back = NULL;
  
  return l;
}//end stk_create

void stk_push(LIST *l, Elemtype mval, Elemtype nval){
  XYNODE *stk = malloc(sizeof(XYNODE));

  stk->next = l->front;
  stk->prev = NULL;
  stk->mval = mval;
  stk->nval = nval;
  l->front = stk;
}//end stk_push_front

void stk_print(LIST *l){
  XYNODE *stk = l->front;

  if(stk == NULL)
    printf("[ ]");
  while(stk != NULL){
    printf("[ ");
    printf(FORMAT, stk->mval);
    printf(",");
    printf(FORMAT, stk->nval);
    stk = stk->next;
    printf(" ]");
  }
  printf("\n");
}//end stk_print

//not used in program...junk function
void stk_print_reverse(LIST *l){
  XYNODE *stk = l->front;
  LIST *temp = stk_create();
  int mval, nval;

  if(stk == NULL)
    printf("[ ]");

  while(stk != NULL){
    stk_top(l, &(stk->mval), &(stk->nval));
    mval = stk->mval;
    nval = stk->nval;
    stk_push(temp, mval, nval);
    stk = stk->next;
    stk_pop(l);
  }
  stk_print(temp);

  free(temp);

}//end stk_print_reverse

LIST *stk_pop(LIST *l){

  XYNODE *stk = l->front;

  if(stk == NULL) { //no elements
    exit(-1);
  }
  else if(l->front == l->back){ //one element
    stk->mval = l->front->mval;
    stk->nval = l->front->nval;
    free(l->front);
    l->front = NULL;
    l->back = NULL;
  }
  else{ //more than one element
    stk->mval = l->front->mval;
    stk->nval = l->front->nval;
    stk = stk->next;
    free(l->front);
    l->front = stk;
  }

  return l;
}//end stk_pop

void stk_destroy(LIST *l){
  XYNODE *stk = l->front;
  XYNODE *stkNext;
  while(stk != NULL){
    stkNext = stk->next;
    free(stk); 
    stk = stkNext;
  } 
  free(l);
}//end stk_destroy

void stk_reset(LIST *l){

  XYNODE *stk = l->front;
  XYNODE *stkNext;
  while(stk != NULL){
    stkNext = stk->next;
    free(stk);
    stk = stkNext;
  }
  l->front = NULL;

  l->back = NULL;
}//end stk_reset

void stk_top(LIST *l, Elemtype *mTop, Elemtype *nTop){
  XYNODE *stk = l->front;

  if(stk != NULL) {
    *mTop = l->front->mval;
    *nTop = l->front->nval;
  }

}//end stk_top

int stk_isempty(LIST *l){
  XYNODE *stk = l->front;

  if(stk == NULL)
    return 1;

  return 0;
}//end stk_isempty

int stk_length(LIST *l){
  XYNODE *stk = l->front;
  int count = 0;

  if(stk==NULL)
    return 0;

  while(stk != NULL){
    count++;
    stk = stk->next;
  }
  return count;
}
