import Order "mo:base/Order";
import List "mo:base/List";

import O "Order";

module {
    public type SortedList<V> = List.List<V>;

    public func insert<V>(xs : SortedList<V>, v : V, order : O.Order<V>) : SortedList<V> {
        switch (xs) {
            case (null) { ?(v, null); };
            case (? xs) {
                let (y, ys) = xs;
                if (O.compare(order, v, y) == #less) {
                    ?(v, ?xs);
                } else {
                    ?(y, insert(ys, v, order));
                };
            };
        };
    };

    public func delete<V>(xs : SortedList<V>, v : V, eq : (V, V) -> Bool) : (?V, SortedList<V>) {
        switch (xs) {
            case (null) { (null, null); };
            case (? xs) {
                let (y, ys) = xs;
                if (eq(v, y)) { (?y, ys); }
                else {
                    let (z, zs) = delete(ys, v, eq);
                    (z, ?(y, zs));
                };
            };
        };
    };
};
