/* Authors: Jeffrey Chang and Wendy Zhou
parameters: none
returns: none
Outputs: if the user is correct or not
This function generates a random number from 0 - 100 inclusive, and will print out if the user is correct or not, exits once the user's answer is correct
*/
#include <stdio.h>     
#include <stdlib.h>     
#include <time.h>
#include <iostream>

int main (void) {
srand (time(NULL));
int randnum =  rand()%100;
int guess = randnum  + 1;

while(randnum != guess){
std::cout << "Input -1 to quit or Please input guess:";
std::cin >> guess;
if(guess == randnum){
std::cout << "Correct!" << std::endl;
break;
}
if(guess == -1){
std::cout << "The number is: " << guess << std::endl;
break;
}
if(guess >= 0 && guess <= 100 && guess != randnum && guess != -1){
std::cout << "Incorrect" << std::endl;
}
else{
std::cout << "Please input integer guess greater than equal to zero or less than equal to 100" << std::endl;
}
}
}
