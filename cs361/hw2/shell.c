/*
 * =====================================================================================
 *
 *       Filename:  shell.c
 *
 *    Description:  Basic Shell Implementation
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

#include "shell.h"

// helper function to display the shell line
void shell_display(){
  printf("cs261-shell$ ");
} // end shell_display

char** line_to_str_arr(char* line){

  int num_str; // num of strings within a line
  char **str_arr; // array of string derived from line
  char *str; // a single string
  const char *delimiters = " \n"; // select which delimiters to use for parsing the line

  num_str = count_str_in_line(line); // count the number of strings within a line

  str_arr = (char**)malloc(sizeof(char*)*(num_str+1));

  if((int)sizeof(str_arr) != (int)sizeof(char*))
    return NULL;

  int i;
  str = strtok(line, delimiters);
  for(i=0; str!=NULL; i++){
    str_arr[i] = (char*)malloc(sizeof(char)*strlen(str));
    strcpy(str_arr[i], str);
    str = strtok(NULL, delimiters);
  }
  str_arr[i] = NULL; //set the last index to NULL as an end point

  return str_arr;
}

/*
 * function: destroy_str_arr
 *
 * frees all memory used by an array of strings
 */
void destroy_str_arr(char** str_arr, int num_elems){

  int i, j;
  //free all characters
  for(i=0; i<num_elems; i++){
    free(str_arr[i]);
    str_arr[i] = NULL;
  }

  //free remaining pointer to array of strings
  free(str_arr);
} // end destrow_str_arr

/*
 * function: malloc_str_arr
 * returns: a pointer to an array of strings
 */
char ** malloc_str_arr(int num_elem){

  char **str_arr = (char**)malloc(sizeof(char*)*num_elem);

  if (str_arr == NULL){
    fprintf(stderr, "malloc_str_arr: Error, could not allocate memory to str_arr");
  }

  int i;
  for(i=0; i<num_elem; i++){

    str_arr[i] = (char*)malloc(sizeof(char)*STR_SIZE);

    if (str_arr[i] == NULL){
      fprintf(stderr, "malloc_str_arr: Error, could not allocate memory to str_arr[%i]", i);
    }
  }

  return str_arr;
} // end malloc_str_arr

/*
 * function: count_str_in_line
 * returns: the number of strings within a line
 *
 * note: Uses ' ' or '\n' as a delimeter
 */
int count_str_in_line(char* line){

  int str_count = 0;
  char* tmp_line = (char*)malloc(sizeof(char)*strlen(line));
  char* str = NULL;

  strcpy(tmp_line, line); //temporarily copy str to not modify it

  str = strtok(tmp_line, " \n");
  while(str !=NULL){
    str = strtok(NULL, " ");
    str_count++;
  }

  free(tmp_line);
  return str_count;
} // end num_args

/*
 * function: read_input
 * returns: user's input as a string
 */
char * get_input(){

  char* input = (char*)malloc(LINE_SIZE*sizeof(char)); //allocate 100 chars for input

  if (input == NULL){
    fprintf(stderr, "read_input: Error allocating memory to input");
  }

  fgets (input, LINE_SIZE, stdin);

  return input;
} // end get_input

// helper function for testing arrays of strings
void print_str_arr(char** str_arr){

  char* curr_str = str_arr[0];
  int i = 0;
  while(curr_str != NULL){
    printf("str %i: %s\n", i, curr_str);
    i++;
    curr_str = str_arr[i];
  }
} // end print_str_arr

// helper function for counts number of strings in a string array
// this assume the last string is set to null
int count_str_arr(char** str_arr){
  char* curr_str = str_arr[0];
  int i = 0;
  for(i=0; str_arr[i] != NULL; i++){

  }
  return i;
} // end count_str_arr

/*
 * function: is_program
 * description: checks if the first arugument contains ./ for running a command
 * return: 1 on success, 0 otherwise
 */
int is_program(char* str){

  if(str[0] == '.' && str[1] == '/'){
    return 1;
  }

  return 0;
} // end is_program

/*
 * function: is_exit
 * description: checks is the user entered exit in the shell
 * return: 1 on success, 0 otherwise
 */
int is_exit(char* str){

  if(strcmp(str, "exit") == 0)
    return 1;

  return 0;
} // end is_exit

/*
 * function: is_file_io
 * description: checks if the user is requesting to do file input output
 * return: 1 on success, 0 otherwise
 */
int is_file_io(char** argv){

  int i = 0;
  
  while(argv[i] != NULL){
    //look for file i/o arg
    if(strcmp(argv[i], ">") == 0)
      return 1;
    else if(strcmp(argv[i], ">>") == 0)
      return 1;
    else if(strcmp(argv[i], "<") == 0)
      return 1;

    i++; // increment to next argument
  }

  return 0;

} // end is_file_io

/*
 * function: exec_program
 * description: executes a unix executable program by spawning a child process
 */
void exec_program(char** argv){
  int pid = -1; // used to identify the current process
  int status = 0; // used to identify a programs exit status code

  switch(pid = fork()){
    case -1:
      // fork() has failed
      perror("fork");
      break;
    case 0:
      // in the child process
      printf("Child PID: [%i]\n", getpid());
      execvp(argv[0], argv);
      invalid_cmd(argv[0]);
      exit(EXIT_FAILURE);
      break;
    default:
      // in the parent process
      wait(&status); //get exit value and wait for child program to finish
      break;
  }
}

/*
 * function: get_cmd
 * description: from ./<cmd> -arg1 -arg2 ... -argn <"<" or ">>" or ">"> <filename>
 *              will extract ./<cmd> -arg1 -arg2 .. -argn
 */
char **get_cmd(char** argv){

  char **cmd;
  int i = 0;
  int j = 0;

  while(argv[i] != NULL){

    // find index where file io operator is
    if(strcmp(argv[i], ">") == 0 || strcmp(argv[i], ">>") == 0 || strcmp(argv[i], "<") == 0){

      cmd = (char**)malloc(sizeof(char*)*(i+1)); // +1 to add null to end

      for(j=0; j<i; j++){
        cmd[j] = (char*)malloc(sizeof(char)*strlen(argv[j]+1));
        strcpy(cmd[j], argv[j]);
      }
      cmd[j] = NULL;
      
      return cmd;
    }

    i++;
  }

  return NULL; // error has occured

} // end get_cmd

/*
 * function: get_file
 * description: gets the filename after an io operator
 */
char *get_file(char **argv){

  char *file;
  int i = 0;

  while(argv[i] != NULL){

    if(strcmp(argv[i], ">") == 0 || strcmp(argv[i], ">>") == 0 || strcmp(argv[i], "<") == 0){
      //found the io operator
      //
      if(argv[i+1] == NULL) // no file after the io operator
        return NULL;
      else{
        i+=1;
        file = (char*)malloc(sizeof(char)*strlen(argv[i])); // allocate space for the filename
        strcpy(file, argv[i]);
        return file;
      }
    }

    i++;
  }

  return NULL; // and error has occured

} // end argv

/*
 * function do_file_io
 * description: does the following:
 *              $ command > filename
 *              Redirects the output of command to filename.
 *              The existing contents of filename are overwritten.
 *
 *              $ command >> filename
 *              Redirects the output of command to filename.
 *              The output from command is appendend to contents of filename.
 *              Existing contents are not overwritten.
 *
 *              $ command < filename
 *              Command reads its input from filename instead of from stdin.
 */
void do_file_io(char** argv){

  char **cmd; // cmd prior to file io operator
  char* fmode = NULL; // file mode, i.e. "r", "w", "a"
  char *file; // filename following io operator

  fmode = get_fmode(argv); // get the file mode

  if(fmode == NULL) // an error has occurred
    return;

  cmd = get_cmd(argv);

  if(cmd == NULL) // an error has occurred
    return;

  file = get_file(argv);

  if(file == NULL) // and error has occurred
    return;

  if(strcmp(fmode, "w") == 0){
    write_to_file(argv, file);
  }
  else if(strcmp(fmode, "a") == 0){
    append_to_file(argv, file);
  }
  else if(strcmp(fmode, "r") == 0){
    cmd_from_file(argv, file);
  }

  // free all mem
  free(fmode); // delete fmode from heap
  free(file);

  int i = 0;
  for(i=0; cmd[i] != NULL; i++){ // free all elements of cmd from memory
    free(cmd[i]);
  }

  free(cmd);

} // end do_file_io

/*
 * function: cmd_from_file
 * description: command reads its input from filename instead of from stdin.
 */
void cmd_from_file(char **argv, char *file){
  int pid = -1; // used to identify the current process
  int status = 0; // used to identify a programs exit status code
  char cmd_buffer[1000]; // buffer to hold contents of a given file
  int fd_in;
  char **cmd = get_cmd(argv);

  switch(pid = fork()){
    case -1:
      // fork() has failed
      perror("fork");
      break;
    case 0:
      // in the child process
      fd_in = open(file, O_RDONLY);
      dup2(fd_in, 0);
      close(fd_in);
      printf("Child PID: [%i]\n", getpid());
      execvp(argv[0], cmd);
      invalid_cmd(argv[0]);
      free(cmd);
      exit(EXIT_FAILURE);
      break;
    default:
      // in the parent process
      wait(&status); //get exit value and wait for child program to finish
      break;
  }

  free(cmd);
} // end cmd_from_file

/*
 * function: append_to_file
 * description: appends output of a command to a file
 */
void append_to_file(char** argv, char *file){
  int pid = -1; // used to identify the current process
  int status = 0; // used to identify a programs exit status code
  int fp = open(file, O_WRONLY | O_CREAT | O_APPEND, S_IRUSR | S_IWUSR); // open file to write, if file doesn't exist, create it
  char **cmd = get_cmd(argv);

  switch(pid = fork()){
    case -1:
      // fork() has failed
      perror("fork");
      break;
    case 0:
      // in the child process
      dup2(fp, 1); // make stdout go to file 
      close(fp);
      printf("Child PID: [%i]\n", getpid());
      execvp(argv[0], cmd);
      debug("test");
      invalid_cmd(argv[0]);
      free(cmd);
      exit(EXIT_FAILURE);
      break;
    default:
      // in the parent process
      wait(&status); //get exit value and wait for child program to finish
      break;
  }

  free(cmd);
} // end append_to_file

/*
 * function: write_to_file
 * description: writes output of a command to a file
 */
void write_to_file(char** argv, char *file){
  int pid = -1; // used to identify the current process
  int status = 0; // used to identify a programs exit status code
  int fp = open(file, O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR); // open file to write, if file doesn't exist, create it, set proper permissions if file doesn't exist already
  char **cmd = get_cmd(argv);

  switch(pid = fork()){
    case -1:
      // fork() has failed
      perror("fork");
      break;
    case 0:
      // in the child process
      dup2(fp, 1); // make stdout go to file 
      printf("Child PID: [%i]\n", getpid());
      execvp(argv[0], cmd);
      invalid_cmd(argv[0]);
      free(cmd);
      exit(EXIT_FAILURE);
      break;
    default:
      // in the parent process
      wait(&status); //get exit value and wait for child program to finish
      break;
  }
  free(cmd);
} // end write_to_file

// prints an invalid command to the terminal
void invalid_cmd(char* cmd){
  printf("-bradley's bash: %s: command not found\n", cmd);
}

// helper function
// converts a char * to a char **
// i.e. str = "test" becomes str_arr[0] = "test"
// only works with one string!
char ** str_to_str_arr(char* str){
  char** str_arr = (char**)malloc(sizeof(char*)); //allocate char **

  if(str_arr == NULL)
    return NULL; // error

  str_arr[0] = (char*)malloc(sizeof(char)*strlen(str)); //allocate space for char *

  if(str_arr[0] == NULL){
    free(str_arr);
    return NULL; // error
  }

  strcpy(str_arr[0], str);

  return str_arr;
} // end str_to_str_arr

// helper function for do_file_io
// returns the file mode as a string allocated in memory
char* get_fmode(char** argv){
  char *fmode = (char*)malloc(sizeof(char)*2);
  int i = 0;

  while(argv[i] != NULL){

    if(strcmp(argv[i], ">") == 0){
      strcpy(fmode, "w"); // open for reading and writing (overwrite file)
      return fmode;
    }
    else if(strcmp(argv[i], ">>") == 0){
      strcpy(fmode, "a"); // open for reading and writing (append if file exists)
      return fmode;
    }
    else if(strcmp(argv[i], "<") == 0){
      strcpy(fmode, "r"); // open for reading
      return fmode;
    }

    i++;
  }

  free(fmode);
  return NULL; // invalid ioType

} // end get_fmode

/*
 * function: process_user_commands
 * description: a wrapper function to gather user input
 *              i.e. "exit", "cmd << file", "./<file>"
 */
int process_user_commands(char** str_arr){
  int num_args = count_str_arr(str_arr); // get the numer of arguments in str_arr

  //
  //// handle exit cmd
  //
  if(is_exit(str_arr[0])){
    if(DEBUG){
      debug("user entered 'exit', TERMINATING THE PROGRAM...");
    }
    exit(0);
  }

  //
  //// handle file io cmds
  //
  else if(is_file_io(str_arr)){
    if(DEBUG)
      debug("Process file I/O");

    do_file_io(str_arr);

    if(DEBUG)
      debug("do_file_io: PASSED");

    return 1;
  }

  //
  //// handle all other commands
  //
  else {
    exec_program(str_arr);

    if(DEBUG){
      debug("exec_program: PASSED");
    }

    return 1;
  }

  return 0;
} // end process_user_commands

void ctrl_c_handler(int sig) /* SIGINT handler */ {
  printf("Caught SIGINT\n");
  shell_display();
  fflush(stdout);
} // end ctrl_c_handler

void ctrl_z_handler(int sig){
  printf("Caught SIGTSTP\n");
  shell_display();
  fflush(stdout);
} // end ctrl_z_handler

void startup_prompt(){
  printf("+--------------------------------------------+\n");
  printf("+                                            +\n");
  printf("+       Welcome to Bradley's Shell           +\n");
  printf("+                                            +\n");
  printf("+--------------------------------------------+\n");
} // end startup_prompt

int is_help(char* input){
  if(strcmp(input, "--help") == 0)
    return 1;
  else
    return 0;
} // end is_help
