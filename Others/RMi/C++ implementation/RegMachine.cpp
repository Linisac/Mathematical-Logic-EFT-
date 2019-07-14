#include <iostream>
#include <vector>
#include "RegMachine.h"

using namespace std;

Register::Register()
{
};

void Register::add(char symbol)
{
     push_back(symbol);
}

void Register::sub(char symbol)
{
     if (!empty())
        pop_back();
}

bool Register::isEmpty()
{
     return empty();
}

char Register::end()
{
     char symbol = back();
     return symbol;
}

void Register::abort()
{
     cout << "error!"
          << endl;
}

Register::~Register()
{
     ~Content();
}
