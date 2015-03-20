/*
 * =====================================================================================
 *
 *       Filename:  stack.h
 *
 *    Description:  header file for stack adt
 *
 *        Version:  1.0
 *        Created:  02/27/2015 19:23:57
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
#include <string.h>

typedef int elemtype;
#define FORMAT "%i"

typedef struct list_struct LIST;

/*
 * function: isDebugMode
 * description: checks if the user enabled debug mode using -d after the file name in
 *              stdin
 */
void checkDebugMode(char *mode);

/*
 * function: stk_create
 * description: allocates space for the stack and creates and
 *              points to a dummy node at the front of the list
 */
extern LIST * stk_create();

/*
 * function: stk_push
 * description: pushes a given value to the front of the stack
 */
extern void stk_push(LIST *l, elemtype data);

/*
 * function: stk_pop
 * description: pops the first value at the front of the stack
 *              and returns that value
 */
extern int stk_pop(LIST *l);

/*
 * function: stk_print
 * description: prints the current stack (except for the dummy node)
 */
extern void stk_print(LIST *l);

/*
 * function: stk_reset
 * description: resets the current stack and points
 *              to the dummy node 
 */
extern void stk_reset(LIST *l);

/*
 * function: stk_destroy
 * description: frees all contents in the stack
 */
extern void stk_destroy(LIST *l);

/*
 * function: stk_top
 * description: returns the top of the stack
 */
extern elemtype stk_top(LIST *l);

/*
 * function: stk_pop_back
 * description: pops the back of the stack, simulates a queue
 */
extern elemtype stk_pop_back(LIST *l);

/*
 * function: stk_isempty
 * description: returns 1 if the stack is empty, 0 otherwise
 */
int stk_isempty(LIST *l);
