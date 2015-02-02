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
//TODO - sort data using insertion or selection sort! 

/*  strtok example */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define MAX_BUF 512
#define fileSelector 0 //1: very_short; 2: total_counts 3: words_that_start_with_a_q; 4: all_words

//snapshot of each line in the text file
typedef struct {
    char word[45]; //the longest word in the US dictionary is 45 characters!
    int year;
    int numOccur;
    int numTexts;
} ngramsData;

//collection of useful stats
typedef struct {
    int numLines;
    int distinctWords;
} ngramsStats;

/* function prototypes */
ngramsData *readData(int *size, char *filename);
void numDistinctWords(ngramsData *rawData, ngramsStats *usefulData, int size);
int wordsAreSame(char *str1, char *str2);
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
double yTitleStep(double min, double max);
int yearPrompt();
int getWordLength(char* str);
double averageWordLengthByYear(ngramsData *rawData, int year, int n);
double *totalAverageWordLength(ngramsData *rawData, int n);

int main (){
    
    ngramsData *rawData;
    ngramsStats *usefulData = (ngramsStats*)malloc(sizeof(ngramsStats));
    int size = 0;
    int enable = 1;
    int *graphFlag = &enable; //graph is enabled by default

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
    int wordIndex = searchByWord(wordInput, rawData, size);
    //printf("Word found at: %i\n", wordIndex);
    int count = numWords(wordInput, rawData, wordIndex, size);
    //printf("word count: %i\n", count);
    double *wordFreq = averageFrequency(wordInput, rawData, wordIndex, count, graphFlag);
    int i;
    for(i=0; i<40; i++){
        //printf("%i: average word frequency: %f\n", i, wordFreq[i]);
    }
    double minVal = findMin(wordFreq, 40);
    double maxVal = findMax(wordFreq, 40);
    //printf("minVal: %f\n", minVal);
    //printf("maxVal: %f\n", maxVal);
    char titleOne[] = "Word Frequency per 5 Years";
    if(*graphFlag)
      graph(wordFreq, count, titleOne, wordInput, minVal, maxVal);
    int yearInput = yearPrompt();
    double aveWordLen = averageWordLengthByYear(rawData, yearInput, size);
    printf("Average word length of %i is: %f\n", yearInput, aveWordLen);
    double *aveWordLenAll = totalAverageWordLength(rawData, size); 
    for(i=0;i<40;i++){
      //printf("aveWordLenAll[%i]: %f\n", i, aveWordLenAll[i]);
    }
    char titleTwo[] = "Total Average Word Length"; 
    char blank[] = "";//used to hide word display at top
    minVal = findMin(aveWordLenAll, 40);
    maxVal = findMax(aveWordLenAll, 40);
    graph(aveWordLenAll, count, titleTwo, blank, minVal, maxVal); 

    free(wordFreq);
    free(usefulData);
    free(rawData);
    free(fileName);
    free(wordInput);
    free(aveWordLenAll);

    return 0;
}
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

/**
 * function: getWordLength
 * description: returns the length of a given word
 */
int getWordLength(char* str){
  int length;
  length = strnlen(str, 45);
  return length;
}//end getWordLength

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
 * function: graph
 * description: prints graph of data to the screen
 */
void graph(double arr[], int size, char *title, char *word, double yMin, double yMax){
  int i = 0;
  int j = 0;
  double yStep;
  double yTitle;
  yStep = yTitleStep(yMin-0.01, yMax+0.01);

  //printf("yStep: %.2g\n", yStep);
  yTitle = yMax;//+yStep;
  printf("\t\t\t\t\t\t\t\t\t%s (%s)\t\t\n", title, word);
  printf("\t\t\t ------------------------------------------------------------------------------------------------------------------------\n");
  //display bars
  for(i=0; i<50; i++){
    printf("%f\t\t|", yTitle);
    for(j=0; j<40; j++){
      //if arr[i] + yTitle print " X "
      if(arr[j] >= yTitle){
        printf(" X ");
      }
      //else print "   "
      else{
        printf("   ");
      }
    }
    printf("|\n");
    yTitle-=yStep;
  }
  printf("\t\t\t ------------------------------------------------------------------------------------------------------------------------\n");
  printf("\t\t\t ");

  //display years
  for(i=0; i<40; i++){
    printf(" 1 ");
  }
  printf("\n\t\t\t ");
  for(i=0; i<20; i++){
    printf(" 8 ");
  }
  for(i=0; i<20; i++){
    printf(" 9 ");
  }
  printf("\n\t\t\t ");
  j=0;
  for(i=1; i<=40; i++){
    printf(" %i ", j);
    if(i%2 == 0)
      j++; 
    if(j > 9)
      j = 0;
  }
  printf("\n\t\t\t ");
  j = 1;
  for(i=0; i<40; i++){
    if(j > 6)
      j = 1;
    printf(" %i ", j); 
    j+=5;
  }
  printf("\n\t\t\t\t\t\t\t\t\tYear\n");
}//end graph

double yTitleStep(double min, double max){
  double step;

  step = (max - min) / 49;

  return step;
}

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
 * function: addFreq
 * description: adds word frequency in a specified year range
 */
int addFreq(char *word, ngramsData *rawData, int start, int range){
  int sum, i;
  sum = 0;
  i = start;
  while(i<(start+range)){
    if(isInYearRange(rawData[i].year) && wordsAreSame(word,rawData[i].word)==0){
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
    if(isInYearRange(rawData[i].year) && wordsAreSame(word,rawData[i].word)==0){
      sum+=rawData[i].numTexts;
    }
    i++;
  }
  return sum;
}//end addTexts

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
  while(wordsAreSame(word, rawData[wordIndex].word) == 0 && i<40){
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


/** function: isInYearRange
 *  description: determines whether the given word is between 1801 and 2000
 */
int isInYearRange(int year){
  if(year >= 1801 && year <= 2001)
    return 1;
  return 0;
}
/** function: numWords
 *  description: counts the number of occurences of a given word within a specified timeframe
 */
int numWords(char *word, ngramsData *rawData, int wordIndex, int n){
  int count, i;
  count = 0;
  i = 0;
  while(wordsAreSame(word, rawData[i].word) == 0){
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
    if(wordsAreSame(word, rawData[i].word) == 0){
      return i;
    }
  }
  return -1;
}//end searchByWord

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
    if(wordsAreSame(rawData[i].word, rawData[i+1].word)!=0)
      //printf("word1: %s word2: %s\n", rawData[i].word, rawData[i+1].word);
      count++;
  }
  usefulData->distinctWords = count;

  printf("Total number of distinct words: %i\n", count);
}//end numDistinctWords

/**
 * function: wordsAreSame
 * description: returns the strcmp value of two strings
 */
int wordsAreSame(char *str1, char *str2){
  int num = 0;
  int i =0;
  int len1, len2;
  len1 = strnlen(str1, 45);
  len2 = strnlen(str2, 45);

  //force strings to be lowercase
  for(i=0; i<len1; i++){
    str1[i] = tolower(str1[i]);
  }
  for(i=0; i<len2; i++){
    str2[i] = tolower(str2[i]);
  }
  num = strncmp(str1, str2, 45);
  return num;
}//end wordsAreSame

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
  int totalAllocated = 1;
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
      for(j=0;j<=i;j++){
        temp[j] = rawData[j];
      }
      free(rawData);
      rawData = NULL;
      free(rawData);
      rawData = temp;
      totalAllocated = totalAllocated * 2;
    }

    //rawData[i].wordArr[i] = rawData[i].word;
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
