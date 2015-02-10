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
typedef struct xy_list_struct LIST;

/** function: stk_create
 * description: allocates the space for a stack
 *              returns a pointer to a node
 * */
extern LIST * stk_create();

/** function: stk_push
 * description: pushes a given value on to the front of the stack
 * */
extern void stk_push(LIST *l, Elemtype mval, Elemtype nval);

/** function: stk_print
 * description: prints the currnt values in the stack 
 * */
extern void stk_print(LIST *l);

/** function: stk_pop_front
 * description: pops a value of the stack and returns that value */
extern LIST * stk_pop(LIST *l);

/** function: stk_destroy
 * description: frees the stack 
 * */
extern void stk_destroy(LIST *l);

/** function: stk_reset
 * description: resets the stack to NULL
 */
extern void stk_reset(LIST *l);

/** function: stk_top
 *  description: returns the top of the stack  
 */
extern void stk_top(LIST *l, Elemtype *mTop, Elemtype *nTop);

/** function: stk_isempty
 * description: return 1 if the stack is empty, 0 otherwise */
extern int stk_isempty(LIST *l);

/** function: stk_print_reverse
 * description: prints the stack in reverse order
 */
extern void stk_print_reverse(LIST *l);

/** function: stk_length
 * decription: prints the length of the current stack
 */
extern int stk_length(LIST *l);
