/// <summary>
/// This class allows mods to hook into events which occur in the tactical game.
///
/// IMPORTANT: XCOM was built in such a way that the strategy game depends on the tactical game,
/// but not vice versa. That means many of the events here may trigger while the game is on the
/// strategy layer, such as OnAbilitiesBuilt, despite being "tactical" events. Mods should be
/// careful that their code doesn't assume they're in the tactical game unless it's an event that
/// truly can only occur during that mode, such as a unit being killed.
/// </summary>
class HighlanderTacticalListener extends Actor
    abstract;

/// <summary>
/// TODO
/// </summary>
simulated function Override_GetTWeapon(out HL_TWeapon kWeapon) {}

/// <summary>
/// Called when the ability tree is built at the start of the battle.
///
/// NOTE: Abilities are built early in the battle initialization sequence, and not everything will be
/// available at this point. You may need to set a short timer to wait for initialization to complete.
/// </summary>
function OnAbilitiesBuilt(array<TAbility> arrAbilities) {}

/// <summary>
/// Called during XGUnit.UpdateItemCharges, which sets the initial number of charges available for items
/// when the unit is spawned. Can be used to dynamically modify item charges from a mod.
///
/// NOTE: This is called for all units, not just XCOM soldiers!
/// </summary>
function OnUpdateItemCharges(XGUnit kUnit) {}

/// <summary>
/// Called after an XGVolume is created, such as from a smoke grenade, Telekinetic Field, etc. When this
/// function is called, XGVolume.Init has already occurred, but the volume has not yet been added to the
/// battle's XGVolumeMgr instance (and thus no units are affected by it yet).
/// </summary>
function OnVolumeCreated(XGVolume kVolume) {}