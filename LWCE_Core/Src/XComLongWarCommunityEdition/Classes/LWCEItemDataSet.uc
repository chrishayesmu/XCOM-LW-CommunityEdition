class LWCEItemDataSet extends LWCEDataSet;

static function OnPostTemplatesCreated()
{
    local int Index;
    local LWCEItemTemplateManager kItemMgr;
    local LWCEShipWeaponTemplate kShipWeaponTemplate;
    local array<LWCEItemTemplate> arrTemplates;

    kItemMgr = `LWCE_ITEM_TEMPLATE_MGR;
    arrTemplates = kItemMgr.GetAllItemTemplates();

    AdjustBuildTimes(arrTemplates);

    // TODO: need to make alien grenades unsellable until researched to match base game

    // TODO: many more functions to OPTC here
    kItemMgr.FindWeaponTemplate('Item_PlasmaDragon').arrBonusWeaponDamageFn.AddItem(CalcBonusWeaponDamage_PlasmaDragon);

    kItemMgr.FindItemTemplate('Item_AlienGrenade').IsInfiniteFn = IsInfinite_AlienGrenade;
    kItemMgr.FindItemTemplate('Item_BaseAugments').IsInfiniteFn = IsInfinite_MecBaseGear;
    kItemMgr.FindItemTemplate('Item_Minigun').IsInfiniteFn = IsInfinite_MecBaseGear;

    kItemMgr.FindEquipmentTemplate('Item_ArcThrower').GetBonusWeaponAmmoFn = GetBonusWeaponAmmoFn_ArcThrower;
    kItemMgr.FindEquipmentTemplate('Item_Medikit').GetBonusWeaponAmmoFn = GetBonusWeaponAmmoFn_Medikit;
    kItemMgr.FindEquipmentTemplate('Item_RestorativeMist').GetBonusWeaponAmmoFn = GetBonusWeaponAmmoFn_RestorativeMist;

    kItemMgr.FindEquipmentTemplate('Item_AlienGrenade').GetBonusWeaponAmmoFn = GetBonusWeaponAmmoFn_OffensiveGrenade;
    kItemMgr.FindEquipmentTemplate('Item_APGrenade').GetBonusWeaponAmmoFn    = GetBonusWeaponAmmoFn_OffensiveGrenade;
    kItemMgr.FindEquipmentTemplate('Item_HEGrenade').GetBonusWeaponAmmoFn    = GetBonusWeaponAmmoFn_OffensiveGrenade;

    kItemMgr.FindEquipmentTemplate('Item_BattleScanner').GetBonusWeaponAmmoFn    = GetBonusWeaponAmmoFn_SupportGrenade;
    kItemMgr.FindEquipmentTemplate('Item_ChemGrenade').GetBonusWeaponAmmoFn      = GetBonusWeaponAmmoFn_SupportGrenade;
    kItemMgr.FindEquipmentTemplate('Item_FlashbangGrenade').GetBonusWeaponAmmoFn = GetBonusWeaponAmmoFn_SupportGrenade;
    kItemMgr.FindEquipmentTemplate('Item_MimicBeacon').GetBonusWeaponAmmoFn      = GetBonusWeaponAmmoFn_SupportGrenade;
    kItemMgr.FindEquipmentTemplate('Item_PsiGrenade').GetBonusWeaponAmmoFn       = GetBonusWeaponAmmoFn_SupportGrenade;
    kItemMgr.FindEquipmentTemplate('Item_SmokeGrenade').GetBonusWeaponAmmoFn     = GetBonusWeaponAmmoFn_SupportGrenade;

    // TODO: stat changes should be handled as a new perk which applies to the character
    kItemMgr.FindEquipmentTemplate('Item_LaserSight').ModifyStatChangesFn = ModifyStatChanges_ScopeUpgrade;
    kItemMgr.FindEquipmentTemplate('Item_SCOPE').ModifyStatChangesFn = ModifyStatChanges_ScopeUpgrade;

    // All ship weapons benefit from base game Foundry projects. Alien-only weapons are included; the stat modifier
    // functions will filter out alien ships as needed.
    for (Index = 0; Index < arrTemplates.Length; Index++)
    {
        if (!arrTemplates[Index].IsShipWeapon())
        {
            continue;
        }

        kShipWeaponTemplate = LWCEShipWeaponTemplate(arrTemplates[Index]);

        kShipWeaponTemplate.arrArmorPenModifiers.AddItem(ShipWeapon_ArmorPenModifier);
        kShipWeaponTemplate.arrDamageModifiers.AddItem(ShipWeapon_DamageModifier);
        kShipWeaponTemplate.arrFiringTimeModifiers.AddItem(ShipWeapon_FiringTimeModifier);
        kShipWeaponTemplate.arrHitChanceModifiers.AddItem(ShipWeapon_HitChanceModifier);
    }
}

protected static function bool IsInfinite_AlienGrenade()
{
    return `LWCE_ENGINEERING.LWCE_IsFoundryTechResearched('Foundry_AlienGrenades');
}

protected static function bool IsInfinite_MecBaseGear()
{
    return `LWCE_HQ.LWCE_HasFacility('Facility_RepairBay');
}

private static function AdjustBuildTimes(array<LWCEItemTemplate> arrTemplates)
{
    local int Index;

    for (Index = 0; Index < arrTemplates.Length; Index++)
    {
        arrTemplates[Index].iPointsToComplete *= class'XGTacticalGameCore'.default.ITEM_TIME_BALANCE;
    }
}

private static function float CalcBonusWeaponDamage_PlasmaDragon(LWCE_XGUnit kSource, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility)
{
    return kTarget.IsFlying() ? 1.0f : 0.0f;
}

private static function int GetBonusWeaponAmmoFn_ArcThrower(const LWCEEquipmentTemplate kEquipment, const LWCE_TCharacter kChar)
{
    local int iTotalBonus;

    if (HasPerk(kChar, `LW_PERK_ID(Repair)))
    {
        iTotalBonus += 2;
    }

    if (HasPerk(kChar, `LW_PERK_ID(Packmaster)))
    {
        iTotalBonus += 1;
    }

    return iTotalBonus;
}

private static function int GetBonusWeaponAmmoFn_Medikit(const LWCEEquipmentTemplate kEquipment, const LWCE_TCharacter kChar)
{
    local int iTotalBonus;

    if (HasPerk(kChar, `LW_PERK_ID(FieldMedic)))
    {
        iTotalBonus += 1;
    }

    if (HasPerk(kChar, `LW_PERK_ID(Packmaster)))
    {
        iTotalBonus += 1;
    }

    return iTotalBonus;
}

private static function int GetBonusWeaponAmmoFn_OffensiveGrenade(const LWCEEquipmentTemplate kEquipment, const LWCE_TCharacter kChar)
{
    local int iTotalBonus;

    if (HasPerk(kChar, `LW_PERK_ID(Grenadier)))
    {
        iTotalBonus += 1;
    }

    if (HasPerk(kChar, `LW_PERK_ID(Packmaster)))
    {
        iTotalBonus += 1;
    }

    return iTotalBonus;
}

private static function int GetBonusWeaponAmmoFn_RestorativeMist(const LWCEEquipmentTemplate kEquipment, const LWCE_TCharacter kChar)
{
    local int iTotalBonus;

    if (HasPerk(kChar, `LW_PERK_ID(FieldMedic)))
    {
        iTotalBonus += 2;
    }

    if (HasPerk(kChar, `LW_PERK_ID(Packmaster)))
    {
        iTotalBonus += 1;
    }

    return iTotalBonus;
}

private static function int GetBonusWeaponAmmoFn_SupportGrenade(const LWCEEquipmentTemplate kEquipment, const LWCE_TCharacter kChar)
{
    local int iTotalBonus;

    if (HasPerk(kChar, `LW_PERK_ID(SmokeAndMirrors)))
    {
        iTotalBonus += 1;
    }

    if (HasPerk(kChar, `LW_PERK_ID(Packmaster)))
    {
        iTotalBonus += 1;
    }

    if (kEquipment.GetItemName() == 'Item_SmokeGrenade' && HasPerk(kChar, `LW_PERK_ID(SmokeGrenade)))
    {
        iTotalBonus += 1;
    }

    return iTotalBonus;
}

/// <summary>
/// This is a giant collection of all bonus weapon ammo situations, most of which should be in their own
/// ability or item templates. This is being used until such time as we have proper templates in place.
///
/// THIS IS KNOWINGLY INCOMPLETE. An accurate version will have to wait for full templates.
/// </summary>
private static function int GetBonusWeaponAmmoFn_ToBeDeleted(const LWCEEquipmentTemplate kEquipment, const LWCE_TCharacter kChar)
{
    local int iTotalBonus;
    local name ItemName;

    ItemName = kEquipment.GetItemName();

    if (HasPerk(kChar, `LW_PERK_ID(BattleScanner)) && ItemName == 'Item_BattleScanner')
    {
        // TODO: Battle Scanner just gives 2 base charges, not a bonus per-item
        iTotalBonus += 2;
    }

    // Field Medic bonuses
    if (HasPerk(kChar, `LW_PERK_ID(FieldMedic)))
    {
        if (ItemName == 'Item_Medikit')
        {
            iTotalBonus += 1;
        }
        else if (ItemName == 'Item_RestorativeMist')
        {
            iTotalBonus += 2;
        }
    }

    // Grenadier bonuses
    if (HasPerk(kChar, `LW_PERK_ID(Grenadier)))
    {
        switch (ItemName)
        {
            case 'Item_AlienGrenade':
            case 'Item_APGrenade':
            case 'Item_HEGrenade':
                iTotalBonus += 1;
                break;
        }
    }

    // Packmaster bonuses
    if (HasPerk(kChar, `LW_PERK_ID(Packmaster)))
    {
        switch (ItemName)
        {
            case 'Item_AlienGrenade':
            case 'Item_APGrenade':
            case 'Item_ArcThrower':
            case 'Item_BattleScanner':
            case 'Item_ChemGrenade':
            case 'Item_FlashbangGrenade':
            case 'Item_HEGrenade':
            case 'Item_Medikit':
            case 'Item_MimicBeacon':
            case 'Item_PsiGrenade':
            case 'Item_RestorativeMist':
            case 'Item_SmokeGrenade':
                iTotalBonus += 1;
                break;
        }
    }

    // Repair bonuses
    if (HasPerk(kChar, `LW_PERK_ID(Repair)))
    {
        if (ItemName == 'Item_ArcThrower')
        {
            iTotalBonus += 2;
        }
    }

    if (HasPerk(kChar, `LW_PERK_ID(SmokeAndMirrors)))
    {
        switch (ItemName)
        {
            case 'Item_SmokeGrenade':
            case 'Item_FlashbangGrenade':
            case 'Item_ChemGrenade':
            case 'Item_PsiGrenade':
            case 'Item_BattleScanner':
            case 'Item_MimicBeacon':
                iTotalBonus += 1;
                break;
        }
    }

    if (HasPerk(kChar, `LW_PERK_ID(SmokeGrenade)) && ItemName == 'Item_SmokeGrenade')
    {
        // TODO this will apply per-item
        iTotalBonus += 1;
    }

    return iTotalBonus;
}

private static function bool HasPerk(const out LWCE_TCharacter kChar, int iPerkId)
{
    return kChar.arrPerks.Find('ID', iPerkId) != INDEX_NONE;
}

private static function ModifyStatChanges_ScopeUpgrade(const LWCEEquipmentTemplate kEquipment, out LWCE_TCharacterStats kStatChangesOut, const LWCE_TCharacter kCharacter)
{
    if (!`LWCE_UTILS.IsFoundryTechResearched('Foundry_SCOPEUpgrade'))
    {
        return;
    }

    // TODO: move values to config
    switch (kEquipment.GetItemName())
    {
        case 'Item_LaserSight':
            kStatChangesOut.iCriticalChance += 4;
            break;
        case 'Item_SCOPE':
            kStatChangesOut.iCriticalChance += 8;
            break;
    }
}

// TODO: move the stats applied below into configuration

private static function int ShipWeapon_ArmorPenModifier(LWCEShipWeaponTemplate kShipWeapon, XGShip kShip, bool bShipIsXCom, int iCurrentValue)
{
    local LWCE_XGFacility_Engineering kEngineering;
    local int iArmorPenModifier;

    if (bShipIsXCom)
    {
        kEngineering = `LWCE_ENGINEERING;

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_PenetratorWeapons'))
        {
            iArmorPenModifier += 25;
        }

        if (kShipWeapon != none && kShipWeapon.GetItemName() == 'Item_LaserCannon' && kEngineering.LWCE_IsFoundryTechResearched('Foundry_Supercapacitors'))
        {
            iArmorPenModifier += 30;
        }
        else if (kShipWeapon != none && kShipWeapon.GetItemName() == 'Item_PhoenixCannon' && kEngineering.LWCE_IsFoundryTechResearched('Foundry_PhoenixCoilguns'))
        {
            iArmorPenModifier += 65;
        }
    }

    return iArmorPenModifier;
}

private static function int ShipWeapon_DamageModifier(LWCEShipWeaponTemplate kShipWeapon, XGShip kShip, bool bShipIsXCom, int iCurrentValue)
{
    local LWCE_XGFacility_Engineering kEngineering;
    local int iDamageModifier;

    if (bShipIsXCom)
    {
        kEngineering = `LWCE_ENGINEERING;

        if (kShipWeapon != none && kShipWeapon.GetItemName() == 'Item_LaserCannon' && kEngineering.LWCE_IsFoundryTechResearched('Foundry_Supercapacitors'))
        {
            iDamageModifier += 10;
        }
        else if (kShipWeapon != none && kShipWeapon.GetItemName() == 'Item_PhoenixCannon' && kEngineering.LWCE_IsFoundryTechResearched('Foundry_PhoenixCoilguns'))
        {
            iDamageModifier += 90;
        }
    }

    return iDamageModifier;
}

private static function float ShipWeapon_FiringTimeModifier(LWCEShipWeaponTemplate kShipWeapon, XGShip kShip, bool bShipIsXCom, float fCurrentValue)
{
    local float fFiringTimeModifier;

    if (bShipIsXCom)
    {
        if (kShipWeapon != none && kShipWeapon.GetItemName() == 'Item_LaserCannon' && `LWCE_ENGINEERING.LWCE_IsFoundryTechResearched('Foundry_Supercapacitors'))
        {
            fFiringTimeModifier = -0.25f;
        }
    }

    return fFiringTimeModifier;
}

private static function int ShipWeapon_HitChanceModifier(LWCEShipWeaponTemplate kShipWeapon, XGShip kShip, bool bShipIsXCom, int iCurrentValue)
{
    local int iAimModifier;

    if (bShipIsXCom)
    {
        if (`LWCE_ENGINEERING.LWCE_IsFoundryTechResearched('Foundry_ImprovedAvionics'))
        {
            iAimModifier += 10;
        }
    }
    else
    {
        if (`LWCE_ENGINEERING.LWCE_IsFoundryTechResearched('Foundry_UFOCountermeasures'))
        {
            iAimModifier -= 15;
        }
    }

    return iAimModifier;
}
