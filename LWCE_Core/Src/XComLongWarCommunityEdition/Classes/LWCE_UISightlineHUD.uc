class LWCE_UISightlineHUD extends UISightlineHUD;

simulated function Init(XComTacticalController _controllerRef, UIFxsMovie _manager)
{
    BaseInit(_controllerRef, _manager);
    m_kSightlineContainer = Spawn(class'LWCE_UISightlineHUD_SightlineContainer', self);
    m_kSightlineContainer.Init(_controllerRef, _manager, self);
}