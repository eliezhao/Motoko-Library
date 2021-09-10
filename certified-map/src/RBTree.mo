import Order "mo:base/Order";

import HashTree "HashTree";

module {
    public type Color = {
        #Red;
        #Black;
    };

    private func flip(c : Color) : Color {
        switch (c) {
            case (#Red)   { #Black; };
            case (#Black) { #Red;   };
        };
    };

    public type Node = {
        key   : Blob;
        value : Blob;
        left  : ?Node;
        right : ?Node;
        color : Color;
        hash  : HashTree.Hash;
    };

    // Returns a new node based on the given key and value.
    public func newNode(key : Blob, value : Blob) : Node {
        let hash = HashTree.labeledHash(
            key,
            HashTree.leafHash(value),
        );
        {
            key;
            value;
            left  = null;
            right = null;
            color = #Red;
            hash;
        };
    };

    // Returns the HashTree corresponding to the node.
    // 1. #Empty if null.
    // 2. #Pruned(hash) otherwise.
    public func getHashTree(n : ?Node) : HashTree.HashTree {
        switch (n) {
            case (null) { #Empty;          };
            case (? n)  { #Pruned(n.hash); };
        };
    };

    // Returns #Labeled(key, #Leaf(value)).
    public func getDataTree(n : Node) : HashTree.HashTree {
        #Labeled(n.key, #Leaf(n.value));
    };

    // Hashes the data contained within the node.
    public func dataHash(n : Node) : HashTree.Hash {
        HashTree.labeledHash(n.key, HashTree.leafHash(n.value));
    };
};
