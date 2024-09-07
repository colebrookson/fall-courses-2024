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
    sds663print_real8("power test: ", &res, 1, 5);
    return 0;
}

//
// myfact
// returns the factorial n!
//
// Input:
// * n  : integer
//
int myfact(int n)
{
    double res = 1; /* again corner case of 1 */
    int i;          /* to iteratre with */
    /* loop through n if n greater 1*/
    for (i = 2; i <= n; i++)
    {
        /* multiply by the next value */
        res = res * i;
    }
    sds663print_real8("factorial test: ", &res, 1, 5);
    return 0;
}

//
// mybinom
// returns the binomial coef n choose k
//
// Input:
// * n  : integer
// * k  : integer
//
int mybinom(int n, int k)
{
    double res = 1; /* again corner case of 1 */
    int i;          /* to iteratre with */
    /* loop through n if n greater 1*/
    if (k > n)
    {
        res = 0;
        sds663print_real8("binomial test: ", &res, 1, 5);
        return 0;
    }
    for (i = (n - k + 1); i <= n; i++)
    {
        /* multiply by the next value */
        res = res * i;
    }
    for (i = 2; i <= k; i++)
    {
        res = res / i;
    }
    sds663print_real8("binomial test: ", &res, 1, 5);
    return 0;
}