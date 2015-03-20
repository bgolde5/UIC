/*  Code for the user interface for Lab 4 for CS 211 Spring 2015  
 *
 *  Author: Pat Troy
 *  Original Date: 10/13/2013
 *
 *  Student Author: Bradley Golden
 *  Completion Date: 3/7/2015
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "stack.h"

typedef enum {FALSE = 0, TRUE, NO = 0, YES} boolean;

typedef enum {ERROR = 0, OPERATOR, VALUE, EOLN, QUIT, HELP} tokenType;

typedef enum {MULTIPLICATION = 0, DIVISION, ADDITION, SUBTRACTION } operation;

typedef struct tokenStruct
{
 tokenType type;
 char      op;
 int       val;
} token;

token getInputToken (FILE *in);

int setDebugMode = 0;

int isEmpty(LIST *l){
  return stk_isempty(l); //function from stack.h ADT
}//end isEmpty

void push(LIST *l, elemtype data){
  stk_push(l, data); //function from stack.h ADT
}//end push

elemtype top(LIST *l){
  if(isEmpty(l)){
    printf("Error: Cannot access the top of the stack, because the stack is empty.\n");
    return -999;
  }
  return stk_top(l);
}//end top

void pop(LIST *l){   
  stk_pop(l); //function from stack.h ADT
}//end pop

int eval(int val1, int op, int val2){

  if(op == '*') 
    return val1 * val2;
  else if(op == '/')
    return val1 / val2;
  else if(op == '+')
    return val1 + val2;
  else if(op == '-')
    return val1 - val2; 
  else{
    printf("Error: Invalid operator when expression is evaluated.\n");
    return -999;
  }

}//end eval

elemtype topPop(LIST *l){
  if(isEmpty(l)){
    printf("Error: Attempted to pop the top of the stack when it is empty.\n");
    return -999;
  }
  return stk_pop(l); //function from stack.h ADT
}//end topPop

void popAndEval(LIST *opStk, LIST *valStk){
  int op, v2, v1, v3;

  if(isEmpty(opStk)){
    printf("Error: Operator stack is empty when it shouldn't be.\n");
  }

  op = topPop(opStk);

  if(isEmpty(valStk)){
    printf("Error: Value stack is empty when it shouldn't be.\n");
  }
  v2 = topPop(valStk);

  if(isEmpty(valStk)){
    printf("Error: Value stack is empty when it shouldn't be.\n");
  }

  v1 = topPop(valStk);

  v3 = eval(v1, op, v2); 

  push(valStk, v3);

}//end popAndEval

void processExpression (token inputToken, FILE *in)
{
  /**********************************************/
  /* Declare both stack head pointers here      */
  LIST *op_stk = stk_create();
  LIST *val_stk = stk_create(); 

  /* Loop until the expression reaches its End */
  while (inputToken.type != EOLN)
  {
    /* The expression contains an OPERATOR */
    if (inputToken.type == OPERATOR)
    {
      /* make this a debugMode statement */
      if(setDebugMode)
        printf ("OP:%c, " ,inputToken.op);
      if (inputToken.op == '('){
        push(op_stk, inputToken.op);
      }
      if (inputToken.op == '+' || inputToken.op == '-'){
        while(!isEmpty(op_stk) && 
            (top(op_stk) == '+' || top(op_stk) == '-' 
             || top(op_stk) == '*' || top(op_stk) == '/')){ 
          popAndEval(op_stk, val_stk);
        }
        push(op_stk, inputToken.op);
      }
      if (inputToken.op == '*' || inputToken.op == '/'){
        while(!isEmpty(op_stk) && 
            (top(op_stk) == '*' || top(op_stk) == '/')) 
          popAndEval(op_stk, val_stk);
        push(op_stk, inputToken.op);
      }
      if (inputToken.op == ')'){
        while(!isEmpty(op_stk) && 
            (top(op_stk) != '(')){ 
          popAndEval(op_stk, val_stk);
        }
        if(isEmpty(op_stk)){
          printf("Error: stack is empty when it shouldn't be.\n");
        }
        else{
          topPop(op_stk);
        }
      }
    }
    /* The expression contain a VALUE */
    else if (inputToken.type == VALUE)
    {
      /* make this a debugMode statement */
      if(setDebugMode)
        printf ("Val: %d, ", inputToken.val); 

      push(val_stk, inputToken.val);
    }

    /* get next token from input */
    inputToken = getInputToken (in);
  } 

  /* The expression has reached its end */
  while(!isEmpty(op_stk)){
    popAndEval(op_stk, val_stk);
  }

  printf("RESULT: %i\n", top(val_stk));

  topPop(val_stk);

  if(!isEmpty(val_stk)){
    printf("Error: the stack is not empty when it should be.\n");
  }

  printf ("\n");

  stk_destroy(val_stk);
  stk_destroy(op_stk);
}

/**************************************************************/
/*                                                            */
/*  The Code below this point should NOT need to be modified  */
/*  for this program.   If you feel you must modify the code  */
/*  below this point, you are probably trying to solve a      */
/*  more difficult problem that you are being asked to solve  */
/*                                                            */
/**************************************************************/

token getInputToken (FILE *in)
{
  token retToken;
  retToken.type = QUIT;

  int ch;
  ch = getc(in);
  if (ch == EOF)
    return retToken;
  while (('\n' != ch) && isspace (ch))
  {
    ch = getc(in);
    if (ch == EOF)
      return retToken;
  }

  /* check for a q for quit */
  if ('q' == ch)
  {
    retToken.type = QUIT;
    return retToken;
  }

  /* check for a ? for quit */
  if ('?' == ch)
  {
    retToken.type = HELP;
    return retToken;
  }

  /* check for the newline */
  if ('\n' == ch)
  {
    retToken.type = EOLN;
    return retToken;
  }

  /* check for an operator: + - * / ( ) */
  if ( ('+' == ch) || ('-' == ch) || ('*' == ch) ||
      ('/' == ch) || ('(' == ch) || (')' == ch) )
  {
    retToken.type = OPERATOR;
    retToken.op = ch;
    return retToken;
  }

  /* check for a number */
  if (isdigit(ch))
  {
    int value = ch - '0';
    ch = getc(in);
    while (isdigit(ch))
    {
      value = value * 10 + ch - '0';
      ch = getc(in);
    }
    ungetc (ch, in);  /* put the last read character back in input stream */
    retToken.type = VALUE;
    retToken.val = value;
    return retToken;
  }

  /* else token is invalid */
  retToken.type = ERROR;
  return retToken;
}

/* Clear input until next End of Line Character - \n */
void clearToEoln(FILE *in)
{
  int ch;

  do {
    ch = getc(in);
  }
  while ((ch != '\n') && (ch != EOF));
}

void printCommands()
{
  printf ("The commands for this program are:\n\n");
  printf ("q - to quit the program\n");
  printf ("? - to list the accepted commands\n");
  printf ("or any infix mathematical expression using operators of (), *, /, +, -\n");
}

int main (int argc, char **argv)
{
  if(argc > 1 && strcmp(argv[1],"-d") == 0)
    setDebugMode = 1;

  char *input;
  token inputToken;

  printf ("Starting Expression Evaluation Program\n\n");
  printf ("Enter Expression: ");

  inputToken = getInputToken (stdin);
  while (inputToken.type != QUIT)
  {
    /* check first Token on Line of input */
    if(inputToken.type == HELP)
    {
      printCommands();
      clearToEoln(stdin);
    }
    else if(inputToken.type == ERROR)
    {
      printf ("Invalid Input - For a list of valid commands, type ?\n");
      clearToEoln(stdin);
    }
    else if(inputToken.type == EOLN)
    {
      printf ("Blank Line - Do Nothing\n");
      /* blank line - do nothing */
    }
    else 
    {
      processExpression(inputToken, stdin);
    } 

    printf ("\nEnter Expression: ");
    inputToken = getInputToken (stdin);
  }

  printf ("Quitting Program\n");
  return 1;
}
