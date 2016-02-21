+++
categories = ["spark","spark mllib"]
date = "2016-02-21T00:20:45+08:00"
description = "Spark version 1.6 has been released on Jan 4th, 2016. Compared to previous version it has significant improvements. Let's cover top 5 of them."
keywords = []
title = "Top 5 features released in spark 1.6"

+++

Spark version 1.6 [has been released](https://spark.apache.org/releases/spark-release-1-6-0.html) on January 4th, 2016.
Compared to the previous version, it has significant improvements. This article covers top 5 of them.

### 1. Partition by column

The idea is to have more control on RDD's partitioning.
Sometimes data needs to be joined and grouped by certain key, such as user_id.
To minify data reshuffling, one may possible to store chunks of objects with the same key within the same data node.

This feature [exists in Hive](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+SortBy#LanguageManualSortBy-SyntaxofClusterByandDistributeBy) and has been [ported to spark](https://issues.apache.org/jira/browse/SPARK-11410).
Example of usage:

```scala
val df = sc.parallelize(Array(
    ("A", 1), ("B", 2), ("C", 3), ("A", 4)
)).toDF("key", "value")
val partitioned = df.repartition($"key")
```

### 2. GroupedData Pivot

This feature is about data presentation: if we need to transform adjacency list to adjacency matrix or convert long narrow RDD to the matrix - pivot is our friend.
Python has pivot functionality in Pandas DataFrames: [unstack](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.unstack.html#pandas.DataFrame.unstack).

```scala
val df = sc.parallelize(Array(
    ("one", "A", 1), ("one", "B", 2), ("two", "A", 3), ("two", "B", 4)
)).toDF("key1", "key2", "value")
df.show()

+----+----+-----+
|key1|key2|value|
+----+----+-----+
| one|   A|    1|
| one|   B|    2|
| two|   A|    3|
| two|   B|    4|
+----+----+-----+
```

[GroupedData.pivot](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.GroupedData) allows making values from columns *key1* or *key2* new columns.
For example:

```scala
df.groupBy("key1").pivot("key2").sum("value").show()

+----+-+-+
|key1|A|B|
+----+-+-+
| one|1|2|
| two|3|4|
+----+-+-+
```


Usually, data to be pivoted is not big and to avoid reshuffling, it makes sense to use `coalesce` first.

```scala
// Better to combine data within one data node before pivot
val groupedData = df.groupBy("key1").coalesce(1).cache()
groupedData.pivot("key2").sum("value")
```

### 3. Standard deviation calculation

Spark is not yet mature in terms of statistics calculation. For example, it does not allow to [calculate the median](https://stackoverflow.com/questions/28158729/how-can-i-calculate-exact-median-with-apache-spark#answer-28160731) value of the column. One of the reasons is that linear algorithm could not be generalized to distributed RDD.

Simple standard deviation was introduced only in spark 1.6.
A Potential problem with custom calculation could be with type overflow.
Example of usage:

    df.agg(stddev("value"))

### 4. Simplified outer join

Join operation is essential for data manipulation and filtering in both RDBMS and distributed systems.
There are different types of joins, such as inner, left outer, right outer, semi, etc.
While inner join of data was relatively easy in earlier versions of spark, all of the other types required to specify join expression.
There are even more difficulties if join uses two or more columns.

Join expressions are not that easy because they require additional DataFrame manipulations, such as column rename and further drop.
If the column has the same name in both data frames, it would not be dropped automatically and cause problems with future select.

Suppose we have another DataFrame

```scala
val df2 = sc.parallelize(Array(
    ("one", "A", 5), ("two", "A", 6)
)).toDF("key1", "key2", "value2")
df2.show()

+----+----+------+
|key1|key2|value2|
+----+----+------+
| one|   A|     5|
| two|   A|     6|
+----+----+------+
```

Outer join prior to 1.6 could only be done using join expression:

```scala
val joined = df.join(df2, df("key1") === df2("key1") && df("key2") === df2("key2"), "left_outer")
joined.show()

+----+----+-----+----+----+------+
|key1|key2|value|key1|key2|value2|
+----+----+-----+----+----+------+
| two|   A|    3| two|   A|     6|
| two|   B|    4|null|null|  null|
| one|   A|    1| one|   A|     5|
| one|   B|    2|null|null|  null|
+----+----+-----+----+----+------+
```

Result data frame has duplicated column names, any operations with them would throw an error

```scala
joined.select("key2")

org.apache.spark.sql.AnalysisException: Reference 'key2' is ambiguous, could be: key2#28, key2#34.;
```

To avoid duplication, one possible to rename columns before and drop them after the join.
The code in this case becomes messy and requires explanation.
Spark 1.6 simplifies [join](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.DataFrame) and allows to write

```scala
df.join(df2, Seq("key1", "key2"), "left_outer").show()

+----+----+-----+------+
|key1|key2|value|value2|
+----+----+-----+------+
| two|   A|    3|     6|
| two|   B|    4|  null|
| one|   A|    1|     5|
| one|   B|    2|  null|
+----+----+-----+------+
```

This syntax is much easier to read.

### 5. QuantileDiscretizer feature transformer

Feature engineering is a big part of data mining.
Usually, data scientists try a lot of different approaches and at the end run some black box algorithm, such as random forest or xgboost.
The more features generated in the beginning, the better.

[QuantileDiscretizer](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.ml.feature.QuantileDiscretizer) is still experimental, but already available.
It allows splitting feature into buckets, based on value's quantiles.


### Conclusion

Apache Spark is a dynamic project, every version brings a lot of new features.
Despite it offers excellent data manipulation tools, it is still quite weak in terms of data mining.
Spark niche is a Big Data, where familiar techniques might simply not work.

It is worthwhile to follow Spark updates.
Based on several previous versions, every one of them brought significant functionality to the tool.

