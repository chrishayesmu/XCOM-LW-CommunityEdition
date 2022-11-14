class LWCE_UITacticalHUD extends UITacticalHUD;

simulated function Init(XComTacticalController _controllerRef, UIFxsMovie _manager)
{
    BaseInit(_controllerRef, _manager);

    m_kInfoBox = Spawn(class'LWCE_UITacticalHUD_InfoPanel', self);
    m_kInfoBox.Init(controllerRef, manager, self);

    m_kAbilityHUD = Spawn(class'LWCE_UITacticalHUD_AbilityContainer', self);
    m_kAbilityHUD.s_name = 'theRightHUD';
    m_kAbilityHUD.Init(controllerRef, manager, self);

    m_kWeaponContainer = Spawn(class'LWCE_UITacticalHUD_WeaponContainer', self);
    m_kWeaponContainer.Init(_controllerRef, _manager, self);

    m_kStatsContainer = Spawn(class'UITacticalHUD_SoldierStatsContainer', self);
    m_kStatsContainer.Init(_controllerRef, _manager, self);

    m_kRadar = Spawn(class'LWCE_UITacticalHUD_Radar', self);
    m_kRadar.Init(_controllerRef, _manager, self);

    m_kObjectives = Spawn(class'UITacticalHUD_ObjectivesList', self);
    m_kObjectives.Init(_controllerRef, _manager, self);

    m_kPerks = Spawn(class'LWCE_UITacticalHUD_PerkContainer', self);
    m_kPerks.Init(_controllerRef, _manager, self);
}