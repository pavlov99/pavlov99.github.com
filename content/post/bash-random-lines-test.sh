#!/bin/bash
FILENAME="/tmp/random-lines.$$.tmp"
NUMLINES=10000000
seq $NUMLINES > $FILENAME;
paste <(seq $NUMLINES) <(seq $NUMLINES) <(seq $NUMLINES) >> $FILENAME

init() {
    seq $NUMLINES > $FILENAME;
}

# get 10 random lines
# echo "10 random lines with nl:"
# time nl -ba $FILENAME | sort -R | sed 's/.*[0-9]\t//' | head > /dev/null

echo "10 random lines with shuf:"
time shuf $FILENAME -n10 | head > /dev/null

echo "10 random lines with rl:"
time rl $FILENAME | head > /dev/null

rm -rf $FILENAME
