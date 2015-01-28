/*
 * =====================================================================================
 *
 *       Filename:  arr.h
 *
 *    Description:  Header file to CS211 Project 1
 *
 *        Created:  01/20/2015 09:09:27
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <stdlib.h>

#define sortType 1 //1: bubble 2: selection

/******************************************
 * Makes a copy of the values from one array 
 * to another array.
 ******************************************/
void arrayCopy(int *fromArray, int *toArray, int *size);

/******************************************
 * Sorts an array in ascending order. 
 *****************************************/
void sort(int arr[], int size);

/******************************************
 * Performs a linear search on an unsorted array. 
 * “Returns” two values. The first is the position 
 * in the array where the value was found or -1 if 
 * the value was not found. The second is the number 
 * of comparisons needed to determine if/where the 
 * value is located in the array.
 *****************************************/
int lsearch(int arr[], int size, int target, int* numComparisons);

/******************************************
 * Performs a binary search on the sorted array. 
 * The function “returns” two values. The first is 
 * the position in the array where the value was 
 * found or -1 if the value was not found. 
 * The second is the number of comparisons 
 * needed to determine if/where the value is 
 * located in the array.
 ******************************************/
int bisearch(int arr[], int size, int target, int* numComparisons);

/******************************************
 * Sort Functions
 ******************************************/
void selectionSort(int arr[], int size);
void bubbleSort(int arr[], int size);

/******************************************
 * Helper Functions
 ******************************************/

/*
 * Prints the contents of a given array
 */
void printArray(int arr[], int size);

/*
 * Finds the smallest number in a given array at a given starting index 
 */
int findSmallestNum(int arr[], int size, int start);

/*
 * Reads a text file specified by the userstd and stores the data 
 * into a pointer. The data is dynamically allocated. Extra space
 * is clean up as well!
 */
int *readFile(int *size);

