/*
 * =====================================================================================
 *
 *       Filename:  icecream.cpp
 *
 *    Description:  Solves the Ice-Cream Town problem we saw in lab. 
 *                  Program reads in values from a data file to represent 
 *                  the graph.  It will then find all dominating sets and display them.  
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <math.h>
#include <time.h>

typedef struct node {
  int vertex;
  node *pNext;
} Node;

typedef struct sets {
  sets *sNext;
  int setVal;
  node *pNext;
} SetList;

typedef struct {
  int numVerticies;
  Node **adjList;
} Graph;

/* Graph Functions */
void findSmallestDominatingSets(Graph*, int*);
void destroyGraph(Graph*);
void printAdjacencyList(Graph*);
void insertVertex(Graph*, Node*, int);
Node *createVertex(int);
Graph *createGraph(int);
void destroyGraph(Graph*);

/* General Functions */
void combinations (Graph*, int*, int*, int, int, int, int) ;
void resetArr(int*, int);
int getNumVerticies(char*);
void displayMyInfo(); //display required program info, i.e. name, date, etc.
void readFileIntoAdjacencyList(char*, Graph*);
void markCurrentAsVisited(int*, int i, int);
void markNeighborsAsVisited(Node*, int*, int N);
void printArr(int*, int N);
int isDominatingSet(int*, int N);
void pickRandomNumbers(int*, int, int);
void chooseRandomNodes(int*, int, int);
void randomCombinations(Graph*, int, int, int);

int debugMode = 0; //used to set debug mode for the client
int dominatingSetVal = 0; //used as a flag when dominating sets are found

/********************************************
  Main                                    
 *******************************************/
int main(int argc, char** argv){

  int i;
  srand(time(NULL));

  //check if client set debug mode
  if(argc == 2 && strcmp(argv[1], "-d") == 0){
    debugMode = 1;
    printf("\n**Debug Mode Set**\n");
  }

  displayMyInfo();

  printf("Enter the name of the data file to use for the graph: ");
  char file[50];
  scanf(" %s", file);

  if(debugMode) printf("You inputted %s\n", file); //debug

  //get the number of verticies in the graph
  int N = getNumVerticies(file);

  if(debugMode) printf("Number of Verticies: %i\n", N); //debug

  //create a blank graph given N verticies
  Graph *graph = createGraph(N);

  //read file contnents in adjacency list
  readFileIntoAdjacencyList(file, graph);

  if(debugMode) printAdjacencyList(graph); //debug

  //create visited array to track which verticies have been visited
  int visited[N];  
  resetArr(visited, N);

  //used for the combinations function
  int set[N];
  //build set with values from 1...N
  for(i=0; i<N; i++) set[i] = i+1;

  //choose stable algorithm for files with less than 50 verticies
  if(N < 50){
    printf("Smallest Dominating Sets Are: \n");
    for(i=0; i<N; i++)
      if(dominatingSetVal == 0){
        combinations(graph, visited, set, 1, N, 1, i);
      }
  }
  //choose unstable algorithm for files with greater than 50 verticies
  else{
    for(i=N; i>0; i--){
      randomCombinations(graph, i, 0, N);
    }
  }

  destroyGraph(graph);
  free(graph);
}//end main

/********************************************
  Graph Functions                                    
 *******************************************/
void destroyGraph(Graph *graph){

  int i = 0;
  int N = graph->numVerticies;
  Node *ptr, *tmp;

  for(i=0; i<N; i++){
    ptr = graph->adjList[i]; //set ptr to adjacency list at index i
    while(ptr != NULL){ //if adjacency list at index i exists, free all verticies at index i
      tmp = ptr->pNext; 
      free(ptr);  
      ptr = tmp;
    }
  }

}//end destroyGraph
void printAdjacencyList(Graph *g){
  Node *ptr;
  int i;
  int N = g->numVerticies; //get number of verticies in graph
  for(i=0; i<N; i++){
    ptr = g->adjList[i]; //set ptr to adjecency list at index i
    //if there exists verticies at index i, print those verticies
    if(g->adjList[i] != NULL){      
      printf("%i", i+1);
      while(ptr != NULL){
        printf("->%i", ptr->vertex);
        ptr = ptr->pNext;
      }
      printf("\n"); //printing a list at listIndex i complete
    }
  }
}//end printAdjacencyList

void insertVertex(Graph *g, Node *v, int listIndex){

  v->pNext = g->adjList[listIndex]; //set pointer of pNext to same pointer of adjacency list at index v
  g->adjList[listIndex] = v; //point adjecency list to current vertex v 

}//end insertVertex

Node *createVertex(int vertexVal){

  Node *newVertex = (Node*)malloc(sizeof(Node)); //allocate space for a new vertex to be placed on the graph
  newVertex->vertex = vertexVal; //set the new vertex value
  newVertex->pNext = NULL; //temporarily set pointer to next vertex to NULL

  return newVertex;

}//end createVertex

Graph *createGraph(int N){

  int v; //vertex index
  Graph *graph = (Graph*)malloc(sizeof(Graph)); //allocate initial graph
  graph->numVerticies = N; //store number of verticies into the graph
  graph->adjList = (Node**)malloc(sizeof(Node*)*N); //allocate space for adjacency list
  for(v=0; v<N; v++){
    graph->adjList[v] = NULL; //initialize adjacency list
  }

  return graph;

}//end createGraph

/********************************************
  General Functions                                    
 *******************************************/

/* function: factorial
 * description: calculates the factorial value of a given integer
 */
int factorial(int n) {
  if (n == 0)
    return 1;
  else
    return(n * factorial(n-1));
}

/* function: randomCombinations
 * description: finds dominating sets by picking verticies witha graph at random until a stopping point
 * input: *g - adjanceny matrix pointer, k - number of random verticies to pick, 
 * stop - number of verticies to stop at, n - number of total verticies 
 */
void randomCombinations(Graph *g, int k, int stop, int n){
  int j, currNode;
  Node *ptr;
  int nodes[n];
  int visited[n];
  resetArr(visited, n);

  //long long totalCombinations = factorial(n)/(factorial(k)*factorial(n-k));
  //long long step;

  //continue loop until k verticies hits the stopping point
  while(k >= stop){
    resetArr(nodes, n);
    chooseRandomNodes(nodes, k, n); //choose nodes at random to check for dominating sets
    for(j=0; j<n; j++){
      visited[j] = nodes[j];
    }
    for(j=0; j<n; j++){
      if(nodes[j] == 1){
        ptr = g->adjList[j];
        markNeighborsAsVisited(ptr, visited, n); //mark all neighboring nodes as visited
      }
    }

    //check if a dominating set has been found
    if(isDominatingSet(visited, n)){
      //print the dominating sets
      printf("Dominating Set Found with %i Nodes\n", k);
      for(j=0; j<n; j++){
        if(nodes[j] == 1)
          printf("%i ", j+1); //print the nodes within the dominating set
      }
      printf("\n");
    }
    k--;
  }
}//end randomCombinations

//wrapper for pickRandomNumbers
//used for readability
void chooseRandomNodes(int *arr, int k, int n){
  return pickRandomNumbers(arr, k, n);
}//end chooseRandomNodes

/* function: pickRandomNumbers
 * description: picks k distinct random numbers from 1 to n and returns them in an array of size N 
 *              populated with 1's in the idicies where the numbers were chosen and 0 otherwise
 *             *each random number chosen is of value x-1 due to array index starting at 0 
 *
 * source: http://stackoverflow.com/questions/20734774/random-array-generation-with-no-duplicates
 */
void pickRandomNumbers(int *arr, int k, int n){
  int i, tmp, randNum;

  resetArr(arr, n);
  //generates first k array indicies with 1's
  for(i=0; i<n; i++){
    if(k > i)
      arr[i] = 1;
    else
      arr[i] = 0;
  }

  //shuffles the array
  for(i=0; i<n-1; i++){
    randNum = i + rand() / (RAND_MAX / (n - i) + 1);
    tmp = arr[randNum];
    arr[randNum] = arr[i];
    arr[i] = tmp;
  } 
}

//PULLED FROM PROFESSOR REED'S PROGRAM 3 PAGE
//ORIGINAL SOURCE: http://www.cs.utexas.edu/users/djimenez/utsa/cs3343/lecture25.html
/* function: combinations 
 * description: finds all possible combinations under specified parameters
 *              *g - adjacency list, *visited - array with visited nodes, v[] - combinations array,
 *              start - first val to start with in combinations, n - number of integers,
 *              maxk - number of integers in combination*/
void combinations (Graph *g, int *visited, int v[], int start, int n, int k, int maxk) {
  int     i;
  Node *ptr;
  resetArr(visited, n);

  /*  k here counts through positions in the maxk-element v.
   * if k > maxk, then the v is complete and we can use it.
   */
  if (k > maxk) {
    for (i=1; i<=maxk; i++){ 
      ptr = g->adjList[v[i]-1]; //point ptr to adjecency list of current combination value
      markCurrentAsVisited(visited, v[i]-1, n); //mark current node as visited in visited array
      markNeighborsAsVisited(ptr, visited, n); //mark all neighbors as visited in visited array

      if(isDominatingSet(visited, n)){ //if dominating set set domating set flag
        dominatingSetVal = maxk;
        for(i=1; i<=maxk; i++) printf("%i ", v[i]); //print dominating set
        printf("\n");
      }
    }
    return;
  }

  /*  for this k'th element of the v, try all start..n
   * elements in that position
   */
  for (i=start; i<=n; i++) {
    v[k] = i;


    /*  recursively generate combinations of integers
     * from i+1..n
     */
    combinations (g, visited, v, i+1, n, k+1, maxk);
  }
}

/* function: isDominatingSet
 * description: if array contains all 1's, a dominating set is found, return 1, else return 0
 */
int isDominatingSet(int arr[], int N){
  int i;
  int counter = 0;
  for(i=0; i<N; i++){
    if(arr[i] > 0){
      counter++;
    }
  }
  if(counter >= N){
    return 1;
  }
  else return 0;
}

/* function: printArr
 * description: prints an array of size n 
 */
void printArr(int arr[], int N){
  int i;
  for(i=0; i<N; i++){
    printf("arr[%i]: %i\n", i+1, arr[i]);
  }
}

/* function: resetArr
 * description: changes all values in array to 0
 */
void resetArr(int arr[], int N){
  int i;
  for(i=0; i<N; i++){
    arr[i] = 0;
  }
}

/* function: markNeighborsAsVisited
 * description: sets all nodes touching the current node to a value of 1 in
 *              visited array
 */
void markNeighborsAsVisited(Node *ptr, int visited[], int N){
  while(ptr != NULL){
    visited[(ptr->vertex)-1] = 1;
    ptr = ptr->pNext;
  }
}

/* function: markCurrentAsVisited
 * description: sets ith position in array to 1
 *              used to track a node as visited 
 */
void markCurrentAsVisited(int visited[], int i, int N){
  visited[i] = 1;
}

/*  */
int getNumVerticies(char *filename){

  FILE *inFile = fopen(filename, "r");

  int numCities = 0;
  char ch;
  int value = 0;
  if(inFile == 0){ //check that the file exists
    printf("Error: Could not open %s\n", filename);
    exit(-1);
  }
  else { //file open successful
    fscanf(inFile, " %i", &numCities);
  }
  fclose(inFile);

  return numCities;
}//end getNumCities


/* function: readFileIntoAdjacencyList
 * description: opens the specified file and reads all data into an 
 *              adjacency list data structure
 */
void readFileIntoAdjacencyList(char *filename, Graph *graph){

  FILE *inFile = fopen(filename, "r");
  Node *vPtr; //will point to a vertex 
  Node *newVertex;

  int value, numberOfLines, j, firstValInRow;
  char inputLine[81];

  if(inFile == 0){ //check that the file exists
    printf("Error: Could not open %s\n", filename);
    exit(-1);
  }

  fscanf(inFile, " %i", &numberOfLines); //get the first value in text file 

  // loop through the input lines, reading a whole line at a time.
  for( int i=0; i<=numberOfLines; i++) {
    fgets( inputLine, 81, inFile);

    // Parse the individual items on the input line.
    // strtok replaces the next space with a NULL
    // and returns the address of the current item
    //printf("Individual values are: ");
    char *pWord = strtok( inputLine, " ");
    j = 0; //tracks the index of the token within the string
    while( pWord != NULL) {
      int value = atoi( pWord);     // Convert string to integer
      if(j==0) //j=0 when the token is the first in the line
        firstValInRow = value;
      if(j>0){ //insert vertex into list if not the first value in the row
        newVertex = createVertex(value);
        insertVertex(graph, newVertex, firstValInRow-1);
      }
      pWord = strtok( NULL, " ");   // Get next token.  Note the NULL parameter here!
      j++;
    }
  }

  fclose(inFile);

}//end readFileIntoAdjacencyList

void displayMyInfo(){

  printf("\n\n");
  printf("+___________________________________________________+\n");
  printf("| Author: Bradley Golden                            |\n");
  printf("| Date: 3/20/2015, UIC CS251 Data Structures        |\n");
  printf("| Program: #3, Ice Cream                            |\n");
  printf("| System: Bert                                      |\n");
  printf("| Lab: Thursday 11am                                |\n");
  printf("+___________________________________________________+\n");
  printf("\n\n");

}//end displayMyInfo
