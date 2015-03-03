/*
 * =====================================================================================
 *
 *       Filename:  restWaitSys.h
 *
 *    Description:  Header file for the restaurant waiting system
 *
 *        Version:  1.0
 *        Created:  02/21/2015 10:26:25 AM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu
 *   Organization:  University of Illiois at Chicago
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node {
  char name[100]; //max name size is 99
  int size;
  struct node *next;
  enum { call_ahead , arrive_at_restaurant } status; 
} node;

extern int debugMode;

/****************** client_system.c *********************/

/*
 * function: addToList
 * description: This operation adds a new node to the end 
 *              of the linked list. 
 *
 *              Used when the a and c commands are given as input.
 */
node *addToList(node *head, char *name, int size);

/*
 * function: doesNameExist
 * description: This operation returns a Boolean value 
 *              indicating whether a name already exists in 
 *              the linked list. 
 *
 *              Used when the a, c, w and l commands are given as input. 
 */
int doesNameExist(node *head, char *name);

/*
 * function: updateStatus
 * description: This operation changes the in-restaurant status 
 *              when a call-ahead group arrives at the restaurant. 
 *              This operation returns a FALSE value if that group 
 *              is already marked as being in the restaurant. 
 *
 *              Used when the w command is given as input.
 */
int updateStatus(node *head, char *name);

/*
 * function: retrieveAndRemove
 * description: This operation finds the first in-restaurant group
 *              that can fit at a given table. This operation returns 
 *              the name of group. This group is then removed from the 
 *              linked list. 
 *
 *              Used when the r command is given as input.
 */
void retrieveAndRemove(node *head, int size);

/*
 * function: countGroupsAhead
 * description: This operation returns the number of groups waiting ahead 
 *              of a group with a specific name. 
 *
 *              Used when the l command is given as input.
 */
int countGroupsAhead(node *head, char *name);

/*
 * function: displayGroupSizeAhead
 * description: This operation traverses down the list until a specific group name 
 *              is encountered. As each node is traversed, print out that node’s 
 *              group size. 
 *
 *              Used when the l command is given. 
 */
void displayGroupSizeAhead(node *head, char *name);

/*
 * function: displayListInformation
 * description: This operation traverses down the entire list from beginning to end. 
 *              As each node is traversed, print out that node’s group name, 
 *              group size and in-restaurant status. 
 *
 *              Used when the d command is given as input.
 */
void displayListInformation(node *head);

/****************** waiting_system.c *********************/

/*
 * function: doAdd
 * description: TODO
 */
void doAdd(node *head);

/*
 * function: doCallAhead
 * description: TODO
 */
void doCallAhead(node *head);

/*
 * function: doWaiting
 * description: TODO
 */
void doWaiting(node *head);

/*
 * function: doRetrieve
 * description: TODO
 */
void doRetrieve(node *head);

/*
 * function: doList
 * description: TODO
 */
void doList(node *head);

/*
 * function: doDisplay
 * description: TODO
 */
void doDisplay(node *head);

/****************** main.c *********************/

/* 
 * function: clearToEoln
 * description: TODO
 */
void clearToEoln();

/*
 * function: getNextNWSChar
 * description: TODO
 */
int getNextNWSChar();

/* 
 * function: getPosInt
 * description: TODO
 */
int getPosInt();

/*
 * function: getName
 * description: TODO
 */
char *getName();

/* 
 * function: printCommands
 * description: TODO
 */
void printCommands();
