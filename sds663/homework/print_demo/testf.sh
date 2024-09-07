
# First, remove the compiled file if it exists, and the old log
rm test
rm test_log.txt

# Now, set first timer
start=`date +%s`
# and compile
# This is cool - C and Fortran code can be compiled together!
# The flag -fallow-argument-mismatch allows us to send the wrong type of variables - which we will use to demonstrate things. You might still get a warning. 
gfortran -o test sds663print.c sds663printq.c sds663printf.c sds663_f_demo.f sds663_f_demo_main.f -fallow-argument-mismatch
# How long did this take?
end=`date +%s`
runtime=$((end-start))
echo "Compiled in" $runtime "seconds"

# reset timer
start=`date +%s`
# and run
# saved a log of the output to test_log.txt
./test | tee test_log.txt
# How long did this take?
end=`date +%s`
runtime=$((end-start))
echo "Run took" $runtime "seconds"

echo "Saved log in test_log.txt"

