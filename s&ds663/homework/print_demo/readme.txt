S&DS 663 (2024) demo code
Roy Lederman (c)
roy.ledeman@yale.edu

====================================================

Files in the demo:
readme.txt         :  This file.
sds663_c_demo.c    :  Some C demo code
sds663_c_demo_main.c  :  The main program file for the c demo code
sds663_f_demo.f    :  Some Fortran demo code
sds663_f_demo_main.f  :  The main program file for the c demo code

testc.sh           :  Script for compiling the c code
testf.sh           :  Script for compiling the Fortran code

sds663print.c      :  Print functions 
sds663print.h      :  Print functions (C header file)
sds663printf.c     :  Fortran interface for the same print functions
sds663printf_pro.c :  Fortran interface for promoting variables (ignore for now)
sds663printq.c     :  Print functions for quadruple precision (ignore for now)
sds663printq.h     :  Print functions for quadruple precision (C header file ignore for now)



====================================================

Running the demo:

The C demo:
./testc.sh

The Fortran demo:
./testf.sh


If you cannot run the script, make sure that the scripts are allowed to run.
Type: chmod +x *.sh

Each script compiles the required files and runs the compiled code.
Open the script files and the code files to see how they work.
Don't worry about the print code at this point.


====================================================

FAQ:
* Q: Why do we have the code and another "_main" file for the main program?
  A: I usually try to have as few files as possible. When we test your code later, we will not be able to compile your functions with our tests if you already have a "main" function in your code. So, you can either remove the "main" function when you submit, or have a short "_main" file this this that just gets your code to run.

* Q: Why don't you have header files for the demo?
  A: If you know C, you may know that header files are the standard. Indeed, our code would throw and "implicit declaration of function" warning had I not suppressed it with "-Wno-implicit-function-declaration" when I called the compiler. You can choose your own approach to this, just make sure that it is compatible and everyone can run it.
     If you don't know what I am talking about, it's OK. 
