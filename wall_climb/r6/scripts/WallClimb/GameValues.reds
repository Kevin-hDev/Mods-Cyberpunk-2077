// A value of one of the game's locomotion states as its tweak data holds it, which a tweak file of another mod may
// have changed.
public func WallClimbStateValue(state: String, name: String, fallback: Float) -> Float {
  return TweakDBInterface.GetFloat(TDBID.Create("playerStateMachineLocomotion." + state + "." + name), fallback);
}
