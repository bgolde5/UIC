/*
 * =====================================================================================
 *
 *       Filename:  maze.h
 *
 *    Description:  Header file for maze.c
 *
 *        Version:  1.0
 *        Created:  02/07/2015 15:01:47
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

typedef struct mazeStruct {
  char **arr; //allows for dynamiccaly sized maze of size MxN
  int xsize, ysize;
  int xstart, ystart;
  int xend, yend;
} maze;

/**
 * function: readFile
 * description: reads the input coordinates for the purpose of building a maze
 */
extern maze *readFile(int argNum, char** argStr, FILE *src);

/**
 * function: buildEmptyMaze
 * description: builds the empty maze board
 */
extern maze *buildEmptyMaze(maze *mptr);

/**
 * function: buildMazeBlocks
 * description: fills the maze with blocks (aka barriers)
 */
extern maze *buildMazeBlock(maze *mptr, FILE *filePtr);

/**
 * function: checkMazeSize
 * description: checks the dimensions of the maze. If the dimensions of the maze are less than 1 the row is considered invalied and is skipped.
 */
extern void checkMazeSize(maze *mptr, FILE *filePtr);

/**
 * function: checkMazeStartOrEnd
 * description: checks the starting point or ending point in the maze and determines if that row valid. If it isn't valid, row is skipped. */
extern void checkMazeStartOrEnd(maze *mptr, int *startOrEndX, int *startOrEndY, FILE *filePtr);

/**
 * function: insertMazeStartAndEnd
 * description: inserted the starting point and ending point in the maze
*/
extern maze *insertMazeStartAndEnd(maze *mptr);

/**
 * function: dfs
 * description: traverses the maze using depth first search
 */
extern void dfs(maze *mptr);

/**
 * function: printMaze
 * description: prints the current maze board 
 */
extern void printMaze(maze *mptr);
