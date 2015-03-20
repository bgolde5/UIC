proj4: stack.o proj4.o
	gcc -o proj4 stack.o proj4.o

stack.o: stack.c stack.h
	gcc -c stack.c

proj4.o: proj4.c stack.h
	gcc -c proj4.c

clean: 
	rm proj4.o stack.o

remove: 
	rm proj4
