#include <stdio.h>
#include "sds663print.h"
#include <string.h>




void sds663print_none_()
{
  sds663print_none();
}

// Fortran interface for sds663print_real8
void sds663print_real8_(char * str, double * v, int * pn, int * pndig)
{
  char str2[1100];
  int j1;

  for ( j1=0; j1<1000; j1++)
  {
    str2[j1] = str[j1];
    if ('*' == str2[j1])
      {
	break;
      }
  }
  str2[j1] = '\0';
  
  sds663print_real8(str2, v, *pn, *pndig);
  
}


// Fortran interface for sds663print_int
void sds663print_int_(char * str, int * v, int * pn)
{
  char str2[1100];
  int j1;

  for ( j1=0; j1<1000; j1++)
  {
    str2[j1] = str[j1];
    if ('*' == str2[j1])
      {
	break;
      }
  }
  str2[j1] = '\0';
  
  sds663print_int(str2, v, *pn);
  
}
