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
#include <ctype.h>

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
ngramsData *readData(int *size, char *filename);
void numDistinctWords(ngramsData *rawData, ngramsStats *usefulData, int size);
int isDistinct(char *str1, char *str2);
void printData(ngramsData *rawData, int n);
void printHeader();
char *wordPrompt();
double average();
char *filePrompt();
char **createWordArr(ngramsData *rawData, int n);

int main (){

  ngramsData *rawData;
  ngramsStats *usefulData = (ngramsStats*)malloc(sizeof(ngramsStats));
  int size = 0;

  printHeader(); //prints required information by instructor at top of program
  char *fileName = filePrompt();
  //printf("You entered %s\n", fileName);
  rawData = readData(&size, fileName); //read data dynamically from the specified file
  //char **wordList = createWordArr(rawData, size);
  //printData(rawData, size);
  usefulData->numLines = size; //collect size into usefulData struct
  //printf("size: %i\n", size);
  numDistinctWords(rawData, usefulData, size); //gives the number of distinct words in the given file
  char *wordInput = wordPrompt(); //prompts user to input a word
  //printf("You entered: %s\n", wordInput);

  free(fileName);
  free(wordInput);

  return 0;
}
/**
 * function: createWordArr
 * description: creates and array of the words
 */
char **createWordArr(ngramsData *rawData, int n){
  int i;
  char **wordArr; 
  *wordArr = (char*)malloc(n*sizeof(char));
  for(i=0; i<n; i++){
    wordArr[i] = rawData[i].word;
  }

  return wordArr;
}
/**
 * function: findWord
 * description: finds a given word and returns the index of that word
 */
int findWord(char* word, char** wordList, int numLines){
  int i, exitLoop;

  //search by first letter first
  for(i=0; i<numLines; i++){
    if(word[i] == *wordList[i]){
      exitLoop = numLines;
    }
  }

  return i;
}
/**
 * function: average
 * description: returns the average of n amount of given integers
 */
double average(int numArr[], int totalNums){
  double avg, sum;
  int i;
  sum = 0;
  for(i=0; i<totalNums; i++){
    sum+=(double)numArr[i];
  }
  avg =  sum / totalNums;

  return avg;
}
/**
 * function: filePrompt
 * description: prompts the user for a file name
 */
char *filePrompt(){
  char *file = (char*)malloc(50*sizeof(char));
  printf("Enter a filename: ");
  scanf("%s", file);
  return file;
}

/**
 * function: wordPrompt
 * description: prompts the user for a word of type char*
 */
char *wordPrompt(){
  char *word = (char*)malloc(50*sizeof(char));
  printf("Enter a word: ");
  scanf("%s", word);
  return word;
}

/**
 * function: printHeader
 * description: prints the required header in CS251 including:
 * author, lab and time, program # and name 
 */
void printHeader(){
  printf("\n\n\nAuthor: Bradley Golden\n");
  printf("Lab: Thur 11am\n");
  printf("Program: #1, Google NGram word count\n\n\n");
}


/** 
 * function: numDistinctWords
 * description: counts the number of distinct words in the given file
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
  str1[0] = tolower(str1[0]);
  str2[0] = tolower(str2[0]);
  num = strcmp(str1, str2);
  return num;
}//end isDistinct


/** 
 * function: readData
 * description: reads ngrams data from file input in the following format:
 * word, year, number of occurences in that year, number of texts in which that word appeared
 *
 * returns a dynamically allocated array of structs of type ngramsData
 *
 * TODO: fix mem leak?
 */
ngramsData *readData(int *size, char *fileName){
  ngramsData *temp;
  *size = 0;
  int i = 0;
  int j = 0;
  int totalAllocated = 10;
  ngramsData *rawData = (ngramsData*)malloc(totalAllocated*sizeof(ngramsData));; //allocated for dynamic allocation

  FILE *ifp;

  ifp = fopen(fileName, "r");

  if(ifp == NULL){
    fprintf(stderr, "Cannot open input file %s", fileName);
  }

  //start dynamic allocation
  while(fscanf(ifp, "%s %d %d %d", rawData[i].word, &rawData[i].year, &rawData[i].numOccur, &rawData[i].numTexts) != EOF){

    if(i == totalAllocated){ //reached end of array, need to allocated more space
      temp = (ngramsData*)malloc(((totalAllocated*2)+1)*sizeof(ngramsData));
      for(j=0; j<=i; j++){
        temp[j] = rawData[j]; //copy array contents to larger allocated space
      }
      free(rawData);
      rawData = temp;
      totalAllocated = totalAllocated * 2; 
    }

    i++;
    //printf("size: %i\n", i);
  }
  *size = i;

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
