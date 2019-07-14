//keywords: {LET, +, -, IF, THEN, ELSE, PRINT, HALT}
#include <vector>

using namespace std;

enum Operation {ADD, SUB, JUMP, PRINT, HALT}
class Instruction;
class Thread;
class Register;
class RegCollection;
class RegisterMachine;

class Instruction {
      private:
              Operation Op;
              unsigned int RegNumber;
              char Symbol;
              unsigned int BrchDegree;//branch degree
              unsigned int* ptrBranch;//pointer to the branch array
      public:
             Instruction();//constructor
             ~Instruction();//destructor
};

class Thread {
      //a thread receives the program name, in addition to the data member ---
      //Memory (of class RegCollection) --- from RegisterMachine.
      //Then it starts executing.
      
      //Thread is responsible for checking the alphabet
      private:
              unsigned int ProgCounter;//program counter
              void loadProgram(char*);//load program with the given name
              void abort();//thread aborts in case of exception
              unsigned int ProgSize;//the length of the program
              vector<Instruction> Program;//the program
      public:
             Thread(char* ProgramName, RegCollection& Mem);//constructor
             ~Thread();//destructor
             void execute();//executes the program
};//end of definition of class Thread

class Register {
      private:
              vector<char> Content;
      public:
             Register();//constructor
             void add(char);//insert a symbol at the end
             void sub(char);//delete a symbol from the end if not empty
             bool isEmpty();//tells whether the register is empty
             char end();//returns the symbol at the end
             void abort();//in case of exception
             ~Register();//destructor
};

class RegCollection {
      private:
              vector<Register> Collection;
      public:
             RegCollection();//constructor
             void add(unsigned int, char);//insert the given symbol to the designated reg.
             void sub(unsigned int, char);//delete the given symbol from the designated reg.
             void enlarge(unsigned int);//enlarge to the designated size
             void abort();//in case of exception
             ~RegCollection();//destructor
};

class RegisterMachine {
      //accessing other classes: register program
      private:
              Thread MainThread;//executes the program loaded
              RegCollection Memory;//contains registers
              unsigned int NumOfSymbols;//the size of the alphabet
              char* Alphabet;
      public:
             RegisterMachine();//constructor
             ~RegisterMachine();//destructor
};//end of definition of class RegMachine
