/*
 * =====================================================================================
 *
 *       Filename:  hashing.cpp
 *
 *    Description:  Program 4 - CS251 Data Structures
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

/* 
 *  REFERENCES:
 *  
 *  USED TO CREATE ADT STYLE HASH IMPLEMATION: http://www.cs.yale.edu/homes/aspnes/pinewiki/C(2f)HashTables.html
 *      -helped with determining how to best structure a hash table
 *
 *  My hash and Golden ratio hash are both based off of Universal Hashing
 *  from Robert Sedgewick's "Algorithms in C - Third Edition"
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <errno.h>

//each struct is an individual row 
struct h_row {
  struct h_row *next;
  char *word;
  int key;
  int bucket;
} ;

//struct for hash table
struct h_table {
  int size; //size of table
  int n; //number of elements stored in table 
  int c; //total number of collisions
  int c_lin; //total number of linear collisions
  int c_quad; //total number of quadtratic collisions
  int c_chain; //total number chaining collisions
  struct h_row **table;
};

#define FILENAME "will.txt" //contains the collective works of shakespeare
#define H_BUCKET 0 //default value to store in bucket
#define H_NUM_BUCKETS 2 //default to 2 buckets for chaining
#define H_NUM 5 //number of hashtables
#define GOLDEN_RATIO 1.61803398875

//hash table structure
typedef struct h_table *hashTable;

//global variables
int totalWords = 0;
int distinctWords = 0;

//program assignment specific functions
void displayMyInfo();
void displayResults(hashTable*);
void displayBestCombination(hashTable*);

//file reading functions
char ** readFile(int*);
void parseStr(char*, char**, int);
void freeWordList(char**, int);

//hash table functions
hashTable h_create(int);
hashTable h_createINTERNAL(int);
void h_insert(hashTable, int, char*);
int h_insertLINEAR(hashTable, int, char*);
int h_insertQUADRATIC(hashTable ht, int, char*);
int h_insertCHAINING(hashTable ht, int key, char *str);
void h_destroy(hashTable);
void h_print(hashTable, int, int);
void h_reset(hashTable);

//hash function
unsigned long myHash(unsigned char*, int tSize);
unsigned long goldenRatioHash(unsigned char*, int tSize);

//helper functions
void str_print(char**, int, int);
int isDuplicateInRow(h_row *row, char *str, int*);

int main(int argc, char** argv){

  //display required class information
  displayMyInfo();

  char **wordList; //holds all words from FILENAME

  //read file contents into array
  if((wordList = readFile(&totalWords)) == NULL){
    fprintf(stderr, "Error worList is NULL");
    return 1;
  }

  //create array of 5 hash tables
  hashTable h_table[H_NUM];
  int h_size[H_NUM] = {39373, 41621, 47569, 57329, 63521};

  //initialize 5 hash tables
  int i;
  for(i=0; i<H_NUM; i++){
    h_table[i] = h_create(h_size[i]); //create hash table

    if(h_table[i] == NULL)
      printf("Error: hash table could not be allocated");
  }

  //fill hash tables
  int j;
  unsigned long key;

  for(j=0; j<H_NUM; j++){

    //implement linear probing
    for(i=0; i< totalWords; i++){
      //key = myHash((unsigned char*)wordList[i], h_table[j]->size) % h_table[j]->size;
      key = goldenRatioHash((unsigned char*)wordList[i], h_table[j]->size) % h_table[j]->size;
      h_insertLINEAR(h_table[j], key, wordList[i]);
    }

    //reset current table
    h_reset(h_table[j]);

    //implement quadratic probing
    for(i=0; i< totalWords; i++){
      //key = myHash((unsigned char*)wordList[i], h_table[j]->size) % h_table[j]->size;
      key = goldenRatioHash((unsigned char*)wordList[i], h_table[j]->size) % h_table[j]->size;
      h_insertQUADRATIC(h_table[j], key, wordList[i]);
    }

    //reset current table
    h_reset(h_table[j]);

    //implement chaining
    for(i=0; i< totalWords; i++){
      //key = myHash((unsigned char*)wordList[i], h_table[j]->size) % h_table[j]->size;
      key = goldenRatioHash((unsigned char*)wordList[i], h_table[j]->size) % h_table[j]->size;
      h_insertCHAINING(h_table[j], key, wordList[i]);
    }
    distinctWords = h_table[j]->n;

    //reset current table
    h_reset(h_table[j]);
  }

  //display total words
  printf("Total words: %i\n", totalWords);
  //distinct words
  printf("Distinct words: %i\n", distinctWords);

  //display final results
  displayResults(h_table);

  //free all hash tables 
  for(i=0; i<5; i++)
    h_destroy(h_table[i]); 

  //free wordList read from file
  freeWordList(wordList, totalWords);
  printf("\nExiting program...\n");
  return 0;

}//end main

/* function: h_reset
 * description: resets the hash table to default settings
 */
void h_reset(hashTable ht){
  int i;
  struct h_row *hr;
  struct h_row *next;

  ht->c = 0;
  ht->n = 0;

  for(i=0; i<ht->size; i++){
    //only free if table has bucket
    if(ht->table[i] != NULL){
      //set to table at index i
      hr = ht->table[i];
      while(hr != NULL){
        //set next next bucket (applied to chaining)
        next = hr->next; 
        //free word in bucket
        free(hr->word);
        //free bucket
        free(hr);
        hr = next;
      }
    }
  }
  for(i=0; i<ht->size; i++){
    ht->table[i] = NULL;
  }
}//end h_reset

//wrapper function for h_createINTERNAL
hashTable h_create(int size){
  return h_createINTERNAL(size);
}//end h_create

/* function: h_createINERNAL 
 * description: allocated space for a hash table
 *              
 *              called by h_create
 */
hashTable h_createINTERNAL(int size){

  int i;
  hashTable ht;

  //allocate hash table structs
  ht = (h_table*)malloc(sizeof(*ht));

  if(ht == NULL)
    printf("Error: could not allocte table");

  ht->size = size; //initiaze size to hash table size

  ht->c = 0; //initialize collisions to 0
  ht->c_lin = 0;
  ht->c_quad = 0;
  ht->c_chain = 0;

  ht->n = 0; //initialize number of elements to 0

  //allocate hash table pointers 
  ht->table = (struct h_row**)malloc(sizeof(struct h_row*)*size); 

  if(ht == NULL)
    printf("Error: could not allocate table pointers");

  //allocate hash table rows
  for(i=0; i<size; i++){
    ht->table[i] = NULL; 
  }

  return ht;
}//end hashTable_create

/* function: h_insert
 * description: creates a row for the hash table and assigns that row
 *              to the hash index determined by the hash function
 *
 *              if the row is already occupied, count as colliion and move to next row
 *              
 *              returns the index where the value has been stored
 *
 */
void h_insert(hashTable ht, int h_key, char *str){

  //declare new hashtable row
  struct h_row *hr;

  //unsigned long h_key;
  int len = 50; //set max word length to 50

  //allocate space for new hash table row
  hr = (h_row*)malloc(sizeof(struct h_row));

  if(hr == NULL)
    printf("Error: could not allocate space for hash table row\n");

  //allocate space for string in hashtable row
  //len = (int)strlen(str);
  hr->word = (char*)malloc(sizeof(char)*len); 

  //copy string into hash table row
  strcpy(hr->word, str);

  //initialize key into bucket 
  //hr->key = KRHash(str) % ht->size;
  hr->key = h_key;

  //point next to hash table at hash index
  hr->next = ht->table[h_key]; 

  //point hash table at hash index to hashtable row
  ht->table[h_key] = hr;
  ht->n++; //increment number of elements in hash table

}//end h_insert

/* function: h_insertLINEAR
 * description: creates a row for the hash table and assigns that row
 *              to the hash index determined by the hash function
 *
 *              if the row is already occupied, count as colliion and move to next row
 *              
 *              returns the index where the value has been stored
 *
 */
int h_insertLINEAR(hashTable ht, int key, char *str){

  int hk, collisions = 0;
  hk = key % ht->size;

  //continue while collisions don't exceed table size
  while(collisions < ht->size) {
    //check that table index insnt empty
    if(ht->table[hk] == NULL){
      h_insert(ht, hk, str); //insert word in table
      ht->c_lin += collisions; //increment collision count
      return hk;
    }
    //if strings are the same
    else if(strcmp(ht->table[hk]->word, str) == 0){
      return hk;
    }
    else{
      hk = hk + collisions++; //increment key by collision amount
      if(hk >= ht->size)
        hk = hk - (ht->size-1); //ensure key doesn't exceed table size
    }
  }

  //table is full
  return -1;
}//end h_insertLINEAR

/* function: h_insertQuadratic
 * 
 * description: creates a row for the hash table and assigns that row
 *              to the hash index determined by the hash function
 *
 *              if the row is already occupied, count as colliion and move to next row
 *              
 *              returns the index where the value has been stored
 *
 */
int h_insertQUADRATIC(hashTable ht, int key, char *str){

  int hk, collisions = 0;
  hk = key % ht->size;

  //continue while collisions less than table size
  while(collisions < ht->size) {
    if(ht->table[hk] == NULL){
      h_insert(ht, hk, str);//insert word into table
      ht->c_quad += collisions;//increment collision count
      return hk;
    }
    //strings are the same
    else if(strcmp(ht->table[hk]->word, str) == 0){
      return hk;
    }
    //collision
    else{
      collisions++;
      hk = (hk + collisions * collisions); //add collisions to current key 
      if(hk >= ht->size) //check that key does not exceed table size
        hk = hk - (ht->size-1);
    }
  }

  //table is full
  return -1;
}//end h_insertQUADRATIC

/* function: h_insertCHAINING
 * description: creates a row for the hash table and assigns that row
 *              to the hash index determined by the hash function
 *
 *              if the row is already occupied, count as colliion and move to next row
 *              
 *              returns the index where the value has been stored
 *
 */
int h_insertCHAINING(hashTable ht, int key, char *str){

  int hk, currBucket = 0, numBuckets = H_NUM_BUCKETS, collisions = 0;
  int count = 0;
  h_row *hr;
  h_row *prev;
  h_row *row;
  hk = key % ht->size;

  while(collisions < ht->size) {
    //printf("collisions: %i\n", collisions);

    hr = ht->table[hk];

    //bucket is not empty
    while(hr != NULL){

      //check if word in bucket is same as current string
      if(strcmp(hr->word, str) == 0)
        return hk+=collisions;

      //word is different and bucket is not empty, increment collisions
      collisions++; //increment collisions only 
      if(hk >= ht->size) //rolls over key to beginning of table
        hk = hk - (ht->size-1); //rolled over key

      //advance to next bucket
      hr = hr->next;
    }

    //bucket is empty
    if(hr == NULL){
      h_insert(ht, hk, str);
      ht->c_chain += collisions;
      return hk;
    }
    return -1;
  }

  //table is full
  return -1;
}//end h_insertCHAINING

//helper function for insertCHAINING
//returns 1 if there is a duplicate string in a given row
int isDuplicateInRow(h_row *row, char *str, int *count){

  while(row != NULL){
    if(strcmp(row->word, str) == 0){
      return *count;
    }
    row = row->next;
    (*count)++;
  }
  //no duplicate
  return 0;
}//end isDuplicateInRow


/* function: h_destroy
 * description: deallocate space used for hash implementation 
 */
void h_destroy(hashTable ht){

  int i;
  h_row *hr;
  h_row *next;

  for(i=0; i < ht->size; i++){
    //onlt get bucket if it exists in table
    if(ht->table[i] != NULL){
      //pointer to next bucket in row
      hr = ht->table[i];
      while(hr != NULL){
        //initalize pointer to next bucket
        next = hr->next;
        //deallocate word in row
        free(hr->word);
        //deallocate current row bucket 
        free(hr);
        hr = next;
      }
    }
  }

  //deallocate hash table
  free(ht->table);

  //deallocate structure for hash table
  free(ht);

}//end h_destroy

/* function: h_print
 * description: print the hash table from user specified start to user specifed end
 */
void h_print(hashTable ht, int start, int end){
  int i, j, bucket = 0, numBuckets = H_NUM_BUCKETS, size;
  h_row *hr;

  //ensure ending point is not greater than hash table size
  if(end > ht->size)
    end = ht->size;

  //ensure stat is greater than or equal to 0
  if(start < 0)
    start = 0;

  for(i=0; i<end; i++){
    //set pointer to current table index
    hr = ht->table[i];
    bucket = 0;

    while(hr != NULL){
      //print first bucket
      if(bucket == 0)
        printf(" %i: %s", hr->key, hr->word);
      //print each subsequent bucket
      else
        printf("\t %s", hr->word);

      //set pointer to next bucket
      hr = hr->next;
      //increment bucket count
      bucket++;
    }
    printf("\n");
  }
}//end h_print

/* function: myHash
 * description: my attempt at creating a hash function to 
 *              evenly disperse values in a hash table
 *
 * reference: Universal Hashing from Robert Sedgewick's "Algorithms in C - Third Edition"
 */
unsigned long myHash(unsigned char *s, int tSize){
  unsigned long hashval;

  int a = 16381, b = 32749;

  for(hashval=0; *s!='\0'; s++, a*=b % tSize-1)
    hashval = (hashval<<2) + *s * a;

  return hashval;
}//end myHash

/* function: goldenHash 
 * description: my attempt at creating a hash function to 
 *              evenly disperse values in a hash table
 *
 * reference: Universal Hashing from Robert Sedgewick's "Algorithms in C - Third Edition"
 */
unsigned long goldenRatioHash(unsigned char *s, int tSize){
  unsigned long hashval;

  unsigned long a = 32749;
  unsigned long gr = (unsigned long)GOLDEN_RATIO<<5; //truncate golden ratio

  for(hashval=0; *s!='\0'; s++, a*=gr % tSize-1)
    hashval = a*hashval + *s;

  return hashval;
}//end goldenRatioHash

//helper function to print arrays of strings
//prints strings from start to end 
void str_print(char **strArr, int start, int end){
  int i;
  for(i=start; i<end; i++){
    printf("i: %i \t %s\n", i, strArr[i]);
  }
}//end printStrArr

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
    else if(str[strIndex] == ' ' || str[strIndex] == '\n' || str[strIndex] == '\t' || 
        str[strIndex] == '.' || str[strIndex] == '!' || str[strIndex] == '*' || str[strIndex] == '#' || str[strIndex] == '@' || str[strIndex] == ',' || str[strIndex] == ':' || str[strIndex] == ';'){
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
  int j, listIndex;
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

/* function: displayResults
 * description: outputs the results from that hash implementation in this program
 */
void displayResults(hashTable *ht){
  int i;

  printf("\n"
      "Number of collisions for different table sizes are:\n");
  printf("Table Size\tLinear\tQuadratic\tChaining\n");
  printf("----------\t------\t---------\t--------\n");
  for(i=0; i<H_NUM; i++)
    printf("%i \t\t %i \t %i \t\t %i \n", ht[i]->size, ht[i]->c_lin, ht[i]->c_quad, ht[i]->c_chain);

  printf("\nThe best combination is: \n");

  displayBestCombination(ht);

  printf("\nHashing function used: My varient of universal hashing using the golden ratio\n");

}//end displayReults

/* function: freeWordList
 * description: frees a given list of words from memory
 */
void freeWordList(char **list, int size){
  int i;
  for(i=0; i<size; i++){
    free(list[i]);
  }
  free(list);
}//end freeWordList

/* function: displayBestCombination
 * description: outputs the best table size/probing method
 */
void displayBestCombination(hashTable *ht){

  int i, lin, quad, chain, cmin, tmin;
  char cstr[20];

  cmin = ht[0]->c_lin; //set default minimum combination to first table combination
  tmin = ht[0]->size; //set default minimum table combinations to first table

  for(i=0; i<H_NUM; i++){

    //store current hash table values
    lin = ht[i]->c_lin;
    quad = ht[i]->c_quad;
    chain = ht[i]->c_chain;

    //check that linear is lower
    if(lin < cmin){
      cmin = lin;
      tmin = ht[i]->size;
      strcpy(cstr, "Linear");
    }
    //check that quadratic is lower
    if(quad < cmin){
      cmin = quad;
      tmin = ht[i]->size;
      strcpy(cstr, "Quadratic");
    }
    //check that chaining is lower
    if(chain < cmin){
      cmin = chain;
      tmin = ht[i]->size;
      strcpy(cstr, "Chaining");
    }

  }
  printf("\tTable Size %i\n", tmin); 
  printf("\tCollision handling using: %s (%i collisions)\n", cstr, cmin);

}//end displayBestCombination

//as requred by Prof Reed
void displayMyInfo(){

  printf("\n\n");
  printf("+___________________________________________________+\n");
  printf("| Author: Bradley Golden                            |\n");
  printf("| Date: 4/12/2015, UIC CS251 Data Structures        |\n");
  printf("| Program: #4, Hashing                              |\n");
  printf("| System: Bert                                      |\n");
  printf("| Lab: Thursday 11am                                |\n");
  printf("+___________________________________________________+\n");
  printf("\n\n");

}//end displayMyInfo
