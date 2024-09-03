#include "sds663print.h" // We'll use sds663print for printing
#include <stdio.h>
#include "sds663print.h"
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
    double res = 1; /* corner case of exponent 0  is taken care of here*/
    /* the loop goes through all n*/
    for (i = 1; i <= n; i++)
    {
        /* multiply x by itself*/
        res = res * x;
    }

    sds663print_real8("", &res, 1, 5);
}