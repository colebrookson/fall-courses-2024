#include "sds663print.h" // We'll use sds663print for printing
#include <stdio.h>
#include <math.h>
#include "funs.h"

int main()
{
    double v; // the output of the mypow() function
    int f;    // the output of the factorial function
    int b;    // the output of the binomial coef function
    //
    // The power question is implemented here
    //
    v = mypow(1.5, 2);
    f = myfact(10);
    b = mybinom(10, 2);
}