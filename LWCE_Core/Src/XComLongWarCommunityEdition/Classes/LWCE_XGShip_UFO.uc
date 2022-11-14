class LWCE_XGShip_UFO extends XGShip_UFO;

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

    super.Init(kTShip);

    // Copy from the base game struct for now; eventually we'll probably move this to templates too
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

        if (m_kTShip.arrWeapons[Index] > 0)
        {
            ItemName = class'LWCE_XGItemTree'.static.ItemNameFromBaseID(Index);

            m_kCETShip.arrWeapons.AddItem(ItemName);
        }
    }
}