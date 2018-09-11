#!/bin/sh
set -e
for i in $(cat ksh-tests | grep -v "^#"); do
    echo "Testing $i..."
    yash ./run-test.sh ksh $i
done

echo "All tests were succesful!"
