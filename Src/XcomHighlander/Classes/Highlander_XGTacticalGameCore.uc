class Highlander_XGTacticalGameCore extends XGTacticalGameCore
    config(HighlanderBaseTacticalGame)
    dependson(HighlanderTypes);

struct CheckpointRecord
{
    var array<XGItem> arrRecordedItems;
    var array<string> arrItemStrings;
};

var config array<HL_TWeapon> arrCfgWeapons;
var config int SuppressionAimPenalty;

// ----------------------------------------
// Config for tactical game abilities
// ----------------------------------------

var config float fShredderRocketDamageMultiplier;

var config int iImprovedMedikitHealBonus;
var config int iMayhemDamageBonusForGrenades;
var config int iMayhemDamageBonusForMachineGuns;
var config int iMayhemDamageBonusForRocketLaunchers;
var config int iMayhemDamageBonusForSniperRifles;
var config int iMindfrayDamage;
var config int iMedikitHealBase;
var config int iPrecisionShotDamageBonusForBallisticSniper;
var config int iPrecisionShotDamageBonusForGaussSniper;
var config int iPrecisionShotDamageBonusForLaserSniper;
var config int iPrecisionShotDamageBonusForPulseSniper;
var config int iPrecisionShotDamageBonusForPlasmaSniper;
var config int iRepairHealBaseAliens;
var config int iRepairHealBaseXCOM;
var config int iSapperDamageBonus;
var config int iSaviorHealBonus;
var config int iSmartMacrophagesHealBonus;

var array<HL_TWeapon> m_arrHLWeapons;

// TODO document these
var array<XGItem> arrRecordedItems;
var array<string> arrItemStrings;


simulated event Init()
{
    m_arrWeapons.Add(255);
    m_arrArmors.Add(255);
    m_arrCharacters.Add(32);

    if (Role == ROLE_Authority)
    {
        m_kAbilities = Spawn(class'Highlander_XGAbilityTree', self);
        m_kAbilities.Init();
    }

    BuildWeapons();
    BuildArmors();
    BuildCharacters();
    m_bInitialized = true;
}

function CreateCheckpointRecord()
{
    local XGItem kItem;

    arrRecordedItems.Remove(0, arrRecordedItems.Length);
    arrItemStrings.Remove(0, arrItemStrings.Length);

    foreach AllActors(class'XGItem', kItem)
    {
        arrRecordedItems.AddItem(kItem);
        arrItemStrings.AddItem(kItem.m_strUIImage);
    }

    `HL_LOG_CLS("Recorded " $ arrRecordedItems.Length $ " items to persist");
}

function ApplyCheckpointRecord()
{
    local int Index;

    for (Index = 0; Index < arrRecordedItems.Length; Index++)
    {
        arrRecordedItems[Index].m_strUIImage = arrItemStrings[Index];
    }

    `HL_LOG_CLS("Loaded " $ arrRecordedItems.Length $ " item IDs");
}

simulated function BuildWeapons()
{
    local HL_TWeapon kWeapon;

    // TODO delete this
    super.BuildWeapons();

    m_arrHLWeapons.Remove(0, m_arrHLWeapons.Length);

    foreach default.arrCfgWeapons(kWeapon)
    {
        if (kWeapon.iItemId < 255)
        {
            kWeapon.strName = class'XLocalizedData'.default.m_aItemNames[kWeapon.iItemId];
        }

        m_arrHLWeapons.AddItem(kWeapon);
    }

    // TODO add mod hook
}

/// <summary>
/// Retrieves a TWeapon struct. THIS FUNCTION IS NOT FOR MODS TO USE.
/// It exists strictly for parts of the vanilla code base that can't be rewritten.
/// Mods should only use HL_GetTWeapon.
/// </summary>
simulated function TWeapon GetTWeapon(int iWeapon)
{
    local int iAbilityId, iPropertyId;
    local HL_TWeapon kHLWeapon;
    local TWeapon kWeapon;

    // Map as much as we can into the original struct
    kHLWeapon = HL_GetTWeapon(iWeapon);

    kWeapon.strName = kHLWeapon.strName;
    kWeapon.iType = kHLWeapon.iItemId;
    kWeapon.iSize = kHLWeapon.iSize;
    kWeapon.iDamage = kHLWeapon.iDamage;
    kWeapon.iEnvironmentDamage = kHLWeapon.iEnvironmentDamage;
    kWeapon.iRange = kHLWeapon.iRange;
    kWeapon.iReactionRange = kHLWeapon.iReactionRange;
    kWeapon.iRadius = kHLWeapon.iRadius;
    kWeapon.iCritical = kHLWeapon.kStatChanges.iCriticalChance;
    kWeapon.iOffenseBonus = kHLWeapon.kStatChanges.iAim;
    kWeapon.iHPBonus = kHLWeapon.kStatChanges.iHP;
    kWeapon.iWillBonus = kHLWeapon.kStatChanges.iWill;

    // iSuppression holds the ammo amount; the high digits are the amount with Ammo Conservation, which
    // always grants +1 ammo, and the low digits are the amount without.
    if (kHLWeapon.iBaseAmmo > 0)
    {
        kWeapon.iSuppression = 100 * (kHLWeapon.iBaseAmmo + 1) + kHLWeapon.iBaseAmmo;
    }

    foreach kHLWeapon.arrAbilities(iAbilityId)
    {
        if (iAbilityId < eAbility_MAX)
        {
            kWeapon.aAbilities[iAbilityId] = 1;
        }
    }

    foreach kHLWeapon.arrProperties(iPropertyId)
    {
        if (iPropertyId < eWP_MAX)
        {
            kWeapon.aProperties[iPropertyId] = 1;
        }
    }

    return kWeapon;
}

simulated function HL_TWeapon HL_GetTWeapon(int iWeapon)
{
    local int Index;
    local HL_TWeapon kBlankWeapon;

    Index = m_arrHLWeapons.Find('iItemId', iWeapon);

    if (Index == INDEX_NONE)
    {
        return kBlankWeapon;
    }

    return m_arrHLWeapons[Index];
}

// This was a rewritten function in Long War that should be deprecated, but it's called in too many
// places to bother rewriting and it already has the right signature, so we just delegate to a method
// that has a better name for mods to call.
simulated function int GetUpgradeAbilities(int iRank, int iPersonality)
{
    return GetEquipmentItemStat(iRank, iPersonality);
}

// TODO: document that this doesn't apply to primary weapons or pistols
simulated function int GetEquipmentItemStat(int iItemId, int iCharacterStat)
{
    local HL_TWeapon kWeapon;

    if (iItemId == 0)
    {
        return 0;
    }

    if (!WeaponHasProperty(iItemId, eWP_Secondary) && !WeaponHasProperty(iItemId, eWP_Backpack))
    {
        if (iCharacterStat != eStat_Defense && iCharacterStat != eStat_Mobility)
        {
            return 0;
        }
    }

    kWeapon = HL_GetTWeapon(iItemId);

    switch (iCharacterStat)
    {
        case eStat_HP:
            return kWeapon.kStatChanges.iHP;
        case eStat_CriticalShot:
            return kWeapon.kStatChanges.iCriticalChance;
        case eStat_Offense:
            return kWeapon.kStatChanges.iAim;
        case eStat_FlightFuel:
            return kWeapon.kStatChanges.iFlightFuel;
        case eStat_Defense:
            return kWeapon.kStatChanges.iDefense;
        case eStat_Mobility:
            return kWeapon.kStatChanges.iMobility;
        case eStat_DamageReduction:
            return kWeapon.kStatChanges.iDamageReduction;
        case eStat_Will:
            return kWeapon.kStatChanges.iWill;
        default:
            return 0;
    }
}

simulated function GetInventoryStatModifiers(out int aModifiers[ECharacterStat], out TCharacter kCharacter, EItemType iEquippedWeapon, array<int> arrBackPackItems)
{
    `HL_LOG_DEPRECATED_CLS(GetInventoryStatModifiers);
    //HL_GetInventoryStatModifiers(aModifiers, kCharacter, iEquippedWeapon, arrBackPackItems);
}

simulated function HL_GetInventoryStatModifiers(out int aModifiers[ECharacterStat], out TCharacter kCharacter, int iEquippedWeaponItemId, array<int> arrBackpackItemIds)
{
    local int iStat;

    //`HL_LOG_CLS("HL_GetInventoryStatModifiers: iEquippedWeaponItemId = " $ iEquippedWeaponItemId);

    foreach arrBackpackItemIds(iStat)
    {
        //`HL_LOG_CLS("Backpack contains item " $ iStat);
    }

    for (iStat = 0; iStat < eStat_MAX; iStat++)
    {
        aModifiers[iStat]  = GetWeaponStatBonus(iStat, iEquippedWeaponItemId, kCharacter);
        aModifiers[iStat] += GetArmorStatBonus(iStat, kCharacter.kInventory.iArmor, kCharacter);

        if (kCharacter.aUpgrades[27] > 0) // Extra Conditioning
        {
            aModifiers[iStat] += GetExtraArmorStatBonus(iStat, kCharacter.kInventory.iArmor);
        }

        if ( !WeaponHasProperty(iEquippedWeaponItemId, eWP_Pistol) || (iStat != eStat_Offense && iStat != eStat_CriticalShot) )
        {
            aModifiers[iStat] += GetBackpackStatBonus(iStat, arrBackPackItemIds, kCharacter);

            switch (iStat)
            {
                case eStat_HP:
                    if ((kCharacter.aUpgrades[123] & 1) > 0) // Shaped Armor
                    {
                        if (kCharacter.iType == eChar_Tank || kCharacter.eClass == eSC_Mec)
                        {
                            aModifiers[iStat] += 3;
                        }
                    }

                    break;
                case eStat_Mobility:
                    aModifiers[iStat] += TotalStatFromItem(kCharacter.kInventory.iArmor, ECharacterStat(iStat));

                    if (kCharacter.aUpgrades[31] > 0) // Sprinter
                    {
                        aModifiers[iStat] += 4;
                    }

                    break;
                case eStat_DamageReduction:
                    aModifiers[iStat] += TotalStatFromItem(kCharacter.kInventory.iArmor, ECharacterStat(iStat));

                    if (kCharacter.aUpgrades[132] > 0) // Automated Threat Assessment
                    {
                        aModifiers[iStat] += 5;
                    }

                    if (kCharacter.aUpgrades[148] > 0) // Iron Skin
                    {
                        aModifiers[iStat] += 10;
                    }

                    break;
                case eStat_Offense:
                    aModifiers[iStat] += TotalStatFromItem(kCharacter.kInventory.iArmor, ECharacterStat(iStat));
                    break;
                case eStat_FlightFuel:
                    if ((kCharacter.aUpgrades[123] & 8) > 0) // Advanced Flight
                    {
                        aModifiers[iStat] *= float(2);
                    }

                    break;
                default:
                    break;
            }
        }
    }
}

simulated function int GetOverheatIncrement(XGUnit kUnit, int iWeapon, int iAbility, out TCharacter kCharacter, optional bool bReactionFire)
{
    local int iAmount;

    if (iWeapon == 0)
    {
        return 0;
    }

    if (WeaponHasProperty(iWeapon, eWP_UnlimitedAmmo))
    {
        return 0;
    }

    if (WeaponHasProperty(iWeapon, eWP_NoReload))
    {
        return 0;
    }

    if (WeaponHasProperty(iWeapon, eWP_Melee))
    {
        return 0;
    }

    iAmount = HL_GetTWeapon(iWeapon).iBaseAmmo;

    if ((kCharacter.aUpgrades[123] & 2) > 0) // Ammo Conservation
    {
        iAmount += 1;
    }

    if (!WeaponHasProperty(iWeapon, eWP_Pistol))
    {
        if (kCharacter.aUpgrades[58] > 0) // Lock and Load
        {
            iAmount += 1;
        }

        if (TInventoryHasItemType(kCharacter.kInventory, `LW_ITEM_ID(HiCapMags)))
        {
            iAmount += 1;
        }

        if (TInventoryHasItemType(kCharacter.kInventory, `LW_ITEM_ID(DrumMags)))
        {
            iAmount += 2;
        }
    }

    iAmount = Max(iAmount, 1);
    iAmount = 100 / iAmount;

    switch (iAbility)
    {
        case eAbility_ShotSuppress:
            iAmount = 2 * iAmount;
            break;
        case eAbility_ShotFlush:
            iAmount = 2 * iAmount;
            break;
        case eAbility_MEC_Barrage:
            iAmount = 2 * iAmount;
            break;
        case eAbility_ShotMayhem:
            iAmount = 2 * iAmount;
            break;
    }

    return iAmount;
}

simulated function int TotalStatFromItem(int iItemId, ECharacterStat eStat)
{
    local TCharacterBalance kCharacterBalance;
    local int iTotal;

    iTotal = 0;

    if (ItemIsWeapon(iItemId))
    {
        return GetEquipmentItemStat(iItemId, eStat);
    }

    // TODO: delete all of this once armor is ported to the Highlander system
    foreach BalanceMods_Classic(kCharacterBalance)
    {
        if (kCharacterBalance.eType == iItemId)
        {
            // Stats are mapped strangely since the original balance struct has limited fields
            switch (eStat)
            {
                case eStat_Offense:
                    iTotal += kCharacterBalance.iAim;
                    break;
                case eStat_Defense:
                    iTotal += kCharacterBalance.iDefense;
                    break;
                case eStat_Mobility:
                    iTotal += kCharacterBalance.iMobility;
                    break;
                case eStat_DamageReduction:
                    iTotal += kCharacterBalance.iHP;
                    break;
                case eStat_CriticalShot:
                    iTotal += kCharacterBalance.iCritHit;
                    break;
                case eStat_FlightFuel:
                    iTotal += kCharacterBalance.iDamage;
                    break;
                default:
                    break;
            }
        }
    }

    return iTotal;
}

function eWeaponRangeCat GetWeaponCatRange(EItemType eWeapon)
{
    `HL_LOG_DEPRECATED_CLS(GetWeaponCatRange);

    return 0;
}

function eWeaponRangeCat HL_GetWeaponCatRange(int iWeaponItemId)
{
    if (HL_GetTWeapon(iWeaponItemId).iRange > 30)
    {
        return eWRC_Long;
    }

    if (HL_GetTWeapon(iWeaponItemId).iReactionRange < 30)
    {
        return eWRC_Short;
    }

    return eWRC_Medium;
}

// TODO: rewrite all of the ItemIs* functions, maybe move into XGItemTree
simulated function bool ItemIsAccessory(int iItem)
{
    return HL_GetTWeapon(iItem).iDamage <= 0;
}

simulated function bool ItemIsWeapon(int iItem)
{
    return HL_GetTWeapon(iItem).iDamage > 0;
}

simulated function bool ItemIsArmor(int iItem)
{
    return m_arrArmors[iItem].iHPBonus > 0;
}

simulated function bool ItemIsMecArmor(int iItem)
{
    switch (iItem)
    {
        case 145:
        case 148:
        case 191:
        case 192:
        case 193:
        case 194:
        case 195:
        case 210:
            return true;
        default:
            return false;
    }
}

simulated function bool ItemIsShipWeapon(int iItem)
{
    return iItem >= 116 && iItem < 123;
}

simulated function bool WeaponHasProperty(int iWeapon, int iWeaponProperty)
{
    return HL_GetTWeapon(iWeapon).arrProperties.Find(iWeaponProperty) != INDEX_NONE;
}