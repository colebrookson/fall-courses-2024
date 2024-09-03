#include "sds663print.h" // We'll use sds663print for printing
#include <stdio.h>
#include <math.h>

//
// mypow
// returns x^n
//
// Input:
// * x  : real number of double precision length 1
// * n  : integer
//
double mypow(double x, int n)
{
    int i;
    double res;
    /* corner case of exponent 0 */
    if (n == 0)
    {
        res = 1;
    }
    /* the loop goes through all n*/
    for (i = 1; i <= n; i++)
    {
        /* multiply x by itself*/
        res = x * x;
    }
    return res;
}