// The game's gadget key (its action UseCombatGadget: middle mouse button, R1 on a controller, CombatGadget_Button in
// inputUserMappings.xml) fires the grapple while our implant is the item on it and Own key is off. D31 (Kevin,
// 17 November 2026): the implant takes the projectile launcher's place, so that key is free, and the quick melee key is
// the game's again. The press is read with the grapple's key (Key.reds), never through the game's gadget path, whose
// guards (safe zone, left hand, time in a state) would refuse the grapple where it fires today.

// Presses left to the game written to the log at most this many times a load: a player who keeps grenades on the key
// presses it at each throw.
public func CyberGrappleGadgetKeyMostLines() -> Int32 {
  return 40;
}

// Times a load the log tells of the gadget key given back to the game (CyberGrappleGadgetKeyGiveBack).
public func CyberGrappleGadgetKeyBackMostLines() -> Int32 {
  return 10;
}

// The item on the game's gadget key, read as the game reads that key (EHotkey.RB, defaultTransition.script:1021,
// scripts 2.5), or ItemID.None().
public func CyberGrappleGadgetKeyItem(player: ref<GameObject>) -> ItemID {
  let puppet: ref<PlayerPuppet> = player as PlayerPuppet;
  if !IsDefined(puppet) {
    return ItemID.None();
  }
  let data: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(puppet);
  if !IsDefined(data) {
    return ItemID.None();
  }
  return data.GetItemIDFromHotkey(EHotkey.RB);
}

// Whether our implant is the item on the game's gadget key, worn or not: the locks below must refuse an implant V no
// longer wears that is still on the key (CyberGrappleGadgetKeyGiveBack), which the game would otherwise fire.
public func CyberGrappleOursOnGadgetKey(player: ref<GameObject>) -> Bool {
  return CyberGrappleIsImplant(CyberGrappleGadgetKeyItem(player));
}

// At a press of the gadget key with Own key off (Key.reds): the press is the grapple's only with our implant on the
// key, and while V carries no body, which the game throws at the release of that same button (ThrowNPC_Button and
// CombatGadget_Button, inputUserMappings.xml:660-668; carriedObject.script:525-539; the carrying flag as the game
// reads it, defaultTransition.script:1378-1380). What the key holds is kept for the crosshair (Implant.reds).
public func CyberGrappleGadgetKeyPress(system: ref<CyberGrappleSystem>, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  system.gadgetKeyOurs = CyberGrappleOursOnGadgetKey(scriptInterface.executionOwner);
  let why: String = "";
  if !system.gadgetKeyOurs {
    why = "the Combat Gadget quickslot holds another item";
  } else {
    if scriptInterface.localBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.Carrying) {
      why = "V carries a body, which the game throws at the release of that button";
    }
  }
  if StrLen(why) == 0 {
    return true;
  }
  if system.gadgetKeyLines <= CyberGrappleGadgetKeyMostLines() {
    system.gadgetKeyLines = CyberGrappleLogUpTo(system.gadgetKeyLines, CyberGrappleGadgetKeyMostLines(), "gadget key", "press left to the game: " + why);
  }
  return false;
}

// Read again with the worn tier, twice a second at most and between grapples (SettingsCopy.reds), for the crosshair:
// a press reads the key itself. Only while the gadget key fires the grapple: off, or with Own key on, nothing asks
// what the key holds (optimisation.md 3.5).
public func CyberGrappleGadgetKeyRead(system: ref<CyberGrappleSystem>) -> Void {
  if !CyberGrappleGadgetKeyGrapples(system) {
    return;
  }
  let player: ref<PlayerPuppet> = GetPlayer(system.GetGameInstance());
  system.gadgetKeyOurs = IsDefined(player) && CyberGrappleOursOnGadgetKey(player);
}

// The game gives the gadget key to the next item, and puts the left hand's gadget away, only when a launcher-type item
// leaves the active arm slot (equipmentSystem.script:2109-2113). Taken off another slot, which only a mod that adds arm
// slots gives, it stays on the key though V wears it no more (:2123-2145). For an implant of ours the key is given to
// the next item as the game forgets it: every unequip passes here (:2032, :764-769, :3907 the ripperdoc's, :4000 an
// upgrade's). Anything else unequipped costs two reads and a comparison.
@wrapMethod(EquipmentSystemPlayerData)
private final func UnequipItem(equipAreaIndex: Int32, slotIndex: Int32, opt forceRemove: Bool) -> Void {
  let removed: ItemID = this.GetItemInEquipSlot(equipAreaIndex, slotIndex);
  let keyed: Bool = ItemID.IsValid(removed) && removed == this.GetItemIDFromHotkey(EHotkey.RB);
  wrappedMethod(equipAreaIndex, slotIndex, forceRemove);
  if keyed {
    this.CyberGrappleGadgetKeyBack(removed, "taken off an arm slot");
  }
}

// A save made before such an unequip was caught may keep on the key an implant of ours V no longer wears: looked at
// once a load, at the first reading of the worn tier (SettingsCopy.reds), between grapples.
public func CyberGrappleGadgetKeyGiveBack(system: ref<CyberGrappleSystem>) -> Void {
  if !system.gadgetKeyBackDue {
    return;
  }
  system.gadgetKeyBackDue = false;
  let player: ref<PlayerPuppet> = GetPlayer(system.GetGameInstance());
  if !IsDefined(player) {
    return;
  }
  let data: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(player);
  if IsDefined(data) {
    data.CyberGrappleGadgetKeyBack(data.GetItemIDFromHotkey(EHotkey.RB), "kept by the save");
  }
}

// The game's own call, made only while the key holds this implant of ours and V wears it in no slot: grenades if V has
// some, else nothing (equipmentSystem.script:1893-1930), as for the active slot.
@addMethod(EquipmentSystemPlayerData)
public func CyberGrappleGadgetKeyBack(held: ItemID, why: String) -> Void {
  if !ItemID.IsValid(held) || this.GetItemIDFromHotkey(EHotkey.RB) != held || this.IsEquipped(held) || !CyberGrappleIsImplant(held) {
    return;
  }
  this.AssignNextValidItemToHotkey(held);
  let system: ref<CyberGrappleSystem> = CyberGrappleSystemOf(this.m_owner.GetGame());
  if IsDefined(system) && system.gadgetKeyBackLines <= CyberGrappleGadgetKeyBackMostLines() {
    let now: ItemID = this.GetItemIDFromHotkey(EHotkey.RB);
    let after: String = ItemID.IsValid(now) ? TDBID.ToStringDEBUG(ItemID.GetTDBID(now)) : "nothing";
    system.gadgetKeyBackLines = CyberGrappleLogUpTo(system.gadgetKeyBackLines, CyberGrappleGadgetKeyBackMostLines(), "gadget key given back", "gadget key given back to the game (" + why + "): it held " + TDBID.ToStringDEBUG(ItemID.GetTDBID(held)) + ", worn in no arm slot; it now holds " + after);
  }
}

// Whether a press of the gadget key fires the grapple: Own key off and the grapple live (switch on, our implant worn,
// not silenced: the copy of the settings, SettingsCopy.reds). The key's hint under the slot shows only then
// (SlotCharges.reds): off or silenced, the key does nothing.
public func CyberGrappleGadgetKeyGrapples(system: ref<CyberGrappleSystem>) -> Bool {
  if ArraySize(system.profiles) == 0 {
    return false;
  }
  let settings: ref<CyberGrappleSettings> = system.profiles[0];
  return IsDefined(settings) && settings.enabled && !settings.ownKey;
}

// A shot of the gadget key refused while no charge is left, whatever refused it (the last hook still coming back
// too): the game's "empty" sound, played as the game plays it on that key (upperBodyTransitions.script:633-636). Asked
// by a refused shot alone (Shot.reds, by a patch of fabrique/gadget_key_spec.py), once a press; a second press that
// calls a grapple off is no shot. The game never plays it for our implant (the wrap below): never heard twice. A
// refusal with a charge left, and any refusal of an own key, is silent.
public func CyberGrappleRefusedSound(system: ref<CyberGrappleSystem>, settings: ref<CyberGrappleSettings>, now: Float, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if settings.ownKey || CyberGrappleChargesLeft(system, now) > 0 {
    return;
  }
  let sound: ref<SoundPlayEvent> = new SoundPlayEvent();
  sound.soundName = n"ui_grenade_empty";
  scriptInterface.owner.QueueEvent(sound);
}

// The game reads its gadget key in five places, the updates of the empty-handed, one-weapon, two-weapon, aiming and
// temporary-unequip states (upperBodyTransitions.script:621, :805, :1002, :1727, :2171). In each, an item of the
// cyberware category on the key, which this question tells, is asked of the equipment system (RequestGadget); the
// first four play the "empty" sound instead when the launcher has no charge (LauncherCharges.reds), the fifth asks nothing
// more. With our implant on the key, the key is the grapple's or does nothing: the answer is no for it, and none of
// the five plays a sound or starts the launcher's shot. Any other category (the grenades' Gadget, asked here and by
// combatGadgetTransitions.script:106, :272) or any other item: the game's own answer. Read live, not from the state the
// system keeps, since the fifth place has no other lock.
@wrapMethod(DefaultTransition)
protected final const func CheckItemCategoryInQuickWheel(const scriptInterface: ref<StateGameScriptInterface>, compareToType: gamedataItemCategory) -> Bool {
  if NotEquals(compareToType, gamedataItemCategory.Cyberware) {
    return wrappedMethod(scriptInterface, compareToType);
  }
  return wrappedMethod(scriptInterface, compareToType) && !CyberGrappleOursOnGadgetKey(scriptInterface.executionOwner);
}

// A press held past the key's hold time (0.3 s, inputContexts.xml:1619) is kept by the game as cgCached, and the five
// places above read the key again each frame while it is kept, the first four each time sending the slot an event that
// stops and starts its animation again (dpadHintItem.script:880-901; the fifth sends none,
// upperBodyTransitions.script:2171-2184). Only the item asked for (RequestGadget, the lines that
// follow it at upperBodyTransitions.script:660, :844, :1041, :1765, :2180) or a grenade's state
// (combatGadgetTransitions.script:296) takes it off before the release, and neither comes for our implant: it is not
// kept for our implant, so a press sends the slot one event. The item is read on the frame the hold is reached only.
@wrapMethod(DefaultTransition)
protected final const func ProcessCombatGadgetActionInputCaching(const scriptInterface: ref<StateGameScriptInterface>, stateContext: ref<StateContext>) -> Void {
  if scriptInterface.IsActionJustHeld(n"UseCombatGadget") && !stateContext.GetBoolParameter(n"cgCached", true) && CyberGrappleOursOnGadgetKey(scriptInterface.executionOwner) {
    return;
  }
  wrappedMethod(scriptInterface, stateContext);
}
