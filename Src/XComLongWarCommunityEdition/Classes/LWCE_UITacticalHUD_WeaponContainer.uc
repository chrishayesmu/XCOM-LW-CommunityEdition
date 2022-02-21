class LWCE_UITacticalHUD_WeaponContainer extends UITacticalHUD_WeaponContainer;

simulated function SetWeapons(XGWeapon ActiveWeapon, XGWeapon PrimaryWeapon, optional XGWeapon secondaryWeapon = none, optional XGWeapon tertiaryWeapon = none)
{
    m_kWeaponPanel0.SetWeaponAndAmmo(PrimaryWeapon);
    m_kWeaponPanel1.SetWeaponAndAmmo(secondaryWeapon);

    AS_SetWeaponName(`LWCE_TWEAPON_FROM_XG(ActiveWeapon).strName);

    if (ActiveWeapon == none)
    {
        HideSelectionBrackets();
    }
    else if (!UITacticalHUD(Owner).m_isMenuRaised)
    {
        UpdateSelectionBracket(ActiveWeapon);
    }
}