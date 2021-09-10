# Sorted Data Structures

Data structures in which each element is sorted in numerical, alphabetical, or some other order.

## Usage

```motoko
let desc = Order.Descending(Nat.compare);
var l : SortedList.SortedList<Nat> = null;
l := SortedList.insert<Nat>(l, 0, desc);
l := SortedList.insert<Nat>(l, 1, desc);
// [1, 0];
```
