import List "mo:base/List";
import Nat "mo:base/Nat";
import O "../src/Order";
import Order "mo:base/Order";
import SList "../src/List";

do {
    let desc = O.Descending(Nat.compare);
    var l : SList.SortedList<Nat> = null;
    l := SList.insert<Nat>(l, 0, desc);
    assert(List.toArray(l) == [0]);
    l := SList.insert<Nat>(l, 1, desc);
    assert(List.toArray(l) == [1, 0]);
};

do {
    type X = (Text, Nat);

    // Insert.
    func compare(x : X, y : X) : Order.Order {
        let (_, a) = x;
        let (_, b) = y;
        Nat.compare(a, b);
    };
    let desc = O.Descending(compare);
    var l : SList.SortedList<X> = null;
    l := SList.insert<X>(l, ("a", 1), desc);
    l := SList.insert<X>(l, ("b", 0), desc);
    l := SList.insert<X>(l, ("c", 2), desc);
    assert(List.toArray(l) == [("c", 2), ("a", 1), ("b", 0)]);

    // Delete
    func eq(x : X, y : X) : Bool {
        let (_, a) = x;
        let (_, b) = y;
        a == b;
    };
    let (a, l_) = SList.delete(l, ("a", 1), eq);
    l := l_;
    assert(a == ?("a", 1));
    assert(List.toArray(l) == [("c", 2), ("b", 0)]);
    let (n, _) = SList.delete(l, ("a", 1), eq);
    assert(n == null);
};
