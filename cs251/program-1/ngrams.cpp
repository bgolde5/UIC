/*
 * =====================================================================================
 *
 *       Filename:  ngrams.cpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  01/26/2015 19:53:34
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

/*  strtok example */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_BUF 512

typedef struct {
  char *word;
  int year;
  int numOccur;
  int numTexts;
} wordLine;

int main (){

  wordLine data[MAX_BUF];

  printf("\n\n\nAuthor: Bradley Golden\n");
  printf("Lab: Thur 11am\n");
  printf("Program: #1, Google NGram word count\n\n\n");

  char line[1024][1024];
  char *token;


  int i = 0;
  int j;
  //tokenizes each line into the (char*)word, (int)year, (int)number of occurences, (int)number of texts
  while (fgets(line[i], 1024, stdin) != NULL && i <= 20){
    //printf("line %i: ", i);
    //printf("%s", line[i]);
    data[i].word = strtok(line[i], " \t"); //get word
    //printf("line %i: ", i);
    //printf("%s\t", data[i].word);
    data[i].year = atoi(strtok(NULL, " \t")); //get year
    //printf("%i\t", data[i].year);
    data[i].numOccur = atoi(strtok(NULL, " \t"));
    //printf("%i\t", data[i].numOccur);
    data[i].numTexts = atoi(strtok(NULL, " \t"));
    //printf("%i\n", data[i].numTexts);
    i++;
  }
  int lines = i-1;
  //printf("\n");
  //
  //TODO: Count number of distinct words
  for(i=0; i<lines; i++){
    printf("%s\n", data[i].word);
  }

  return 0;
}
