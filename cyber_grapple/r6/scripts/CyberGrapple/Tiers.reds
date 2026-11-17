// What each tier of the implant allows, and how far and how fast it goes: the one table the grapple's settings are
// filled from (docs/cyber-grapple/conception.md, "Les Tiers"; the numbers are decision D23 of the README beside it).
// The rest of the code knows no tier: it reads settings already made.
// `tier` counts the records, 1 to 11 (Implant.reds): 1 and 2 are the player's Tier 1 and 1+, 3 and 4 his Tier 2
// and 2+, 5 and up his Tier 3 and above. 0 is no implant, and -1 no player yet to read it from (SettingsCopy.reds),
// taken as 0: nothing is allowed, and no shot is fired anyway.
// Every field named in TIER and ADDED of fabrique/grapple_spec.py is written here, whatever the tier: a field left
// out would keep Apex Grapple's default.
// A number never goes down from a record to the next: a tier is bought as well as upgraded to, and an upgrade that
// took something away would read as a fault (fabrique/test_grapple.py).
// The hook's speed is Apex Grapple's default at every tier until the balancing pass (D22). The hook's way back, 4 times
// its way out (D25), and the speed of what V pulls, 24 m/s (D28), are this mod's own, the same at every tier
// (FIXED_VALUES of fabrique/grapple_spec.py).

// Function b, from the player's Tier 2: a person, an enemy or a motorcycle is pulled to V, and the hook takes hold
// of vehicles and people at all. Below it, a person or a vehicle in the way is not a target.
public func CyberGrapplePullsFrom() -> Int32 {
  return 3;
}

// Function c, from the player's Tier 3: a person is brought to V and seized, with the game's grab key held.
public func CyberGrappleSeizesFrom() -> Int32 {
  return 5;
}

// One value a record, in the order of the tiers: 1, 1+, 2, 2+, 3, 3+, 4, 4+, 5, 5+, 5++.

// How many records the implant has: the length of the tables below, which test_source.py holds equal to the tier tags
// of the records (r6/tweaks/CyberGrapple/implants.yaml).
public func CyberGrappleTierCount() -> Int32 {
  let ranges: array<Float> = CyberGrappleRanges();
  return ArraySize(ranges);
}

// The range V travels over, in metres. Kevin, 16 November 2026: "le mod commencera a 40m de distance au debut, et il
// doit finir a 70m max a la fin de la derniere amelioration, pas plus". 3 m more a record.
public func CyberGrappleRanges() -> array<Float> {
  return [40.0, 43.0, 46.0, 49.0, 52.0, 55.0, 58.0, 61.0, 64.0, 67.0, 70.0];
}

// The top speed the rope adds, in metres a second: 35 is Apex Grapple's default. Kevin, 16 November 2026: "on va
// partir sur 35 de vitesse au premier niveau [...] on ne doit pas depasser 45 de vitesse max donc on pourrait la faire
// augmenter uniquement sur a certains paliers comme a 1+ / 2+ / 3+, ca fais trois amelioration de vitesse".
public func CyberGrappleTopSpeeds() -> array<Float> {
  return [35.0, 38.3, 38.3, 41.7, 41.7, 45.0, 45.0, 45.0, 45.0, 45.0, 45.0];
}

// How far a person or a motorcycle is taken from, in metres (PullRange.reds); 0 below the tier that pulls. Kevin,
// 16 November 2026: "on commencerais a 20 m et on le ferait augmenter en 4 fois jusqu'a 40m". Where the four steps
// fall is not his: after the three steps of speed, so that each upgrade brings one thing. To be confirmed.
public func CyberGrapplePullRanges() -> array<Float> {
  return [0.0, 0.0, 20.0, 20.0, 20.0, 20.0, 25.0, 30.0, 35.0, 40.0, 40.0];
}

// The charges a tier holds (D24, Kevin, 16 November 2026: "2 charges au tier 1 , 3 au Tier 2, 4 au Tier 4"), and the
// seconds one takes to come back: "on va partir sur 12 secondes , de très grand saut peuvent durée entre 6 et 8
// secondes et c'est pas juste un moyen de deplacement, c'est aussi un moyen de tuer et de saisir les gens". The
// game's own launcher holds 1 and takes 25 (read in its data, releves/cyber-grapple/2026-11-16-charges-du-lanceur).
public func CyberGrappleCharges() -> array<Float> {
  return [2.0, 2.0, 3.0, 3.0, 3.0, 3.0, 4.0, 4.0, 4.0, 4.0, 4.0];
}

public func CyberGrappleRechargeTime() -> Float {
  return 12.0;
}

// A table's value for a tier; the first record's for no implant, when nothing fires anyway.
public func CyberGrappleTierValue(values: array<Float>, tier: Int32) -> Float {
  return values[Clamp(tier, 1, ArraySize(values)) - 1];
}

public func CyberGrappleApplyTier(settings: ref<CyberGrappleSettings>, tier: Int32) -> Void {
  let pulls: Bool = tier >= CyberGrapplePullsFrom();
  settings.hookTargets = pulls;
  settings.pullPeople = pulls;
  settings.pullBikes = pulls;
  // "Le faire valser et le tuer à l'impact" (Kevin, 11 November 2026): the pull hurts, and the person follows the
  // aim, so that V throws them at a wall or a car. Steering was off at the first trial, as in Apex Grapple's
  // defaults; Kevin, 16 November 2026: "ca tire uniquement tout droit vers V, impossible de projeter en gerent avec
  // le viseur comme apex grapple". The slam at arrival was switched off at the second trial, on a wrong guess that
  // it ended the throw; Kevin, 16 November 2026: "il manque juste lecrasement au sol quand on pull les ennemies".
  // The two live together: the aim steers the flight, the slam is what happens at arrival. To be weighed again at
  // the balancing pass (D22).
  settings.pullDamage = pulls;
  settings.steerPeople = pulls;
  settings.pullSlam = pulls;
  settings.grabPeople = tier >= CyberGrappleSeizesFrom();
  settings.range = CyberGrappleTierValue(CyberGrappleRanges(), tier);
  settings.pullSpeedCap = CyberGrappleTierValue(CyberGrappleTopSpeeds(), tier);
  settings.pullRange = CyberGrappleTierValue(CyberGrapplePullRanges(), tier);
}
