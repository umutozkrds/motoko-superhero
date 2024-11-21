import List "mo:base/List";
import Option "mo:base/Option";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";

actor Superkahraman {

  public type SuperkahramanId = Nat32;
  public type Superkahraman = {
    isim : Text;
    supergucler : List.List<Text>;
    aktif : Bool; // Yeni özellik: Süperkahramanın aktiflik durumu
  };

  private stable var next : SuperkahramanId = 0;
  private stable var superkahramanlar : Trie.Trie<SuperkahramanId, Superkahraman> = Trie.empty();

  public func create(superkahraman : Superkahraman) : async SuperkahramanId {
    let superkahramanId = next;
    next += 1;
    superkahramanlar := Trie.replace(
      superkahramanlar,
      key(superkahramanId),
      Nat32.equal,
      ?superkahraman
    ).0;
    return superkahramanId;
  };

  public query func read(superkahramanId : SuperkahramanId) : async ?Superkahraman {
    return Trie.find(superkahramanlar, key(superkahramanId), Nat32.equal);
  };

  public func update(superkahramanId : SuperkahramanId, superkahraman : Superkahraman) : async Bool {
    let exists = Option.isSome(Trie.find(superkahramanlar, key(superkahramanId), Nat32.equal));
    if (exists) {
      superkahramanlar := Trie.replace(
        superkahramanlar,
        key(superkahramanId),
        Nat32.equal,
        ?superkahraman
      ).0;
    };
    return exists;
  };

  public func delete(superkahramanId : SuperkahramanId) : async Bool {
    let exists = Option.isSome(Trie.find(superkahramanlar, key(superkahramanId), Nat32.equal));
    if (exists) {
      superkahramanlar := Trie.remove(superkahramanlar, key(superkahramanId), Nat32.equal);
    };
    return exists;
  };

  public query func list() : async List.List<{id: SuperkahramanId; isim: Text}> {
    return Trie.toList(superkahramanlar).map(
      func ((id, kahraman)) {
        { id = id; isim = kahraman.isim };
      }
    );
  };

  private func key(x : SuperkahramanId) : Trie.Key<SuperkahramanId> {
    return {hash = x; key = x};
  };
}
