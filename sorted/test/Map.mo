import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Map "../src/Map";
import Nat "mo:base/Nat";
import O "../src/Order";
import Text "mo:base/Text";

import Debug "mo:base/Debug";

do {
    let m = Map.SortedMap<Nat, Text>(
        0, Nat.equal, Hash.hash,
        O.Descending(Nat.compare),
    );
    m.put(1, "a");
    m.put(0, "b");
    m.put(2, "c");
    assert(Iter.toArray(m.entries()) == [(2, "c"), (1, "a"), (0, "b")]);
    assert(m.remove(1) == ?(1, "a"));
    assert(Iter.toArray(m.entries()) == [(2, "c"), (0, "b")]);
    assert(m.remove(1) == null);

    assert(m.getIndex(1) == null);
    assert(m.getIndex(0) == ?1);
    assert(m.getKey(1) == ?0);
    assert(m.getValue(1) == ?"b");
};

do {
    let m = Map.SortedValueMap<Nat, Text>(
        0, Nat.equal, Hash.hash,
        O.Ascending(Text.compare),
    );
    m.put(1, "a");
    m.put(0, "b");
    m.put(2, "c");
    assert(Iter.toArray(m.entries()) == [(1, "a"), (0, "b"), (2, "c")]);
    assert(m.remove(0) == ?(0, "b"));
    assert(Iter.toArray(m.entries()) == [(1, "a"), (2, "c")]);
    assert(m.remove(0) == null);

    assert(m.getIndex(0) == null);
    assert(m.getIndex(2) == ?1);
    assert(m.getKey(1) == ?2);
    assert(m.getValue(1) == ?"c");
};
