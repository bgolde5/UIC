/*
 * =====================================================================================
 *
 *       Filename:  test.cpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  02/14/2015 11:05:17
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

/*
 * This program displays the names of all files in the current directory.
 * Modified from: 
 *    faq.cprogramming.com/cgi-bin/smartfaq.cgi?answer=1046380353&id=1044780608
 */
#include <dirent.h>
#include <stdio.h>

int main()
{
  DIR *theDirectory;
  struct dirent *aFile;
  theDirectory = opendir(".");  // customize this to change relative directory
  if (theDirectory != NULL)
  {
    while ((aFile = readdir( theDirectory)) != NULL)
    {
      printf("%s\n", aFile->d_name);  // This is the file name
    }

    closedir( theDirectory);
  }

  return(0);
}//end main
