# commands to compare original maxtract output against new after replacement of mikmatch
find . -name '*.jsonf' -exec perl -n -p -i.bak -e 's/\d+/<digits>/g' {} \;
diff -wr -x '*.bak' -x'*.bb' -x'*.json' -x'*.lin' --suppress-common-lines --side-by-side gpu gpu-nomikmatch/
