// When the mod stays silent, and why. Silent, it fires nothing and leaves every key to the game.
// - Codeware missing: the hook, the rope, the own key and every text need it.
// - Apex Grapple switched on: the two mods wrap the same functions of the game (V's states each frame, the landing,
//   the quick melee), and a key both listen to would fire two grapples. Its master switch is read through Codeware,
//   by name, so that this mod compiles without it. Mod Settings writes a setting's value as its class's default, so a
//   new object reads the current one. Read at each copy of the settings: at a load, and whenever a setting of any mod
//   changes in the menu.

// What was read of Apex Grapple's switch: "absent", "off", "on", or why it could not be read.
@if(ModuleExists("Codeware"))
public func CyberGrappleOtherGrapple() -> String {
  let other: ref<ReflectionClass> = Reflection.GetClass(n"ApexGrappleSettings");
  if !IsDefined(other) {
    return "absent";
  }
  let property: ref<ReflectionProp> = other.GetProperty(n"enabled");
  let settings: ref<ISerializable> = other.MakeHandle();
  if !IsDefined(property) || !IsDefined(settings) {
    return "unreadable (no switch or no object)";
  }
  let value: Variant = property.GetValue(ToVariant(settings));
  if NotEquals(VariantTypeName(value), n"Bool") {
    return "unreadable (read as " + NameToString(VariantTypeName(value)) + ")";
  }
  return FromVariant<Bool>(value) ? "on" : "off";
}

@if(!ModuleExists("Codeware"))
public func CyberGrappleOtherGrapple() -> String {
  return "not looked for";
}

// Anything but "absent" or "off" keeps this mod silent: installed but not readable, rather than two grapples at once.
@if(ModuleExists("Codeware"))
public func CyberGrappleSilentWhy(const other: String) -> String {
  if Equals(other, "absent") || Equals(other, "off") {
    return "";
  }
  if Equals(other, "on") {
    return "Apex Grapple is installed and switched on: switch it off in its settings, or remove one of the two mods";
  }
  return "Apex Grapple is installed and its switch is " + other;
}

@if(!ModuleExists("Codeware"))
public func CyberGrappleSilentWhy(const other: String) -> String {
  return "Codeware is not installed, and this mod needs it";
}

// Called once a load by the grapple's system (Hook.reds); the reason itself is written at each copy of the settings.
public func CyberGrappleSayWhatCodewareGives() -> Void {}

// Whether the own key is heard at all (CrosshairRange.reds).
@if(ModuleExists("Codeware"))
public func CyberGrappleOwnKeysHeard() -> Bool {
  return true;
}

@if(!ModuleExists("Codeware"))
public func CyberGrappleOwnKeysHeard() -> Bool {
  return false;
}
