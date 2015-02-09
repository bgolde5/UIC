/*
 * =====================================================================================
 *
 *       Filename:  main.c
 *
 *    Description:  Project 1 main file. Creates and solves a maze using depth first search
 *
 *        Version:  1.0
 *        Created:  02/07/2015 14:30:26
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

//Some code used from maze.c example at http://www.cs.uic.edu/pub/CS211/ProjectsS15/maze.c

#include "maze.h"

#define debug 1 //set debugging mode: 0 off, 1 on

int main(int argc, char** argv){
  int i,j;

  maze *m1;
  FILE *src;

  /*    verify the proper number of command line arguments were given */
  if(argc != 2) {
    printf("Usage: %s <input file name>\n", argv[0]);
    exit(-1);
  }

  /*    Try to open the input file. */
  if ( ( src = fopen( argv[1], "r" )) == NULL ) {
    printf ( "Can't open input file: %s", argv[1] );
    exit(-1);
  }

  m1 = readFile(argc, argv, src);

  if(debug)
    printf("\nreadFile COMPLETE\n\n");

  m1 = buildEmptyMaze(m1);

  if(debug)
    printf("\nbuildEmptyMaze COMPLETE\n\n");

  m1 = buildMazeBlock(m1, src);

  fclose(src); //close file

  if(debug)
    printf("\nbuildMazeBlocks COMPLETE\n\n");

  m1 = insertMazeStartAndEnd(m1);
  printMaze(m1);

  if(debug)
    printf("\ninsertMazeStartAndEnd COMPLETE\n\n");

  dfs(m1);
  printMaze(m1);

}//end main
