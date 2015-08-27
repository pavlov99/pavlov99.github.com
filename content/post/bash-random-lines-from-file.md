+++
date = "2015-08-27T06:18:14Z"
draft = true
title = "bash random lines from file"

+++

cat -n unusual.txt | sort -R | cut -f2-

coreutils, makes strings unique

    nl -ba file | sort -R | sed 's/.*[0-9]\t//'

    sort -R 

sort -R will only work if the lines are unique. If there are duplicate lines, sort -R will put them next to each other.
shuf on the other hand will sufficiently randomize a list, including NOT putting duplicate lines next to each other.


    apt-get install randomize-lines

    rl

why don't you just use shuf? like 

    shuf unusual.txt > randorder.txt

    data https://archive.ics.uci.edu/ml/machine-learning-databases/poker/poker-hand-testing.data
    seq 1000 > data.txt
