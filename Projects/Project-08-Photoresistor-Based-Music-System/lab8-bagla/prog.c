#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <softPwm.h>
#include <wiringPi.h>

#define U 26
#define D 28


void playSound(int choice) { 
	char * arg[3] = {"mpg321","22311", NULL};

	if(choice!=0) {
		arg[1] = "20712";
	}	
	int ret = fork(); 	//create a child

	if (ret < 0) {
		perror("fork");
		exit(0);

	} else if (ret == 0) {

		//child process
		execvp(arg[0], arg);
		exit(0);

	} else {

		//parent process
		sleep(5);
		kill(ret, 9);
		printf("It's closing time...\n");
	}
}

int changeVolume() {

	pinMode(U, INPUT);
	pinMode(D, INPUT);

	int ret = fork();	//creates a child

	if (ret < 0) {
		perror("fork");
		exit(0);

	} else if (ret == 0) {

		//child process
		while(1) {
			if (digitalRead(U) == 1) {
				system ("./vol +");
			}
			if (digitalRead(D) == 1) {
				system ("./vol -");
			}

		}
	} else {
		return ret;
	}
}

