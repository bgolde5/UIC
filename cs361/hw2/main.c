/*
 * =====================================================================================
 *
 *       Filename:  main.c
 *
 *    Description:  Main file for a basic shell program
 *
 *        Version:  1.0
 *        Created:  09/10/2015 17:41:08
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Bradley Golden (BG), bgolde5@uic.edu, golden.bradley@gmail.com
 *   Organization:  University of Illinois at Chicago
 *
 * =====================================================================================
 */

#include "shell.c"

int main(int argc, char** argv){
  if(argc > 1 && (strcmp(argv[1], "-d") == 0 || strcmp(argv[1], "-debug") == 0)){ DEBUG = 1;
    printf("\n**Debug mode set**\n\n");
  }

  int num_args = 0; //number of argument user inputs
  char *input = NULL; // user input
  char ** str_arr = NULL; // arr of arguments parsed from user input
  int input_size = 0; // size of input pointer (char* in this case)
  int char_ptr_size = 0; // size of a char*
  int valid_cmd = 0; // track whether input is valid or not

  // listen for CTRL-C
  if (signal(SIGINT, ctrl_c_handler) == SIG_ERR)
    debug("Error");

  // listen for CTRL-Z
  if (signal(SIGTSTP, ctrl_z_handler) == SIG_ERR)
    debug("Error");

  startup_prompt();

  while(1){

    shell_display();

    input = get_input();

    // check that input was allocated properly
    input_size = (int)sizeof(input);
    char_ptr_size = (int)sizeof(char*);
    if(input_size != char_ptr_size)
      fprintf(stderr, "line_to_str_arr: Error, pointer not allocated properly as it should be");

    else { // input is a pointer to something so we can proceed

      if(DEBUG){
        debug("get_input: PASSED");
      }

      str_arr = line_to_str_arr(input);

      if((int)sizeof(str_arr) != (int)sizeof(char*))
        fprintf(stderr, "line_to_str_arr: Error, pointer not allocated properly as it should be");

      if(DEBUG){
        debug("line_to_str_arr: PASSED");
      }

      //
      // begin to process user commands
      //
      valid_cmd = process_user_commands(str_arr);

      if(!valid_cmd)
        invalid_cmd(input);

      //
      // end processing user commands
      //

      // this goes last in the while loop
      int num_elems = count_str_in_line(input);
      destroy_str_arr(str_arr, num_elems);

      if(DEBUG){
        debug("destroy_str_arr: PASSED");
      }
    }

    free(input);
  }

  return 0;
} // end main
