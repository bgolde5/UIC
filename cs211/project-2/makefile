stack.o: stack.c stack.h
	gcc -c stack.c

maze.o: maze.c maze.h
	gcc -c maze.c

main: main.c maze.o maze.h stack.o stack.h
	gcc main.c maze.o stack.o -o maze 

