/*
 * =====================================================================================
 *
 *       Filename:  stack.h
 *
 *    Description:  header file to a basic stack-like implementation
 *
 *        Version:  1.0
 *        Created:  12/16/2014 13:36:39
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

//allow user to easily change data type
typedef int Elemtype;
#define FORMAT "%i"
#define DEFAULT 0

//allow user to access stack_struct
typedef struct list_struct LIST;

/** function: stk_create
 * description: allocates the space for a stack
 *              returns a pointer to a node
 * */
extern LIST * stk_create();

/** function: stk_push_front
 * description: pushes a given value on to the front of the stack
 * */
extern void stk_push_front(LIST *l, Elemtype val);

/** function: stk_print
 * description: prints the currnt values in the stack 
 * */
extern void stk_print(LIST *l);

/** function: stk_pop_front
 * description: pops a value of the stack and returns that value */
extern Elemtype stk_pop_front(LIST *l);

/** function: stk_destroy
 * description: frees the stack 
 * */
extern void stk_destroy(LIST *l);
