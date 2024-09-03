#include <stdio.h>
#include <stdlib.h>
#include "sds663print.h"
#include <string.h>


//
// sds663print_none
// print the string "Nothing much to say" - for tests
//
void sds663print_none()
{
  printf("Nothing much to say\n");
}



//
// sds663print_real8
// Print an array of double precision numbers
//
// Input:
// * str : string (\0 terminated)
// * v   : array of double precision numbers
// * n   : integer. length of the array
// * ndig : pricision for printing, how many digits to print
//
void sds663print_real8(char * str, double * v, int n, int ndig)
{
  int j1;
  char prndef[100];

  // title
  printf("%s",str);
  // print defs
  sprintf(prndef,"%%.%de   ",ndig);
  // print
  for ( j1=0; j1<n ; j1++ )
  {
    if ((j1%6)==0)
    {
       printf("\n   ");
    }
    printf(prndef,v[j1]);
  }
  printf("\n");
}



//
// sds663print_int
// Print an array of integer numbers
//
// Input:
// * str : string (\0 terminated)
// * v   : array of integers
// * n   : integer. length of the array
//
void sds663print_int(char * str, int * v, int n)
{
  int j1;

  // title
  printf("%s",str);
  // print
  for ( j1=0; j1<n ; j1++ )
  {
    if ((j1%10)==0)
    {
       printf("\n");
    }
    printf("%13d",v[j1]);
  }
  printf("\n");
}


//
// sds663print_int
// Print an array of integer numbers
//
// Input:
// * str : string (\0 terminated)
// * v   : array of integers
// * n   : integer. length of the array
//
void sds663print_intM(char * str, int * v, int n, int M)
{
  int j1;

  // title
  printf("%s",str);
  // print
  for ( j1=0; j1<n ; j1++ )
  {
    if ((j1%M)==0)
    {
       printf("\n");
    }
    printf("%13d",v[j1]);
  }
  printf("\n");
}




//
// sds663print_byte
//
//
void sds663print_byte(char * str, unsigned char * v, int n)
{
  int j1,j2;
  char c[20];
  unsigned char vtmp;
  // title
  printf("%s",str);
  // print
  for ( j1=0; j1<n ; j1++ )
  {
    if ((j1%4)==0)
    {
       printf("\n");
    }
    vtmp = v[j1];
    for (j2=0; j2<8; j2++ )
      {
	if ((vtmp%2)==1)
	  {
	    c[7-j2] = '1';
	  }
	else
	  {
	    c[7-j2] = '0';
	  }
	vtmp = vtmp/2;
      }
    c[8] = '\0';
    printf("%s   ",c);
  }
  printf("\n");
}

