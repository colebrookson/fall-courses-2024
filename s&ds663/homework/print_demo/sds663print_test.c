#include <stdio.h>
#include "testdef.h"

void main()
{
  double myd;
  double mydar[10];
  mydouble mydbl,mydbl2,mydbl3;
  int j1;
  printf("print test \n");

  printf("len: %lu\n", sizeof(myd));
  printf("len ar: %lu\n", sizeof(mydar));
  printf("len ar star: %lu\n", sizeof(*mydar));

  printf("len dbl: %lu\n", sizeof(mydbl));

  mydbl = 1.0;
  mydbl2 = 1.0;
  for(j1=0;j1<10000;j1++)
    {
      mydbl2 = mydbl2/10;
      mydbl3 = mydbl-mydbl2;
      if (mydbl==mydbl3)
	{
	  printf("j1=%d\n",j1);
	  break;
	}
		  
    }
  
  myprinf("ABC", mydbl2, 1);
  myprinf("SQRT", mysqrt(mydbl2), 1);
}
