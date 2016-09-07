+++
categories = ["hive","infrastructure","maintenance"]
date = "2016-09-07T20:15:41+08:00"
description = "Often analysts would use lookup tables for data manipulation. It is common, that such tables are maintained manually. This post reveals how to make this process easy and yet flexible using Hadoop and Hive external tables and views."
keywords = ["hive","csv","maintenance","lookup"]
title = "Lookup table maintenance in Hive"

+++

Lookup table is a translation table, aimed to enrich and extend base data.
Such tables are very common, especially in data warehousing (schema normalization) and business analytics area.
Usually they are mainteined manually and developers are constantly looking for the ways to simplify this process.



Let's consider an example: base table consists of [San Jose Sharks 2016-2017 NHL season schedule](http://sharks.nhl.com/club/page.htm?id=81102).
The goal is to analyze, how many games are played against each of four divisions teams.

{{<img src="/images/san-jose-nhl-schedule-2016-2017-example.png" alt="data example">}}

This table is located in a database already, but there is no information about divisions.
If data is small, then one can use SQL expression "if team == xxx then division = yyy"
However this is not the case. There are 30 teams and nobody would write such big query.
A way to go is to manually create small table and join it with original data. The other question is in maintenance – even small data needs to be updated time to time. One of the best tool to use for lookup data manipulation is Excel because it exists nearly everywhere and a lot of people know how to work with it. Data from Excel is exported to csv and uploaded to Hadoop. This is a general idea, lets talk about the details.

Full lookup table in Excel looks like 

{{<img src="/images/lookup-example-nhl-teams.png" alt="lookup table example">}}




Example of base data and lookup (shop transactions and product categories)

Could we do if-when? It is easier to use table.

How to upload such table? How to maintain? Excel and dump to csv.

csv with schema, better to use hive and external table.

hive view.


Often such tables are maintaned manually. For example

Often analysts would use lookup tables for data manipulation. It is common, that such
tables are maintained manually in Excel. 
