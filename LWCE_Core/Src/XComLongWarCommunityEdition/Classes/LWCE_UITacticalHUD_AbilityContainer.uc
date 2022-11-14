class LWCE_UITacticalHUD_AbilityContainer extends UITacticalHUD_AbilityContainer;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen)
{
    local int I;
    local UITacticalHUD_AbilityItem kItem;

    PanelInit(_controller, _manager, _screen);

    for (I = 0; I < 30; I++)
    {
        kItem = new class'LWCE_UITacticalHUD_AbilityItem';
        kItem.m_kContainer = self;
        kItem.m_kMovieMgr = _manager;
        kItem.m_kController = _controller;
        m_arrUIAbilityData.AddItem(kItem);
    }
}
