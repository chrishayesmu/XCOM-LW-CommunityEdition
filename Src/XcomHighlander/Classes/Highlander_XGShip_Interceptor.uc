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

// Custom functions for dealing with manually entering callsigns

function string GetCallsign()
{
    if (InStr(m_strCallsign, " ") >= 0)
    {
        return Split(m_strCallsign, " ", true);
    }

    return m_strCallsign;
}

function SetCallsign(string strNewCallsign)
{
    // Only change the callsign if it's different. This covers a small case where the callsign is set after every
    // kill to update the rank, but the rank may not be included in the callsign yet if the player has never named
    // this interceptor. In any other case, the two strings will be different because m_strCallsign will include
    // the rank label, and the incoming callsign should not.
    if (strNewCallsign != m_strCallsign)
    {
        m_strCallsign = `HL_HANGAR.GetRankForKills(m_iConfirmedKills) @ strNewCallsign;
    }
}
