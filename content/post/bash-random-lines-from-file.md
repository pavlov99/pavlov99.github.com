+++
date = "2015-08-27T06:18:14Z"
title = "Get random lines from file with bash"
categories = ["bash"]
description = "Data sampling with bash"
keywords = ["bash","sampling"]
+++

Data sampling is one of the duties of data scientists and data engineers.
One may require to split original data into train and test subsets.
How could we do it fast with less amount of code?
This article shows usage of different command line tools for such task.

There are several ways to get random lines from a file:

- Sort lines with random key
- `shuf` from GNU core utils
- `rl` randomize-lines package
- perl one-liner
- python one-liner

All of the approaches would be compared in terms of execution time, tools availability and code complexity. File to be sorted consists of 10M lines:

```bash
FILENAME="/tmp/random-lines.$$.tmp"
NUMLINES=10000000
seq -f 'line %.0f' $NUMLINES > $FILENAME;
```

sort
----

Default `sort` has option `-R`, `--random-sort` which sorts lines by random hash. However, if there are two lines with the same content, their hashes would be the same and they would be sorted one after another. To prevent such case, one may possible to make all of the lines unique via adding line number to all of them.

```bash
nl -ba $FILENAME | sort -R | sed 's/.*[0-9]\t//' | head
```

Time: 3 min 09.77 sec

Complexity: medium, need to keep in mind making lines unique

Availability: good

shuf
----

Another bash tool `shuf` on the other hand will sufficiently randomize a list, including not putting duplicate lines next to each other. Another advantage of this tool is it's availability. Being part of GNU core utils it is available on nearly every machine.

```bash
shuf $FILENAME | head
```

It has parameter `-n` to specify number of lines to output, however based on my tests, it does not speed up the process. Combination with `head` works better.

Time: 0.14 sec

Complexity: easy

Availability: good

randomized-lines
----------------

Tool `rl` from [randomize-lines](http://manpages.ubuntu.com/manpages/wily/en/man1/rl.1.html) package makes random sampling easy, however, not every machine has it. As mentioned in it's description: "It does this with only a single pass over the input while trying to use as little memory as possible".

```bash
rl $FILENAME | head
```

Time: 0.68 sec

Complexity: easy

Availability: bad, need to install from external repository


perl
----

Perl is a good language for text processing. For those developers, who are less familiar with bash, it might be native to try it first.

```bash
cat $FILENAME | perl -MList::Util=shuffle -e 'print shuffle(<STDIN>);'
```

Time: 2.11 sec

Availability: medium, some of the machines might not have it

Complexity: medium, need to remember how to call perl from bash and include libraries


python
------

Python is among most popular programming languages. Nowadays it exists on nearly every machine and a lot of developers worked with it at least once. It has library to work with random numbers and shuffles. As well as perl, it could be invoked from bash.

```bash
python -c "import random, sys; lines = open(sys.argv[1]).readlines(); random.shuffle(lines); print ''.join(lines)," $FILENAME
```

Script execution is inefficient, it requires to store data in memory.

Time: 6.92 sec

Availability: medium, some of the machines might not have it

Complexity: medium, need to remember how to call python from bash and include libraries

Conclusion
----------

To sample random lines from command line, default `shuf` from core utils is probably the best choice. It is very easy to use and outperforms others in term of execution time.
However, everything depends on a task. For machine learning problems sampling is not a bottleneck and might not require fastest execution.

Appendix
--------

Gist with benchmark file:
{{< gist 34836af4fa1d6c2a0dfa >}}
