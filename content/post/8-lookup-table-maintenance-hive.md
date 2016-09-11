+++
categories = ["hive","infrastructure","maintenance"]
date = "2016-09-10T20:15:41+08:00"
description = "Often analysts would use lookup tables for data manipulation. It is common, that such tables are maintained manually. This post reveals how to make this process easy and yet flexible using Hadoop and Hive external tables and Hive views."
keywords = ["hive","csv","maintenance","lookup"]
title = "Lookup table maintenance in Hive"

+++

{{<img src="/images/hive-lookup-tables-logo.png" alt="data example">}}

A *lookup table* is a translation table, aimed to enrich and extend base data.
Such tables are very common, especially in data warehousing (schema normalisation) and business analytics area.
Usually, they are updated manually and developers are constantly looking for the ways to simplify maintenance.

This article shows how to work with lookup tables in Hive using National Hockey League open data.

### Data

Let's consider the following example: base table consists of [San Jose Sharks 2016-2017 NHL season schedule](http://sharks.nhl.com/club/page.htm?id=81102).
The table consists of records with game date, start time and description of a competitor.
Initial CSV file with schedule has the following format:

{{<img src="/images/san-jose-nhl-schedule-2016-2017-example.png" alt="data example">}}

Each team in NHL belongs to one of the four divisions, for example, San Jose is in Pacific.
Teams within the same division play more often than teams from different divisions.
Our goal is to analyse, how many games are played against each of four divisions teams.


Base table with the schedule is located in a database already, but it does not have information about divisions.
If data is small, then one can use SQL expression to add necessary information: "if team == xxx then division = yyy"
However this is not the case. There are 30 teams in NHL and nobody would write such a big query.

A way to go is to manually create a small table with team-to-division mapping and join it with original data.
The other question is in maintenance – even small data needs to be updated time to time.
One of the best tool to use for lookup data manipulation is Excel because it exists nearly everywhere and a lot of people know how to work with it.
Data from Excel is exported to CSV and uploaded to Hadoop.
This is a general idea, let's talk about the details.

### Schedule data in Hadoop

The data is taken from official NHL site and uploaded to Hadoop as a CSV file.
To read it I use [spark-csv](http://github.com/databricks/spark-csv) library.
In order to extract dates from strings and extract actual competitor name, I use the following code:

```scala
val schedule = sqlContext.read
  .format("com.databricks.spark.csv")
  .option("header", "true")
  .option("inferSchema", "true")
  .load("lookup-example/san-jose-schedule-2016-2017.csv")
  .select(
    to_date(
      unix_timestamp($"START_DATE", "MM/dd/yyyy").cast("timestamp")
    ) as "date",
    when(
      locate("San Jose", $"SUBJECT") === 1,
      regexp_extract($"SUBJECT", "^San Jose at (.*)$", 1)
    ).otherwise(
      regexp_extract($"SUBJECT", "^(.*) at San Jose$", 1)
    ) as "competitor"
  )
```

So, schedule DataFrame has two columns: date and competitor.

### Lookup table

To add division information to each team we would create a table *teams.xlsx* in Excel (from [Wikipedia](https://en.wikipedia.org/wiki/National_Hockey_League#List_of_teams)):

{{<img src="/images/lookup-example-nhl-teams.png" alt="lookup table example">}}

Then one need to upload exported *teams.csv* to Hadoop as shown on the workflow below:

{{<img src="/images/lookup-table-hive.png" alt="lookup table example">}}

Next step is to add lookup data to Hive. It ensures that schema is persistent, so data update would not change it.
One may possible to read lookup table with spark-csv as we did with base table, but every single time it would require proper type cast if a schema is not inferred correctly.

Since the data is already stored in Hadoop, there is no need to copy it to Hive. External table would work:

```hive
CREATE EXTERNAL TABLE IF NOT EXISTS lookup_example_nhl_ext(
    team String,
    division String,
    conference String)
  COMMENT 'NHL teams'
  ROW FORMAT DELIMITED
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  STORED AS TEXTFILE
  LOCATION 'hdfs:///user/<user>/lookup-example/nhl-lookup'
  TBLPROPERTIES ("skip.header.line.count"="1");
```

Note, that

  * LOCATION field should have full file address in Hadoop,
  * LOCATION address is a folder with one CSV file in it,
  * Data header should be skipped in table properties ("skip.header.line.count"="1").

This external table works fine in Hive

```hive
select * from lookup_example_nhl_ext limit 5;
OK
Boston Bruins Atlantic  Eastern Conference
Buffalo Sabres Atlantic Eastern Conference
Detroit Red Wings   Atlantic    Eastern Conference
Florida Panthers    Atlantic    Eastern Conference
Montreal Canadiens  Atlantic    Eastern Conference
Time taken: 0.1 seconds, Fetched: 5 row(s)
```

But it does not work with `HiveContext` in spark. For some reason it keeps header row (Team,Division,Conference):

```scala
sqlContext.table("lookup_example_nhl_ext").limit(2).show()

+-------------+--------+------------------+
|         team|division|        conference|
+-------------+--------+------------------+
|         Team|Division|        Conference|
|Boston Bruins|Atlantic|Eastern Conference|
+-------------+--------+------------------+
```

One way to fix it is to create a Hive view, which filters the data.
Based on my observations, data warehouse techniques are penetrating into Hive (which is an unstructured data warehouse, by the way).
One of them is to maintain source tables as they are and read the data only from views. It aims to simplify data structure update.
Because of the same reason, I advocate Hive views, even if they implement simple logic, such as in our case:

```hive
CREATE VIEW IF NOT EXISTS lookup_example_nhl
AS
SELECT *
FROM lookup_example_nhl_ext
WHERE team != 'Team';
```

Now `HiveContext` reads the data without header, so the issue is fixed.

### Join data with lookup table

At this point of time, it should be easy to join the data and get the result.
However, schedule and lookup tables have different team names: base table has either city or competitor name.
To ensure that all of the code examples work here is a fix: add `short_name` to the lookup table, which is either first, last or first two words from the team name.


```scala
val teams = sqlContext.table("lookup_example_nhl")
  .withColumn("short_name",
    when(
      locate("New York", $"team") === 1,
      regexp_extract($"team", "\\w+$", 0)
    ).when(
      (locate("Devils", $"team") > 0) ||
      (locate("Kings", $"team") > 0) ||
      (locate("Sharks", $"team") > 0) ||
      (locate("Blues", $"team") > 0),
      regexp_extract($"team", "^(.*) \\w+", 1)
    ).otherwise(regexp_extract($"team", "^\\w+", 0))
  )

teams.show()

+--------------------+------------+------------------+------------+
|                team|    division|        conference|  short_name|
+--------------------+------------+------------------+------------+
|       Boston Bruins|    Atlantic|Eastern Conference|      Boston|
|      Buffalo Sabres|    Atlantic|Eastern Conference|     Buffalo|
|   Detroit Red Wings|    Atlantic|Eastern Conference|     Detroit|
|    Florida Panthers|    Atlantic|Eastern Conference|     Florida|
|  Montreal Canadiens|    Atlantic|Eastern Conference|    Montreal|
|     Ottawa Senators|    Atlantic|Eastern Conference|      Ottawa|
| Tampa Bay Lightning|    Atlantic|Eastern Conference|       Tampa|
| Toronto Maple Leafs|    Atlantic|Eastern Conference|     Toronto|
| Carolina Hurricanes|Metropolitan|Eastern Conference|    Carolina|
|Columbus Blue Jac...|Metropolitan|Eastern Conference|    Columbus|
+--------------------+------------+------------------+------------+
```

Now `short_name` is almost the same as `competitor`.
One need to do a "fuzzy" join.
Check out [join expressions]({{< relref "7-spark-join-examples.md#join-expression-slowly-changing-dimensions-and-non-equi-join" >}}) for more information.
We would do join based on [Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance), which is 0 for exactly the same strings and small for nearly the same.
There is no golden rule for such join, but initial distance should be big enough to find fuzzy lookup match and small enough to not cartesian-join both tables.
Result table could have several lookup teams for one original. To filter wrong matches, we would use window function, which keeps only match with lower Levenshtein distance.

```scala
import org.apache.spark.sql.Window

val competitorWindow = Window
  .partitionBy("date", "competitor")
  .orderBy(levenshtein($"competitor", $"short_name"))

val scheduleRich = schedule
  .join(
    teams, levenshtein($"competitor", $"short_name") < 5, "left_outer"
  )
  .withColumn("_rank", row_number().over(competitorWindow))
  .filter($"_rank" === 1)
  .drop("_rank")

scheduleRich.drop("short_name").show(2)

+----------+----------+---------------+--------+------------------+
|      date|competitor|           team|division|        conference|
+----------+----------+---------------+--------+------------------+
|2016-10-05|   Anaheim|  Anaheim Ducks| Pacific|Western Conference|
|2016-10-09|   Anaheim|  Anaheim Ducks| Pacific|Western Conference|
+----------+----------+---------------+--------+------------------+
```

Finally, schedule data is enriched and one may possible to compute the result:

```scala
scheduleRich.groupBy("division").count().orderBy($"count".desc).show()

+------------+-----+
|    division|count|
+------------+-----+
|     Pacific|   36|
|     Central|   20|
|    Atlantic|   16|
|Metropolitan|   16|
+------------+-----+
```

As expected, San Jose plays more games against other teams from Pacific division, but there are also slightly more games against Central division teams.
Did you know it before?

### Conclusion

This tutorial has shown, how to deal with lookup tables with Hadoop and Hive, including header row fix.

