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
#define debug 1

typedef struct {
  char *word;
  int year;
  int numOccur;
  int numTexts;
} ngramsData;

typedef struct {
  int numLines;
} ngramsStats;

/* functions  */
ngramsData readData(ngramsData rawData[], ngramsStats *usefulData);

int main (){

  ngramsData rawData[MAX_BUF];
  ngramsStats usefulData;

  printf("\n\n\nAuthor: Bradley Golden\n");
  printf("Lab: Thur 11am\n");
  printf("Program: #1, Google NGram word count\n\n\n");

  readData(rawData, &usefulData);
  printf("numLines: %i\n", usefulData.numLines);

  //TODO: Count number of distinct words
  

  return 0;
}

ngramsData readData(ngramsData rawData[], ngramsStats *usefulData){

  char line[1024][1024];
  char *token;
  int i = 0;
  int j;
  
  //tokenizes each line into the (char*)word, (int)year, (int)number of occurences, (int)number of texts
  while (fgets(line[i], 1024, stdin) != NULL && i <= 20){
    rawData[i].word = strtok(line[i], " \t"); //get word
    rawData[i].year = atoi(strtok(NULL, " \t")); //get year
    rawData[i].numOccur = atoi(strtok(NULL, " \t"));
    rawData[i].numTexts = atoi(strtok(NULL, " \t"));
    i++;
  }
  //get number of lines in a text file
  usefulData->numLines = i - 1;
  int size = usefulData->numLines;

  if(debug){
    for(i=0; i<size; i++){
      printf("%s\t", rawData[i].word);
      printf("%i\t", rawData[i].year);
      printf("%i\t", rawData[i].numOccur);
      printf("%i\n", rawData[i].numTexts);
    }
  }

  return *rawData;
}
