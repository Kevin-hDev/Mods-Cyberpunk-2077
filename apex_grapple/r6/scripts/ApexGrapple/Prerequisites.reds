// What needs Codeware: our hook and rope (Pieces.reds), the own keys of every profile (OwnKey.reds) and the menu's
// texts (Localization.reds). Without it the grapple still works on the quick melee key, and the log says once a load
// what is missing rather than leaving the player to guess.

@if(ModuleExists("Codeware"))
public func ApexGrappleSayWhatCodewareGives() -> Void {}

@if(!ModuleExists("Codeware"))
public func ApexGrappleSayWhatCodewareGives() -> Void {
  ApexGrappleLog("Codeware is not installed: no hook or rope is shown, and no own key does anything, profiles 2 to 5 included; the quick melee key still grapples");
}

// Whether the own keys are heard at all: the range indicator counts profiles 2 to 5 only then (CrosshairRange.reds).
@if(ModuleExists("Codeware"))
public func ApexGrappleOwnKeysHeard() -> Bool {
  return true;
}

@if(!ModuleExists("Codeware"))
public func ApexGrappleOwnKeysHeard() -> Bool {
  return false;
}
