j/*
 * =====================================================================================
 *
 *       Filename:  bgolde5.cpp
 *
 *    Description:  Determines if two files are similar or not by comparing text.
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

//reference: http://cslibrary.stanford.edu/110/BinaryTrees.html
//           https://tkramesh.wordpress.com/2011/02/15/binary-search-trees-in-c-2-occurrences-function/
//           http://stackoverflow.com/questions/5248915/execution-time-of-c-program

#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <ctype.h>
#include <time.h>

#define DEBUG 0 //sets debug mode

/* struct for the created of a binary tree that stores words up to length 20 */
 typedef struct node {
  char *word;
  struct node *left;
  struct node *right;
} Node;

/* struct that holds the filename and a pointer to a binary tree of words within that file */
typedef struct lst {
  char filename[101]; //assuming file name is no more than 100 characters
  char *fileContents; //stores file contents into array
  int numChars; //holds the number of chars with fileContents
  struct node *tree; //pointer to all possible combiniations of words
  struct lst *next; //pointer to the next file
} linkedList;

/* struct that holds all comparisons between two files */
typedef struct fileList {
  char currFile[101]; //assuing file name is no more than 100 characters
  char nextFile[101];
  int numMatches;
  struct fileList *next;
} fileList;

//fn prototypes
void printHeader();
void getUsrInput(char *directory, int *len, int *pairs);
int countDirectory(char *directory);
void copyDirectory(char *directory, char **files, int totalFiles);
void copyDirectoryToList(linkedList *head, char **arr, int num);
void insertNodeWithFilename(linkedList *head, char *filename);
char *copyFileContents(char *directory, char *file, int totalChars, int strLen);
int fileLength(char *directory, char *file);
char *pushToArr(char letter, int *size, int *spaceAllocated, char *arr);
char *tempStoreFileContents(char letter, int *size);
Node *newNode(char *word);
Node *insert(Node *node, char *word);
void pushToFileList(char *arr, int num, linkedList *l, char *filename, int strLen);
void printList(linkedList *l);
Node *sortIntoTree(char *arr, int numChar, int strLen);
void printTree(Node *node);
void compareAllFiles(linkedList *head, fileList *fHead);
int traverseCurrTree(Node *curr, Node *next);
int numOccurences(Node* node, char *target); 
void printFileArr(char **arr, int num);
void insertFileIfFound(fileList *head, char *currFile, char *nextFile, int numMatches);
void printFileList(fileList *fHead, int n);
void deallocateTree(Node *tree);
void deallocateFileList(fileList *head);
void deallocateLinkedList(linkedList *head);

int main(int argc, char** argv){
  //begin clock to count file run time
  clock_t begin, end;
  double time_spent;
  begin = clock();

  char directoryName[101];//limit directory name size to 100 characters
  int strLen, numPairs; //used to read string length and number of pairs to display
  int numFiles; //holds the number of files in the specified directory
  int i;
  int fileLen;
  
  //initialize dummy node for list of files compared with each other
  fileList *fDummy = (fileList*)malloc(sizeof(fileList));
  linkedList *lDummy = (linkedList*)malloc(sizeof(linkedList));
  fDummy->numMatches = -1;
  strcpy(fDummy->currFile, "dummy");
  strcpy(fDummy->nextFile, "dummy");
  fDummy->next = NULL;

  //fileList *allFiles;

  printHeader(); //prints the required header
  getUsrInput(directoryName, &strLen, &numPairs); //gets the directory name, string length to compare, and number of pairs to display

  if(DEBUG)
    printf("directoryName: %s, strLen: %i, numPairs: %i\n", directoryName, strLen, numPairs);

  //get total files from directory
  numFiles = countDirectory(directoryName);
  printf("There are %i files in directory \"%s\"\n", numFiles, directoryName);

  //copy all filenames in to array of strings
  char **fileArr = (char**)malloc(numFiles*(sizeof(char*)));
  copyDirectory(directoryName, fileArr, numFiles);

  //create and copy linked list of same size as the number of files in the directory
  copyDirectoryToList(lDummy, fileArr, numFiles);
  //printList(lDummy);

  //copy fileContents into linked list
  printf("Copying file contents to memory...\n");
  linkedList *curr = lDummy->next;
  while(curr != NULL){
    curr->numChars = fileLength(directoryName, curr->filename);
    curr->fileContents = copyFileContents(directoryName, curr->filename, curr->numChars, strLen);
    curr = curr->next;
  }

  curr = lDummy->next;; //reset curr to front of list
  
  //copy all fileContents into binary tree within each node of the linked list
  while(curr != NULL){
    curr->tree = sortIntoTree(curr->fileContents, curr->numChars, strLen);
    curr = curr->next;
  }

  curr = lDummy->next; //reset curr to front of list 

  printf("Comparing all files...\n");
  compareAllFiles(lDummy, fDummy);
  printf("\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
  printf("\tMatches Found\n");
  printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
  printFileList(fDummy, numPairs);

  //free all lists
  printf("\nFreeing all memory...\n");
  deallocateTree(lDummy->tree);
  deallocateFileList(fDummy);
  deallocateLinkedList(lDummy);

  //end clock to stop file run time
  end = clock();
  time_spent = (double)(end - begin) / CLOCKS_PER_SEC;

  printf("\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
  printf("Program took %f seconds\n", time_spent);
  printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");

  return 0;
}//end main

/*
 * function: deallocateLinkedList
 * description: deallocates all nodes that hold file contents, file names, link to file tree, number of character in that file 
 */
void deallocateLinkedList(linkedList *head){
  linkedList *lPtr = head;
  while(head != NULL){
    lPtr = head->next;
    free(head);
    head = lPtr; 
  }
  free(head);
}//end dellocateFileList


/*
 * function: deallocateFileList
 * description: deallocates all nodes that hold file comparison data
 */
void deallocateFileList(fileList *head){
  fileList *fPtr = head;
  while(head != NULL){
    fPtr = head->next;
    free(head);
    head = fPtr; 
  }
  free(head);
}//end dellocateFileList

/*
 * function: deallocateTree
 * description: deallocates all nodes in the binary tree
 */
void deallocateTree(Node *tree){
  if(tree == NULL)
   return;
  else {
    deallocateTree(tree->left);
    deallocateTree(tree->right);
  } 
  free(tree);
}//end deallocateTree

/*
 * function: printFileList
 * description: prints n file compared in descending order (most matches found to least matches found)
 */
void printFileList(fileList *fHead, int n){
  fileList *fTemp = fHead->next; //advance past dummy node
  while(fTemp != NULL && n > 0){
    printf("%i between %s and %s\n", fTemp->numMatches, fTemp->currFile, fTemp->nextFile); 
    fTemp = fTemp->next;
    n--;
  }
}

/* 
 * function: printList 
 * description: prints the current list of filenames
 */
 void printList(linkedList *l){
  while(l != NULL){
    printf("%s\n", l->filename);
    if(l->tree != NULL)
      printTree(l->tree);
    l = l->next;
  }
}//end printList

/*
 * function: printTree
 * description: prints a binary tree of char*
 */
 void printTree(Node *node){
  if(node == NULL)
    return;
  else{
    printTree(node->left);
    printf("%s\n", node->word);
    printTree(node->right);
  }
}//end printTree

/* 
 * function: printFileArray
 * description: prints an array of pointers of size num
 */
 void printFileArr(char **arr, int num){
  int i;
  i=0;
  while(i<num){
    printf("%i: arr: %s\n", i, arr[i]);
    i++;
  }
 } //end printFileArr

/* function: copyDirectoryToList
 * description: copies a given array of strings to a linked list
 */
void copyDirectoryToList(linkedList *head, char **arr, int num){
  int i = 0;

  while(i < num){ //only add strings if they exist
    insertNodeWithFilename(head, arr[i]);
    i++;
  }
}//end copyDirectoryToList

/*
 * function: insertNode
 * description: inserts a node at the last position of the linked list with the filename populated
 */
void insertNodeWithFilename(linkedList *head, char *filename){

  linkedList *lTemp = head;

  if(strlen(filename) == 0) //at end of filename list or list is empty
    return;

  linkedList *newNode = (linkedList*)malloc(sizeof(linkedList));

  if(newNode == NULL) {
    printf("Error, cannot allocate memory for newNode.\n");
    exit(-1);
  }

  strcpy(newNode->filename, filename);
  newNode->next = NULL;
  newNode->tree = NULL;

  //
  while(lTemp->next != NULL && strcmp(filename, lTemp->next->filename) > 0){
    lTemp = lTemp->next;
  }
  newNode->next = lTemp->next;
  lTemp->next = newNode;

}//end insertNode

/*
 * function: compareAllFiles
 * description: compares all strings accross all files and counts the matching strings
 */
void compareAllFiles(linkedList *head, fileList *fHead){
  fileList *fhead = NULL; //initialized to NULL until matching strings are found
  linkedList *currList = head;
  linkedList *nextList = head;
  int numFound = 0;

  if(currList == NULL){
    printf("Error: linkedList is empty, there is nothing to compare\n");
    exit(-1);
  }

  //traverse all files, starting with the first file, comparing with the next file
  while(currList != NULL){ 
    //this loop checks the current file with all other files
    while(nextList->next != NULL){ //check that there are at least two files to compare
      nextList = nextList->next;
      numFound = traverseCurrTree(currList->tree, nextList->tree);
      if(numFound > 0){ //only add file comparisons to the file list if they have a match
        insertFileIfFound(fHead, currList->filename, nextList->filename, numFound);
      }
      numFound = 0;
    }
    currList = currList->next; //increment l to the next file
    nextList = currList; //reset temp to location of l
  }
}//end compareAllFiles

/*
 * function: insertFileIfFound
 * description: inserts a file node with the two files compared, along with the total matches between
 *              those two files in descending order to a linked list
 */
void insertFileIfFound(fileList *fHead, char *currFile, char *nextFile, int numMatches){

  fileList *fTemp = fHead;

  //create new file node
  fileList *newFile = (fileList*)malloc(sizeof(fileList));

  if(newFile == NULL){
    printf("Error: could not allocate space for a new matching file.\n");
    exit(-1);
  }

  //initialie new file node
  strcpy(newFile->currFile, currFile);
  strcpy(newFile->nextFile, nextFile);
  newFile->numMatches =  numMatches;
  newFile->next = NULL;


  //insert in descending order
  while(fTemp->next != NULL && numMatches < fTemp->next->numMatches ){
    fTemp = fTemp->next;
  }
  newFile->next = fTemp->next;
  fTemp->next = newFile;

}//end insertFileIfFound

/*  
 * function: numOccurences
 * description: Given a binary tree, return true if a node 
 * with the target data is found in the tree. Recurs 
 * down the tree, chooses the left or right 
 * branch by comparing the target to each node. 
 */ 
int numOccurences(Node* node, char *target) { 
  if (node == NULL) { 
    return 0; 
  } 
  if (strcmp(target, node->word) == 0)
    return (1 + numOccurences(node->right, target) + numOccurences(node->left, target)); 
  else if (strcmp(target, node->word) < 0) 
    return (numOccurences(node->left, target));
  else 
    return(numOccurences(node->right, target)); 
}//end numOccurences 

/*
 * function: compareCurrTree 
 * description: compares all strings in the current file with the remaining files
 */
//static int count = 0;
int traverseCurrTree(Node *currTree, Node *nextTree){

  int leftFreq, count, rightFreq;

  //base case
  if(currTree == NULL)
    return 0; //current linked list is empty

  else { //grab strings from the tree in the first file
    leftFreq = traverseCurrTree(currTree->left, nextTree);
    count =  numOccurences(nextTree, currTree->word);
    //if(count > 0)
    //printf("%i: %s\n", count, curr->word);
    rightFreq = traverseCurrTree(currTree->right, nextTree);
  }

  //add all three frequencies

  return (leftFreq + count + rightFreq);
}//end traverseCurrTree 

/*
 * function: insert
 * description: inserts a node within a binary tree
 */
  Node *insert(Node *node, char *word){
    if(node == NULL)
      return newNode(word);
    else {
      if(strcmp(word, node->word) <= 0) 
        node->left = insert(node->left, word);
      else
        node->right = insert(node->right, word);
      return node;
    }
  }//end insert

/*
 * funtion newNode
 * description: creates a new node with a given word
 */
Node *newNode(char *word){
  Node *node = (Node*)malloc(sizeof(Node));
  node->word = (char*)malloc(sizeof(char)*strlen(word));
  strcpy(node->word, word);
  node->left = NULL; //initialize left child to null
  node->right = NULL; //initialize right child to null
  return node;
}//end newNode

/*
 * function: tempStoreFileContents
 * description: stores the given contents into a dynamically created array
 */
char *tempStoreFileContents(char letter, int *size){

  int spaceAllocated = 1;
  char *wordArr = (char*)malloc((*size+1)*sizeof(char));
  wordArr = pushToArr(letter, size, &spaceAllocated, wordArr); 
  return wordArr;

}//end tempStoreFileContents

/*
 * function: pushToArr 
 * description: pushes chars to an array dynamically
 */
char *pushToArr(char letter, int *size, int *spaceAllocated, char *arr){
  int i;
  int n = *size;
  int memory = *spaceAllocated;
  //dynamically allocate space for new letters
  if(n == memory){
    char *temp = (char*)malloc((memory+1000)*sizeof(char));
    for(i=0; i<n; i++){
      temp[i] = arr[i]; //copy contents to newly allocated space 
    }
    free(arr);
    temp = arr;
    memory+=1000; //add 1000 more chars to memory space
  }
  n++;
  arr[n] = letter; //add letter to array
  *size = n;
  *spaceAllocated = memory;

  return arr;
}//end pushToArr

/*
 * function: readFile
 * descripton: reads the given file TODO -- update how it reads
 */
char *copyFileContents(char *directory, char *file, int totalChars, int strLen){

  char *contents = (char*)malloc(sizeof(char)*totalChars); //stores the contents of the file read in
  int i=0;
  char delimeter[2] = "/"; //used as a delimter between the filename and directory name
  char fileWithDirectory[150]; //contains both the filename and directory name

  sprintf(fileWithDirectory, "%s/%s", directory, file); //create directory name
  if(DEBUG)
    printf("Full File: %s\n", fileWithDirectory);

  FILE *inFile = fopen(fileWithDirectory, "r");

  if(inFile == 0){
    printf("Could not open %s\n", fileWithDirectory);
  }
  else { //read one character at a time
    int ch;
    while((ch = fgetc(inFile)) != EOF){ 
      if(isalpha(ch) || isdigit(ch)){ //check that char read in is a letter or digit
        ch = tolower(ch); //lowercase the letter
        contents[i] = ch;
        //printf("%c", ch);
        i++;
      }
    }
    //printf("\n");
  }
  strcpy(fileWithDirectory, ""); //reset fileWithDirectory for next readFile call
  fclose(inFile);

  return contents;
}//end readFile

/*
 * function: fileLength
 * descripton: determines the number of chars in the file contents
 */
int fileLength(char *directory, char *file){

  int numChars = 0; //used to count total chars in a given file
  char delimeter[2] = "/"; //used as a delimter between the filename and directory name
  char fileWithDirectory[150]; //contains both the filename and directory name
  int ch; //holds each character in the file

  sprintf(fileWithDirectory, "%s/%s", directory, file); //create directory name

  FILE *inFile = fopen(fileWithDirectory, "r");

  if(inFile == 0){
    printf("Could not open %s\n", fileWithDirectory);
  }
  else { //read one character at a time
    while((ch = fgetc(inFile)) != EOF){ 
      if(isalpha(ch) || isdigit(ch)){ //check that char read in is a letter or digit
        numChars++;
      }
    }
    ch = 0;
    fclose(inFile);
  }
  return numChars;

}//end fileLength

/*
 * function: pushToFileList
 * description: pushes a file node to the list and populates that node with:
 *              the filename, a binary tree of all possible strings, 
 */
void pushToFileList(char *arr, int num, linkedList *l, char *filename, int strLen){
  if(l == NULL){
    linkedList *newNode = (linkedList*)malloc(sizeof(linkedList));
    newNode->next = NULL;
    strcpy(newNode->filename, filename);
    newNode->tree = sortIntoTree(arr, num, strLen);
    return;
  }
  while(l->next != NULL){ //traverse through list until l points to end of list
    l = l->next;
  }
  //now l is pointing at end of list
  linkedList *newNode = (linkedList*)malloc(sizeof(linkedList));
  l->next = newNode;
  newNode->next = NULL;
  strcpy(newNode->filename, filename);
  newNode->tree = sortIntoTree(arr, num, strLen); //newNode points to binary tree of all possible strings 
}//end pushToFileList

/*
 * function: sortIntoTree
 * description: creates a binary tree of all strings
 */
Node *sortIntoTree(char *arr, int numChar, int strLen){
  int i=0, j=0, iteration=0;
  Node *currNode = NULL;
  char *tempStr = (char*)malloc(sizeof(char)*strLen);

  for(i=0; i<numChar; i++){
    for(j=0; j<strLen && i<numChar; j++){
      tempStr[j] = arr[i]; //get temporary string for storing
      i++; //incrememnt counter
    }
    currNode = insert(currNode, tempStr);

    //check that i isn't at end of file
    if(i < numChar)
      i-=strLen; //decrement counter if haven't reached end of file 
  }
  free(tempStr);

  return currNode;
}

void copyDirectory(char *directory, char **files, int totalFiles){

  int i=0;
  DIR *theDirectory; //pointer used to read the directory
  struct dirent *aFile; //struct for directory reading

  //read directories from a user specified path
  theDirectory = opendir(directory);  // customize this to change relative directory
  if (theDirectory == NULL)
    printf("Couldn't open %s\n", directory);
  else {
    while ((aFile = readdir( theDirectory)) != NULL)
    {
      if(aFile->d_name[0] != '.'){ //ignore hidden files
        files[i] = (char*)malloc(sizeof(char)*strlen(aFile->d_name));
        strcpy(files[i], aFile->d_name);
        if(DEBUG)
          printf("files[%i]: %s\n", i, aFile->d_name);
        i++;
      }
    }
    closedir(theDirectory);
  }
}//end readDirectory

/*
 * function: readDirectory
 * description: reads a given directory TODO -- possibly modify later on
 */
int countDirectory(char *directory){

  int count = 0; //used to count the number of files in the directory

  DIR *theDirectory; //pointer used to read the directory
  struct dirent *aFile; //struct for directory reading

  //read directories from a user specified path
  printf("Opening directory \"%s\"...\n", directory);
  theDirectory = opendir(directory);  // customize this to change relative directory
  if (theDirectory == NULL)
    printf("Couldn't open %s\n", directory);
  else {
    while ((aFile = readdir( theDirectory)) != NULL)
    {
      if(aFile->d_name[0] != '.'){ //ignore hidden files
        count++;
      }
    }
    closedir(theDirectory);
  }
  return count;
}//end readDirectory

/*
 * function: getUsrInput
 * description: gets the directory name, string length, number of pairs to display 
 */
void getUsrInput(char *directory, int *len, int *pairs){
  printf("Enter a directory, string length, and number of pairs to display (e.g. datafiles 15 10): ");
  scanf(" %s %i %i", directory, len, pairs);
}//end getUsrInput

/*
 * function: printHeader
 * description: prints the required header per instructor request
 */
void printHeader(){
  printf("\nAuthor: Bradley Golden\n");
  printf("Date: 2/19/15, UIC CS251 Data Structures Program #2: Like What\n");
  printf("System: VIM on 2.4 GHz Intel Core i5, 8GB RAM && BERT\n");
  printf("Lab: Thurs 11am\n");
  printf("Running with medium data set with string of length 20 takes 7.5 seconds\n\n");
}//end printHeader
