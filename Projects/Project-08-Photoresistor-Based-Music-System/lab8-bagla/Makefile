all:  clean main 

main:	main.s
	
	gcc -c -o prog.o prog.c
	gcc -g -o main main.s prog.o -lwiringPi
clean:
	touch main
	rm main
