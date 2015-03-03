/*
 * =====================================================================================
 *
 *       Filename:  maze.c
 *
 *    Description:  Includes core functions to implement a maze
 *
 *        Version:  1.0
 *        Created:  02/07/2015 14:49:26
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

#include "maze.h"
#include "stack.h"

int debugMode;

maze *readFile(int argNum, char **argStr, FILE *src){

  maze *mptr = (maze*)malloc(sizeof(maze));
  int i, j;

  mptr->xsize = 0;
  mptr->ysize = 0;
  mptr->xstart = 0;
  mptr->ystart = 0;
  mptr->xend = 0;
  mptr->yend = 0;

  /*   read in the size, starting and ending positions in the maze */
  //check that maze dimensions are correct
  checkMazeSize(mptr, src);
  printf("%i %i\tMaze size becomes %i x %i\n", mptr->xsize, mptr->ysize, mptr->xsize, mptr->ysize);

  checkMazeStartOrEnd(mptr, &(mptr->xstart), &(mptr->ystart), src);
  printf("%i %i\tStarting position is at %i, %i\n", mptr->xstart, mptr->ystart, mptr->xstart, mptr->ystart);

  checkMazeStartOrEnd(mptr, &(mptr->xend), &(mptr->yend), src);
  printf("%i %i\tEnding position is at %i, %i\n", mptr->xend, mptr->yend, mptr->xend, mptr->yend);

  //allocate rows for maze board
  char **board = (char**)malloc((mptr->xsize+2)*sizeof(char*));
  int **visited = (int**)malloc((mptr->xsize+2)*sizeof(int*));

  //allocate columns for maze board
  for(i = 0; i < mptr->xsize+2; i++){
    board[i] = (char*)malloc((mptr->ysize+2)*sizeof(char));
    visited[i] = (int*)malloc((mptr->ysize+2)*sizeof(int));
  }

  mptr->arr = board;
  mptr->visited = visited;

  return mptr; 
}//end readFile

void checkMazeStartOrEnd(maze *mptr, int *startOrEndX, int *startOrEndY, FILE *filePtr){
  while(*startOrEndX < 1 || *startOrEndX > mptr->xsize){
    if(fscanf (filePtr, "%d %d", startOrEndX, startOrEndY) != EOF){
      if(*startOrEndX < 1 || *startOrEndX > mptr->xsize)
        fprintf(stderr, "%i %i\tInvalid: row %i is outside range from 1 to %i\n", *startOrEndX, *startOrEndY, *startOrEndX, mptr->xsize);
    }
    else {
      fprintf(stderr, "Error: file doesn't contain enough lines to build a maze\n");
      exit(-1);
    }
  }
  while(*startOrEndY < 1 || *startOrEndY > mptr->ysize){
    fscanf (filePtr, "%d %d", startOrEndX, startOrEndY);
    if(*startOrEndY < 1 || *startOrEndY > mptr->ysize){
      fprintf(stderr, "%i %i\tInvalid: column %i is outside range from 1 to %i\n", *startOrEndX, *startOrEndY, *startOrEndY, mptr->ysize);
    }
  }
}//end checkMazeStartOrEnd

void checkMazeSize(maze *mptr, FILE *filePtr){
  //checks that the mize size is valid
  while(mptr->xsize <= 0 || mptr->ysize <= 0){
    if (fscanf (filePtr, "%d %d", &mptr->xsize, &mptr->ysize) != EOF){
      if(mptr->xsize <= 0 || mptr->ysize <=0){
        fprintf(stderr, "%i %i\tInvalid: Maze sizes must be greater than 0.\n", mptr->xsize, mptr->ysize);
      }
    }
    else{
      fprintf(stderr, "Error: file doesn't contain enough lines to build a maze\n");
      exit(-1);
    }
  }
}//end checkMazeSize

maze *buildEmptyMaze(maze *mptr){

  int i,j;

  /*   initialize the maze to empty */
  for (i = 0; i < mptr->xsize+2; i++)
    for (j = 0; j < mptr->ysize+2; j++){
      mptr->arr[i][j] = '.';
      mptr->visited[i][j] = 0;
    }

  /*   mark the borders of the maze with #'s and 1's*/
  for (i=0; i < mptr->xsize+2; i++) {
    mptr->arr[i][0] = '#';
    mptr->arr[i][mptr->ysize+1] = '#';
  }

  for (i=0; i < mptr->ysize+2; i++) {
    mptr->arr[0][i] = '#';
    mptr->arr[mptr->xsize+1][i] = '#';
  }

  return mptr;
}//end buildEmptyMaze

maze *insertMazeStartAndEnd(maze *mptr){
  mptr->arr[mptr->xstart][mptr->ystart] = 's';
  mptr->arr[mptr->xend][mptr->yend] = 'e';

  return mptr;
}//end insertMAzeStartAndEnd

maze *buildMazeBlock(maze *mptr, FILE *filePtr){

  int x, y;

  while (fscanf (filePtr, "%d %d", &x, &y) != EOF) {
    if(x < 1 || x > mptr->xsize){
      fprintf(stderr, "%i %i\tInvalid: row %i is outside range from 1 to %i\n", x, y, x, mptr->xsize);
    }
    else if(y < 1 || y > mptr->ysize){
      fprintf(stderr, "%i %i\tInvalid: column %i is outside range from 1 to %i\n", x, y, y, mptr->ysize);
    }
    else if(x == mptr->xstart && y == mptr->ystart){
      fprintf(stderr, "%i %i\tInvalid: attempting to block the starting position\n", x, y);
    }
    else if(x == mptr->xend && y == mptr->yend){
      fprintf(stderr, "%i %i\tInvalid: attempting to block the ending position\n", x, y);
    }
    else{
      if(DEBUG)
        fprintf(stderr, "%i %i\n", x, y);
      mptr->arr[x][y] = '#';
      mptr->visited[x][y] = TRUE;
    }
  }
  return mptr;
}//end buildMazeBlocks


void dfs(maze *mptr){
  int mPos, nPos;
  int mTop, nTop; //holds the value at the top of the stack
  int i,j;
  int count = 0;
  mPos = mptr->xstart; //initialize initial m coordinate
  nPos = mptr->ystart; //initialize initial n coordinate
  mTop = -1;
  nTop = -1;

  //create a stack
  LIST *stk = stk_create();

  //mark borders as visited
  for (i=0; i < mptr->xsize+2; i++) {
    mptr->visited[i][0] = TRUE;
    mptr->visited[i][mptr->ysize+1] = TRUE;
  }

  for (i=0; i < mptr->ysize+2; i++) {
    mptr->visited[0][i] = TRUE;
    mptr->visited[mptr->xsize+1][i] = TRUE;
  }

  //push the starting position onto the stack
  stk_push(stk, mptr->xstart, mptr->ystart);

  //mark starting position as visited
  mptr->visited[mPos][nPos] = TRUE;

  //traverse through stack until stack is empty or end position has been reached
  while(!stk_isempty(stk) && !endFound(mptr, mPos, nPos)){
    //check if end has been found
    if(endFound(mptr, mPos, nPos)){ 
      return;
    }
    //check if surrounding positions are visited
    if (unVisitedNeighbor(mptr, &mPos, &nPos)) { //check if unvisted and move to unvisted position
      stk_push(stk, mPos, nPos); //push corrdinates on top of stack
      markVisited(mptr, mPos, nPos); //mark position a visited
      if(MAZE_PRINT_ON)
        printMaze(mptr);
    } 
    else {
      stk_pop(stk);
      if(debugMode == TRUE){
        if(count == 0){
          printf("Debugging Information - All Popped Coordinates\n");
        }
        count++;
        printf("[ %i,%i ]\n", mPos, nPos);
      }
      stk_top(stk, &mPos, &nPos);
    }
  }

  //end has been found, display solution
  if(endFound(mptr, mPos, nPos)){
    printf("Solution Found at position: %i %i!\n", mPos, nPos);
    //reverse contents of stack to print out solution in order or traversal from start position
    printf("Path taken:\n");
    stk_print_reverse(stk);
  }
  //end has not been found :(
  else
    fprintf(stderr, "The maze has no solution.\n");

  stk_destroy(stk); //frees the stack
}//end dfs

void printVisited(maze *mptr){
  int i,j;
  for( i = 0; i < mptr->xsize+2; i++){
    for (j = 0; j < mptr->ysize+2; j++){
      printf(" %i ", mptr->visited[i][j]);
    }
    printf("\n");
  }
}//end printVisited

void printMaze(maze *mptr){
  int i,j;
  for (i = 0; i < mptr->xsize+2; i++) {
    for (j = 0; j < mptr->ysize+2; j++)
      printf ("%c", mptr->arr[i][j]);
    printf("\n");
  }
}//end printMaze

int unVisitedNeighbor(maze *mptr, int *mTop, int *nTop){

  if(!mptr->visited[*mTop+1][*nTop]){
    (*mTop)++;
    return 1;
  }
  else if(!mptr->visited[*mTop-1][*nTop]){
    (*mTop)--;
    return 1;
  }
  else if(!mptr->visited[*mTop][*nTop+1]){
    (*nTop)++;
    return 1;
  }
  else if(!mptr->visited[*mTop][*nTop-1]){
    (*nTop)--;
    return 1;
  }

  return 0;
}//end unvistedNeighbor

void markVisited(maze *mptr, int m, int n){
  if(mptr->arr[m][n] != END_POSITION){
    mptr->visited[m][n] = TRUE;
    mptr->arr[m][n] = VISITED;
  }
}//end markVisited

int endFound(maze *mptr, int m, int n){
  if(mptr->arr[m][n] == END_POSITION){
    return 1;
  }
  return 0;
}

void destroyMaze(maze *mptr){
  int i, j;

  //free columns from maze board
  for(i = 0; i < mptr->xsize+2; i++){
    free(mptr->arr[i]);
    free(mptr->visited[i]); 
  }
  //free rows from maze board
  free(mptr->arr);
  free(mptr->visited);

  //free pointer to maze
  free(mptr);
}//end destroyMaze
