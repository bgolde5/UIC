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

#define DEBUG 0 //set debugging mode for personal use: 0 off, 1 on

int debugMode; //set debugging mode for assingment specs

int main(int argc, char** argv){
  int i,j, fileIndex = 1;

  maze *m1;
  FILE *src;

  /*    verify the proper number of command line arguments were given */
  if(argc < 2) {
    printf("Usage: %s <input file name>\n", argv[0]);
    exit(-1);
  }
  /* check if user set -d flag */
  //before filename
  if(argc == 3 && (strcmp(argv[1], "-d") == 0)){
    debugMode = 1;
    fileIndex = 2;
    printf("true\n");
  }
  //after filename
  else if(( argc == 3 && strcmp(argv[2], "-d") == 0)){
    debugMode = 1;
    fileIndex = 1;
    printf("true\n");
  }
  //no -d flag set
  else{
    debugMode = 0;
    fileIndex = 1;
  }

  /*    Try to open the input file. */
  if ( ( src = fopen( argv[fileIndex], "r" )) == NULL ) {
    printf ( "Can't open input file: %s", argv[1] );
    exit(-1);
  }

  m1 = readFile(argc, argv, src);

  if(DEBUG)
    printf("\nreadFile COMPLETE\n\n");

  m1 = buildEmptyMaze(m1);

  if(DEBUG)
    printf("\nbuildEmptyMaze COMPLETE\n\n");

  m1 = buildMazeBlock(m1, src);

  fclose(src); //close file

  if(DEBUG)
    printf("\nbuildMazeBlocks COMPLETE\n\n");

  m1 = insertMazeStartAndEnd(m1);
  printMaze(m1);

  if(DEBUG)
    printf("\ninsertMazeStartAndEnd COMPLETE\n\n");

  dfs(m1);

  if(DEBUG)
    printf("\ndfs COMPLETE\n\n");

  destroyMaze(m1);

  if(DEBUG)
    printf("\ndestroyMaze COMPLETE\n\n");

}//end main
