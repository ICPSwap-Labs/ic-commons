import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Char "mo:base/Char";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";

import BitwiseInt "./BitwiseInt";
import BitwiseNat "./BitwiseNat";

module {

    public let Nat256Max = 115792089237316195423570985008687907853269984665640564039457584007913129639935;

    /**
     * Converts the Int type of x into Nat.
     */
    public func toNat(x: Int) : Nat {
        if (x < 0){
            return Nat.sub(Nat256Max, toNat(Int.neq(x)));
        };
        var intArr: [Int64] = BitwiseInt.toIntArr(x, 8);
        var natVal: Nat = 0;
        for (t: Int64 in intArr.vals()) {
            natVal := BitwiseNat.bitshiftLeft(natVal, 8) + Nat64.toNat(Int64.toNat64(t));
        };
        return natVal;
    };

    func _comp(r: Int, bit: Int, m: Int): Int {
        if (BitwiseInt.bitshiftRight(r, bit - 1) == 1) {
            return -(Int.sub(m, Int.add(r, 1))) - 1;
        } else {
            return r;
        }
    };
    public func add(a: Int, b: Int, bit: Int): Int {
        assert(bit > 0);
        let max: Int = 2 ** bit;
        return _comp((a + b) % max, bit, max);
    };
    public func sub(a: Int, b: Int, bit: Int): Int {
        assert(bit > 0);
        let max: Int = 2 ** bit;
        return _comp((a - b) % max, bit, max);
    };
    public func mul(a: Int, b: Int, bit: Int): Int {
        assert(bit > 0);
        let max: Int = 2 ** bit;
        return _comp((a * b) % max, bit, max);
    };
    public func div(a: Int, b: Int, bit: Int): Int {
        assert(bit > 0);
        let max: Int = 2 ** bit;
        return _comp((a / b) % max, bit, max);
    };
};