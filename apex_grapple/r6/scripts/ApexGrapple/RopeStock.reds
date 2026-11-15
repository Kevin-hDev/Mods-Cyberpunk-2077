// Our rope's pieces of one length (PiecesData.reds): the long ones, laid along most of the rope, and the short ones,
// one turn of the twist, laid on the spans too short for a long one (RopeHang.reds, ApexGrappleOnePiece), where a long
// piece squashed to a few centimetres lost its twisted strands: the curve out of the launcher's barrel (enquête 13).
// Each frame takes a stock's pieces from its first on, so the pieces shown are always its first `shown`.

@if(ModuleExists("Codeware"))
public class ApexGrappleRopeStock extends IScriptable {
  // Strong pointers, as the hook's: see ApexGrapplePiecesSet.
  public let pieces: array<ref<MeshComponent>>;
  public let length: Float;
  public let shown: Int32;
  public let taken: Int32;

  public static func Create(count: Int32, length: Float) -> ref<ApexGrappleRopeStock> {
    let stock: ref<ApexGrappleRopeStock> = new ApexGrappleRopeStock();
    ArrayResize(stock.pieces, count);
    stock.length = length;
    return stock;
  }
}

// A piece of our entity files taken into the stock when its name is the stock's prefix and its number in the stock
// (fabrique/cr2w_json.py).
@if(ModuleExists("Codeware"))
public func ApexGrappleStockPiece(stock: ref<ApexGrappleRopeStock>, mesh: ref<MeshComponent>, name: String, prefix: String) -> Bool {
  if !StrBeginsWith(name, prefix) {
    return false;
  }
  let index: Int32 = StringToInt(StrAfterFirst(name, prefix), -1);
  if index < 0 || index >= ArraySize(stock.pieces) {
    return false;
  }
  stock.pieces[index] = mesh;
  return true;
}

// The stock's next piece put in place and shown if it was hidden; false when the stock has none left.
@if(ModuleExists("Codeware"))
public func ApexGrappleStockLay(stock: ref<ApexGrappleRopeStock>, at: Vector4, turn: Quaternion, stretch: Vector3) -> Bool {
  if stock.taken >= ArraySize(stock.pieces) {
    return false;
  }
  let piece: ref<MeshComponent> = stock.pieces[stock.taken];
  piece.SetLocalTransform(at, turn);
  piece.visualScale = stretch;
  if stock.taken >= stock.shown {
    piece.Toggle(true);
  }
  stock.taken = stock.taken + 1;
  return true;
}

// The pieces shown last frame and not taken this one hidden, and the stock ready for the next frame.
@if(ModuleExists("Codeware"))
public func ApexGrappleStockSettle(stock: ref<ApexGrappleRopeStock>) -> Void {
  let i: Int32 = stock.taken;
  while i < stock.shown {
    let extra: ref<MeshComponent> = stock.pieces[i];
    extra.Toggle(false);
    i = i + 1;
  }
  stock.shown = stock.taken;
  stock.taken = 0;
}

@if(ModuleExists("Codeware"))
public func ApexGrappleStockHide(stock: ref<ApexGrappleRopeStock>) -> Void {
  stock.taken = 0;
  ApexGrappleStockSettle(stock);
}
