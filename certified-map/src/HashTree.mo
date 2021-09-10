import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import SHA256 "mo:sha/SHA256";
import Text "mo:base/Text";

module {
    public type Hash  = Blob;
    public type Label = Blob;

    public type HashTree = {
        #Empty;
        #Fork    : (HashTree, HashTree);
        #Labeled : (Label,    HashTree);
        #Leaf    : Blob;
        #Pruned  : Hash;
    };

    public func reconstruct(t : HashTree) : Hash {
        switch (t) {
            case (#Empty) {
                let h = domainSeperator("ic-hashtree-empty");
                Blob.fromArray(SHA256.sum256(
                    Blob.toArray(h),
                ));
            };
            case (#Fork(t1, t2)) {
                let h = domainSeperator("ic-hashtree-fork");
                Blob.fromArray(SHA256.sum256(
                    append([h, reconstruct(t1), reconstruct(t2)]),
                ));
            };
            case (#Labeled(l, t)) {
                labeledHash(l, reconstruct(t));
            };
            case (#Leaf(v)) {
                leafHash(v);
            };
            case (#Pruned(h)) {
                h;
            };
        };
    };

    public func labeledHash(l : Label, content : Hash) : Hash {
        Blob.fromArray(SHA256.sum256(
            append([domainSeperator("ic-hashtree-labeled"), l, content]),
        ));
    };

    public func leafHash(content : Blob) : Hash {
        Blob.fromArray(SHA256.sum256(
            append([domainSeperator("ic-hashtree-leaf"), content]),
        ));
    };

    private func append(xs : [Blob]) : [Nat8] {
        var ys = Blob.toArray(xs[0]);
        for (i in Iter.range(1, xs.size()-1)) {
            ys := Array.append(ys, Blob.toArray(xs[i]));
        };
        ys;
    };

    private func domainSeperator(t : Text) : Blob {
        Blob.fromArray(Array.append(
            [Nat8.fromNat(t.size())],
            Blob.toArray(Text.encodeUtf8(t)),
        ));
    };
};
