import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import List "mo:base/List";

import O "Order";
import SList "List";

module {
    public class SortedMap<K,V>(
        capacity : Nat,
        equal    : (K, K) -> Bool,
        hash     : (K) -> Hash.Hash,
        order    : O.Order<K>,
    ) {
        let map = HashMap.HashMap<K, V>(
            capacity, equal, hash,
        );
        var keys : SList.SortedList<K> = null;

        // Returns the number of entries in the map.
        public func size() : Nat = map.size();

        // Insert the value v at key k. Overwrites an existing entry with key k.
        public func put(k : K, v : V) = ignore replace(k, v);

        // Insert the value v at key k. Returns the previous value stored at
        // k or null if it didn't exist.
        public func replace(k : K, v : V) : ?V {
            let v_ = map.replace(k, v);
            let (_, keys_) = SList.delete(keys, k, equal);
            keys := SList.insert(keys_, k, order);
            v_;
        };

        // Deletes the entry with the key k. Ignores unexisting keys.
        public func delete(k : K) = ignore remove(k);

        // Removes the entry with the key k. Returns the associated value if it 
        // existed or null otherwise.
        public func remove(k : K) : ?(K, V) {
            switch (map.get(k)) {
                case (null) { null; };
                case (? v)  {
                    map.delete(k);
                    let (_, keys_) = SList.delete(keys, k, equal);
                    keys := keys_;
                    ?(k, v);
                };
            };
        };

        // Gets the entry with the key k. Returns its associated value if it
        // existed or null otherwise.
        public func get(k : K) : ?V = map.get(k);

        // Gets the key based on its index.
        public func getKey(n : Nat) : ?K {
            List.get(keys, n);
        };

        // Gets the value based on its index.
        public func getValue(n : Nat) : ?V {
            switch (getKey(n)) {
                case (null) { null; };
                case (? k)  {
                    switch (get(k)) {
                        case (null) {
                            // panic: keys and map out of sync.
                            assert(false);
                            null;
                        };
                        case (? v) { ?v; };
                    };
                };
            };
        };

        // Gets the index of the key k. Returns its associated index if it
        // existed or null otherwise.
        public func getIndex(k : K) : ?Nat {
            var i  = 0;
            var xs = keys;
            loop {
                switch(xs) {
                    case (null) { return null; };
                    case (? (y, ys)) {
                        if (equal(y, k)) return ?i;
                        xs := ys; i += 1;
                    };
                };
            };
        };

        // Returns an iterator over the key-value pairs.
        public func entries() : Iter.Iter<(K, V)> = object {
            var xs = keys;
            public func next() : ?(K, V) {
                switch (xs) {
                    case (null) { null; };
                    case (? (y, ys)) {
                        xs := ys;
                        switch (map.get(y)) {
                            case (null) { null; };
                            case (? v)  {
                                ?(y, v);
                            };
                        };
                    };
                };
            };
        };
    };

    public class SortedValueMap<K, V>(
        capacity : Nat,
        equal    : (K, K) -> Bool,
        hash     : (K) -> Hash.Hash,
        order    : O.Order<V>,
    ) {
        let map = HashMap.HashMap<K,V>(
            capacity, equal, hash,
        );
        var keys : SList.SortedList<K> = null;

        // Returns the number of entries in the map.
        public func size() : Nat = map.size();

        // Insert the value v at key k. Overwrites an existing entry with key k.
        public func put(k : K, v : V) = ignore replace(k, v);

        // Insert the value v at key k. Returns the previous value stored at
        // k or null if it didn't exist.
        public func replace(k : K, v : V) : ?V {
            let v_ = map.replace(k, v);
            let (_, keys_) = SList.delete(keys, k, equal);
            keys := _replace(keys_, k, v, order);
            v_;
        };

        private func _replace(xs : SList.SortedList<K>, k : K, v : V, order : O.Order<V>) : SList.SortedList<K> {
            switch (xs) {
                case (null) { ?(k, null); };
                case (? xs) {
                    let (y, ys) = xs;
                    switch (map.get(y)) {
                        case (null) {
                            // panic: keys and map out of sync.
                            assert(false);
                            null;
                        };
                        case (? z) {
                            if (O.compare(order, v, z) == #less) {
                                ?(k, ?xs);
                            } else {
                                ?(y, _replace(ys, k, v, order));
                            };
                        };
                    };
                };
            };
        };

        // Deletes the entry with the key k. Ignores unexisting keys.
        public func delete(k : K) = ignore remove(k);

        // Removes the entry with the key k. Returns the associated value if it 
        // existed or null otherwise.
        public func remove(k : K) : ?(K, V) {
            switch (map.get(k)) {
                case (null) { null; };
                case (? v)  {
                    map.delete(k);
                    let (_, keys_) = SList.delete(keys, k, equal);
                    keys := keys_;
                    ?(k, v);
                };
            };
        };

        // Gets the entry with the key k. Returns its associated value if it
        // existed or null otherwise.
        public func get(k : K) : ?V = map.get(k);

        // Gets the key based on its index.
        public func getKey(n : Nat) : ?K {
            List.get(keys, n);
        };

        // Gets the value based on its index.
        public func getValue(n : Nat) : ?V {
            switch (getKey(n)) {
                case (null) { null; };
                case (? k)  {
                    switch (get(k)) {
                        case (null) {
                            // panic: keys and map out of sync.
                            assert(false);
                            null;
                        };
                        case (? v) { ?v; };
                    };
                };
            };
        };

        // Gets the index of the key k. Returns its associated index if it
        // existed or null otherwise.
        public func getIndex(k : K) : ?Nat {
            var i  = 0;
            var xs = keys;
            loop {
                switch(xs) {
                    case (null) { return null; };
                    case (? (y, ys)) {
                        if (equal(y, k)) return ?i;
                        xs := ys; i += 1;
                    };
                };
            };
        };

        // Returns an iterator over the key-value pairs.
        public func entries() : Iter.Iter<(K, V)> = object {
            var xs = keys;
            public func next() : ?(K, V) {
                switch (xs) {
                    case (null) { null; };
                    case (? (y, ys)) {
                        xs := ys;
                        switch (map.get(y)) {
                            case (null) {
                                // panic: keys and map out of sync.
                                assert(false);
                                null;
                            };
                            case (? v)  {
                                ?(y, v);
                            };
                        };
                    };
                };
            };
        };
    };
};
