#include <stdio.h>
#include "sds663printq.h"
#include <string.h>
#include <quadmath.h>


//
// sds663print_real16
// Print an array of quad precision numbers
//
// Input:
// * str : string (\0 terminated)
// * v   : array quad precision numbers
// * n   : integer. length of the array
// * ndig : pricision for printing, how many digits to print
//
void sds663print_real16(char * str, __float128 * v, int n, int ndig)
{
  int j1;
  int cntr = 0;
  int tmp = 1;
  char qstr[256];

  // title
  printf("%s",str);
  // print
  for ( j1=0; j1<n ; j1++ )
  {
    if ((j1%6)==0)
    {
       printf("\n   ");
    }
    if (ndig < 18)
      tmp = quadmath_snprintf( qstr, 256, "%+-#24.*Qe", ndig, v[j1]);
    else
      tmp = quadmath_snprintf( qstr, 256, "%+-#41.*Qe", ndig, v[j1]);
    printf("%s", qstr);
  }
  printf("\n");
}

