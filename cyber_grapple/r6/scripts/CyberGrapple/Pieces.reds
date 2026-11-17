// Made by fabrique/grapple.py from Apex Grapple's Pieces.reds, never edited by hand: change it there,
// then run python -I fabrique/grapple.py (fabrique/test_grapple.py fails while this file is out of date).
// Our pieces in the game: the hook and the rope's pieces spread over our entity files (PiecesData.reds), asked of
// Codeware's StaticEntitySystem (objects with no AI) from the first frame with the mod on, everything hidden until a
// shot needs it. One set: a new shot waits for the last hook to be home (CyberGrappleHookStillOut). A system attaches
// again at each load (Hook.reds): the pieces are asked for again, any left by the load removed first by their tag.
// The files are asked for one at a time, each once the one before is there: the game builds an entity's pieces into a
// list of 192 places with no check, and one file of 221 pieces crashed it. Whether two entities built in one go would
// share that list is not known.

public func CyberGrapplePiecesTag() -> CName {
  return n"CyberGrapplePieces";
}

public func CyberGrapplePiecesFiles() -> Int32 {
  let files: array<ResRef> = CyberGrapplePiecesEntities();
  return ArraySize(files);
}

// Seconds of game time after which the log says once that the pieces are late.
public func CyberGrapplePiecesLate() -> Float {
  return 10.0;
}

@if(ModuleExists("Codeware"))
public class CyberGrapplePiecesSet extends IScriptable {
  public let entities: array<wref<Entity>>;
  public let found: Int32;
  // Kept by strong pointers, against rule 3 of optimisation.md, on purpose (Kevin, 10 November 2026): they are pieces of
  // our own entities, which CyberGrapplePiecesAlive checks through weak pointers at each frame before any use; weak
  // pointers here would add more than 200 checks a frame for no risk seen either way.
  public let hook: ref<MeshComponent>;
  // The rope's long pieces and its short ones (RopeStock.reds).
  public let rope: ref<CyberGrappleRopeStock>;
  public let ropeShort: ref<CyberGrappleRopeStock>;
  public let hookShown: Bool;
  public let shot: ref<CyberGrappleHookShot>;
  public let bends: ref<CyberGrappleRopeBends>;
  public let hang: ref<CyberGrappleRopeHangs>;
  // Worked out again at each frame, kept rather than made anew (RopeHang.reds, RopeMotion.reds).
  public let laid: ref<CyberGrappleRopeLaid>;
  public let table: ref<CyberGrappleHangTable>;
  // For the log, over one shot.
  public let mostPieces: Int32;
  public let mostShort: Int32;
  public let mostPushStep: Float;
  public let cut: Bool;
  public let lead: ref<CyberGrappleRopeLead>;
}

@if(ModuleExists("Codeware"))
public class CyberGrapplePieces extends IScriptable {
  public let set: ref<CyberGrapplePiecesSet>;
  public let at: Vector4;
  // The entity asked for last, how many files have been asked for, and since when.
  public let asking: EntityID;
  public let asked: Int32;
  public let askedAt: Float;
  public let ready: Bool;
  public let failed: Bool;
  public let waited: Int32;
  public let saidLate: Bool;
}

@if(ModuleExists("Codeware"))
public func CyberGrappleAskForPieces(at: Vector4, now: Float) -> ref<CyberGrapplePieces> {
  let statics: ref<StaticEntitySystem> = GameInstance.GetStaticEntitySystem();
  if !IsDefined(statics) || !statics.IsReady() {
    return null;
  }
  statics.DespawnTagged(CyberGrapplePiecesTag());
  let pieces: ref<CyberGrapplePieces> = new CyberGrapplePieces();
  pieces.at = at;
  pieces.askedAt = now;
  pieces.set = new CyberGrapplePiecesSet();
  pieces.set.lead = new CyberGrappleRopeLead();
  pieces.set.laid = new CyberGrappleRopeLaid();
  pieces.set.table = new CyberGrappleHangTable();
  pieces.set.rope = CyberGrappleRopeStock.Create(CyberGrappleRopePieces(), CyberGrappleRopePieceLength());
  pieces.set.ropeShort = CyberGrappleRopeStock.Create(CyberGrappleRopeShortPieces(), CyberGrappleRopeShortLength());
  if CyberGrappleAskNextPieces(pieces, statics) {
    CyberGrappleLog("pieces asked for: " + ToString(CyberGrapplePiecesFiles()) + " entity files, one at a time");
  }
  return pieces;
}

// The next of our entity files asked for; false, said once, when the game does not know it.
@if(ModuleExists("Codeware"))
public func CyberGrappleAskNextPieces(pieces: ref<CyberGrapplePieces>, statics: ref<StaticEntitySystem>) -> Bool {
  let files: array<ResRef> = CyberGrapplePiecesEntities();
  let spec: ref<StaticEntitySpec> = new StaticEntitySpec();
  spec.templatePath = files[pieces.asked];
  spec.position = pieces.at;
  spec.orientation = new Quaternion(0.0, 0.0, 0.0, 1.0);
  spec.attached = true;
  ArrayPush(spec.tags, CyberGrapplePiecesTag());
  pieces.asking = statics.SpawnEntity(spec);
  pieces.asked = pieces.asked + 1;
  if !EntityID.IsDefined(pieces.asking) {
    pieces.failed = true;
    CyberGrappleLog("no pieces: the game does not know our entity files (is archive/pc/mod/CyberGrapple.archive installed?); the grapple works without them");
    return false;
  }
  return true;
}

// Each piece of one entity file by its name (fabrique/cr2w_json.py), hidden; how many were found.
@if(ModuleExists("Codeware"))
public func CyberGrappleCollectPieces(set: ref<CyberGrapplePiecesSet>, entity: ref<Entity>) -> Int32 {
  let found: Int32 = 0;
  let components: array<ref<IComponent>> = entity.GetComponents();
  for component in components {
    let mesh: ref<MeshComponent> = component as MeshComponent;
    if IsDefined(mesh) {
      let name: String = NameToString(mesh.GetName());
      if Equals(name, "hook") {
        set.hook = mesh;
        found = found + 1;
      } else {
        if CyberGrappleStockPiece(set.rope, mesh, name, "rope_") || CyberGrappleStockPiece(set.ropeShort, mesh, name, "short_") {
          found = found + 1;
        }
      }
      mesh.Toggle(false);
    }
  }
  return found;
}

// The file asked for last, once there: its pieces taken, then the next file asked for, until all are there.
@if(ModuleExists("Codeware"))
public func CyberGrappleFindPieces(pieces: ref<CyberGrapplePieces>, now: Float) -> Void {
  let statics: ref<StaticEntitySystem> = GameInstance.GetStaticEntitySystem();
  pieces.waited = pieces.waited + 1;
  let files: Int32 = CyberGrapplePiecesFiles();
  if !statics.IsSpawned(pieces.asking) {
    if now - pieces.askedAt >= CyberGrapplePiecesLate() && !pieces.saidLate {
      pieces.saidLate = true;
      CyberGrappleLog("pieces still not there after " + ToString(now - pieces.askedAt) + " s (" + ToString(pieces.asked - 1) + " of " + ToString(files) + " entity files there)");
    }
    return;
  }
  let set: ref<CyberGrapplePiecesSet> = pieces.set;
  let entity: ref<Entity> = statics.GetEntity(pieces.asking);
  if IsDefined(entity) {
    ArrayPush(set.entities, entity);
    set.found = set.found + CyberGrappleCollectPieces(set, entity);
  }
  if pieces.asked < files {
    CyberGrappleAskNextPieces(pieces, statics);
    return;
  }
  let expected: Int32 = 1 + CyberGrappleRopePieces() + CyberGrappleRopeShortPieces();
  if ArraySize(set.entities) != files || set.found != expected {
    pieces.failed = true;
    CyberGrappleLog("no pieces: " + ToString(ArraySize(set.entities)) + " of our " + ToString(files) + " entity files there and " + ToString(set.found) + " of the " + ToString(expected) + " pieces this mod expects (archive from another build?)");
    return;
  }
  pieces.ready = true;
  CyberGrappleLog("pieces ready after " + ToString(pieces.waited) + " frames (" + ToString(files) + " entity files)");
}

@if(ModuleExists("Codeware"))
public func CyberGrapplePiecesAlive(pieces: ref<CyberGrapplePieces>) -> Bool {
  for entity in pieces.set.entities {
    if !IsDefined(entity) {
      return false;
    }
  }
  return true;
}

@if(ModuleExists("Codeware"))
public func CyberGrappleHideSet(set: ref<CyberGrapplePiecesSet>) -> Void {
  if set.hookShown {
    set.hook.Toggle(false);
    set.hookShown = false;
  }
  CyberGrappleStockHide(set.rope);
  CyberGrappleStockHide(set.ropeShort);
}

// The last shot's hook is still out, flying, planted or coming back: a new shot waits until it is home, so that two
// hooks never fly at once. Without Codeware no hook is shown, and none is waited for.
@if(ModuleExists("Codeware"))
public func CyberGrappleHookStillOut(system: ref<CyberGrappleSystem>) -> Bool {
  let pieces: ref<CyberGrapplePieces> = system.pieces as CyberGrapplePieces;
  return IsDefined(pieces) && IsDefined(pieces.set.shot);
}

@if(!ModuleExists("Codeware"))
public func CyberGrappleHookStillOut(system: ref<CyberGrappleSystem>) -> Bool {
  return false;
}
