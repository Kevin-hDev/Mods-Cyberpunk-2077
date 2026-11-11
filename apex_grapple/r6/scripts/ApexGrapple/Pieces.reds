// Our pieces in the game: the hook and the rope's pieces spread over our entity files (PiecesData.reds), asked of
// Codeware's StaticEntitySystem (objects with no AI) from the first frame with the mod on, everything hidden until a
// shot needs it. One set: a new shot waits for the last hook to be home (ApexGrappleHookStillOut). A system attaches
// again at each load (Hook.reds): the pieces are asked for again, any left by the load removed first by their tag.
// The files are asked for one at a time, each once the one before is there: the game builds an entity's pieces into a
// list of 192 places with no check, and one file of 221 pieces crashed it. Whether two entities built in one go would
// share that list is not known.

public func ApexGrapplePiecesTag() -> CName {
  return n"ApexGrapplePieces";
}

public func ApexGrapplePiecesFiles() -> Int32 {
  let files: array<ResRef> = ApexGrapplePiecesEntities();
  return ArraySize(files);
}

// Seconds of game time after which the log says once that the pieces are late.
public func ApexGrapplePiecesLate() -> Float {
  return 10.0;
}

@if(ModuleExists("Codeware"))
public class ApexGrapplePiecesSet extends IScriptable {
  public let entities: array<wref<Entity>>;
  public let found: Int32;
  // Kept by strong pointers, against rule 3 of optimisation.md, on purpose (Kevin, 10 November 2026): they are pieces of
  // our own entities, which ApexGrapplePiecesAlive checks through weak pointers at each frame before any use; weak
  // pointers here would add more than 200 checks a frame for no risk seen either way.
  public let hook: ref<MeshComponent>;
  public let rope: array<ref<MeshComponent>>;
  public let shown: Int32;
  public let hookShown: Bool;
  public let shot: ref<ApexGrappleHookShot>;
  public let bends: ref<ApexGrappleRopeBends>;
  public let hang: ref<ApexGrappleRopeHangs>;
  // Worked out again at each frame, kept rather than made anew (RopeHang.reds, RopeMotion.reds).
  public let laid: ref<ApexGrappleRopeLaid>;
  public let table: ref<ApexGrappleHangTable>;
  // For the log, over one shot.
  public let mostPieces: Int32;
  public let mostPushStep: Float;
  public let cut: Bool;
  public let lead: ref<ApexGrappleRopeLead>;
}

@if(ModuleExists("Codeware"))
public class ApexGrapplePieces extends IScriptable {
  public let set: ref<ApexGrapplePiecesSet>;
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
public func ApexGrappleAskForPieces(at: Vector4, now: Float) -> ref<ApexGrapplePieces> {
  let statics: ref<StaticEntitySystem> = GameInstance.GetStaticEntitySystem();
  if !IsDefined(statics) || !statics.IsReady() {
    return null;
  }
  statics.DespawnTagged(ApexGrapplePiecesTag());
  let pieces: ref<ApexGrapplePieces> = new ApexGrapplePieces();
  pieces.at = at;
  pieces.askedAt = now;
  pieces.set = new ApexGrapplePiecesSet();
  pieces.set.lead = new ApexGrappleRopeLead();
  pieces.set.laid = new ApexGrappleRopeLaid();
  pieces.set.table = new ApexGrappleHangTable();
  ArrayResize(pieces.set.rope, ApexGrappleRopePieces());
  if ApexGrappleAskNextPieces(pieces, statics) {
    ApexGrappleLog("pieces asked for: " + ToString(ApexGrapplePiecesFiles()) + " entity files, one at a time");
  }
  return pieces;
}

// The next of our entity files asked for; false, said once, when the game does not know it.
@if(ModuleExists("Codeware"))
public func ApexGrappleAskNextPieces(pieces: ref<ApexGrapplePieces>, statics: ref<StaticEntitySystem>) -> Bool {
  let files: array<ResRef> = ApexGrapplePiecesEntities();
  let spec: ref<StaticEntitySpec> = new StaticEntitySpec();
  spec.templatePath = files[pieces.asked];
  spec.position = pieces.at;
  spec.orientation = new Quaternion(0.0, 0.0, 0.0, 1.0);
  spec.attached = true;
  ArrayPush(spec.tags, ApexGrapplePiecesTag());
  pieces.asking = statics.SpawnEntity(spec);
  pieces.asked = pieces.asked + 1;
  if !EntityID.IsDefined(pieces.asking) {
    pieces.failed = true;
    ApexGrappleLog("no pieces: the game does not know our entity files (is archive/pc/mod/ApexGrapple.archive installed?); the grapple works without them");
    return false;
  }
  return true;
}

// Each piece of one entity file by its name (fabrique/cr2w_json.py), hidden; how many were found.
@if(ModuleExists("Codeware"))
public func ApexGrappleCollectPieces(set: ref<ApexGrapplePiecesSet>, entity: ref<Entity>) -> Int32 {
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
        if StrBeginsWith(name, "rope_") {
          let index: Int32 = StringToInt(StrAfterFirst(name, "rope_"), -1);
          if index >= 0 && index < ApexGrappleRopePieces() {
            set.rope[index] = mesh;
            found = found + 1;
          }
        }
      }
      mesh.Toggle(false);
    }
  }
  return found;
}

// The file asked for last, once there: its pieces taken, then the next file asked for, until all are there.
@if(ModuleExists("Codeware"))
public func ApexGrappleFindPieces(pieces: ref<ApexGrapplePieces>, now: Float) -> Void {
  let statics: ref<StaticEntitySystem> = GameInstance.GetStaticEntitySystem();
  pieces.waited = pieces.waited + 1;
  let files: Int32 = ApexGrapplePiecesFiles();
  if !statics.IsSpawned(pieces.asking) {
    if now - pieces.askedAt >= ApexGrapplePiecesLate() && !pieces.saidLate {
      pieces.saidLate = true;
      ApexGrappleLog("pieces still not there after " + ToString(now - pieces.askedAt) + " s (" + ToString(pieces.asked - 1) + " of " + ToString(files) + " entity files there)");
    }
    return;
  }
  let set: ref<ApexGrapplePiecesSet> = pieces.set;
  let entity: ref<Entity> = statics.GetEntity(pieces.asking);
  if IsDefined(entity) {
    ArrayPush(set.entities, entity);
    set.found = set.found + ApexGrappleCollectPieces(set, entity);
  }
  if pieces.asked < files {
    ApexGrappleAskNextPieces(pieces, statics);
    return;
  }
  if ArraySize(set.entities) != files || set.found != ApexGrappleRopePieces() + 1 {
    pieces.failed = true;
    ApexGrappleLog("no pieces: " + ToString(ArraySize(set.entities)) + " of our " + ToString(files) + " entity files there and " + ToString(set.found) + " of the " + ToString(ApexGrappleRopePieces() + 1) + " pieces this mod expects (archive from another build?)");
    return;
  }
  pieces.ready = true;
  ApexGrappleLog("pieces ready after " + ToString(pieces.waited) + " frames (" + ToString(files) + " entity files)");
}

@if(ModuleExists("Codeware"))
public func ApexGrapplePiecesAlive(pieces: ref<ApexGrapplePieces>) -> Bool {
  for entity in pieces.set.entities {
    if !IsDefined(entity) {
      return false;
    }
  }
  return true;
}

@if(ModuleExists("Codeware"))
public func ApexGrappleHideSet(set: ref<ApexGrapplePiecesSet>) -> Void {
  if set.hookShown {
    set.hook.Toggle(false);
    set.hookShown = false;
  }
  let i: Int32 = 0;
  while i < set.shown {
    let piece: ref<MeshComponent> = set.rope[i];
    piece.Toggle(false);
    i = i + 1;
  }
  set.shown = 0;
}

// The last shot's hook is still out, flying, planted or coming back: a new shot waits until it is home, so that two
// hooks never fly at once. Without Codeware no hook is shown, and none is waited for.
@if(ModuleExists("Codeware"))
public func ApexGrappleHookStillOut(system: ref<ApexGrappleSystem>) -> Bool {
  let pieces: ref<ApexGrapplePieces> = system.pieces as ApexGrapplePieces;
  return IsDefined(pieces) && IsDefined(pieces.set.shot);
}

@if(!ModuleExists("Codeware"))
public func ApexGrappleHookStillOut(system: ref<ApexGrappleSystem>) -> Bool {
  return false;
}
