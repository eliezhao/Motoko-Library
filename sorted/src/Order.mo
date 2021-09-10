import Order "mo:base/Order";

module {
    public type Order<V> = {
        #Ascending  : (V, V) -> Order.Order;
        #Descending : (V, V) -> Order.Order;
    };

    public func Ascending<V>(compare : (V, V) -> Order.Order) : Order<V> {
        #Ascending(compare);
    };

    public func Descending<V>(compare : (V, V) -> Order.Order) : Order<V> {
        #Descending(func (a : V, b : V) : Order.Order {
            switch (compare(a, b)) {
                case (#less)    { #greater; };
                case (#equal)   { #equal;   };
                case (#greater) { #less;    };
            }
        });
    };

    public func compare<V>(o : Order<V>, a : V, b : V) : Order.Order {
        switch (o) {
            case (#Ascending(c))  { c(a, b); };
            case (#Descending(c)) { c(a, b); };
        };
    };
};
