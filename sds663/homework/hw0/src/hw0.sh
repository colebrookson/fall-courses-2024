# First, remove the compiled file if it exists, and the old log
rm test
rm test_log.txt
# Now, set first timer
start=`date +%s`
# and compile
# -Wno-implicit-function-declaration suppresses warnings related to not using a header file
gcc -std=c99  -o test sds663print.c  funs.c __main.c -lm  -Wno-implicit-function-declaration
# How long did this take?
end=`date +%s`
runtime=$((end-start))
echo "Compiled in" $runtime "seconds"