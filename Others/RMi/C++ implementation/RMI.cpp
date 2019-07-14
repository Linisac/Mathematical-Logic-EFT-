#include <iostream>
#include <cstdlib>
#include "test.h"
//#include <vector>

using namespace std;

int main(int argc, char** argv)
{
    //[- @ comment 0: The meta information
    const int MaxProgNameLength = 20;
    char ProgName[MaxProgNameLength];
    //-] @ comment 0.---------------------
    
    //[- @ comment 1: Prompt the user to specify the program
    cout << "Please specify the program to be executed."
         << endl
         << "The program name is ";
    
    cin >> ProgName;
    
    //[- @@ comment 1.0: This block is for ease of test
    cout << ProgName
         << endl;
    //-] @@ comment 1.0.-------------------------------
    //-] @ comment 1.---------------------------------------
    
    system("pause");
    return 0;
}
