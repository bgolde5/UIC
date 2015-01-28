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
#define fileSelector 0 //1: very_short; 2: total_counts 3: words_that_start_with_a_q; 4: all_words

typedef struct {
  char word[45]; //the longest word in the US dictionary is 45 characters!
  int year;
  int numOccur;
  int numTexts;
} ngramsData;

typedef struct {
  int numLines;
  int distinctWords;
} ngramsStats;

/* function prototypes */
ngramsData *readData(int *size);
void numDistinctWords(ngramsData *rawData, ngramsStats *usefulData, int size);
int isDistinct(char *str1, char *str2);
void printData(ngramsData *rawData, int n);

int main (){

  ngramsData *rawData;
  ngramsStats *usefulData = (ngramsStats*)malloc(sizeof(ngramsStats));
  int size = 0;

  printf("\n\n\nAuthor: Bradley Golden\n");
  printf("Lab: Thur 11am\n");
  printf("Program: #1, Google NGram word count\n\n\n");

  rawData = readData(&size);
  printData(rawData, size);
  usefulData->numLines = size; //collect size into usefulData struct
  numDistinctWords(rawData, usefulData, size);

  return 0;
}
/** 
 * function: numDistinctWords
 * description: counts the number of distinct words in the given file
 *
 * TODO - Account for these cases: Apples, apples 
 */
void numDistinctWords(ngramsData *rawData, ngramsStats *usefulData, int n){
  int i;
  int count = 1;//the first word is distinct and is thus counted
  for(i=0; i<n-1; i++){
    if(isDistinct(rawData[i].word, rawData[i+1].word)!=0)
    //printf("word1: %s word2: %s\n", rawData[i].word, rawData[i+1].word);
      count++;
  }
  usefulData->distinctWords = count;

  printf("Total number of distinct words: %i\n", count);
}//end numDistinctWords  

/** 
 * function: isDistinct
 * description: returns the strcmp value of two strings
 */
int isDistinct(char *str1, char *str2){
  int num;
  num = strcmp(str1, str2);
  return num;
}//end isDistinct


/** 
 * function: readData
 * description: reads ngrams data from file input in the following format:
 * word, year, number of occurences in that year, number of texts in which that word appeared
 *
 * returns a dynamically allocated array of structs of type ngramsData
 */
ngramsData *readData(int *size){
  ngramsData *temp;
  *size = 0;
  int totalAllocated = 0;
  int j = 0;
  ngramsData *rawData = (ngramsData*)malloc((totalAllocated+1)*sizeof(ngramsData));; //allocated for dynamic allocation

  FILE *ifp;
  char fileName[50] = "datafiles3/words_that_start_with_q.csv";

  ifp = fopen(fileName, "r");

  if(ifp == NULL){
    fprintf(stderr, "Cannot open input file %s", fileName);
  }

  //start dynamic allocation
  while(fscanf(ifp, "%s %d %d %d", rawData[*size].word, &rawData[*size].year, &rawData[*size].numOccur, &rawData[*size]. numTexts) != EOF){
    if(*size == totalAllocated){ //reached end of array, need to allocated more space
      temp = (ngramsData*)malloc((totalAllocated*2)*sizeof(ngramsData));
      for(j=0; j<=*size; j++){
        temp[j] = rawData[j]; //copy array contents to larger allocated space
      }
      free(rawData);
      rawData = temp;
      totalAllocated*=2; 
    }
    (*size)++; //increment number of word lines with each line read
  }
  fclose(ifp);

  return rawData;
}//end readData

/**
 * function: printData
 * description: prints the current words, etc. tha are stored in struct ngramsData
 */
void printData(ngramsData *rawData, int n){

  int i = 0;

  for(i=0; i<n; i++){
    printf("%s %i %i %i\n", rawData[i].word, rawData[i].year, rawData[i].numOccur, rawData[i].numTexts);
  }
}
