#include <stdio.h>
#include "sds663printq.h"
#include "sds663print.h"
#include <string.h>




// This wrapper should only be used with  -freal-8-real-16
 
void sds663print_real8_(char * str, __float128 * v, int * pn, int * pndig)
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
  
  sds663print_real16(str2, v, *pn, *pndig);
  
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
