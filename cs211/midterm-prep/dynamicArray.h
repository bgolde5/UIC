/*
 * =====================================================================================
 *
 *       Filename:  dynamicArray.h
 *
 *    Description:  header files for dynamic array implementation
 *
 *        Version:  1.0
 *        Created:  03/01/2015 12:27:03
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FORMAT "%i"

typedef int elemtype;

/*
 * function: makeDynamicArr
 * description: dynamically allocates an array
 */
elemtype * makeDynamicArr(int *arrLength, int *totalAllocated, elemtype arr[], elemtype data);

/*
 * function: cleanArr
 * description: removes empty space after dynamically allocating array
 */
elemtype * cleanArr(int arrLength, int totalAllocated, elemtype arr[]);

/*
 * function: arrayCopy
 * description: copies the contents of one array to another
 */
void arrayCopy(elemtype toArr[], elemtype fromArr[], int len);

/*
 * function: printArray
 * description: prints the contents of an array
 */
void printArray(elemtype arr[], int len);

/*
 * function: destroyArr
 * description: frees a given arr
 */
void destoryArr(elemtype *arr);
