class LWCE_UITacticalHUD_WeaponContainer extends UITacticalHUD_WeaponContainer;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UI_FxsScreen _screen)
{
    PanelInit(_controllerRef, _manager, _screen);

    m_kWeaponPanel0 = Spawn(class'LWCE_UITacticalHUD_WeaponPanel', self);
    m_kWeaponPanel0.Init(_controllerRef, _manager, _screen, 'weapon0');

    m_kWeaponPanel1 = Spawn(class'LWCE_UITacticalHUD_WeaponPanel', self);
    m_kWeaponPanel1.Init(_controllerRef, _manager, _screen, 'weapon1');
}

simulated function SetWeapons(XGWeapon ActiveWeapon, XGWeapon PrimaryWeapon, optional XGWeapon SecondaryWeapon = none, optional XGWeapon tertiaryWeapon = none)
{
    m_kWeaponPanel0.SetWeaponAndAmmo(PrimaryWeapon);
    m_kWeaponPanel1.SetWeaponAndAmmo(SecondaryWeapon);

    AS_SetWeaponName(LWCE_XGWeapon(ActiveWeapon).m_kTemplate.strName);

    if (ActiveWeapon == none)
    {
        HideSelectionBrackets();
    }
    else if (!UITacticalHUD(Owner).m_isMenuRaised)
    {
        UpdateSelectionBracket(ActiveWeapon);
    }
}