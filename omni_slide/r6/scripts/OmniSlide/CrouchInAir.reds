// Slide on landing: in the air the game hears the crouch key only once V falls fast enough, so a press while
// rising or at the top of a jump is lost and V lands standing. With this setting, a press at any moment of the
// jump counts, exactly as the game counts it while falling. The game's landing rules still decide the slide,
// and a second jump still clears the press, as in the game.
@wrapMethod(LocomotionAirEvents)
protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  // States that give the crouch key another use in the air (air thrusters, air dash) turn this flag off.
  if !this.m_updateInputToggles {
    return;
  }
  if !scriptInterface.IsActionJustTapped(n"ToggleCrouch") && !scriptInterface.IsActionJustHeld(n"ToggleCrouch") {
    return;
  }
  if scriptInterface.IsActionJustPressed(n"Jump") || this.IsTouchingGround(scriptInterface) || !OmniSlideKeepsCrouchInAir() {
    return;
  }
  if !stateContext.GetConditionBool(n"CrouchToggled") {
    OmniSlideLog("crouch kept in the air");
  }
  stateContext.SetConditionBoolParameter(n"CrouchToggled", true, true);
  stateContext.SetConditionBoolParameter(n"SprintToggled", false, true);
  stateContext.SetConditionBoolParameter(n"SprintHoldCanStartWithoutNewInput", false, true);
}
