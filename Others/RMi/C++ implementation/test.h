//#include <vector>
#include <vector>
//class A;
using namespace std;

class B {
      public:
             int a;
      B(int value)
      {
             a = value;
      }
};

class A {
      //private:
              //vector <int> a;
      //friend int main(int, char**);
      public:
             //int* ptrInt;
             int b;
             vector<int> a;
             A();
             void show();
             void list();
};
