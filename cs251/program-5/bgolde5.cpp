/*
 * =====================================================================================
 *
 *       Filename:  bgolde5.cpp
 *
 *    Description:  Program 5 - CS251 Data Structures
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

/* 
 * REFERENCES:
 * 
 * https://cristibalas.wordpress.com/2008/05/11/generic-string-trie-implementation/
 * USED TO DETERMINE HOW TO STRUCTURE STRUCTS AND MALLOC SPACE
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define FILENAME "will.txt" //contains the collective works of shakespeare
#define FALSE 0
#define TRUE 1
#define FOUND 1
#define NOT_FOUND 0

typedef struct sTRIE_NODE {
  struct sTRIE_NODE *pLetters[26];
  int isWord;
} TRIE_NODE;

typedef struct {
  TRIE_NODE *pRoot;
} TRIE, *pTRIE;

//global variables
int totalWords = 0;
int totalTrieNodes = 0;
int debugMode = 0;

//program assignment specific functions
void displayMyInfo();

//file reading functions
TRIE * readFileToTrie(int*);
int parseStrToTrie(char*, pTRIE, int*);
char * scrubInput(char *word);

//trie functions
TRIE * initTrie();
void initTrieNode(TRIE_NODE*);
void addTrie(TRIE_NODE*, char*);
void addWordToTrie(TRIE_NODE*, char*);
int searchTrie(TRIE_NODE*, char*);
void lookupTrie(pTRIE);
int letterInTrie(TRIE_NODE*, int);
void printTrie(TRIE_NODE*);
int isWord(pTRIE);
void freeTrie(TRIE_NODE *node);

//helper functions
void str_print(char**, int, int);

//function used strictly for debugging purposes
char ** readFile(int*);
void parseStr(char*, char**, int);
void freeWordListTest(char**, int);

int main(int argc, char** argv){

  if(argc > 1 && strcmp(argv[1], "-d") == 0){
    debugMode = 1;
    printf("\n-=Debug Mode Set=-\n");
  }

  //display required class information
  displayMyInfo();

  pTRIE wordList; //holds all words from FILENAME
  //read file contents into trie
  if((wordList = readFileToTrie(&totalWords)) == NULL){
    fprintf(stderr, "Error wordList is NULL");
    return 1;
  }

  //used to scan entire trie from string array
  if(debugMode){
    printf("\n---==DEBUGGING INFORMATION==---\n\n");
    char **wordListTest; //holds all words from FILENAME
    int totalWordsTest = 0;

    //read file contents into array
    if((wordListTest = readFile(&totalWordsTest)) == NULL){
      fprintf(stderr, "Error worList is NULL");
      return 1;

    }

    printf("Total words parsed from %s: %i\n", FILENAME, totalWordsTest);

    if(totalWordsTest != totalWords)
      printf("Total word count mismatch, please recheck your parsing code\n");

    //search for every word in trie to see if they all exist
    int i, count = 0;
    for(i=0; i<totalWordsTest; i++){
      strcpy(wordListTest[i], scrubInput(wordListTest[i]));
      if(searchTrie(wordList->pRoot, wordListTest[i]) == NOT_FOUND){
        printf("%s couldn't be found in the trie!\n", wordListTest[i]);
        count++;
      }
    }
    printf("\n%i words weren't added properly to the trie\n", count);
    printf("\n---==END DEBUGGING INFORMATION==---\n");
    freeWordListTest(wordListTest, totalWordsTest);
  }

  printf("Total words parsed from %s: %i\n", FILENAME, totalWords);

  //enter look and allow user to search for words in the word list
  lookupTrie(wordList);

  freeTrie(wordList->pRoot);

  return 0;

}//end main

/* function: printTrie
 * description: prints the current trie node
 */
void printTrie(TRIE_NODE *curr){
  int i;
  for(i=0; i<26; i++){
    printf("%i %c: %p\n", i, i+97, curr->pLetters[i]); 
  }
  printf("isWord: %i\n", curr->isWord); 

}//end printTrie

/*
 * function: scrubInput
 * description: scrubs the users input, i.e. Gutenbergs -> gutengbergs and 123'YES -> yes
 */
char * scrubInput(char *word){
  int len = strlen(word), count = 0, tempCount = 0;

  //scrub input until length of word is reached
  while(count < len){
    //check that the letter in the word is in the alphabet
    if(isalpha(word[count])){
      //lowercase the letter
      word[count] = tolower(word[count]);
      count++;
    }
    //letter is not alphabetic, shift word to the left
    else{
      tempCount = count;
      //continue to shift until length of word is reached
      while(tempCount < len){
        word[tempCount] = word[tempCount+1];
        tempCount++;
      }
      //decreaes length of word by 1
      len--;
    }
  }
  return word;
}//end scrubInput

/*
 * function: lookupTrie
 * description: prompts the user or a word to look up in the Trie
 */
void lookupTrie(pTRIE words){
  char input[100];

  //continue loop until user enters an x
  while(strcmp(input, "x") != 0){

    printf("Enter a word to lookup or x to exit: ");
    scanf(" %s", input);
    if(strcmp(input, "x") == 0)
      return;
    strcpy(input, scrubInput(input));

    if(searchTrie(words->pRoot, input) == FOUND)
      printf("%s is found.\n", input);

    else
      printf("%s is NOT found.\n", input);
  }

}//end lookupTrie

/*
 * function: initTrie
 * description: mallocs space for a trie with 26 letters, each letter points to null
 */
TRIE * initTrie(){

  int count = 0;

  //point pRoot to new allocated trie
  TRIE *trie = (TRIE*)malloc(sizeof(TRIE));
  trie->pRoot = (TRIE_NODE*)malloc(sizeof(TRIE_NODE));

  initTrieNode(trie->pRoot);

  return trie;
}//end initTrie

/* 
 * function: freeTrie
 */
void freeTrie(TRIE_NODE *node){

  int count = 0;

  if(node == NULL)
    return;

  while(count < 26){
    if(node->pLetters[count] != NULL){
      freeTrie(node->pLetters[count]);
      free(node->pLetters[count]);
    }
    count++;
  }

}//freeTrie

/*
 * function: initTrieNode
 * description: initializes a trie node to default values
 */
void initTrieNode(TRIE_NODE *node){

  //set each letter in the node to null
  int count = 0;

  while(count < 26){
    node->pLetters[count] = NULL;
    count++;
  }

  //set curr word to false
  node->isWord = FALSE;

  //increament total nodes allocated by 1
  totalTrieNodes++;

}//end TRIE_NODE

//helper function
int endOfWord(char letter){
  if(letter == '\0')
    return 1;
  return 0;
}

//helper function
int isWord(TRIE_NODE *curr){
  if(curr->isWord == TRUE){
    return 1;
  }
  return 0;
}

/* 
 *  function: searchTrie
 *  description: searches the trie and returns 1 if the word has been found, 0 otherwise
 */
int searchTrie(TRIE_NODE *curr, char* word){

  int index;
  index = *word - 97;

  //if a word and reached the null character in the word
  if(endOfWord(*word) && isWord(curr)){
    return FOUND;
  }

  //end of word reached and not a word
  else if(endOfWord(*word) && !isWord(curr)){
    return NOT_FOUND;
  }

  //end of word not reached
  else {
    //if is word and not end of word, continue down the trie
    if(letterInTrie(curr, index)){
      return searchTrie(curr->pLetters[index], word+1);
    }
    //end of word not reached and word isn't in the trie
    else {
      return NOT_FOUND;
    }
  }

}//end searchTrie

int letterInTrie(TRIE_NODE *curr, int index){

  if(curr == NULL){
    return 0;
  }

  if(index >= 0  && curr->pLetters[index] != NULL)
    return 1;

  return 0;
}

/*  
 * Helper function for addTrie: addWordToTrie
 * Description: adds a word to a trie letter by letter
 *              i.e. if the word "pre" is already in the 
 *              trie and we want to add "preset", s e t is 
 *              added in the appropriate place following p r e
 */
void addWordToTrie(TRIE_NODE *curr, char *word){

  int index = *word - 97;

  //check if end of word and is a word in the trie, if so word already exists in the trie 
  if(endOfWord(*word)){
    curr->isWord = TRUE;
    return;
  }

  else { //not found
    //letter already in trie
    if(letterInTrie(curr, index)){
      addWordToTrie(curr->pLetters[index], word+1);
    }

    else if(!letterInTrie(curr, index)) { //add letter to trie
      pTRIE newNode = initTrie(); //allocate new node
      curr->pLetters[index] = newNode->pRoot; //point current letter index to new node
      if(endOfWord(*word)){
        curr->isWord = TRUE;
        return;
      }
      else { //not end of word
        addWordToTrie(curr->pLetters[index], word+1);
      }
    }
  }
}//end addWordToTrie

/*
 * function: addTrieNode
 * description: add a new node or nodes to a trie structure
 */
void addTrie(pTRIE pRoot, char *word){

  pTRIE temp = pRoot;

  if(searchTrie(temp->pRoot, word) == FOUND)
    return; //word is already in the trie

  addWordToTrie(temp->pRoot, word);

}//end addTrie



//helper function to print arrays of strings
//prints strings from start to end 
void str_print(char **strArr, int start, int end){
  int i;
  for(i=start; i<end; i++){
    printf("i: %i \t %s\n", i, strArr[i]);
  }
}//end printStrArr

/*  function: checkFormat
 *  description: checks that the word is all lowercase without special characters
 */
void checkFormat(char *word){
  int index=0, len = strlen(word);

  while(index < len){
    if((word[index] >= 'a' && word[index] <= 'z') || word[index] == '\0'){
      //do nothing
    }
    else{
      printf("Error incorrect format: %s %c\n", word, word[index]);
    }
    index++;
  }
}//end checkFormat

/* function: parseStrToTrie
 * description: given a string, parses the string into individual words
 *              
 *              returns the number of words generated from the string
 */
int parseStrToTrie(char *str, pTRIE strList, int *numWords){
  int strIndex = 0, letterIndex = 0, len;
  char *tempWord = (char*)malloc(sizeof(char)*100);

  while(str[strIndex] != '\0'){
    //if character store in temp word
    if(isalpha(str[strIndex])){
      tempWord[letterIndex] = tolower(str[strIndex]);
      letterIndex++;
    }
    //if space, tab, or newline, start new word and store the prvious
    else if(str[strIndex] == ' ' || str[strIndex] == '\t' || str[strIndex] == '\n'){

      if(strlen(tempWord) != 0){

        //check that the input format is correct
        checkFormat(tempWord); 

        //store current word in trie
        addTrie(strList, tempWord);

        //count current word
        (*numWords)++;
      }

      //reset index to 0 to start new word
      letterIndex = 0;

      //reset word
      memset(tempWord,0,sizeof(char)*100);
      tempWord = (char*)malloc(sizeof(char)*100);
    }

    //otherwise skip invalid punctuation
    else {
      //do nothing
    }
    strIndex++;
  }

  free(tempWord);
  return *numWords;
}//end parseStrToTrie

/* function: readFileToTrie
 * description: reads words from a given file line by line and parses each line
 *              all punctionation is skipped
 *              all letters are lowercased
 *              spaces, tabs, periods, exclamation points, and newlines indicate new words
 */
TRIE * readFileToTrie(int *numWords){
  FILE *fp;
  int listIndex;
  char word[50], str[200], currChar;

  //allocate space for all words in the text file
  pTRIE newTrie = initTrie();

  fp = fopen(FILENAME, "r");

  //check if file has been opened correctly
  if(fp == NULL){
    fprintf(stderr, "Error: could not open %s\n", FILENAME);
    return NULL;
  }
  else{
    printf("Reading words from file %s into Trie...\n", FILENAME);
  }

  //read file line by line
  while(fgets (str, 200, fp) != NULL){
    if(parseStrToTrie(str, newTrie, numWords) == -1)
      return NULL;
  }

  printf("Created %i Trie Nodes.\n", totalTrieNodes);

  fclose(fp);

  return newTrie;
} //end readFileToTrie

/* function: parseStr
 * description: given a string, parses the string into individual words
 *
 *              returns the number of words generated from the string
 */
int parseStr(char *str, char **strList, int *listIndex){
  int numWords = 0, strIndex = 0, validChar = 0, len;

  while(str[strIndex] != '\0'){
    //if character store in temp word
    if(isalpha(str[strIndex])){
      strList[*listIndex][validChar] = tolower(str[strIndex]);
      validChar++;
    }
    //if space, tab, or newline, perdiod or exlamation point, start new word
    else if(str[strIndex] == ' ' || str[strIndex] == '\n' || str[strIndex] == '\t'){
      //reset wordList currChar index
      len = strlen(strList[*listIndex]);
      if(len != 0){
        //start new word
        (*listIndex)++;
        numWords++;
      }
      //no longer a validChar, starting new word
      validChar = 0;
    }
    //otherwise skip invalid punctuation
    else {
      //do nothing
    }
    strIndex++;
  }

  return numWords;
}//end parseStr

/* function: readFile
 * description: reads words from a given file line by line and parses each line
 *              all punctionation is skipped
 *              all letters are lowercased
 *              spaces, tabs, periods, exclamation points, and newlines indicate new words
 */
char** readFile(int *numWords){
  FILE *fp;
  int j, listIndex = 0;
  char word[50], str[200], currChar;

  //allocate space for all words in the text file
  char **wordList = (char**)malloc(sizeof(char*)*1000000);
  for(j=0; j<1000000; j++){
    wordList[j] = (char*)malloc(sizeof(char)*100);
  }

  fp = fopen(FILENAME, "r");

  //check if file has been opened correctly
  if(fp == NULL){
    fprintf(stderr, "Error: could not open %s\n", FILENAME);
    return NULL;
  }
  else{
    printf("Reading from file %s\n", FILENAME);
  }

  //read file line by line
  while(fgets (str, 200, fp) != NULL){
    *numWords += parseStr(str, wordList, &listIndex);
  }

  fclose(fp);

  return wordList;
} //end readFile

/* function: freeWordListTest
 * description: frees a given list of words from memory
 */
void freeWordListTest(char **list, int size){
  int i;
  for(i=0; i<size; i++){
    free(list[i]);
  }
  free(list);
}//end freeWordListTest

//as requred by Prof Reed
void displayMyInfo(){

  printf("\n\n");
  printf("+___________________________________________________+\n");
  printf("| Author: Bradley Golden                            |\n");
  printf("| Date: 4/21/2015, UIC CS251 Data Structures        |\n");
  printf("| Program: #5, Trie Again                           |\n");
  printf("| System: Bert                                      |\n");
  printf("| Lab: Thursday 11am                                |\n");
  printf("+___________________________________________________+\n");
  printf("\n\n");

}//end displayMyInfo
