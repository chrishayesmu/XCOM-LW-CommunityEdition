class LWCE_UIScienceLabs extends UIScienceLabs;

simulated function XGResearchUI GetMgr()
{
    return XGResearchUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGResearchUI', (self)));
}

simulated function OnInit()
{
    super.OnInit();
    m_iView = GetMgr().m_iCurrentView;

    RealizeArchiveList();
    LWCE_RealizeReport();
    `HQPRES.GetStrategyHUD().ClearButtonHelp();
    `HQPRES.GetStrategyHUD().ShowBackButton(OnUCancel);

    if (m_iView == 3)
    {
        AS_EnableArchives(false);
    }
    else
    {
        AS_EnableArchives(true);
        OnOption();
    }
}

simulated function GoToView(int iView)
{
    m_iView = iView;

    switch (m_iView)
    {
        case 0:
            Hide();
            `HQPRES.GetStrategyHUD().ClearButtonHelp();
            XComHQPresentationLayer(controllerRef.m_Pres).PopState();
            break;
        case 2:
            `HQPRES.GetStrategyHUD().ClearButtonHelp();
            `HQPRES.GetStrategyHUD().ShowBackButton(OnUCancel);
            RealizeArchiveList();
            AS_SetListSelection(m_arrUIOptions[m_iCurrentSelection].iIndex);
            AS_EnableArchives(true);
            break;
        case 3:
            `HQPRES.GetStrategyHUD().ClearButtonHelp();
            `HQPRES.GetStrategyHUD().ShowBackButton(OnUCancel);
            LWCE_RealizeReport();
            AS_EnableArchives(false);
            break;
        case 1:
            XComHQPresentationLayer(controllerRef.m_Pres).PopState();
            break;
    }
}

simulated function bool OnCancel(optional string Str = "")
{
    if (XComHeadquartersInput(`HQGAME.PlayerController.PlayerInput).m_bDisableCancel)
    {
        GetMgr().PlayBadSound();
        return false;
    }

    switch (m_iView)
    {
        case 2:
            GetMgr().OnLeaveArchives();
            return true;
        case 3:
            if (`HQGAME.GetGameCore().GetHQ().m_kLabs.m_bChooseTechAfterReport)
            {
                `HQGAME.GetGameCore().GetHQ().m_kLabs.m_bChooseTechAfterReport = false;
                GetMgr().OnLeaveReport(true);
            }
            else
            {
                GetMgr().OnLeaveReport(false);
            }

            return true;
        default:
            return false;
    }
}

simulated function RealizeArchiveList()
{
    local UIScienceLabs.UIOption kOption;
    local TMenuOption tMnuOption;
    local TMenu tMnu;
    local int I;

    m_arrUIOptions.Length = 0;

    AS_ClearArchives();
    AS_SetArchiveTitle(m_strScienceLabsArchiveTitle);
    AS_SetTopSecretText(m_strTopSecret);

    tMnu = LWCE_XGResearchUI(GetMgr()).m_kCEArchives.mnuArchives;

    for (I = 0; I < tMnu.arrOptions.Length; I++)
    {
        tMnuOption = tMnu.arrOptions[I];

        kOption.iIndex = I;
        kOption.strLabel = tMnuOption.strText;
        kOption.iState = tMnuOption.iState;
        kOption.strHelp = tMnuOption.strHelp;

        m_arrUIOptions.AddItem(kOption);

        AS_AddOption(kOption.iIndex, kOption.strLabel, false);
    }
}

protected simulated function LWCE_RealizeReport()
{
    local int I;
    local string fullDate;

    if (GetLanguage() == "KOR")
    {
        fullDate = GetMgr().m_kReport.txtYear.StrValue $ class'UIStrategyComponent_Clock'.default.KOR_year_suffix @ GetMgr().m_kReport.txtMonthNum.StrValue $ class'UIStrategyComponent_Clock'.default.KOR_month_suffix;
    }
    else if (GetLanguage() == "JPN")
    {
        fullDate = GetMgr().m_kReport.txtYear.StrValue $ class'UIStrategyComponent_Clock'.default.JPN_year_suffix @ GetMgr().m_kReport.txtMonthNum.StrValue $ class'UIStrategyComponent_Clock'.default.JPN_month_suffix;
    }
    else
    {
        fullDate = GetMgr().m_kReport.txtMonth.StrValue $ "," @ GetMgr().m_kReport.txtYear.StrValue;
    }

    AS_SetReportTitles(GetMgr().m_kReport.txtTitle.StrValue, GetMgr().m_kReport.txtCodename.StrValue $ "\n" $ fullDate);
    AS_SetReportItem(GetMgr().m_kReport.txtSubject.StrValue, GetMgr().m_kReport.txtNotes.StrValue, GetMgr().m_kReport.imgProject.strPath);
    AS_ClearResults();

    for (I = 0; I < GetMgr().m_kReport.txtResults.Length; I++)
    {
        AS_AddResults(class'UIUtilities'.static.GetHTMLColoredText(GetMgr().m_kReport.txtResults[I].StrValue, GetMgr().m_kReport.txtResults[I].iState));
    }
}