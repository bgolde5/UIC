main.o: shell.h main.c
	gcc -std=c99 -c main.c

shell:   main.c shell.o
	gcc -o shell main.c

clean: 
	rm *.o shell
