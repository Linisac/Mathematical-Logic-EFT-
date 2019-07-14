#include <iostream>
#include <cstdlib>

using namespace std;

unsigned long pairing(unsigned long, unsigned long);

class formula
{
      private:
              int code;
              unsigned long tleft;
              unsigned long tright;
              formula *fleft;
              formula *fright;
      public:
             formula(unsigned long a, unsigned long b)
             {
                  code = 0;
                  tleft = a;
                  tright = b;
                  fleft = 0;
                  fright = 0;
             }
             
             formula(formula* p)
             {
                  code = 1;
                  tleft = 0;
                  tright = 0;
                  fleft = p;
                  fright = 0;
             }
             
             formula(formula* p, formula* q)
             {
                  code = 2;
                  tleft = 0;
                  tright = 0;
                  fleft = p;
                  fleft = q;
             }
             
             formula(unsigned long a, formula* p)
             {
                  code = 3;
                  tleft = a;
                  tright = 0;
                  fleft = p;
                  fright = 0;
             }
             
             unsigned long eval()
             {
                  unsigned long value = 0;
                  
                  switch (code)
                  {
                         case 0:
                              value = 4 * pairing(tleft, tright);
                              break;
                         case 1:
                              value = 4 * (fleft -> eval()) + 1;
                              break;
                         case 2:
                              value = 4 * pairing(fleft -> eval(), fright -> eval()) + 2;
                              break;
                         case 3:
                              value = 4 * pairing(tleft, fleft -> eval()) + 3;
                              break;
                         default:
                              exit(1);
                  }
                  
                  return value;
             }     
};

int main()
{
    formula a(3 * pairing(2, 0) + 3, 2);
    formula b(&a);
    formula c((unsigned long) 0, &b);
    formula d(&c);
    
    unsigned long int t = 0 - 1;
    unsigned int u = t;
    
    cout << t << endl
         << u << endl;
    
    system("pause");
    return 0;
}

unsigned long pairing(unsigned long a, unsigned long b)
{
     unsigned long c = a + b;
     return (c * (c + 1)) / 2 + a;
}

