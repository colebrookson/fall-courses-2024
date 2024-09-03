

ccccccccccccccccccccccccccccccccccccccccccccccccc
cccc            Test subroutines             cccc
ccccccccccccccccccccccccccccccccccccccccccccccccc

c
c Test subroutine
c      
      subroutine mytest(w,n,ln)
      implicit none
c     define our input parameters
      integer n,ln,m
c     Sometimes, we want to pass an array without stating its size implicitly:
      real *8 w(*)
c     We could have also stated the size
ccc      real *8 w(ln)
c     Variables that we will use
      integer ndig,j1,q
c     Another array that we create here
      integer iw(1000)

c     Define a real number 1.0. Why do we need this?
      real *8 rone
      rone = 1.0


c
c     Assigning and printing
c      
      
c     Number of digits to print
      ndig = 30

c     Assign values to array
c     Note that arrays in Fortran are indexed 1,2,3.... not 0,1,2,... like in C
c     This is a for loop in Fortran. Note that the number 1000 will not be used in other loops and "continue" statements in the subroutine mytest.
      do 1000 j1=1,n
         w(j1) = rone*j1 + rone/(rone+j1)
 1000 continue

c     Print the array of reals
c     Note the "*" at the end of the string!     
      call sds663print_real8("mytest: print array of reals*",w,n,ndig) 


      
c     Integers
c     Assign values to array
c     This is a for loop in fortran. Note that we are using a different number for the loop.
c     Let's also add a condition that will exit the loop.
c     We need another arbitrary number (2009) for the goto command.
      do 2000 j1=1,500
         iw(j1) = j1
         if (j1.ge.n) then
            goto 2009
         endif         
 2000 continue
 2009 continue
c     Print the array of integers
      call sds663print_int("mytest: print array of integers*",iw,n) 
c     What happens if we send the array of real to the integer printing
      call sds663print_int("mytest: oops, wrong array!*",w,n)



c
c     Passing by reference
c
c     When we pass a variable in f\Fortran it is always by reference.
c     This means that if we update the variable in a subroutine, it is
c     updated in the calling subroutine as well.      
c
      q=10
      call sds663print_int("pass by ref: iw before calling*",iw,4)  
      call sds663print_int("pass by ref: q before calling*",q,1)
      call testpassbyref(iw,q)
      call sds663print_int("pass by ref: iw after calling*",iw,4)  
      call sds663print_int("pass by ref: q after calling*",q,1)
c     You can also pass an expression, in which case the variable is not updated
      call testpassbyref(iw,(q+1))      
      call sds663print_int("pass by ref: expression : q*",q,1)
c     You can also pass some point in the array
      call testpassbyref(iw(3),(q))      
      call sds663print_int("pass by ref: after passing iw(3)*",iw,4)  

      
c
c     2-D arrays (more advanced)
c
c     Let's call test2darray, and make it treat w as a matrix, where
c     the first dimension is 6 (the next is arbitrary).
c          
      m=6
      call test2darray(w,m)

      
      end
      


ccccccccccccccccccccccccccccccccccccccccccccccccc

c
c
c
      subroutine testpassbyref(iw,m)
      implicit none
      integer m
      integer iw(*)

      m=m+1
      iw(2) = iw(1)
      
      end


ccccccccccccccccccccccccccccccccccccccccccccccccc
      
      
c
c
c
      subroutine test2darray(w,m)
      implicit none
      integer m
      real *8 w(m,*)

      call sds663print_real8("test2darray print element (1,1) *",
     1     w(1,1),1,5)

      call sds663print_real8("test2darray print element (1,1) *",
     1     w(2,1),1,5)
      
      call sds663print_real8("test2darray print element (1,2) *",
     1     w(1,2),1,5)

      call sds663print_real8("test2darray print stating at (1,2) *",
     1     w(1,2),6,5)
      
      end
