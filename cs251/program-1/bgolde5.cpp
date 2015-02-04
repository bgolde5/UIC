/*
 * =====================================================================================
 *
 *       Filename:  ngrams.cpp
 *
 *    Description:  Program 1, cs251
 *
 *        Version:  1.0
 *        Created:  02/03/2015 04:02:57 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu
 *   Organization:  University of Illiois at Chicago
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <iostream>
#include <climits>

using namespace std;

#define GRAPH_HEIGHT 20
#define GRAPH_WIDTH 40

//snapshot of each line in the text file
typedef struct {
    char *word; //the longest word in the US dictionary is 45 characters!
    int year;
    int numOccur;
    int numTexts;
} ngramsData;

//collection of useful stats
typedef struct {
    int numLines;
    int distinctWords;
} ngramsStats;


//function prototypes
char *allocateWordMem(char *word);
ngramsData *dynamicMemAllocation(ngramsData *rawData, int *memAvail);
ngramsData *readData(int *size, char *fileName);
ngramsData *createWord(ngramsData *rawData);
void numDistinctWords(ngramsData *rawData, ngramsStats *usefulData, int size);
int wordsAreDiff(char *str1, char *str2);
void printData(ngramsData *rawData, int n);
void printHeader();
char *wordPrompt();
char *filePrompt();
int searchByWord(char *word, ngramsData *rawData, int n);
double *averageFrequency(char *word, ngramsData *rawData, int wordIndex, int n, int *graphFlag);
int numWords(char *word, ngramsData *rawData, int wordIndex, int numWords);
int isInYearRange(int year);
int addTexts(char *word, ngramsData *rawData, int start, int range);
int addFreq(char *word, ngramsData *rawData, int start, int range, int yMin, int yMax);
void graph(double arr[], int size, char *title, char *word, double yMin, double yMax);
double findMin(double arr[], int n);
double findMax(double arr[], int n);
double yTitleStep(double min, double max, int height);
int yearPrompt();
int getWordLength(char* str);
double averageWordLengthByYear(ngramsData *rawData, int year, int n);
double *totalAverageWordLength(ngramsData *rawData, int n);
void printYears();
void fillBuckets(int width, int height, double step, double yVal, double data[]);
void printBars(int n);
int yearPrompt();
ngramsData *sort(ngramsData *rawData, int size);

int main() {
    ngramsData *rawData;
    ngramsStats *usefulData = (ngramsStats*)malloc(sizeof(ngramsStats));
    int size = 0;
    int enable = 1;
    int *graphFlag = &enable; //graph is enabled by default
    double *wordFreq;
    double minVal;
    double maxVal;
    char titleOne[] = "Word Frequency per 5 Years";
    int yearInput;
    double aveWordLen;
    double *aveWordLenAll;
    char bottomTitle[] = "";//left blank
    char titleTwo[] = "Total Average Word Length";
    
    
    //gen info
    printHeader();

    //read and store file contents
    char* fileName = filePrompt();
    if(fileName == NULL)
      return -1;
    printf("Reading file.... Please wait...\n");
    rawData = readData(&size, fileName);
    if(rawData == NULL)
      return -1;
    printf("Reading complete...Sorting file...Please wait...\n");
    rawData = sort(rawData, size);
    //printData(rawData, size);

    //collect stats
    usefulData->numLines = size; //collect size into usefulData struct
    numDistinctWords(rawData, usefulData, size);
    char *wordInput = wordPrompt(); //prompts user to input a word
    printf("Searching for word... Please wait...\n");
    int wordIndex = searchByWord(wordInput, rawData, size);
    if(wordIndex == -1){
      printf("%s could not be found in the file.\n", wordInput);
      return -1;
    }
    else{
      printf("%s has been found!\n", wordInput);
    }
    int count = numWords(wordInput, rawData, wordIndex, size);
    if(count < 40){
      printf("This file is too small to perform the rest of the operations. :(\n");
      return 0;
    }

    //part I
    wordFreq = averageFrequency(wordInput, rawData, wordIndex, count, graphFlag);

    //part II
    minVal = findMin(wordFreq, 40);
    maxVal = findMax(wordFreq, 40);
    if(*graphFlag)
      graph(wordFreq, count, titleOne, wordInput, minVal, maxVal);

    //part III
    yearInput = yearPrompt();
    aveWordLen = averageWordLengthByYear(rawData, yearInput, size);
    printf("Average word length of %i is: %f\n", yearInput, aveWordLen);

    //partIV
    aveWordLenAll = totalAverageWordLength(rawData, size);
    minVal = findMin(aveWordLenAll, 40);
    maxVal = findMax(aveWordLenAll, 40);
    if(*graphFlag)
      graph(aveWordLenAll, count, titleTwo, bottomTitle, minVal, maxVal);


    //free space used
    free(wordFreq);
    free(usefulData);
    free(rawData);
    free(fileName);
    free(wordInput);
    free(aveWordLenAll);

    return 0;
}//end main

/** 
 * function: sort
 * description: insertion sort
 */
ngramsData *sort(ngramsData *rawData, int size){
  int c, d, t;
  ngramsData *temp = (ngramsData*)malloc(sizeof(ngramsData));
  d = 0;
  for (c = 1 ; c <= size - 1; c++) {
    d = c;
    while ( d > 0 && strcasecmp(rawData[d].word, rawData[d-1].word) > 0) {
      *temp = rawData[d];
      rawData[d] = rawData[d-1];
      rawData[d-1] = *temp;
      d--;
    }
  }
  return rawData;
}//end sort

/**
 * function: filePrompt
 * description: prompts the user for a file name
 */
char *filePrompt(){
  char *file = (char*)malloc(50*sizeof(char));
  printf("Enter a filename: ");
  scanf("%s", file);
  return file;
}//end filePrompt

/**
 * function: getWordLength
 * description: returns the length of a given word
 */
int getWordLength(char* str){
  int length;
  length = (int)strnlen(str, 45);
  //printf("word length: %i\n", length);
  return length;
}//end getWordLength

/**
 * function: averageWordLengthByYear
 * description: returns the average word length in a given year
 */
double averageWordLengthByYear(ngramsData *rawData, int year, int n){
  int i, count;
  double totalLen = 0;
  count=0;
  ///printf("year: %i\n", year);
  //printf("n: %i\n", n);
  for(i=0; i<n; i++){
    if(year == rawData[i].year){
      //printf("totalLen: %f\n", totalLen);
      totalLen += (double)getWordLength(rawData[i].word);
      count++;
    }
  }
  //printf("total words: %i\n", count);
  return totalLen/count;
}//end averageWordLength

/** function: isInYearRange
 *  description: determines whether the given word is between 1801 and 2000
 */
  int isInYearRange(int year){
    if(year >= 1801 && year <= 2001)
      return 1;
    return 0;
  }//end isInYearRange

/**
 * function: addFreq
 * description: adds word frequency in a specified year range
 */
int addFreq(char *word, ngramsData *rawData, int start, int range){
  int sum, i;
  sum = 0;
  i = start;
  while(i<(start+range)){
    if(isInYearRange(rawData[i].year) && wordsAreDiff(word,rawData[i].word)==0){
      sum+=rawData[i].numOccur;
    }
    i++;
    //    printf("sum: %i\n", sum);
  }
  return sum;
}//end addRange

/**
 * function: addTexts
 * description: add number of texts in a specified year range
 */
int addTexts(char *word, ngramsData *rawData, int start, int range){
  int sum, i;
  sum = 0;
  i = start;
  while(i<(start+range)){
    if(isInYearRange(rawData[i].year) && wordsAreDiff(word,rawData[i].word)==0){
      sum+=rawData[i].numTexts;
    }
    i++;
  }
  return sum;
}//end addTexts

/**
 * function: totalAverageWordLength
 * description: returns the overall average words length of all words across all years
 * if 5 year buckets from 1801-2000
 */
double *totalAverageWordLength(ngramsData *rawData, int n){
  int i, j, index;
  double *ave = (double*)malloc(40*sizeof(double));
  double sum;
  sum=0;

  index = 0;
  for(i=1801; i<2001; i+=5){
    for(j=1; j<6; j++){
      sum += averageWordLengthByYear(rawData, i+j, n);
      //printf("sum: %f\n", sum);
    }
    ave[index]=(sum/5);
    sum = 0;
    index++;
  }
  return ave;
}//end totalAverageWordLength



/**
 * function: yearPrompt
 * description: prompts the user for a year
 */
int yearPrompt(){
  int year;
  printf("Please enter a year to get the average word length for that year: ");
  scanf("%i", &year);
  return year;
}//end yearPrompt


/**
 * function: printBars
 * description: prints bars("-") for the graph window
 */
void printBars(int n){
  int i;
  printf("\t\t ");
  for(i=0; i<n; i++){
    printf("-");
  }
  printf("\n");
}//end printBars
/**
 * function: fillBuckets
 * description: fills the year buckets in the graph windows with X
 */
void fillBuckets(int width, int height, double step, double yVal, double data[]){
  int i;
  int j;
  for(i=0; i<height; i++){
    printf("%f\t|", yVal);
    for(j=0; j<width; j++){
      //if arr[i] + yTitle print " X "
      if(data[j] >= yVal){
        printf("X");
      }
      //else print "   "
      else{
        printf(" ");
      }
    }
    printf("|\n");
    yVal-=step;
  }
}//fillBuckets

/**
 * function: printYears
 * description: prints the years to be display on the graph
 */
void printYears(){
  int i, j;
  printf("\t\t ");
  for(i=0; i<40; i++){
    printf("1");
  }
  printf("\n\t\t ");
  for(i=0; i<20; i++){
    printf("8");
  }
  for(i=0; i<20; i++){
    printf("9");
  }
  printf("\n\t\t ");
  j=0;
  for(i=1; i<=40; i++){
    printf("%i", j);
    if(i%2 == 0)
      j++;
    if(j > 9)
      j = 0;
  }
  printf("\n\t\t ");
  j = 1;
  for(i=0; i<40; i++){
    if(j > 6)
      j = 1;
    printf("%i", j);
    j+=5;
  }
  printf("\n\t\t\tYear\n");
}//end printYears

/**
 * function: graph
 * description: prints graph of data to the screen
 */
void graph(double arr[], int size, char *title, char *word, double yMin, double yMax){

  int graphWidth = GRAPH_WIDTH;
  int graphHeight = GRAPH_HEIGHT;
  double yStep;
  double yTitle;
  yStep = yTitleStep(yMin-0.01, yMax+0.01, graphHeight);

  //printf("yStep: %.2g\n", yStep);
  yTitle = yMax;//+yStep;
  printf("\t\t\t%s (%s)\t\t\n", title, word);

  //print graph window bars ("-")
  printBars(graphWidth);

  //fill year buckets
  fillBuckets(graphWidth, graphHeight, yStep, yTitle, arr);

  //print graph windows bars ("-")
  printBars(graphWidth);

  //display years
  printYears();

}//end graph

double yTitleStep(double min, double max, int height){
  double step;

  step = (max - min) / (height-1);

  return step;
}

/**
 * function: findMax
 * description: finds the max of a given array
 */
double findMax(double arr[], int n){
  double max;
  int i;
  max = arr[0];
  for(i=1; i<n; i++){
    if(arr[i] > max){
      max = arr[i];
    }
  }
  return max;
}//end findMax

/**
 * function: findMin
 * description: finds the min of a given array
 */
double findMin(double arr[], int n){
  double min;
  int i;
  min = arr[0];
  for(i=1; i<n; i++){
    if(arr[i] < min){
      min = arr[i];
    }
  }
  return min;
}//end findMin

/** function: averageFrequency
 *  description: gives the frequency of a given word every 5 years
 */
double *averageFrequency(char *word, ngramsData *rawData, int wordIndex, int numWords, int *graphFlag){
  double *ave;
  int freq, texts;
  int i = 0;
  //printf("numWords: %i\n", numWords);
  //ave = (double*)malloc(numWords*sizeof(double));//size of ave depends on number of words in the specified range of years
  ave = (double*)malloc(40*sizeof(double));//size of ave depends on number of words in the specified range of years


  //average years if year is in the range of 1801 - 2000
  while(!wordsAreDiff(word, rawData[wordIndex].word) && i<40){ //while words are the same
    //sum 5 year range of word frequency
    //printf("year: %i\n", rawData[wordIndex].year);
    freq = addFreq(word, rawData, wordIndex, 5);
    //printf("freq: %i\n", freq);
    texts = addTexts(word, rawData, wordIndex, 5);
    //printf("texts: %i\n", texts);
    ave[i] = (double)freq / texts;
    //printf("%i: ave[%i]: %f\tyear: %i\n", i, i, ave[i], rawData[wordIndex].year);
    if(isInYearRange(rawData[wordIndex].year)){
      i++;//only increment index if the correct year
      wordIndex+=5;
    }
    else{
      wordIndex++; //check each year until 1801 then begin adding 5
    }
  }
  if(i==0){
    printf("There are no words in the file between 1801 and 2001\n");
    *graphFlag = 0;
  }
  return ave;
}//end averageFrequency

/** function: numWords
 *  description: counts the number of occurences of a given word within a specified timeframe
 */
int numWords(char *word, ngramsData *rawData, int wordIndex, int n){
  int count, i;
  count = 0;
  i = 0;
  while(wordsAreDiff(word, rawData[i].word) == 0){
    if(isInYearRange(rawData[i].year))
      count++;
    i++;
  }
  return count;
}//end numWords

/**
 * function: searchByWord
 * description: seraches for a given word and returns the index of that word if found
 */
int searchByWord(char *word, ngramsData *rawData, int n){
  int i;
  for(i=0; i<n; i++){
    if(wordsAreDiff(word, rawData[i].word) == 0){
      return i;
    }
  }
  return -1;
}//end searchByWord

/**
 * function: wordPrompt
 * description: prompts the user for a word of type char*
 */
char *wordPrompt(){
  char *word = (char*)malloc(50*sizeof(char));
  printf("Enter a word: ");
  scanf("%s", word);
  return word;
}//end wordPrompt

/**
 * function: wordsAreDiff
 * description: returns the strcmp value of two strings
 */
int wordsAreDiff(char *str1, char *str2){
  //printf("%s %s\n", str1, str2);
  int num=0;
  int i=0;
  int len1, len2;
  len1 = (int)strlen(str1);
  len2 = (int)strlen(str2);
  //printf(" len1: %i, len2: %i\n", len1, len2);

  //force strings to be lowercase
  for(i=0; i<len1; i++){
    str1[i] = tolower(str1[i]);
  }
  //printf("%s", str1);
  for(i=0; i<len2; i++){
    str2[i] = tolower(str2[i]);
  }
  //printf(" %s\n", str2);
  num = strcmp(str1, str2);
  //printf("num: %i", num);

  return num;

}//end wordsAreDiff

/**
 * function: numDistinctWords
 * description: counts the number of distinct words in the given file
 */
void numDistinctWords(ngramsData *rawData, ngramsStats *usefulData, int n){
  int i;
  int count = 1;//the first word is distinct and is thus counted
  for(i=0; i<n-1; i++){
    if(wordsAreDiff(rawData[i].word, rawData[i+1].word))
      count++;
  }
  printf("Number of Distinct Words: %d\n", count);
  usefulData->distinctWords = count;
}//end numDistinctWords

/**
 * function: cleanMem
 * description: Removes excess space from dynamic memory allocation
 */
ngramsData *cleanMem(ngramsData *rawData, int size){
  ngramsData *temp = (ngramsData*)malloc(size*sizeof(ngramsData));

  return temp;
}//end cleanMem

/**
 * function: printHeader
 * description: prints the required header in CS251 including:
 * author, lab and time, program # and name
 */
void printHeader(){
  printf("\n\n\nAuthor: Bradley Golden\n");
  printf("Lab: Thur 11am\n");
  printf("Program: #1, Google NGram word count\n\n\n");
}//end printHeader

/**
 * function: readData
 * description: reads ngrams data from file input in the following format:
 * word, year, number of occurences in that year, number of texts in which that word appeared
 *
 * returns a dynamically allocated array of structs of type ngramsData
 */
ngramsData *readData(int *size, char *fileName){

  FILE *inFile;    // declare file pointer
  inFile = fopen( fileName,"r");

  if(inFile == NULL){
    fprintf(stderr, "Cannot open input file %s\n", fileName);
  }

  int totalAllocated = 100;
  int count = 0;
  char word[100];
  int year;
  int wordCount;
  int uniqueTextCount;
  char *newWord;
  int j;

  ngramsData *rawData = (ngramsData*)malloc(totalAllocated*sizeof(ngramsData));
  if(rawData == NULL){
    printf("Error allocating initial memory for *rawData");
  }

  while( fscanf( inFile, "%s %d %d %d", word, &year, &wordCount, &uniqueTextCount) != EOF ) {
    if(count == totalAllocated){
      //ngramsData *temp = dynamicMemAllocation(rawData, &totalAllocated);
      ngramsData *temp = (ngramsData*)malloc((totalAllocated+1000)*sizeof(ngramsData));
      for(j=0;j<count;j++){
        temp[j] = rawData[j];
      }
      free(rawData);
      rawData = temp;
      totalAllocated+=1000;
    }

    //allocate word mem
    newWord = allocateWordMem(word);
    //printf("newWord: %s\n", newWord);
    rawData[count].word = newWord;
    //for(j=0; j<strlen(word); j++){
    //rawData[count].word[j] = word[j];
    //}
    rawData[count].year = year;
    rawData[count].numOccur = wordCount;
    rawData[count].numTexts = uniqueTextCount;
    //printf("%s %d %d %d \n", word, year, wordCount, uniqueTextCount);
    //printf("%s %d %d %d \n", rawData[count].word, rawData[count].year, rawData[count].numOccur, rawData[count].numTexts);
    count++;
  }
  *size = count;

  return rawData;
}//end readData

/**
 * function: allocateWordMem
 * description: creates space and copies a string dynamically
 */
char *allocateWordMem(char *word){
  int length;
  length = (int)strlen(word);

  //  printf("length: %i word: %s\n", length, word);

  char *dynWord = (char*)malloc(1+sizeof(length));

  strcpy(dynWord, word);

  return dynWord;
}//end allocateWordMem

/**
 * function: dynamicMemAllocation 
 * description: pushes each input to a dynamically allocated array of structs
 */
ngramsData *dynamicMemAllocation(ngramsData *rawData, int *memAvail){
  int j;

  ngramsData *temp = (ngramsData*)malloc((*memAvail+100)*sizeof(ngramsData));
  for(j=0;j<=(*memAvail);j++){
    temp[j] = rawData[j];
  }
  rawData = temp;
  *(memAvail)+=100;

  return rawData;
}//end pushToArr

/**
 * function: printData
 * description: prints the current words, etc. tha are stored in struct ngramsData
 */
void printData(ngramsData *rawData, int n){

  int i = 0;

  for(i=0; i<n; i++){
    printf("%s %i %i %i\n", rawData[i].word, rawData[i].year, rawData[i].numOccur, rawData[i].numTexts);
  }
}//end printData
