class LWCE_XComPresentationLayerBase_Extensions extends Object
    abstract;

static simulated function State_PCKeybindings_Activate(const XComPresentationLayerBase kSelf)
{
    kSelf.m_kPCKeybindings = kSelf.Spawn(class'LWCE_UIKeybindingsPCScreen', kSelf);
    kSelf.m_kPCKeybindings.Init(XComPlayerController(kSelf.Owner), kSelf.GetHUD());
}

static simulated function State_SaveScreen_Activate(const XComPresentationLayerBase kSelf)
{
    if (XComOnlineEventMgr(GameEngine(class'Engine'.static.GetEngine()).OnlineEventManager).HasValidLoginAndStorage())
    {
        kSelf.m_kSaveUI = kSelf.Spawn(class'LWCE_UISaveGame', kSelf);
        kSelf.m_kSaveUI.Init(XComPlayerController(kSelf.Owner), kSelf.GetHUD());
        kSelf.m_kSaveUI.Show();
    }
    else
    {
        kSelf.HandleInvalidStorage(kSelf.m_strSelectSaveDeviceForSavePrompt, kSelf.UISaveScreen);
        kSelf.PopState();
    }
}

static simulated function State_LoadScreen_Activate(const XComPresentationLayerBase kSelf)
{
    if (XComOnlineEventMgr(GameEngine(class'Engine'.static.GetEngine()).OnlineEventManager).HasValidLoginAndStorage())
    {
        kSelf.m_kLoadUI = kSelf.Spawn(class'LWCE_UILoadGame', kSelf);
        kSelf.m_kLoadUI.Init(XComPlayerController(kSelf.Owner), kSelf.GetHUD());
        kSelf.m_kLoadUI.Show();
    }
    else
    {
        kSelf.HandleInvalidStorage(kSelf.m_strSelectSaveDeviceForLoadPrompt, kSelf.UILoadScreen);
        kSelf.PopState();
    }
}