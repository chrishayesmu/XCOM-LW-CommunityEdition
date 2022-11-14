class LWCEArmorTemplate extends LWCEEquipmentTemplate;

var config name nmArmorCategory; // TODO how are we even using this

var config int iExtraConditioningBonusHP;

var config int iLargeItemSlots;

var config int iSmallItemSlots;

var config array<name> arrProperties; // Properties of the armor; LWCE uses the values from EArmorProperty, but the array uses names so that
                                      // mods can define custom properties if they wish.

function int GetLargeInventorySlots(XGStrategySoldier kSoldier)
{
    if (kSoldier.HasPerk(`LW_PERK_ID(FireRocket)))
    {
        return iLargeItemSlots + 1;
    }

    return iLargeItemSlots;
}

function int GetSmallInventorySlots(XGStrategySoldier kSoldier)
{
    local bool bHasTacRigging;

    bHasTacRigging = kSoldier.HasPerk(`LW_PERK_ID(TacticalRigging));

    // Jungle Scouts starting bonus: certain early-game armors count as having Tactical Rigging
    if (`LWCE_HQ.HasBonus(`LW_HQ_BONUS_ID(JungleScouts)) > 0)
    {
        switch (GetItemName())
        {
            case 'Item_AuroraArmor':
            case 'Item_KestrelArmor':
            case 'Item_PhalanxArmor':
            case 'Item_TacArmor':
            case 'Item_TacVest':
                bHasTacRigging = true;
                break;
        }
    }

    if (bHasTacRigging)
    {
        return iSmallItemSlots + 1;
    }

    return iSmallItemSlots;
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