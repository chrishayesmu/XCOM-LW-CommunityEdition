class LWCEArmorTemplate extends LWCEEquipmentTemplate;

var config name nmArmorCategory; // TODO how are we even using this

var config int iExtraConditioningBonusHP;

var config int iLargeItemSlots;

var config int iSmallItemSlots;

// Properties of the armor; LWCE uses the values from EArmorProperty, but the array uses names so that mods can define custom properties if they wish.
var config array<name> arrProperties;

// Delegates which can modify how many large item inventory slots are available.
var array< delegate<InventorySlotsDel> > arrLargeInventorySlotsFns;

// Delegates which can modify how many small item inventory slots are available.
var array< delegate<InventorySlotsDel> > arrSmallInventorySlotsFns;

delegate InventorySlotsDel(LWCE_XGStrategySoldier kSoldier, out int iNumSlots);

function int GetLargeInventorySlots(LWCE_XGStrategySoldier kSoldier)
{
    local delegate<InventorySlotsDel> delSlotsFn;
    local int iNumSlots;

    iNumSlots = iLargeItemSlots;

    foreach arrLargeInventorySlotsFns(delSlotsFn)
    {
        delSlotsFn(kSoldier, iNumSlots);
    }

    // TODO: move this logic into a dataset's delegate once abilities are migrated
    if (kSoldier.HasPerk(`LW_PERK_ID(FireRocket)))
    {
        iNumSlots++;
    }

    return iNumSlots;
}

function int GetSmallInventorySlots(LWCE_XGStrategySoldier kSoldier)
{
    local bool bHasTacRigging;
    local delegate<InventorySlotsDel> delSlotsFn;
    local int iNumSlots;

    iNumSlots = iSmallItemSlots;

    foreach arrSmallInventorySlotsFns(delSlotsFn)
    {
        delSlotsFn(kSoldier, iNumSlots);
    }

    // TODO: move this logic into a dataset's delegate once abilities are migrated
    bHasTacRigging = kSoldier.HasPerk(`LW_PERK_ID(TacticalRigging));

    if (bHasTacRigging)
    {
        iNumSlots++;
    }

    return iNumSlots;
}

function bool HasArmorProperty(EArmorProperty eProp)
{
    local name PropertyName;

    switch (eProp)
    {
        case eAP_Tank:
            PropertyName = 'SHIV';
            break;
        case eAP_Grapple:
            PropertyName = 'Grapple';
            break;
        case eAP_Psi:
            PropertyName = 'Psi';
            break;
        case eAP_AirEvade:
            PropertyName = 'AirEvade';
            break;
        case eAP_FireImmunity:
            PropertyName = 'FireImmunity';
            break;
        case eAP_PoisonImmunity:
            PropertyName = 'AcidPartialImmunity';
            break;
        case eAP_MEC:
            PropertyName = 'Mec';
            break;
    }

    return HasProperty(PropertyName);
}

function bool HasProperty(name PropertyName)
{
    return arrProperties.Find(PropertyName) != INDEX_NONE;
}

function bool IsArmor()
{
    return true;
}

function bool IsMecArmor()
{
    return arrProperties.Find('Mec') != INDEX_NONE;
}