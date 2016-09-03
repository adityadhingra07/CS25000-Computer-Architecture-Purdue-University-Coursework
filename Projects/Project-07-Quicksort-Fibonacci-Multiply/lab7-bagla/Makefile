CC=gcc

all: clean fibonacci multiply quicksort
	
fibonacci: 
	$(CC) -g -o fibonacci main_fib.c fibonacci.s

multiply:
	$(CC) -g -o multiply main_mult.c multiply.s

quicksort:
	$(CC) -g -o quicksort main_quicksort.c quicksort.s

clean:
	rm -rf quicksort fibonacci multiply
