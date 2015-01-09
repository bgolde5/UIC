#makefile for bb_bubble_pop game
simplio.o: simpleio.h simpleio.c
	gcc -std=99 -c simpleio.c
stack.o: stack.h stack.c
	gcc -std=c99 -c stack.c
bboard.o: bboard.h bboard.c
	gcc -std=c99 -c bboard.c
bpop: bpop.c bboard.o stack.o simpleio.o
	gcc -std=c99 bpop.c bboard.o stack.o simpleio.o -o bpop

