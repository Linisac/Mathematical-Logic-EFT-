#include "test.h"
#include <iostream>
#include <vector>

using namespace std;

A::A()
{
         //b = value;
      for (int i = 0; i < 10; i++)
          a.push_back(i);
      //ptrInt = 0;
      //ptrInt -> push_back(314);
}

void A::show()
{
         cout << a.size()
              << endl;
         
         for (int i = 0; i < 10; i++)
             cout << a.at(i)
                  << endl;
}

void A::list()
{
     cout << "Hello";
}
