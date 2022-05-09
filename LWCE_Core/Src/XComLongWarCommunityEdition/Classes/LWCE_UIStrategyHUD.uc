class LWCE_UIStrategyHUD extends UIStrategyHUD;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager)
{
    local XComOnlineProfileSettings ProfileSettings;

    m_kBuildQueue = Spawn(class'LWCE_UIStrategyHUD_BuildQueue', self);
    m_kBuildQueue.Init(_controller, _manager, self);

    BaseInit(_controller, _manager);

    m_kHelpBar = Spawn(class'UINavigationHelp', self);
    m_kHelpBar.Init(_controller, _manager, self, UpdateTopLevelButtonHelp);

    m_kMenu = Spawn(class'UIStrategyHUD_FacilityMenu', self);
    m_kMenu.Init(_controller, _manager, self);

    m_kEventList = Spawn(class'LWCE_UIStrategyComponent_EventList', self);
    m_kEventList.m_iMaxEventsPerRow = 1;
    m_kEventList.m_bExpandListVertically = true;
    m_kEventList.Init(_controller, _manager, self);

    m_kClock = Spawn(class'LWCE_UIStrategyComponent_Clock', self);
    m_kClock.Init(_controller, _manager, self);

    ProfileSettings = XComOnlineProfileSettings(class'Engine'.static.GetEngine().GetProfileSettings());

    if (ProfileSettings != none)
    {
        controllerRef.SetTouchEnabled(ProfileSettings.Data.IsTouchActive());

        if (ProfileSettings.Data.IsTouchActive())
        {
            manager.EnableTouch();
        }
        else
        {
            manager.DisableTouch();
        }
    }
}

simulated function OnLoseFocus()
{
    m_bIsFocused = false;
    m_bPostOnInitFocusCached = false;
    m_kHelpBar.ClearButtonHelp();

    if (m_kMgr != none)
    {
        m_kMgr.OnLoseFocus();
    }

    if (m_kMenu != none)
    {
        m_kMenu.OnLoseFocus();
    }

    if (m_kClock != none)
    {
        m_kClock.OnLoseFocus();
    }

    if (m_kEventList != none)
    {
        m_kEventList.OnLoseFocus();
    }

    AS_HideTicker();
    AS_HideHotlink();
    Hide();
}