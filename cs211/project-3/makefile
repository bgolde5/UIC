waiting_system: waiting_system.o client_system.o main.o
	gcc -o waiting_system waiting_system.o client_system.o main.o

waiting_system.o: waiting_system.c waiting_system.h
	gcc -c waiting_system.c

client_system.o: client_system.c waiting_system.h
	gcc -c client_system.c

main.o: main.c waiting_system.h
	gcc -c main.c

clean: 
	rm main.o client_system.o waiting_system.o

remove: 
	rm waiting_system
