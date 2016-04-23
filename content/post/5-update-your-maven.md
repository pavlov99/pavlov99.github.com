+++
categories = ["maven","build manager","mvn"]
date = "2016-02-22T20:09:47+08:00"
description = "Install proper maven version on your computer, howto."
keywords = []
title = "How to update your maven"

+++

Maven is a popular build manager in java world. It is used to build Apache Spark, for example.
Here is correct deb repository with latest version:

```bash
sudo apt-get purge maven maven2 maven3
sudo apt-add-repository ppa:andrei-pozolotin/maven3
sudo apt-get update
sudo apt-get install maven3
```

Version available at the time of writing is `3.3.9`.
