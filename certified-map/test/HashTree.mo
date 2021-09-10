import Blob "mo:base/Blob";
import Hex "mo:encoding/Hex";
import Nat8 "mo:base/Nat8";
import SHA256 "mo:sha/SHA256";
import Text "mo:base/Text";

import HashTree "../src/HashTree";

import Debug "mo:base/Debug";

func b(t : Text) : Blob {
    Text.encodeUtf8(t);
};

// Source: https://sdk.dfinity.org/docs/interface-spec/index.html#_example

// ─┬─┬╴"a" ─┬─┬╴"x" ─╴"hello"
//  │ │      │ └╴Empty
//  │ │      └╴  "y" ─╴"world"
//  │ └╴"b" ──╴"good"
//  └─┬╴"c" ──╴Empty
//    └╴"d" ──╴"morning"
let x : HashTree.HashTree = #Fork(
    #Labeled(b("x"), #Leaf(b("hello"))),
    #Empty,
);
assert(
    Hex.encode(Blob.toArray(HashTree.reconstruct(x)))
    == "1B4FEFF9BEF8131788B0C9DC6DBAD6E81E524249C879E9F10F71CE3749F5A638",
);

let bt : HashTree.HashTree = #Leaf(b("good"));
assert(
    Hex.encode(Blob.toArray(HashTree.reconstruct(bt)))
    == "7B32AC0C6BA8CE35AC82C255FC7906F7FC130DAB2A090F80FE12F9C2CAE83BA6",
);

let c : HashTree.HashTree = #Labeled(b("c"), #Empty);
assert(
    Hex.encode(Blob.toArray(HashTree.reconstruct(c)))
    == "EC8324B8A1F1AC16BD2E806EDBA78006479C9877FED4EB464A25485465AF601D",
);

let tree : HashTree.HashTree = #Fork(
    #Fork(
        #Labeled(b("a"), #Fork(
            x,
            #Labeled(b("y"), #Leaf(b("world"))),
        )),
        #Labeled(b("b"), bt),
    ),
    #Fork(
        c,
        #Labeled(b("d"), #Leaf(b("morning"))),
    ),
);

assert(
    Hex.encode(Blob.toArray(HashTree.reconstruct(tree)))
    == "EB5C5B2195E62D996B84C9BCC8259D19A83786A2F59E0878CEC84C811F669AA0"
);
