test: queue.o test.o
	gcc -o test queue.o test.o

queue.o: queue.c queue.h
	gcc -c queue.c

test.o: test.c queue.h
	gcc -c test.c

clean: 
	rm test.o queue.o

remove: 
	rm test 
