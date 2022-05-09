/// <summary>
/// This class allows mods to hook into events which occur in the tactical game.
///
/// IMPORTANT: XCOM was built in such a way that the strategy game depends on the tactical game,
/// but not vice versa. That means many of the events here may trigger while the game is on the
/// strategy layer, such as OnAbilitiesBuilt, despite being "tactical" events. Mods should be
/// careful that their code doesn't assume they're in the tactical game unless it's an event that
/// truly can only occur during that mode, such as a unit being killed.
/// </summary>
class LWCETacticalListener extends Actor
    abstract;

/// <summary>
/// TODO
/// </summary>
simulated function Override_GetTWeapon(out LWCE_TWeapon kWeapon) {}

/// <summary>
/// Called when the ability tree is built at the start of the battle.
///
/// NOTE: Abilities are built early in the battle initialization sequence, and not everything will be
/// available at this point. You may need to set a short timer to wait for initialization to complete.
/// </summary>
function OnAbilitiesBuilt(array<TAbility> arrAbilities) {}

/// <summary>
/// TODO
/// </summary>
function OnBattleBegin(XGBattle kBattle) {}

/// <summary>
/// TODO
/// </summary>
function AddCritChanceModifiers(XGAbility_Targeted kAbility, out TShotInfo kInfo) {}

/// <summary>
/// TODO
/// </summary>
function AddHitChanceModifiers(XGAbility_Targeted kAbility, out TShotInfo kInfo) {}

/// <summary>
/// Called when the perks list is built at the start of the battle. This is also called on the strategy
/// layer, so that perks can be shown in the Barracks, on items, etc.
/// </summary>
function OnPerksBuilt(out array<LWCE_TPerk> arrPerks) {}

/// <summary>
/// TODO
/// </summary>
function OnPerkTreesBuilt(out array<LWCE_TPerkTree> arrSoldierPerkTrees, out array<LWCE_TPerkTree> arrPsionicPerkTrees) {}

/// <summary>
/// Called when a unit bonus is being displayed, such as in the shot HUD where it shows various active perks (e.g. showing that
/// Tactical Sense is active). Ordinarily the text displayed under the bonus is static, and is set in the LWCE_TPerk.strBonusDescription
/// field. This method provides an opportunity for mods to provide a dynamic value, so instead of the bonus text being "Tactical Sense: Active",
/// it could (for example) be "Tactical Sense: +10 Defense".
///
/// If your mod is not modifying the description text for the given perk ID, simply return strCurrentText.
///
/// TODO: replace this method with localization tags
/// </summary>
function string GetDynamicBonusDescription(int iPerkId, string strCurrentText, LWCE_XGUnit kUnit) { return strCurrentText; }

/// <summary>
/// See documentation for GetDynamicBonusDescription above; this is the same method but for unit penalties.
/// </summary>
function string GetDynamicPenaltyDescription(int iPerkId, string strCurrentText, LWCE_XGUnit kUnit) { return strCurrentText; }

/// <summary>
/// Called when a unit needs to re-evaluate its active bonuses. Examples of times when this will occur are when the mission first starts,
/// when the unit enters cover, or when a unit becomes panicked.
///
/// Use XGUnit.AddBonus to add the perk ID of any applicable bonuses from your mod.
/// </summary>
function OnRegenBonusPerks(LWCE_XGUnit kUnit, XGAbility ContextAbility) {}

/// <summary>
/// See documentation for OnRegenBonusPerks above; this is the same method but for unit passives. Unlike bonuses or penalties, passives are
/// not conditional. If a unit has a passive perk from your mod, then your mod should add that passive here.
///
/// Use XGUnit.AddPassive to add the perk ID of any passive perks from your mod.
/// </summary>
function OnRegenPassivePerks(LWCE_XGUnit kUnit) {}

/// <summary>
/// See documentation for OnRegenBonusPerks above; this is the same method but for unit penalties.
///
/// Use XGUnit.AddPenalty to add the perk ID of any applicable penalties from your mod.
/// </summary>
function OnRegenPenaltyPerks(LWCE_XGUnit kUnit) {}

/// <summary>
/// Called during XGUnit.UpdateItemCharges, which sets the initial number of charges available for items
/// when the unit is spawned. Can be used to dynamically modify item charges from a mod.
///
/// NOTE: This is called for all units, not just XCOM soldiers!
/// </summary>
function OnUpdateItemCharges(LWCE_XGUnit kUnit) {}

/// <summary>
/// TODO
/// </summary>
function OnUnitSpawned(LWCE_XGUnit kUnit) {}

/// <summary>
/// Called after an XGVolume is created, such as from a smoke grenade, Telekinetic Field, etc. When this
/// function is called, XGVolume.Init has already occurred, but the volume has not yet been added to the
/// battle's XGVolumeMgr instance (and thus no units are affected by it yet).
/// </summary>
function OnVolumeCreated(XGVolume kVolume) {}