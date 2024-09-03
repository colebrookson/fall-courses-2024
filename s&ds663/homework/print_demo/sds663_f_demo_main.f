c
c     Main program calls other subroutines
c
      program main
      real *8 w(1 000 000)
      integer ln
      integer n

      ln=1 000 000
      n=20
      
      call mytest(w,n,ln)
      
      stop
      end

