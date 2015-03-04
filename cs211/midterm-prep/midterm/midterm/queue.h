/*
 * =====================================================================================
 *
 *       Filename:  queue.h
 *
 *    Description:  header file for queue implementation
 *
 *        Version:  1.0
 *        Created:  03/04/2015 09:13:52
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <stdlib.h>

typedef float data;
#define FORMAT "%f"

typedef struct list_struct LIST;

#define TRUE 1
#define FALSE 0

/*
 * function: queue_create
 * description: allocates space for a newly created queue
 */
LIST * queue_create();

/*
 * function: int isQEmpty
 * description: return true if queue is empty, false otherwise
 */
int isQEmpty(LIST *l);

/*
 * function: data front
 * description: return the data item at the front of the linked
 *              list (does NOT modify the linked list)
 */
data front(LIST *l);

/*
 * function: void removeFront
 * description: remove the first node from linked list 
 */
void removeFront(LIST *l);

/*
 * function: void addtoEnd
 * description: Add the data item to the end of the linked list
 */
void addToEnd(LIST *l, data val);

/*
 * function: void print_queue
 * description: prints the contents in the  queue
 */
void print_queue(LIST *l);

/*
 * function: int isSEmpty
 * desctiption: returns the value from a call to: isQEmpty
 */
int isSEmpty(LIST *l);

/*
 * function: data top
 * description: returns the value from a call to: front(stack)
 */
data top(LIST *l);

/*
 * function: void pop
 * description: calls removeFront(stack)
 */
void pop(LIST *l);

/*
 * function: void push
 * description: implements a push operation as defined by
 *              professor Troy's algorithm
 */
void push(LIST *l, data d);

/* function: void readFile 
 * description: reads the contents of a file and pushes them to the stack
 */
void readFile(LIST *l, char *filename);
