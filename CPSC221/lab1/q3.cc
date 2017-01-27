/*Authors: Jeffrey Chang and Wendy Zhou
parameters: begin - the first element in the array
increment - the number to be incremented
returns: void
This function fills an array given 2 inputs, the first indicates the first number of the array, and subsequent values in the array are incremented by the second input. The function uses pass by reference to modify the array */
#include <cstdlib> // for atoi
#include <iostream>

int global_array [10]; //declaring a global array

void fill_array(int begin, int increment){

for(int index = 0; index < 10; index++){
global_array[index] = begin;
begin += increment;
}
}

int main(void){
	fill_array(4,2);
	std::cout << "{";
for(int index = 0; index < 10; index++){
	std::cout << global_array[index];
	if(index != 9){
		std::cout << ", ";
}
}
	std::cout << "}";
}
