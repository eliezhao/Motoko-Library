import Array "mo:base/Array";
import Nat "mo:base/Nat";
import O "../src/Order";
import Order "mo:base/Order";
import SArray "../src/Array";

do {
    let desc = O.Descending(Nat.compare);
    var l : SArray.SortedArray<Nat> = [];
    l := SArray.insert<Nat>(l, 0, desc);
    assert(l == [0]);
    l := SArray.insert<Nat>(l, 1, desc);
    assert(l == [1, 0]);
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
    var l : SArray.SortedArray<X> = [];
    l := SArray.insert<X>(l, ("a", 1), desc);
    l := SArray.insert<X>(l, ("b", 0), desc);
    l := SArray.insert<X>(l, ("c", 2), desc);
    assert(l == [("c", 2), ("a", 1), ("b", 0)]);

    // Delete
    func eq(x : X, y : X) : Bool {
        let (_, a) = x;
        let (_, b) = y;
        a == b;
    };
    let (a, l_) = SArray.delete(l, ("a", 1), eq);
    l := l_;
    assert(a == ?("a", 1));
    assert(l == [("c", 2), ("b", 0)]);
    let (n, _) = SArray.delete(l, ("a", 1), eq);
    assert(n == null);
};
