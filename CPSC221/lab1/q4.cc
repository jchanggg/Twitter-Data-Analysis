/* Authors: Wendy Zhou and Jeffrey Chang 
Parameters: n - the number of disks to be moved
Returns: void
Outputs: The moves required to move the stack from one peg to another
Takes in a parameter n such that, it will print out the supposed moves to move a stack from one peg to another, according to the rules of Towers of Hanoi
*/

#include <cstdlib> // for atoi
#include <iostream>

void moveDisks(int n, char x, char z, char y);

int main (void){
char x = 'A';
char y = 'B';
char z = 'C';
std::cout << "Please input the number of disks:";
int n;
std::cin >> n;


moveDisks(n, x, z, y);
}



void moveDisks(int n, char x, char z, char y){
if(n <= 0){
std::cout << "No pegs to move!";
}

if(n == 1){
std::cout << "Move disk from peg";
std::cout << x;
std::cout << "to peg" ;
std::cout << z << std::endl;
}
else{
moveDisks(n-1, x, y, z);
std::cout << "Move disk from peg"; 
std::cout << x;
std::cout << "to peg" ;
std::cout << z << std::endl;
moveDisks(n-1, y, z, x);
}
}

