class Highlander_XGShip_Interceptor extends XGShip_Interceptor;

function EquipWeapon(EItemType eItem)
{
    `HL_LOG_DEPRECATED_CLS(EquipWeapon);
}

function HL_EquipWeapon(int iItemId)
{
    local Highlander_XGFacility_Hangar kHangar;

    kHangar = `HL_HANGAR;

    // TODO: rewrite this method for generic ints
    if (m_eWeapon != 0 && iItemId != 255) // Wingtip Sparrowhawks
    {
        STORAGE().AddItem(m_eWeapon);
    }

    if (iItemId != 255) // Wingtip Sparrowhawks
    {
        m_eWeapon = EItemType(iItemId);
    }

    m_kTShip.arrWeapons.Remove(0, m_kTShip.arrWeapons.Length);
    m_kTShip.arrWeapons.AddItem(kHangar.HL_ItemTypeToShipWeapon(m_eWeapon));

    if (ENGINEERING().IsFoundryTechResearched(27)) // Wingtip Sparrowhawks
    {
        m_kTShip.arrWeapons.AddItem(kHangar.HL_ItemTypeToShipWeapon(/* Stingray Missiles */ 116));
    }

    if (m_kHangarShip != none)
    {
        m_kHangarShip.UpdateWeapon(EShipWeapon(kHangar.HL_ItemTypeToShipWeapon(m_eWeapon)));
    }
}

function string GetWeaponString()
{
    return `HL_ITEM(m_eWeapon).strName;
}

function XGHangarShip GetWeaponViewShip()
{
    if (m_kHangarShip == none)
    {
        if (IsFirestorm())
        {
            m_kHangarShip = Spawn(class'XGHangarShip_Firestorm', self);
        }
        else
        {
            m_kHangarShip = Spawn(class'XGHangarShip', self);
        }

        m_kHangarShip.Init();
        m_kHangarShip.UpdateWeapon(EShipWeapon(`HL_HANGAR.HL_ItemTypeToShipWeapon(m_eWeapon)));
    }

    return m_kHangarShip;
}