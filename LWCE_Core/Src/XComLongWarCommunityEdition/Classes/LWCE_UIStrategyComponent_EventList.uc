class LWCE_UIStrategyComponent_EventList extends UIStrategyComponent_EventList;

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none && controllerRef != none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGMissionControlUI', UIMissionControl(screen), iStaringView));
    }

    return m_kLocalMgr;
}

simulated function OnInit()
{
    local int numEvents;
    local LWCE_XGMissionControlUI kMgr;

    super.OnInit();

    kMgr = LWCE_XGMissionControlUI(GetMgr());

    AS_OverrideMaxItemsPerColumn(m_iMaxEventsPerRow);
    AS_ExpandListVertically(m_bExpandListVertically);

    numEvents = kMgr.m_kEvents.arrOptions.Length;

    if (numEvents > 0)
    {
        m_strEventListLabel = class'UIUtilities'.static.CapsCheckForGermanScharfesS(class'UIUtilities'.static.GetDaysString(2));
    }
    else
    {
        m_strEventListLabel = "";
    }

    if (m_iMaxEventsPerRow == 1)
    {
        AS_SetTitle(m_strSingleEventListTitle, m_strEventListLabel);
    }
    else
    {
        AS_SetTitle(m_strEventListTitle, m_strEventListLabel);
    }

    UpdateData();

    if (UIMissionControl(screen) != none)
    {
        m_hEventsWatchHandle = WorldInfo.MyWatchVariableMgr.RegisterWatchVariableStructMember(kMgr, 'm_kCEEvents', 'arrOptions', self, UpdateData);
        m_hTimeScaleHandle = WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(kMgr.GEOSCAPE(), 'm_fTimeScale', self, TimeScaleChanged);
        TimeScaleChanged();
    }
    else
    {
        m_hEventsWatchHandle = -1;
    }
}

function ContractEventList()
{
    if (m_bIsExpanded)
    {
        // LWCE: fix a none access here to keep the logs cleaner
        if (UIMissionControl(screen) != none)
        {
            UIMissionControl(screen).ToggleMissionList(true);
        }

        if (m_iMaxEventsPerRow == 1)
        {
            AS_SetTitle(m_strSingleEventListTitle, m_strEventListLabel);
        }

        Invoke("ContractList");
        m_bIsExpanded = false;

        if (UIMissionControl(screen) != none)
        {
            UIMissionControl(screen).UpdateButtonHelp();
        }
        else
        {
            UpdateButtonHelp();

            if (!`HQPRES.GetHUD().IsMouseActive())
            {
                UIStrategyHUD(screen).ShowZoomButtonHelp();
            }
        }
    }
}

simulated function string GetEventImageLabel(int EventType, int iContinentMakingRequest)
{
    `LWCE_LOG_DEPRECATED_CLS(GetEventImageLabel);

    return "";
}

simulated function string LWCE_GetEventImageLabel(name EventType, int iContinentMakingRequest)
{
    switch (EventType)
    {
        case 'Research':
            return "_research";
        case 'ItemProject':
            return "_itemProject";
        case 'Facility':
            return "_facility";
        case 'Foundry':
            return "_foundry";
        case 'EndOfMonth':
            return "_endOfMonth";
        case 'Hiring':
            return "_hiring";
        case 'InterceptorOrdering':
            return "_interceptorOrdering";
        case 'ShipTransfers':
            return "_shipTransfers";
        case 'PsiTraining':
            return "_psiTraining";
        case 'GeneModification':
            return "_genemod";
        case 'CyberneticModification':
            return "_mech";
        case 'MecRepair':
            return "_mech";
        case 'FCRequest':
            return class'UIUtilities'.static.GetEventListFCRequestIcon(iContinentMakingRequest);
        case 'SatOperational':
            return "_satellite";
        case 'CovertOperative':
            return "_covertop";
        default:
            return "_unknown";
    }
}

simulated function Hide()
{
    // LWCE: event list is typically contracted when receiving focus, which means it suddenly appears at full size and
    // then contracts. It's a much slicker experience to simply contract it when hidden, to avoid animating this while visible.
    ContractEventList();

    super.Hide();
}

simulated function UpdateButtonHelp()
{
    local string helpString;
    local delegate<onButtonClickedDelegate> mouseCallback;
    local LWCE_XGMissionControlUI kMgr;

    kMgr = LWCE_XGMissionControlUI(GetMgr());

    if (`HQGAME.GetGameCore().GetHQ().m_bInFacilityTransition)
    {
        return;
    }

    kMgr.UpdateEvents();
    m_iNumUpcomingEvents = kMgr.m_kCEEvents.arrOptions.Length;

    if (m_iNumUpcomingEvents > m_iMaxEventsPerRow)
    {
        helpString = "";
        mouseCallback = None;

        if (m_iNumUpcomingEvents > m_iMaxEventsPerRow)
        {
            if (m_bIsExpanded)
            {
                if (manager.IsMouseActive())
                {
                    helpString = m_strContractEventList;
                    mouseCallback = ContractEventList;
                }
            }
            else
            {
                helpString = m_strExpandEventList;

                if (manager.IsMouseActive())
                {
                    mouseCallback = ExpandEventList;
                }
            }
        }

        if (UIMissionControl(screen) != none)
        {
            if (UIMissionControl(screen).m_kHelpBar.IsInited())
            {
                if (helpString != "")
                {
                    UIMissionControl(screen).m_kHelpBar.AddRightHelp(helpString, "Icon_RT_R2", mouseCallback);
                }
            }
        }
        else if (UIStrategyHUD(screen).m_kHelpBar.IsInited())
        {
            UIStrategyHUD(screen).m_kHelpBar.ClearButtonHelp();

            if (helpString != "")
            {
                UIStrategyHUD(screen).m_kHelpBar.AddRightHelp(helpString, "Icon_RT_R2", mouseCallback);
            }

            if (controllerRef.IsTouchEnabled())
            {
                UIStrategyHUD(screen).Touch_ShowPauseButtonHelp();
            }
        }
    }
}

simulated function UpdateData()
{
    local int I, iAdditionalData;
    local array<LWCE_TMCEvent> arrEventData;
    local LWCE_TMCEvent kEvent;
    local LWCE_XGMissionControlUI kMgr;

    kMgr = LWCE_XGMissionControlUI(GetMgr());

    if (!b_IsInitialized || !b_IsVisible || !b_IsFocused || `HQGAME.GetGameCore().m_bGameOver || m_bIsExpanded)
    {
        return;
    }

    if (m_hEventsWatchHandle == -1)
    {
        kMgr.UpdateEvents();
    }

    Invoke("clear");
    arrEventData = kMgr.m_kCEEvents.arrOptions;
    m_iNumUpcomingEvents = arrEventData.Length;

    for (I = 0; I < m_iNumUpcomingEvents; I++)
    {
        kEvent = arrEventData[I];
        iAdditionalData = 0;

        if (kEvent.arrData.Length > 0)
        {
            iAdditionalData = kEvent.arrData[0].iData;
        }

        AS_AddEvent(kEvent.txtOption.StrValue, class'UIUtilities'.static.GetDaysString(int(kEvent.txtDays.StrValue)), kEvent.txtDays.StrValue, LWCE_GetEventImageLabel(kEvent.EventType, iAdditionalData));
    }

    if (m_iNumUpcomingEvents > 0)
    {
        Show();
    }
    else
    {
        Hide();
    }
}