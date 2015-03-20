/*
 * =====================================================================================
 *
 *       Filename:  queue.c
 *
 *    Description:  queue implemention
 *
 *        Version:  1.0
 *        Created:  03/04/2015 09:00:45
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

#include "queue.h"
typedef struct stack_struct {
  data val;
  struct stack_struct *next;
} NODE;

struct list_struct {
  NODE *front;
};

LIST * queue_create(){
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

  dummy->val = -1;
  dummy->next = NULL;

  l->front = dummy;

  return l;
}//end queue_create

int isQEmpty(LIST *l){
  if(l->front->next == NULL){
    return TRUE;
  }
  else
    return FALSE;
}//end isQEmpty

data front(LIST *l){

  NODE *curr = l->front->next;

  return curr->val; 

}//end front 

void removeFront(LIST *l){

  NODE *tmp = l->front; //point tmp at the dummy node
  NODE *curr = l->front->next; //point curr at the node to be popped

  tmp->next = curr->next; //point dummy next to node after node to be popped

  free(curr);
}//end stk_pop

void addToEnd(LIST *l, data val){

  NODE *curr = l->front;
  NODE *prev = NULL;
  NODE *back = (NODE*)malloc(sizeof(NODE));
  back->next = NULL; //make back next null
  back->val = val;

  while(curr->next != NULL){
    prev = curr;
    curr = curr->next; 
  }
  //curr is now at the end of the linked list
  curr->next = back; //point last node in list to back

}//end addToEnd

void print_queue(LIST *l){

  NODE *curr = l->front->next; //skip the dummy node

  while(curr != NULL){
    printf("[");
    printf(FORMAT, curr->val);
    printf("] ");
    curr = curr->next;
  }
  printf("\n");
}// end print_queue

int isSEmpty(LIST *l){
  return isQEmpty(l);
}//end isSEmpty

data top(LIST *l){
  return front(l);
}//end top

void pop(LIST *l){

  removeFront(l);

}//end stk_pop

void push(LIST *l, data d){
  addToEnd(l, d);

  while( d != front(l)){
    addToEnd(l,front(l));
    removeFront(l);
  }
}//end push

void readFile(LIST *l, char *filename){

  LIST *stk = l;

  //holds values read from file
  float tempData = 0;

  //open file and read
  FILE *ifp;
  char *mode = "r";

  //prompt user for file name
  ifp = fopen(filename, mode);

  if (ifp == NULL) {
    fprintf(stderr, "Can't open input file %s!\n", filename);
    exit(1);
  }

  //read integers from file
  while(fscanf(ifp, " %f", &tempData) != EOF){

    push(stk, tempData);

  }//end while

  //close file
  fclose(ifp);

}//end readFile
