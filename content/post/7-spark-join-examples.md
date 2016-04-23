+++
categories = []
date = "2016-04-23T09:40:05+08:00"
description = "Examples of DataFrame jois with spark and why output sometimes looks wrong. This article covers variety of join types, including non-equi-join and slowly changing dimensions."
keywords = ["spark"]
title = "Beyond traditional join with Apache Spark"

+++

An [SQL join](https://en.wikipedia.org/wiki/Join_(SQL\)) clause combines records from two or more tables.
This operation is very common in data processing and understanding of what happens under the hood is important.
There are several common join types: `INNER`, `LEFT OUTER`, `RIGHT OUTER`, `FULL OUTER` and `CROSS` or `CARTESIAN`.

{{<img src="/images/join-types.png" alt="join types">}}

Join which uses the same table is a self-join.
If an operation uses equality operator, it is [equi-join](https://en.wikipedia.org/wiki/Join_(SQL\)#Equi-join), otherwise, it is non-equi-join.

This article covers different join types in Apache Spark as well as examples of [slowly changed dimensions (SCD)](https://en.wikipedia.org/wiki/Slowly_changing_dimension) and joins on non-unique columns.

### Sample data

All subsequent explanations on join types in this article make use of the following two tables, taken from Wikipedia article.
The rows in these tables serve to illustrate the effect of different types of joins and join-predicates.

Employees table has a nullable column. To express it in terms of statically typed Scala, one needs to use [Option](http://www.scala-lang.org/api/current/#scala.Option) type.

```scala
val employees = sc.parallelize(Array[(String, Option[Int])](
  ("Rafferty", Some(31)), ("Jones", Some(33)), ("Heisenberg", Some(33)), ("Robinson", Some(34)), ("Smith", Some(34)), ("Williams", null)
)).toDF("LastName", "DepartmentID")

employees.show()

+----------+------------+
|  LastName|DepartmentID|
+----------+------------+
|  Rafferty|          31|
|     Jones|          33|
|Heisenberg|          33|
|  Robinson|          34|
|     Smith|          34|
|  Williams|        null|
+----------+------------+
```

Department table does not have nullable columns, type specification could be omitted.

```scala
val departments = sc.parallelize(Array(
  (31, "Sales"), (33, "Engineering"), (34, "Clerical"),
  (35, "Marketing")
)).toDF("DepartmentID", "DepartmentName")

departments.show()

+------------+--------------+
|DepartmentID|DepartmentName|
+------------+--------------+
|          31|         Sales|
|          33|   Engineering|
|          34|      Clerical|
|          35|     Marketing|
+------------+--------------+
```

### Inner join

Following SQL code

```SQL
SELECT *
FROM employee 
INNER JOIN department
ON employee.DepartmentID = department.DepartmentID;
```

could be written in Spark as

```scala
employees
  .join(departments, "DepartmentID")
  .show()

+------------+----------+--------------+
|DepartmentID|  LastName|DepartmentName|
+------------+----------+--------------+
|          31|  Rafferty|         Sales|
|          33|     Jones|   Engineering|
|          33|Heisenberg|   Engineering|
|          34|  Robinson|      Clerical|
|          34|     Smith|      Clerical|
+------------+----------+--------------+
```

Beautiful, is not it? Spark automatically removes duplicated "DepartmentID" column, so column names are unique and one does not need to use table prefix to address them.

### Left outer join

Left outer join is a very common operation, especially if there are nulls or gaps in a data.
Note, that column name should be wrapped into scala `Seq` if join type is specified.

```scala
employees
  .join(departments, Seq("DepartmentID"), "left_outer")
  .show()

+------------+----------+--------------+
|DepartmentID|  LastName|DepartmentName|
+------------+----------+--------------+
|          31|  Rafferty|         Sales|
|          33|     Jones|   Engineering|
|          33|Heisenberg|   Engineering|
|          34|  Robinson|      Clerical|
|          34|     Smith|      Clerical|
|        null|  Williams|          null|
+------------+----------+--------------+
```

### Other join types

Spark allows using following join types: `inner`, `outer`, `left_outer`, `right_outer`, `leftsemi`.
The interface is the same as for left outer join in the example above.

For cartesian join column specification should be omitted:

```scala
employees
  .join(departments)
  .show(10)

+----------+------------+------------+--------------+
|  LastName|DepartmentID|DepartmentID|DepartmentName|
+----------+------------+------------+--------------+
|  Rafferty|          31|          31|         Sales|
|  Rafferty|          31|          33|   Engineering|
|  Rafferty|          31|          34|      Clerical|
|  Rafferty|          31|          35|     Marketing|
|     Jones|          33|          31|         Sales|
|     Jones|          33|          33|   Engineering|
|     Jones|          33|          34|      Clerical|
|     Jones|          33|          35|     Marketing|
|Heisenberg|          33|          31|         Sales|
|Heisenberg|          33|          33|   Engineering|
+----------+------------+------------+--------------+
only showing top 10 rows
```

Warning: do not use cartesian join with big tables in production.

### Join expression, slowly changing dimensions and non-equi join

Spark allows us to specify join expression instead of a sequence of columns.
In general, expression specification is less readable, so why do we need such flexibility? 
The reason is non-equi join.

One application of it is slowly changing dimensions.
Assume there is a table with product prices over time:

```scala
val products = sc.parallelize(Array(
  ("steak", "1990-01-01", "2000-01-01", 150),
  ("steak", "2000-01-02", "2020-01-01", 180),
  ("fish", "1990-01-01", "2020-01-01", 100)
)).toDF("name", "startDate", "endDate", "price")

products.show()

+-----+----------+----------+-----+
| name| startDate|   endDate|price|
+-----+----------+----------+-----+
|steak|1990-01-01|2000-01-01|  150|
|steak|2000-01-02|2020-01-01|  180|
| fish|1990-01-01|2020-01-01|  100|
+-----+----------+----------+-----+
```

There are two products only: steak and fish, price of steak has been changed once.
Another table consists of product orders by day:

```scala
val orders = sc.parallelize(Array(
  ("1995-01-01", "steak"),
  ("2000-01-01", "fish"),
  ("2005-01-01", "steak")
)).toDF("date", "product")

orders.show()

+----------+-------+
|      date|product|
+----------+-------+
|1995-01-01|  steak|
|2000-01-01|   fish|
|2005-01-01|  steak|
+----------+-------+
```

Our goal is to assign an actual price for every record in the orders table.
It is not obvious to do using only equality operators, however, spark join expression allows us to achieve the result in an elegant way:

```scala
orders
  .join(products, $"product" === $"name" && $"date" >= $"startDate" && $"date" <= $"endDate")
  .show()

+----------+-------+-----+----------+----------+-----+
|      date|product| name| startDate|   endDate|price|
+----------+-------+-----+----------+----------+-----+
|2000-01-01|   fish| fish|1990-01-01|2020-01-01|  100|
|1995-01-01|  steak|steak|1990-01-01|2000-01-01|  150|
|2005-01-01|  steak|steak|2000-01-02|2020-01-01|  180|
+----------+-------+-----+----------+----------+-----+
```

This technique is very useful, yet not that common.
It could save a lot of time for those who write as well as for those who read the code.

### Inner join using non primary keys

Last part of this article is about joins on non unique columns and common mistakes related to it.
Join (intersection) diagrams in the beginning of this article stuck in our heads.
Because of visual comparison of sets intersection we assume, that result table after inner join should be smaller, than any of the source tables.
This is correct only for joins on unique columns and wrong if columns in both tables are not unique.
Consider following DataFrame with duplicated records and its self-join:

```scala
val df = sc.parallelize(Array(
  (0), (1), (1)
)).toDF("c1")

df.show()
df.join(df, "c1").show()

// Original DataFrame
+---+
| c1|
+---+
|  0|
|  1|
|  1|
+---+

// Self-joined DataFrame
+---+
| c1|
+---+
|  0|
|  1|
|  1|
|  1|
|  1|
+---+
```

Note, that size of the result DataFrame is bigger than the source size. It could be as big as n<sup>2</sup>, where n is a size of source.

### Conclusion

The article covered different join types implementations with Apache Spark, including join expressions and join on non-unique keys.

Apache Spark allows developers to write the code in the way, which is easier to understand. It improves code quality and maintainability.
