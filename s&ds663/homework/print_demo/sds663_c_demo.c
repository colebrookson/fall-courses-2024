#include "sds663print.h" // We'll use sds663print for printing
#include "sds663printq.h"
#include <stdio.h>
#include <math.h>
//#include <quadmath.h>

void mytest(double * vv, int n)
{
  
  int j1;               // variable for our loop
  double v;             //real number
  int j;                // and integer
  int vi[1000];         // an array on integers
  //__float128 vq[1000];     // Array in quadruple precision
  
  //
  // Examples for printing using our print functions.
  // You don't have to use them, but you may find them useful in some future assignments
  //

  
  // assign a real number
  v = 12.34;
  // print real number
  sds663print_real8("Print a real number",&v,1,5);          // Note the "&" sign
  
  // assign some values to the array of real numbers
  for(j1=0;j1<n;j1++)
    {
      vv[j1]=1.0/(j1+1.0);
    }
  // print the array
  sds663print_real8("Print array of real numbers",vv,n,5); // Note that we don't need "&" for an array


  
  // assign an integer
  j = -12;
  // print real number
  sds663print_int("Print an integer",&j,1);                // Note the & sign
  
  // assign some values to the array of integers
  for(j1=0;j1<n;j1++)
    {
      vi[j1]=j1;
    }
  // print the array
  sds663print_int("Print array of integers",vi,n);



  // Print bits
  sds663print_byte("The bytes \n", ((void *)vi), 12);

  
  
  // assign some values to the array of quadruple precision
  //for(j1=0;j1<n;j1++)
  //  {
  //    vq[j1]=((__float128)j1*(__float128)j1);
  //  }
  //// print the array
  //sds663print_real16("Print array of float128",vq,n,10);



  

  //
  // You don't need many types of loops, for-loop is enough
  //
  for (j1=0;j1<1000000;j1++)
    {
      // check stop condition
      if ( vv[j1] < 0.5 )
	{
	  sds663print_int("For loop stopped at j1=",&j1,1);
	  // "break" takes us out of the loop.
	  break;
	}
    }
 
  
}


