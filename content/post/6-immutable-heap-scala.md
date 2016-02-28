+++
categories = ["scala","functional programming"]
date = "2016-02-28T21:32:38+08:00"
description = ""
keywords = ["scala","immutable data structures","heap","functional programming"]
title = "Immutable heap implementation in Scala"

+++

Current [Heap](https://en.wikipedia.org/wiki/Heap_(data_structure\)) implementation in Scala ([PriorityQueue](https://github.com/scala/scala/blob/2.12.x/src/library/scala/collection/mutable/PriorityQueue.scala)) is mutable. It means that after heap manipulation, the previous state is no longer accessible. This article describes immutable heap construction based on Scala Vector.

First of all, we need to define an interface to the Heap. It should have `insert` and `extract` methods.
As far as designed data structure should be immutable, both methods should return the whole heap in addition to expected result.

There are two helper methods: `siftUp` and `siftDown`, which help to fix heap property.
Suppose we store keys in `Vector` of type `T` with implicit ordering:

```scala
class Heap[T: Ordering](val keys: Vector[T]) {
  val keyOrdering = implicitly[Ordering[T]]
  ...
}
```

This definition allows us to use arbitrary type for stored objects, including (key, value) pair and use the same code for min and max heap.

Method `siftDown` moves an element with greater value than it's children down.
Every time it selects child with minimal value and swaps current element with it.

```scala
private def siftDownKeys(keys: Vector[T], i: Int): Vector[T] = {
  while (2 * i + 1 < size) {
    val left = 2 * i + 1  // left child
    val right = left + 1  // right child
    var j = left
    if (right < size && keyOrdering.compare(keys(right), keys(left)) < 0) {j = right}
    if (keyOrdering.compare(keys(i), keys(j)) <= 0) return keys
    return siftDownKeys(swap(keys, i, j), j)
  }
  keys
}

private def siftDown(i: Int): Heap[T] = new Heap(siftDownKeys(keys, i))
```

Method `siftUp` moves an element with smaller value than it's parent up.

```scala
private def siftUpKeys(keys: Vector[T], i: Int): Vector[T] = {
  val j = (i - 1) / 2
  while (keyOrdering.compare(keys(i), keys(j)) < 0)
    return siftUpKeys(swap(keys, i, j), j)
  keys
}

private def siftUp(i: Int): Heap[T] = new Heap(siftUpKeys(keys, i))
```

Using these helper methods, it is easy to implement defined interface methods:

```scala
def insert(key: T): Heap[T] = new Heap(keys :+ key) siftUp size
def extract(): (T, Heap[T]) = (
  keys(0),
  new Heap(keys.last +: keys.tail.dropRight(1)) siftDown 0
)
```

Final [implementation](https://github.com/pavlov99/scalastructures/blob/3a938f9402ed0609c93bbfbb59e3fc83798969fc/src/main/scala/com/github/pavlov99/heap/Heap.scala) takes 74 lines, which is less than default one.
Performance is worst compared to mutable version because of the data manipulation.
