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

maze *readFile(int argNum, char **argStr, FILE *src){

  maze *mptr = (maze*)malloc(sizeof(maze));
  int i, j;

  /*   verify the proper number of command line arguments were given */
  if(argNum != 2) {
    printf("Usage: %s <input file name>\n", argStr[0]);
    exit(-1);
  }

  /*   Try to open the input file. */
  if ( ( src = fopen( argStr[1], "r" )) == NULL ) {
    printf ( "Can't open input file: %s", argStr[1] );
    exit(-1);
  }

  mptr->xsize = 0;
  mptr->ysize = 0;
  mptr->xstart = 0;
  mptr->ystart = 0;
  mptr->xend = 0;
  mptr->yend = 0;

  /*   read in the size, starting and ending positions in the maze */
  //check that maze dimensions are correct
  checkMazeSize(mptr, src);
  printf("%i %i Maze size becomes %i x %i\n", mptr->xsize, mptr->ysize, mptr->xsize, mptr->ysize);

  checkMazeStartOrEnd(mptr, &(mptr->xstart), &(mptr->ystart), src);
  printf("%i %i Starting position is at %i, %i\n", mptr->xstart, mptr->ystart, mptr->xstart, mptr->ystart);

  checkMazeStartOrEnd(mptr, &(mptr->xend), &(mptr->yend), src);
  printf("%i %i Ending position is at %i, %i\n", mptr->xend, mptr->yend, mptr->xend, mptr->yend);

  //allocate rows for maze board
  char **board = (char**)malloc((mptr->xsize+2)*sizeof(char *));

  //allocate columns for maze board
  for(i = 0; i < mptr->xsize+2; i++){
    board[i] = (char*)malloc((mptr->ysize+2)*sizeof(char));
  }

  mptr->arr = board;

  /*   print them out to verify the input */
  //printf ("size: %d, %d\n", mptr->xsize, mptr->ysize);
  //printf ("start: %d, %d\n", mptr->xstart, mptr->ystart);
  //printf ("end: %d, %d\n", mptr->xend, mptr->yend);

  return mptr; 
}//end readFile

void checkMazeStartOrEnd(maze *mptr, int *startOrEndX, int *startOrEndY, FILE *filePtr){
  while(*startOrEndX < 1 || *startOrEndX > mptr->xsize){
    fscanf (filePtr, "%d %d", startOrEndX, startOrEndY);
    if(*startOrEndX < 1 || *startOrEndX > mptr->xsize)
      printf("%i %i Invalid: row %i is outside range from 1 to %i\n", *startOrEndX, *startOrEndY, *startOrEndX, mptr->xsize);
  }
  while(*startOrEndY < 1 || *startOrEndY > mptr->ysize){
    fscanf (filePtr, "%d %d", startOrEndX, startOrEndY);
    if(*startOrEndY < 1 || *startOrEndY > mptr->ysize){
      printf("%i %i Invalid: column %i is outside range from 1 to %i\n", *startOrEndX, *startOrEndY, *startOrEndY, mptr->ysize);
    }
  }
}//end checkMazeStartOrEnd

void checkMazeSize(maze *mptr, FILE *filePtr){
  //checks that the mize size is valid
  while(mptr->xsize <= 0 || mptr->ysize <= 0){
    fscanf (filePtr, "%d %d", &mptr->xsize, &mptr->ysize);
    if(mptr->xsize <= 0 || mptr->ysize <=0){
      printf("%i %i Invalid: Maze sizes must be greater than 0.\n", mptr->xsize, mptr->ysize);
    }
  }
}//end checkMazeSize

maze *buildEmptyMaze(maze *mptr){

  int i,j;

  /*   initialize the maze to empty */
  for (i = 0; i < mptr->xsize+2; i++)
    for (j = 0; j < mptr->ysize+2; j++)
      mptr->arr[i][j] = '.';

  /*   mark the borders of the maze with #'s */
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
      printf("%i %i Invalid: row %i is outside range from 1 to %i\n", x, y, x, mptr->xsize);
    }
    else if(y < 1 || y > mptr->ysize){
      printf("%i %i Invalid: row %i is outside range from 1 to %i\n", x, y, x, mptr->ysize);
    }
    else{
      printf("%i %i\n", x, y);
    mptr->arr[x][y] = '#';
    }
  }
  return mptr;
}//end buildMazeBlocks

void dfs(maze *mptr){
  LIST *stk = stk_create(); //creates stack
  int nmCoor[2] = {-1,-1};
  int nPos = mptr->ystart; //starting x position
  nmCoor[0] = mptr->ystart; //starting x position
  nmCoor[1] = mptr->xstart; //starting x position
  int mPos = mptr->xstart; //starting y position

  while(mptr->arr[mPos][nPos] != 'e'){
    mptr->arr[mPos][nPos] = 'X'; //mark as visited
    stk_push(stk, mPos, nPos); //initially pushes s onto stack
    stk_print(stk);

    while(!stk_empty(stk)){
    }
    

    if(mptr->arr[mPos+1][nPos] != '#' && mptr->arr[mPos+1][nPos] != 'X'){
      mPos = mPos+1; //move south 
    }
    else if(mptr->arr[mPos-1][nPos] != '#' && mptr->arr[mPos-1][nPos] != 'X'){
      mPos = mPos-1; //move north
    }
    else if(mptr->arr[mPos][nPos+1] != '#' && mptr->arr[mPos][nPos+1] != 'X'){
      nPos = nPos+1; //move west
    }
    else if(mptr->arr[mPos][nPos-1] != '#' && mptr->arr[mPos][nPos-1] != 'X'){
      nPos = nPos-1; //move east 
    }

    printf("mPos: %i, nPos: %i\n", mPos, nPos);
    printMaze(mptr);
  }
}//end dfs

void printMaze(maze *mptr){
  int i,j;
  for (i = 0; i < mptr->xsize+2; i++) {
    for (j = 0; j < mptr->ysize+2; j++)
      printf ("%c", mptr->arr[i][j]);
    printf("\n");
  }
}//end printMaze
