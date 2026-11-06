// The camera's slide settings say whether V's body is held still while the camera turns (game value: locked).
// In a script, only TweakXL can change a game value during play: without it this does nothing, and the tweak file is
// not read either, so the slide keeps the game's lock.

@if(ModuleExists("TweakXL"))
public func OmniSlideSetHeadingLock(locked: Bool) -> Void {
  let flat: TweakDBID = t"fppCameraParamSets.Slide.headingLocked";
  if Equals(TweakDBInterface.GetBool(flat, true), locked) {
    return;
  }
  let written: Bool = TweakDBManager.SetFlat(flat, ToVariant(locked));
  OmniSlideLog("heading lock " + ToString(locked) + ", written " + ToString(written));
}

@if(!ModuleExists("TweakXL"))
public func OmniSlideSetHeadingLock(locked: Bool) -> Void {}
