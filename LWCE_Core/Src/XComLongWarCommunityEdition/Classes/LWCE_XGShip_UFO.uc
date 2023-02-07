class LWCE_XGShip_UFO extends XGShip_UFO implements(LWCE_XGShip);

struct CheckpointRecord_LWCE_XGShip_UFO extends CheckpointRecord_XGShip_UFO
{
    var LWCE_TShip m_kCETShip;
};

var LWCE_TShip m_kCETShip;

function Init(TShip kTShip)
{
    local LWCE_TItemQuantity kItemQuantity;
    local int Index;
    local name ItemName;

    class'LWCE_XGShip_Extensions'.static.Init(self, kTShip);
    InitSound();

    // Copy from the base game struct for now; eventually we'll move this to templates too
    m_kCETShip.eType = m_kTShip.eType;
    m_kCETShip.strName = m_kTShip.strName;
    m_kCETShip.strSize = m_kTShip.strSize;
    m_kCETShip.iSpeed = m_kTShip.iSpeed;
    m_kCETShip.iEngagementSpeed = m_kTShip.iEngagementSpeed;
    m_kCETShip.iHP = m_kTShip.iHP;
    m_kCETShip.iArmor = m_kTShip.iArmor;
    m_kCETShip.iArmorPen = m_kTShip.iAP;
    m_kCETShip.iRange = m_kTShip.iRange;
    m_kCETShip.iImage = m_kTShip.iImage;

    for (Index = 1; Index < eItem_MAX; Index++)
    {
        if (m_kTShip.arrSalvage[Index] > 0)
        {
            ItemName = class'LWCE_XGItemTree'.static.ItemNameFromBaseID(Index);

            kItemQuantity.ItemName = ItemName;
            kItemQuantity.iQuantity = m_kTShip.arrSalvage[Index];

            m_kCETShip.arrSalvage.AddItem(kItemQuantity);
        }
    }

    for (Index = 0; Index < m_kTShip.arrWeapons.Length; Index++)
    {
        switch (m_kTShip.arrWeapons[Index])
        {
            case eShipWeapon_UFOPlasmaI:
                ItemName = 'Item_UFOPlasmaMkI';
                break;
            case eShipWeapon_UFOPlasmaII:
                ItemName = 'Item_UFOPlasmaMkII';
                break;
            case eShipWeapon_UFOFusionI:
                ItemName = 'Item_UFOFusionMkI';
                break;
            default:
                ItemName = '';
        }

        if (ItemName != '')
        {
            m_kCETShip.arrWeapons.AddItem(ItemName);
        }
    }
}

function LWCE_TShip GetShipData()
{
    return m_kCETShip;
}

function name GetWeaponAtIndex(int Index)
{
    if (Index >= m_kCETShip.arrWeapons.Length)
    {
        return '';
    }

    return m_kCETShip.arrWeapons[Index];
}

function array<TShipWeapon> GetWeapons()
{
    local array<TShipWeapon> arrWeapons;

    `LWCE_LOG_DEPRECATED_CLS(GetWeapons);

    arrWeapons.Length = 0;
    return arrWeapons;
}

function array<name> LWCE_GetWeapons()
{
    return m_kCETShip.arrWeapons;
}

function int NumWeapons()
{
    return m_kCETShip.arrWeapons.Length;
}