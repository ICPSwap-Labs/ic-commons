import Principal "mo:base/Principal";
import SHA224 "mo:sha224/SHA224";
import Nat8 "mo:base/Nat8";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Blob "mo:base/Blob";
import Char "mo:base/Char";
import List "mo:base/List";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Order "mo:base/Order";
import Text "mo:base/Text";
import Prim "mo:⛔";
import CRC32 "./CRC32";
import TextUtils "./TextUtils";
import Bool "mo:base/Bool";

module {

    /**
     * Converts Principal into the Account Id string.
     */
    public func toAddress(p: Principal) : Text {
        let digest = SHA224.Digest();
        digest.write([10, 97, 99, 99, 111, 117, 110, 116, 45, 105, 100]:[Nat8]); // b"\x0Aaccount-id"
        let blob = Principal.toBlob(p);
        digest.write(Blob.toArray(blob));
        digest.write(Array.freeze<Nat8>(Array.init<Nat8>(32, 0 : Nat8))); // sub account
        let hash_bytes : [Nat8] = digest.sum();
        let crc : [Nat8] = CRC32.crc32(hash_bytes);
        let aid_bytes = addAll<Nat8>(crc, hash_bytes);

        return TextUtils.encode(aid_bytes);
    };

    /**
     * Converts Blob into the Account Id string.
     */
    public func blobToAddress(blob : Blob) : Text {
        let digest = SHA224.Digest();
        digest.write([10, 97, 99, 99, 111, 117, 110, 116, 45, 105, 100]:[Nat8]); // b"\x0Aaccount-id"
        digest.write(Blob.toArray(blob));
        digest.write(Array.freeze<Nat8>(Array.init<Nat8>(32, 0 : Nat8))); // sub account
        let hash_bytes = digest.sum();
        let crc = CRC32.crc32(hash_bytes);
        let aid_bytes = addAll<Nat8>(crc, hash_bytes);

        return TextUtils.encode(aid_bytes);
    };

    /** 
     * Converts Principal into the Principal Id string.
     */
    public func toText(p: Principal) : Text {
        return Principal.toText(p);
    };

    /**
     * Checks if the caller is empty.
     */
    public func isEmptyIdentity(caller: Principal) : Bool {
        var principal = Principal.toText(caller);
        if (principal == "2vxsx-fae") {
            return true;
        };
        return false;
    };

    private func addAll<T>(a : [T], b : [T]) : [T] {
        var result : Buffer.Buffer<T> = Buffer.Buffer<T>(0);
        for (t : T in a.vals()) {
            result.add(t);
        };
        for (t : T in b.vals()) {
            result.add(t);
        };
        return result.toArray();
    }
};