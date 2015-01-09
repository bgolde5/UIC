/*
 * =====================================================================================
 *
 *       Filename:  bboard.c
 *
 *    Description:  Contains functions from bboard.h.
 *
 *        Version:  1.0
 *        Created:  11/03/14 14:23:44
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu
 *   Organization:  
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "bboard.h"
#include "stack.h"

#define MAX_FLOAT 39 

//helper functions
void bb_store_mtx(BBoardPtr b);
int size_correct(int r, int c);
int input_is_correct(BBoardPtr b, int r, int c);
int balloon_is_north(BBoardPtr b, int r, int c);
int balloon_is_east(BBoardPtr b, int r, int c);
int balloon_is_south(BBoardPtr b, int r, int c);
int balloon_is_west(BBoardPtr b, int r, int c);
void visited_board(BBoard b, int r, int c);
void update_visited_board(BBoard b);
void bb_create_helper(BBoardPtr b, char mtx[][MAX_COLS], int flag, int r, int c);
 
struct bboard {
  char items[MAX_ROWS][MAX_COLS];
  int visited[MAX_ROWS][MAX_COLS];
  char undo_cache[MAX_ROWS][MAX_COLS][MAX_FLOAT+1];//max float possibilities + original display 
  int visited_undo[MAX_ROWS][MAX_COLS];
  int frame;
  int score;
  int prev_score;
  int rows;
  int cols;
};

/*
 * Function:  bb_create
 */
BBoardPtr bb_create(int nrows, int ncols){ 
  if(!size_correct(nrows, ncols))
    return NULL;
  BBoardPtr b = malloc(sizeof(struct bboard));
  bb_create_helper(b, 0, 1, nrows, ncols);
  return b;
}//end bb_create

/*
 * Function:  bb_create_from_mtx
 */
BBoardPtr bb_create_from_mtx(char mtx[][MAX_COLS], int nrows, int ncols){
  if(!size_correct(nrows, ncols))
    return NULL;
  BBoardPtr b = malloc(sizeof(struct bboard));
  bb_create_helper(b, mtx, 0, nrows, ncols);
  return b;
}//end bb_create_from_mtx 

/*
 * Function:  bb_destroy
 */
void bb_destroy(BBoardPtr b){
  free(b);
}//end bb_destroy

/*
 * Function:  bb_clear
 */
int bb_clear(BBoardPtr b){
  b->rows = 0;
  b->cols = 0;
  b->score = 0;

  return b->score;
}//end bb_clear

/*  
 * Function:  bb_display
 */
void bb_display(BBoardPtr b){
  int i,j, count_tens, count_ones;
  count_tens = 0;
  count_ones = 0;
  //print top border
  printf("    +");
  for(i=0;i<(b->cols);i++){
    printf("--");
  }
  printf("-+\n");

  //print balloons, line numbers, side borders
  for(i=0;i<(b->rows);i++){
    if(i%10==0 && i!=0){
      count_tens++;
      count_ones = 0;
    }
    printf("%i ", count_tens);
    printf("%i | ", count_ones);
    count_ones++;
    for(j=0;j<(b->cols);j++){
      //print balloons
      printf("%c ", b->items[i][j]);
    }
    //print right border
    printf("|\n");
  }
  //print bottom border
  printf("    +");
  for(i=0; i<(b->cols);i++){
    printf("--");
  }
  printf("-+\n");
  //print column number
  count_tens=0;
  count_ones=0;
  printf("      ");//spacer
  for(i=0;i<(b->cols);i++){
    if(i%10==0 && i!=0){
      count_tens++;
    }
    printf("%i ", count_tens);
  }
  printf("\n");
  printf("      ");//spacer
  for(i=0;i<(b->cols);i++){
    count_ones++;
    if(i%10==0)
      count_ones=0;
    printf("%i ", count_ones);
  }
  printf("\n");
}//end bb_display

/*
 * Function:  bb_pop
 */
int bb_pop(BBoardPtr b, int r, int c){
  int i, j, count;
  if(input_is_correct(b,r,c) == 0)
    return b->score;

  StackPtr stk;
  b->frame=0;
  stk = stk_create();
  //store current score for use by undo function
  b->prev_score = b->score;
  //store matrix before pop for use by undo function
  bb_store_mtx(b);
  //store b->visited prior to modifications for use by undo function 
  for(i=0; i<(b->rows); i++){
    for(j=0; j<(b->cols); j++){
      b->visited_undo[i][j] = b->visited[i][j];
    }
  }
  int array[b->rows][b->cols];
  int previous;
  count = 0;
  //create array to reference previous values
  for(i=0;i<(b->rows);i++){
    for(j=0;j<(b->cols);j++){
      array[i][j] = count;
      count++;
    }
  }
  //use to count number balloons popped
  count = 0;
  //count first value as visited and push first value to stack
  b->visited[r][c]=1;
  stk_push(stk, array[r][c]);

  //begin checking directions around balloon (north,east,south,west)
  for(;;){ 
    if(balloon_is_north(b,r,c) || balloon_is_east(b,r,c) || balloon_is_south(b,r,c) || balloon_is_west(b,r,c)){
      previous = array[r][c];
      if(balloon_is_north(b,r,c))
        r--;
      if(balloon_is_east(b,r,c))
        c++;
      if(balloon_is_south(b,r,c))
        r++;
      if(balloon_is_west(b,r,c))
        c--;
      b->visited[r][c] = 1;
      stk_push(stk, array[r][c]);
      count++;
    }
    //no unvisted baloons/matches go back to previous and pop with ' '
    else{
      previous = stk_pop(stk);
      if(stk_is_empty(stk)){
        count++;
        //more than 1 balloon found, begin popping
        if(count>1){
          for(i=0; i<(b->rows); i++){
            for(j=0; j<(b->cols); j++){
              if(b->visited[i][j] == 1){
                b->items[i][j] = ' ';
              }
            }
          }
        }
        stk_free(stk);
        b->score += (count*(count-1));
        return b->score;
      }
      //set r,c to location of previous value
      for(i=0;i<(b->rows);i++){
        for(j=0;j<(b->cols);j++){
          if(array[i][j] == previous){
            r = i;
            c = j;
          }
        }
      }
    }
  }
  stk_free(stk);
  return -1;
}//end bb_pop

/**
 * Function:  bb_is_compact
 */
int bb_is_compact(BBoardPtr b){
  int i,j;
  //go through each row/column and see if there are any spaces before balloons  
  for(i=0;i<((b->rows)-1);i++){
    for(j=0;j<(b->cols);j++){
      //if space, check next slot down to see if balloon
      if(b->items[i][j]==' ' && b->items[i+1][j]!=' '){
        return 0;
      }
    }
  }
  return 1;
}//end bb_is_compact

/**
 * Function:  bb_float_one_step
 */
int bb_float_one_step(BBoardPtr b){
  int i,j,k;

  bb_display(b);
  bb_store_mtx(b);
  for(i=0;i<((b->rows)-1);i++){
    for(j=0;j<(b->cols);j++){
      //if balloon after space
      if(b->items[i][j]==' ' && b->items[i+1][j]!=' '){
        //shift entire column up
        for(k=i;k<(b->rows)-1;k++){
          b->items[k][j] = b->items[k+1][j];
          b->visited[k][j] = 0;
        }
        //fill last space with popped balloon 
        b->items[k][j] = ' ';
      }   
    }
  }
  update_visited_board(b);
  return 1;
}//end float_one_step

/*
 * Function:  bb_score
 */
int bb_score(BBoardPtr b){
  return b->score;
}//end bb_score

/*
 * Function:   bb_get_balloon
 */
int bb_get_balloon(BBoardPtr b, int r, int c){
  if(r>(b->rows)-1 || c>(b->cols)-1 || r<0 || c<0)
    return -1;
  return b->items[r][c];
}//end bb_get_balloon

/*
 * Function:  bb_undo
 */
int bb_undo(BBoardPtr b){
  int i,j,k;

  //print undo_cache from "top to bottom"
  for(k=(b->frame)-1;k>=0;k--){
    bb_display(b);
    for(i=0;i<(b->rows);i++){
      for(j=0;j<(b->cols);j++){
        b->items[i][j] = b->undo_cache[i][j][k];
      }
    }
  }
  //restart undo cache to 0 
  b->frame = 0;
  //undo the score
  b->score = b->prev_score;
  //restore the visited array tracker
  for(i=0;i<(b->rows);i++){
    for(j=0;j<(b->cols);j++){
      b->visited[i][j] = b->visited_undo[i][j];
    }
  }
  return 1;
}//end bb_undo

/***************************Helper Functions**************************/

/*
 * Function: bb_store_mtx - helper function
 * Description: stores first thru final stages of one balloon pop cycle
 *              for use by the undo function
 *
 *              
 */
void bb_store_mtx(BBoardPtr b){
  int i,j;
  for(i=0;i<(b->rows);i++){
    for(j=0;j<(b->cols);j++){
      b->undo_cache[i][j][b->frame] = b->items[i][j]; 
    }
  }
  b->frame++;
  return;
}//end bb_store_mtx

/*
 * Function: size_correct
 * Description: checks in the user specified correct
 *              values for the row and column
 *
 *              Prints to stderr: Incorrect Row/Column Input
 *              returns 1 for success, 0 for failure
 */
int size_correct(int r, int c){
  if(r>MAX_ROWS || r<1){
    fprintf(stderr, "Incorrect row input: %i\n",r);
    printf("test");
    return 0;
  }
  if(c>MAX_COLS || c<1){ 
    fprintf(stderr, "Incorrect column input: %i\n",c);
    return 0;
  }
  return 1;
}//end check_size

/* Functions: balloon_is_<direction>
 * Description: check if there is a balloon one position up or over
 *              in the indicated direction
 */
int balloon_is_north(BBoardPtr b, int r, int c){
  return (r>0 && (b->items[r][c] == b->items[r-1][c]) && (b->visited[r-1][c] == 0));
}//end is_balloon_north

int balloon_is_east(BBoardPtr b, int r, int c){
  return (c<(b->cols) && (b->items[r][c] == b->items[r][c+1]) && (b->visited[r][c+1] == 0));
}//end balloon_is_east

int balloon_is_south(BBoardPtr b, int r, int c){
  return (r<(b->rows) && (b->items[r][c] == b->items[r+1][c]) && (b->visited[r+1][c] == 0));
}//end balloon_is_south

int balloon_is_west(BBoardPtr b, int r, int c){
  return (c>0 && (b->items[r][c] == b->items[r][c-1]) && (b->visited[r][c-1] == 0)); 
}//end balloon_is_west

/*
 * Function: visited_board
 * Description: creates a board that shows which spaces have been scanned
 *              1 for scanned, 0 for not scanned
 */
void visited_board(BBoardPtr b, int r, int c){
  int i,j;
  for(i=0;i<r;i++){
    for(j=0;j<c;j++){
      b->visited[i][j] = 0;
    }
  }
}//end visited_board

/*
 * Function: bb_create_helper
 * Description: reduces redundant code in bb_create and bb_create_from_mtx
 */
void bb_create_helper(BBoardPtr b, char mtx[][MAX_COLS], int flag, int r, int c){
  int i,j,random;
  char colors[4] = {Red, Blue, Green, Yellow};

  b->rows = r;
  b->cols = c;

  if(flag){
    for(i=0; i<r; i++){
      for(j=0; j<c; j++){
        //choose random index
        random = rand()%4;
        //assign color from random index to balloon_type
        b->items[i][j] = colors[random];
      }
    }
  }
  else{
    for(i=0;i<r;i++){
      for(j=0;j<c;j++){
        b->items[i][j] = mtx[i][j];
      }
    }
  }
  b->frame = 0;
  visited_board(b,r,c); 
  return;
}//end bb_create_helper

/*
 * Function: input_is_correct
 * Description: if user enters the wrong r or column
 *              print error
 */
int input_is_correct(BBoardPtr b, int r, int c){
  if(r>(b->rows)-1 || r<0 || c>(b->cols)-1 || c<0){
    printf("Incorrect input\n");
    return 0;
  }
  return 1;
}

/*
 * Function: update_visited_board
 * Description: checks and updates the visited board
 *              for use in float_one_step
 */
void update_visited_board(BBoardPtr b){
  int i, j;
  for(i=0;i<(b->rows);i++){
    for(j=0;j<(b->cols);j++){
      if(b->items[i][j]==' ')
        b->visited[i][j] = 1;
      else
        b->visited[i][j] = 0;
    }
  }
}//end update_visited_board
