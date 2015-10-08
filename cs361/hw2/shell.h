/*
 * =====================================================================================
 *
 *       Filename:  shell.h
 *
 *    Description:  Header file for shell.h
 *
 *        Version:  1.0
 *        Created:  09/13/2015 20:33:22
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
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <fcntl.h>
#include <ctype.h>

#include "dbg.h"

#define STR_SIZE 100
#define LINE_SIZE 100
#define MAXARGS 100
#define MAXLEN 100

int DEBUG = 0; // set to 1 during debug mode "-d or -debug"

void unix_error(char*);
char * get_input();
int count_str_in_line(char*);
char ** malloc_str_arr(int);
void destroy_str_arr(char**, int);
void print_str_arr(char**);
void exec_program(char**);
int is_program(char*);
int is_exit(char*);
int is_help(char*);
int is_file_io(char**);
int count_str_arr(char**);
int process_user_commands(char**);
char * get_fmode(char**);
char ** str_to_str_arr(char*);
void invalid_cmd(char*);
void write_to_file(char**, char*);
void append_to_file(char**, char*);
void cmd_from_file(char**, char*);
void shell_display(void);
void do_file_io(char**);
char **get_cmd(char**);
char *get_file(char**);
void ctrl_c_handler(int sig);
void ctrl_z_hanlder(int sig);
