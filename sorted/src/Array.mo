import Array "mo:base/Array";
import Order "mo:base/Order";

import O "Order";

module {
    public type SortedArray<V> = [V];

    public func insert<V>(xs : SortedArray<V>, v : V, order : O.Order<V>) : SortedArray<V> {
        let l = xs.size();
        switch (l) {
            case (0) { return [v]; };
            case (l) {
                for (i in xs.keys()) {
                    let x = xs[i];
                    if (O.compare(order, v, x) == #less) {
                        return append([takeN<V>(i, xs), [v], removeN<V>(i, xs)]);
                    };
                };
            };
        };
        append([xs, [v]]);
    };

    public func delete<V>(xs : SortedArray<V>, v : V, eq : (V, V) -> Bool) : (?V, SortedArray<V>) {
        for (i in xs.keys()) {
            let x = xs[i];
            if (eq(v, x)) {
                if (i == 0) { return (?x, removeN(1, xs)); };
                return (?x, append([takeN(i : Nat, xs), removeN(i+1, xs)]));
            };
        };
        (null, xs);
    };

    private func append<T>(
        xs : [[T]],
    ) : [T] {
        var ys : [T] = [];
        for (x in xs.vals()) {
            ys := Array.append(ys, x);
        };
        ys;
    };

    private func removeN<T>(
        n : Nat,
        xs : [T],
    ) : [T] {
        Array.tabulate<T>(
            xs.size() - n,
            func (i : Nat) : T {
                xs[i + n];
            },
        );
    };

    private func takeN<T>(
        n : Nat,
        xs : [T],
    ) : [T] {
        Array.tabulate<T>(
            n,
            func (i : Nat) : T {
                xs[i];
            },
        );
    };
};
