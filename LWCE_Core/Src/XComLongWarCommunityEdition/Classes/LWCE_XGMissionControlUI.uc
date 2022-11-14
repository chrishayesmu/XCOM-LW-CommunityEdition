class LWCE_XGMissionControlUI extends XGMissionControlUI
    implements(LWCE_IFCRequestInterface)
    dependson(LWCE_XGGeoscape);

struct LWCE_TMCAlert
{
    var name AlertType;
    var TText txtTitle;
    var array<TText> arrText;
    var array<TLabeledText> arrLabeledText;
    var TMenu mnuReplies;
    var TImage imgAlert;
    var TImage imgAlert2;
    var TImage imgAlert3;
    var int iNumber;
};

var LWCE_TMCEventMenu m_kCEEvents;
var LWCE_TMCAlert m_kCECurrentAlert;

function AddNotice(EGeoscapeAlert eNotice, optional int iData1, optional int iData2, optional int iData3)
{
    local array<LWCE_TData> arrData;
    local name AlertName;

    arrData.Add(3);

    arrData[0].eType = eDT_Int;
    arrData[0].iData = iData1;

    arrData[1].eType = eDT_Int;
    arrData[1].iData = iData2;

    arrData[2].eType = eDT_Int;
    arrData[2].iData = iData3;

    AlertName = class'LWCE_XGGeoscape'.static.AlertNameFromEnum(eNotice);

    LWCE_AddNotice(AlertName, arrData);
}

function LWCE_AddNotice(name AlertName, array<LWCE_TData> arrData)
{
    local int iData1, iData2, iData3;
    local TMCNotice kNotice;
    local XGParamTag kTag;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kNotice.fTimer = 6.0;

    switch (AlertName)
    {
        case 'NewItemBuilt':
            Sound().PlaySFX(SNDLIB().SFX_Notify_ItemBuilt);
            kTag.IntValue0 = arrData[1].iData;
            kTag.StrValue0 = `LWCE_ITEM(arrData[0].nmData).strName;
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelItemBuilt);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_FacilityGear;
            break;
        case 'ItemRepairsComplete':
            kTag.StrValue0 = `LWCE_ITEM(arrData[0].nmData).strName;
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strSpeakSatDestroyed);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_FacilityGear;
            break;
        default:
            iData1 = arrData.Length > 0 ? arrData[0].iData : 0;
            iData2 = arrData.Length > 1 ? arrData[1].iData : 0;
            iData3 = arrData.Length > 2 ? arrData[2].iData : 0;

            super.AddNotice(class'LWCE_XGGeoscape'.static.EnumFromAlertName(AlertName), iData1, iData2, iData3);
            return;
    }

    if (m_arrNotices.Length == 0)
    {
        m_arrNotices.AddItem(kNotice);
        UpdateView();
    }
    else if (m_arrNotices.Length <= 3)
    {
        m_arrNotices.InsertItem(0, kNotice);
        UpdateView();
    }
}

function BuildEventOptions()
{
    local int iEvent, iDays;
    local LWCEFoundryProjectTemplate kFoundryTech;
    local LWCETechTemplate kTech;
    local LWCE_TMCEvent kOption;
    local XGParamTag kTag;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

    for (iEvent = 0; iEvent < m_kCEEvents.arrEvents.Length; iEvent++)
    {
        iDays = m_kCEEvents.arrEvents[iEvent].iHours / 24;

        if ((m_kCEEvents.arrEvents[iEvent].iHours % 24) > 0)
        {
            iDays += 1;
        }

        if (iDays < 0)
        {
            iDays = 0;
        }

        switch (m_kCEEvents.arrEvents[iEvent].EventType)
        {
            case 'Research':
                kTech = `LWCE_TECH(m_kCEEvents.arrEvents[iEvent].arrData[0].nmData);

                kOption.EventType = 'Research';
                kOption.iPriority = 5;
                kOption.imgOption.iImage = eImage_OldResearch;
                kOption.txtOption.StrValue = kTech.strName;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 200, 0, byte(175 / 3));
                break;
            case 'ItemProject':
                kOption.EventType = 'ItemProject';
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldManufacture;
                kOption.txtOption.StrValue = `LWCE_ITEM(m_kCEEvents.arrEvents[iEvent].arrData[0].nmData).strName;

                if (m_kCEEvents.arrEvents[iEvent].arrData[1].iData > 1)
                {
                    kOption.txtOption.StrValue @= "(" $ m_kCEEvents.arrEvents[iEvent].arrData[1].iData $ ")";
                }

                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 100, 0, byte(175 / 3));
                break;
            case 'Facility':
                kOption.EventType = 'Facility';
                kOption.iPriority = 3;
                kOption.imgOption.iImage = eImage_OldManufacture;
                kOption.txtOption.StrValue = Facility(m_kCEEvents.arrEvents[iEvent].arrData[0].iData).strName;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(100, 100, 100, byte(175 / 3));
                break;
            case 'Foundry':
                kFoundryTech = `LWCE_FTECH(m_kCEEvents.arrEvents[iEvent].arrData[0].nmData);

                kOption.EventType = 'Foundry';
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_FacilityFoundry;
                kOption.txtOption.StrValue = kFoundryTech.strName;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 200, 0, byte(175 / 3));
                break;
            case 'Hiring':
                kOption.EventType = 'Hiring';
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldSoldier;
                kOption.txtOption.StrValue = m_strNewSoldierEvent;

                if (m_kCEEvents.arrEvents[iEvent].arrData[1].iData > 1)
                {
                    kOption.txtOption.StrValue @= "(" $ m_kCEEvents.arrEvents[iEvent].arrData[1].iData $ ")";
                }

                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case 'InterceptorOrdering':
                kTag.StrValue0 = Continent(m_kCEEvents.arrEvents[iEvent].arrData[0].iData).GetName();
                kOption.EventType = 'InterceptorOrdering';
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldInterception;
                kOption.txtOption.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelNewInterceptors);

                if (m_kCEEvents.arrEvents[iEvent].arrData[1].iData > 1)
                {
                    kOption.txtOption.StrValue @= "(" $ m_kCEEvents.arrEvents[iEvent].arrData[1].iData $ ")";
                }

                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case 'SatOperational':
                kTag.StrValue0 = Country(m_kCEEvents.arrEvents[iEvent].arrData[0].iData).GetName();
                kOption.EventType = 'SatOperational';
                kOption.iPriority = 2;
                kOption.txtOption.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelSatOperational);
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case 'ShipTransfers':
                kTag.StrValue0 = Continent(m_kCEEvents.arrEvents[iEvent].arrData[0].iData).GetName();
                kOption.EventType = 'ShipTransfers';
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldInterception;
                kOption.txtOption.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelShipTransfer);
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case 'FCRequest':
                kTag.StrValue0 = Continent(m_kCEEvents.arrEvents[iEvent].arrData[0].iData).GetName();
                kOption.arrData = m_kCEEvents.arrEvents[iEvent].arrData;
                kOption.EventType = 'FCRequest';
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldInterception;
                kOption.txtOption.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelFCRequest);
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case 'PsiTraining':
                kOption.EventType = 'PsiTraining';
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldSoldier;
                kOption.txtOption.StrValue = m_strLabelPsiTesting;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 0, 200, byte(175 / 3));
                break;
            case 'GeneModification':
                kOption.EventType = 'GeneModification';
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldSoldier;
                kOption.txtOption.StrValue = m_strLabelGeneModification;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 0, 200, byte(175 / 3));
                break;
            case 'CyberneticModification':
                kOption.EventType = 'CyberneticModification';
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldSoldier;
                kOption.txtOption.StrValue = m_strLabelCyberneticModification;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 0, 200, byte(175 / 3));
                break;
            case 'ItemRepair':
                kTag.StrValue0 = Item(m_kCEEvents.arrEvents[iEvent].arrData[0].iData).strName;
                kOption.EventType = 'ItemRepair';
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldManufacture;
                kOption.txtOption.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelMecRepair);
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 0, 200, byte(175 / 3));
                break;
            case 'EndOfMonth':
                kOption.EventType = 'EndOfMonth';
                kOption.iPriority = 4;
                kOption.imgOption.iImage = eImage_OldFunding;
                kOption.txtOption.StrValue = m_strLabelCouncilReport;
                kOption.txtOption.iState = eUIState_Warning;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case 'CovertOperative':
                kOption.EventType = 'CovertOperative';
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldSoldier;
                kOption.txtOption.StrValue = m_strLabelCovertOperative;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 0, 200, byte(175 / 3));
                break;
        }

        m_kCEEvents.arrOptions.AddItem(kOption);
    }

    m_kCEEvents.iHighlight = -1;
}

function bool CheckForInterrupt()
{
    local LWCE_TGeoscapeAlert kAlert;

    kAlert = LWCE_XGGeoscape(GEOSCAPE()).LWCE_GetTopAlert();

    switch (kAlert.AlertType)
    {
        case 'UFODetected':
        case 'Abduction':
        case 'Terror':
        case 'FCMission':
        case 'UFOCrash':
        case 'UFOLanded':
        case 'DropArrive':
        case 'AlienBase':
        case 'Temple':
        case 'PsiTraining':
        case 'PayDay':
        case 'ExaltMissionActivity':
        case 'ExaltAlert':
        case 'ExaltResearchHack':
        case 'Augmentation':
            return true;
    }

    if (m_iEvent == -1)
    {
        return true;
    }

    switch (m_kCEEvents.arrEvents[m_iEvent].EventType)
    {
        case 'EndOfMonth':
            return kAlert.AlertType == 'PayDay';
        case 'ItemProject':
            return kAlert.AlertType == 'ItemProjectCompleted' && kAlert.arrData[0].iData == m_kCEEvents.arrEvents[m_iEvent].arrData[0].iData;
        case 'Facility':
            return kAlert.AlertType == 'NewFacilityBuilt' && kAlert.arrData[0].iData == m_kCEEvents.arrEvents[m_iEvent].arrData[0].iData;
        case 'Foundry':
            return kAlert.AlertType == 'FoundryProjectCompleted' && kAlert.arrData[0].iData == m_kCEEvents.arrEvents[m_iEvent].arrData[0].iData;
        case 'Research':
            return kAlert.AlertType == 'ResearchCompleted' && kAlert.arrData[0].iData == m_kCEEvents.arrEvents[m_iEvent].arrData[0].iData;
    }

    return false;
}

simulated function GetRequestData(out TFCRequest kRequestRef)
{
    `LWCE_LOG_DEPRECATED_CLS(GetRequestData);
}

simulated function LWCE_GetRequestData(out LWCE_TFCRequest kRequestRef)
{
    kRequestRef = LWCE_XGFundingCouncil(World().m_kFundingCouncil).m_arrCEPendingRequests[0];
}

function OnAbductionInput(int iOption)
{
    GoToView(eMCView_MainMenu);
    GEOSCAPE().ShowRealEarth();
    GEOSCAPE().Resume();

    if (iOption != -1)
    {
        PRES().UIChooseSquad(m_kAbductInfo.arrAbductions[iOption]);
    }
    else
    {
        PRES().CAMLookAtEarth(HQ().GetCoords());
        LWCE_XGGeoscape(GEOSCAPE()).LWCE_PreloadSquadIntoSkyranger('Abduction', true);
    }

    m_kAbductInfo.iSelected = -1;
}

function OnAlertInput(int iOption)
{
    local LWCE_TGeoscapeAlert kAlert;
    local XGShip_Dropship kSkyranger;
    local XGMission kMission;
    local int iIndex;
    local bool bCanceledAction;

    if (iOption != -1 && m_kCECurrentAlert.mnuReplies.arrOptions[iOption].iState == eUIState_Disabled)
    {
        PlayBadSound();
        return;
    }

    PlaySmallCloseSound();
    kAlert = LWCE_XGGeoscape(GEOSCAPE()).LWCE_GetTopAlert();
    GEOSCAPE().ClearTopAlert();

    switch (m_kCECurrentAlert.AlertType)
    {
        case 'SecretPact':
            if (Game().CheckForLoseGame() <= 0)
            {
                GEOSCAPE().Pause();
            }
            else
            {
                HQ().CheckForOperatingLoss(GetUIScreen());
            }

            break;
        case 'SatelliteDestroyed':
            HQ().CheckForOperatingLoss(GetUIScreen());
            break;
        case 'UFODetected':
            if (iOption == 0 && m_iCurrentView != eMCView_ChooseShip)
            {
                if (m_kCECurrentAlert.mnuReplies.arrOptions[0].iState == eUIState_Disabled)
                {
                    PlayBadSound();
                    return;
                }
                else
                {
                    PlayOpenSound();
                }

                GoToView(eMCView_ChooseShip);
                PRES().UIIntercept(AI().GetUFO(kAlert.arrData[0].iData));

                return;
            }

            break;
        case 'Terror':
        case 'FCMission':
        case 'UFOCrash':
        case 'UFOLanded':
            if (iOption == 0)
            {
                if (HANGAR().m_kSkyranger.IsFlying())
                {
                    PlayBadSound();
                }
                else
                {
                    GoToView(eMCView_MainMenu);
                    PRES().UIChooseSquad(GEOSCAPE().GetMission(kAlert.arrData[0].iData));
                }
            }
            else
            {
                bCanceledAction = true;
            }

            break;
        case 'Temple':
            if (iOption == 0)
            {
                if (HANGAR().m_kSkyranger.IsFlying())
                {
                    PlayBadSound();
                }
                else
                {
                    GoToView(eMCView_MainMenu);
                    PRES().UIChooseSquad(GEOSCAPE().GetMission(kAlert.arrData[0].iData));
                }
            }
            else
            {
                bCanceledAction = true;
            }

            break;
        case 'AlienBase':
            if (iOption == 0)
            {
                if (HANGAR().m_kSkyranger.IsFlying())
                {
                    PlayBadSound();
                }
                else
                {
                    if (LWCE_XGStorage(STORAGE()).LWCE_GetNumItemsAvailable('Item_SkeletonKey') == 0)
                    {
                        PlayBadSound();
                    }
                    else
                    {
                        GoToView(eMCView_MainMenu);
                        PRES().UIChooseSquad(GEOSCAPE().GetMission(kAlert.arrData[0].iData));
                    }
                }
            }
            else
            {
                bCanceledAction = true;
            }

            break;
        case 'Abduction':
            if (iOption == 0 && !HANGAR().m_kSkyranger.IsFlying())
            {
                GoToView(eMCView_Abduction);
                return;
            }
            else
            {
                bCanceledAction = true;
            }

            break;
        case 'ResearchCompleted':
            if (iOption == 0)
            {
                LABS().m_bChooseTechAfterReport = true;
                JumpToFacility(LABS());
                return;
            }

            break;
        case 'NewFacilityBuilt':
        case 'ItemProjectCompleted':
        case 'FoundryProjectCompleted':
            if (iOption == 0)
            {
                JumpToFacility(ENGINEERING());
                return;
            }
            else
            {
                GoToView(eMCView_MainMenu);
            }

            break;
        case 'PsiTraining':
            if (iOption == 0 || PSILABS().m_bSubjectZeroCinematic)
            {
                JumpToFacility(BARRACKS());
                return;
            }
            else
            {
                GoToView(eMCView_MainMenu);
            }

            break;
        case 'Augmentation':
            if (iOption == 0)
            {
                JumpToFacility(ENGINEERING(), eEngView_Build, 'State_BuildItem');
                return;
            }
            else
            {
                GoToView(eMCView_MainMenu);
            }

            break;
        case 'NewSoldiers':
            if (iOption == 0)
            {
                JumpToFacility(BARRACKS());
                return;
            }
            else
            {
                GoToView(eMCView_MainMenu);
            }

            break;
        case 'NewScientists':
            if (iOption == 0)
            {
                JumpToFacility(LABS());
                return;
            }

            break;
        case 'NewEngineers':
            if (iOption == 0)
            {
                JumpToFacility(ENGINEERING());
                return;
            }

            break;
        case 'FCActivity':
            if (iOption == 0)
            {
                World().m_kFundingCouncil.AcceptPendingRequest();
                GoToView(eMCView_MainMenu);
                return;
            }
            else
            {
                bCanceledAction = true;
            }

            break;
        case 'FCMissionActivity':
            if (iOption == 0)
            {
                PRES().bShouldUpdateSituationRoomMenu = false;
                SITROOM().m_bDisplayMissionDetails = true;
                JumpToFacility(SITROOM(), eSitView_Mission);
            }
            else
            {
                bCanceledAction = true;
            }

            return;
        case 'ExaltMissionActivity':
        case 'ExaltResearchHack':
            if (iOption == 0)
            {
                m_eCountryFromExaltSelection = -1;
                JumpToFacility(SITROOM(), eSitView_Exalt);

                return;
            }
            else if (iOption == 1)
            {
                m_eCountryFromExaltSelection = -1;
                GEOSCAPE().ShowRealEarth();
            }
            else
            {
                GEOSCAPE().ShowRealEarth();
                bCanceledAction = true;
            }

            break;
        case 'FCJetTransfer':
        case 'FCSatCountry':
            if (iOption == 0)
            {
                JumpToFacility(SITROOM());
            }
            else
            {
                GoToView(eMCView_MainMenu);
            }

            break;
        case 'FCExpiredRequest':
            if (iOption == 0)
            {
                JumpToFacility(SITROOM());
                return;
            }
            else if (iOption == 1)
            {
                World().m_kFundingCouncil.ClearExpiredRequests();
            }

            break;
        case 'ModalNotify':
            JumpToFacility(SITROOM());
            return;
        case 'DropArrive':
            kSkyranger = HANGAR().m_kSkyranger;

            if (iOption == 0)
            {
                PRES().ShouldPause(false);
                PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
                GetALocalPlayerController().ClientSetCameraFade(true, MakeColor(0, 0, 0), vect2d(0.0, 1.0), 0.20);
                `HQPRES.SetTimer(0.210, false, 'PostFadeForBeginCombat');

                if (`HQPRES.IsInState('State_SimCombat'))
                {
                    `HQPRES.PrintStateStack();
                }
                else
                {
                    `HQPRES.m_kNarrativeUIMgr.ShutDown();
                    `HQPRES.GetUIComm().Hide();
                    `HQPRES.ClearAllUIScreens();
                }
            }
            else
            {
                PRES().ShouldPause(true);
                PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
                GEOSCAPE().SkyrangerReturnToBase(kSkyranger, true);
                GEOSCAPE().Resume();
            }

            break;
        case 'ExaltAlert':
            if (iOption == 0)
            {
                if (HANGAR().m_kSkyranger.IsFlying())
                {
                    PlayBadSound();
                }
                else
                {
                    GoToView(eMCView_MainMenu);

                    for (iIndex = 0; iIndex < GEOSCAPE().m_arrMissions.Length; iIndex++)
                    {
                        kMission = GEOSCAPE().m_arrMissions[iIndex];

                        if (kMission.IsA('XGMission_CovertOpsExtraction') || kMission.IsA('XGMission_CaptureAndHold'))
                        {
                            SITROOM().SetInfiltratorMission(kMission);
                            break;
                        }
                    }

                    PRES().bShouldUpdateSituationRoomMenu = false;
                    SITROOM().m_bDisplayInfiltratorMissionDetails = true;
                    JumpToFacility(SITROOM(), eSitView_CovertOpsExtractionMission);
                    PRES().UIInfiltratorMission();
                }
            }
            else
            {
                PRES().CAMLookAtEarth(HQ().GetCoords());
            }

            break;
        default:
            if (!GEOSCAPE().HasAlerts())
            {
                PRES().CAMLookAtEarth(HQ().GetCoords());
            }

            break;
    }

    if (bCanceledAction)
    {
        LWCE_XGGeoscape(GEOSCAPE()).LWCE_PreloadSquadIntoSkyranger(m_kCECurrentAlert.AlertType, true);
    }

    if (GEOSCAPE().HasAlerts())
    {
        UpdateView();
    }
    else
    {
        GoToView(eMCView_MainMenu);
    }
}

function OnChooseEvent()
{
    if (m_kCEEvents.iHighlight == -1)
    {
        PlayBadSound();
        return;
    }

    m_iEvent = m_kCEEvents.iHighlight;
    GEOSCAPE().FastForward();
}

function OnMissionInput()
{
    local LWCE_XGGeoscape kGeoscape;
    local XGMission kMission;

    kGeoscape = LWCE_XGGeoscape(GEOSCAPE());

    if (!CanActivateMission())
    {
        PlayBadSound();
        return;
    }

    if (m_kMenu.iHighlight == m_kMenu.arrMissions.Length - 1 && kGeoscape.GetFinalMission() == none)
    {
        if (!kGeoscape.IsScanning())
        {
            OnScan();
        }
        else
        {
            OnCancelScan();
        }

        return;
    }

    m_iEvent = -1;

    if (m_kMenu.iHighlight < m_arrMenuUFOs.Length)
    {
        ShowUFOInterceptAlert(m_arrMenuUFOs[m_kMenu.iHighlight]);
    }
    else if (m_kMenu.iHighlight < m_arrMenuMissions.Length)
    {
        kMission = kGeoscape.m_arrMissions[m_arrMenuMissions[m_kMenu.iHighlight]];

        if (kMission.m_iMissionType == eMission_Special)
        {
            PRES().bShouldUpdateSituationRoomMenu = false;
        }

        switch (kMission.m_iMissionType)
        {
            case eMission_Abduction:
                kGeoscape.LWCE_PreloadSquadIntoSkyranger('Abduction', false);
                GoToView(eMCView_Abduction);
                m_intMissionType = kMission.m_iMissionType;
                break;
            default:
                kGeoscape.MissionAlert(m_arrMenuMissions[m_kMenu.iHighlight]);
                m_intMissionType = kMission.m_iMissionType;
                break;
        }
    }
}

function ProcessAlert()
{
    if (m_iCurrentView != eMCView_Alert)
    {
        if (CheckForInterrupt())
        {
            GoToView(eMCView_Alert);
        }
        else
        {
            NotifyTopAlert();
        }
    }

    if (LWCE_XGGeoscape(GEOSCAPE()).LWCE_GetTopAlert().AlertType == 'DropArrive')
    {
        UpdateCamera();
    }
}

function ShowUFOInterceptAlert(int iUFOindex)
{
    local LWCE_XGGeoscape kGeoscape;

    kGeoscape = LWCE_XGGeoscape(GEOSCAPE());

    kGeoscape.LWCE_Alert(`LWCE_ALERT('UFODetected').AddInt(iUFOindex).Build());
    GoToView(eMCView_ChooseShip);
    kGeoscape.ClearTopAlert(true);
    PRES().UIIntercept(AI().GetUFO(iUFOindex));
}

event Tick(float fDeltaT)
{
    local LWCE_XGGeoscape kGeoscape;

    if (Owner == none || HQ().m_kActiveFacility != HQ().m_kMC || Game().m_bGameOver)
    {
        return;
    }

    kGeoscape = LWCE_XGGeoscape(GEOSCAPE());

    UpdateClock();

    if (BARRACKS().m_kVolunteer != none)
    {
        if (kGeoscape.LWCE_GetTopAlert().AlertType == 'Temple')
        {
            ProcessAlert();
            UpdateCamera();
            return;
        }
    }

    if ( (m_iCurrentView == eMCView_Abduction || m_iCurrentView == eMCView_Alert) && kGeoscape.HasAlerts() )
    {
        if (!kGeoscape.IsPaused())
        {
            UpdateView();
        }
    }

    if (m_iCurrentView != eMCView_Abduction && m_iCurrentView != eMCView_ChooseShip)
    {
        if ( kGeoscape.HasAlerts() && (!kGeoscape.IsBusy() || kGeoscape.LWCE_GetTopAlert().AlertType == 'DropArrive') )
        {
            ProcessAlert();
            return;
        }
        else if (World().m_kFundingCouncil.HasPendingRequest() && !kGeoscape.IsBusy())
        {
            ProcessFCRequest();
        }
        else if (m_iCurrentView != eMCView_MainMenu)
        {
            GoToView(eMCView_MainMenu);
        }
        else
        {
            UpdateNotices(fDeltaT);

            if (kGeoscape.m_kDateTime.GetDay() != m_iLastUpdateDay)
            {
                UpdateView();
            }
        }
    }

    UpdateCamera();
}

function UpdateAlert()
{
    local LWCEFoundryProjectTemplate kFoundryTech;
    local LWCEItemTemplate kItem;
    local LWCETechTemplate kTech;
    local LWCE_TGeoscapeAlert kGeoAlert;
    local LWCE_TMCAlert kAlert;
    local TLabeledText txtLabel;
    local TText txtTemp;
    local XGShip_UFO kUFO;
    local TMenuOption kReply;
    local XGMission kMission;
    local XGShip_Dropship kSkyranger;
    local XGContinent kContinent;
    local XGParamTag kTag;
    local XGCountryTag kCountryTag;
    local XGStrategySoldier kSoldier;

    if (!GEOSCAPE().HasAlerts())
    {
        return;
    }

    kGeoAlert = LWCE_XGGeoscape(GEOSCAPE()).LWCE_GetTopAlert();
    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kCountryTag = new class'XGCountryTag';

    `LWCE_LOG_CLS("New alert with type " $ kGeoAlert.AlertType);

    switch (kGeoAlert.AlertType)
    {
        case 'UFODetected':
            kUFO = AI().GetUFO(kGeoAlert.arrData[0].iData);

            if (kUFO.GetType() == eShip_UFOEthereal && !HQ().m_kMC.m_bDetectedOverseer)
            {
            }
            else
            {
                Sound().PlaySFX(SNDLIB().SFX_Alert_UFOContact);
            }

            Narrative(`XComNarrativeMoment("RoboHQ_ContactDetected"));

            kAlert.txtTitle.StrValue = m_strLabelRadarContact;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldAssault;

            txtLabel.strLabel = m_strLabelContact;
            txtLabel.StrValue = m_strLabelUFOPrefix $ string(kUFO.m_iCounter);
            txtLabel.iState = eUIState_Warning;
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelLocation;
            txtLabel.StrValue = Country(kUFO.GetCountry()).GetName();
            txtLabel.StrValue $= kUFO.GetAltitudeString();
            txtLabel.iState = eUIState_Highlight;
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelSize;
            txtLabel.StrValue = kUFO.GetSizeString();
            txtLabel.iState = eUIState_Highlight;
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelUFOClass;

            if (GEOSCAPE().CanIdentifyCraft(kUFO.GetType()))
            {
                kAlert.imgAlert2.iImage = kUFO.m_kTShip.iImage;
                txtLabel.StrValue = kUFO.m_kTShip.strName;
                txtLabel.iState = eUIState_Highlight;
            }
            else
            {
                kAlert.imgAlert2.iImage = eImage_MCUFOScramble;
                txtLabel.StrValue = m_strLabelUnidentified;
                txtLabel.iState = eUIState_Bad;
            }
            kAlert.arrLabeledText.AddItem(txtLabel);

            if (HQ().IsHyperwaveActive())
            {
                txtLabel.strLabel = m_strLabelAlienObjective;
                txtLabel.StrValue = kUFO.m_kObjective.m_kTObjective.strName;
                kAlert.arrLabeledText.AddItem(txtLabel);
            }

            if (HANGAR().GetNumInterceptorsInRangeAndAvailable(kUFO) == 0)
            {
                kReply.strText = m_strLabelInterceptorsUnavailable;
                kReply.iState = eUIState_Disabled;
            }
            else
            {
                kReply.strText = m_strLabelScrambleInterceptors;
                kReply.iState = eUIState_Normal;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnoreContact;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kUFO.GetCoords());

            break;
        case 'UFOLanded':
            Sound().PlaySFX(SNDLIB().SFX_Alert_UFOLanded);

            kUFO = XGMission_UFOLanded(GEOSCAPE().GetMission(kGeoAlert.arrData[0].iData)).kUFO;
            kMission = XGMission_UFOLanded(GEOSCAPE().GetMission(kGeoAlert.arrData[0].iData));

            if (kMission.m_kDesc.m_strMapName == "EWI_HQAssault_MP (Airbase Defense)")
            {
                kTag.StrValue0 = m_strLabelUFOPrefix $ string(kUFO.m_iCounter);
                kAlert.txtTitle.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelMissionCounter);
                kAlert.txtTitle.iState = eUIState_Warning;
                kAlert.imgAlert.iImage = eImage_OldUFO;

                txtLabel.strLabel = m_strLabelLocation;
                txtLabel.StrValue = kMission.GetLocationString();
                txtLabel.iState = eUIState_Highlight;
                kAlert.arrLabeledText.AddItem(txtLabel);

                txtLabel.strLabel = m_strLabelNoInterceptors;
                txtLabel.StrValue = string(HANGAR().GetNumInterceptors(kMission.m_iContinent)) @ m_strLabelNewHire;
                txtLabel.iState = eUIState_Warning;
                kAlert.arrLabeledText.AddItem(txtLabel);

                kAlert.imgAlert2.iImage = eImage_MCUFOLanded;
                txtLabel.strLabel = m_strLabelSignatureIdentified;
                txtLabel.iState = eUIState_Warning;
                txtLabel.StrValue = m_strLabelGeneModBody;
                txtLabel.iState = eUIState_Warning;
                kAlert.arrLabeledText.AddItem(txtLabel);

                if (HQ().IsHyperwaveActive())
                {
                    txtLabel.strLabel = m_strLabelAlienObjective;
                    txtLabel.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelMissionCounter);
                    kAlert.arrLabeledText.AddItem(txtLabel);

                    txtLabel.strLabel = m_strLabelAlienCrewSize;
                    txtLabel.StrValue = string(kMission.GetEnemyCount());
                    kAlert.arrLabeledText.AddItem(txtLabel);

                    txtLabel.strLabel = m_strLabelAlienSpecies;
                    txtLabel.StrValue = kMission.GetSpeciesList();
                    kAlert.arrLabeledText.AddItem(txtLabel);
                }

                PRES().CAMLookAtEarth(kMission.GetCoords());
            }
            else
            {
                kTag.StrValue0 = m_strLabelUFOPrefix $ string(kUFO.m_iCounter);
                kAlert.txtTitle.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelUFOHasLanded);
                kAlert.txtTitle.iState = eUIState_Warning;
                kAlert.imgAlert.iImage = eImage_OldUFO;
                txtLabel.strLabel = m_strLabelContact;
                txtLabel.StrValue = m_strLabelUFOPrefix $ string(kUFO.m_iCounter);
                txtLabel.iState = eUIState_Warning;
                kAlert.arrLabeledText.AddItem(txtLabel);

                txtLabel.strLabel = m_strLabelLocation;
                txtLabel.StrValue = kMission.GetLocationString();
                txtLabel.iState = eUIState_Highlight;
                kAlert.arrLabeledText.AddItem(txtLabel);

                kAlert.imgAlert2.iImage = eImage_MCUFOLanded;
                txtLabel.strLabel = m_strLabelUFOClass;
                txtLabel.iState = eUIState_Warning;

                if (GEOSCAPE().CanIdentifyCraft(kUFO.GetType()))
                {
                    txtLabel.StrValue = kUFO.m_kTShip.strName;
                    txtLabel.iState = eUIState_Highlight;
                }
                else
                {
                    txtLabel.StrValue = m_strLabelUnidentified;
                    txtLabel.iState = eUIState_Bad;
                }

                kAlert.arrLabeledText.AddItem(txtLabel);

                if (HQ().IsHyperwaveActive())
                {
                    txtLabel.strLabel = m_strLabelAlienObjective;
                    txtLabel.StrValue = kUFO.m_kObjective.m_kTObjective.strName;
                    kAlert.arrLabeledText.AddItem(txtLabel);

                    txtLabel.strLabel = m_strLabelAlienCrewSize;
                    txtLabel.StrValue = string(kMission.GetEnemyCount());
                    kAlert.arrLabeledText.AddItem(txtLabel);

                    txtLabel.strLabel = m_strLabelAlienSpecies;
                    txtLabel.StrValue = kMission.GetSpeciesList();
                    kAlert.arrLabeledText.AddItem(txtLabel);

                }

                PRES().CAMLookAtEarth(kUFO.GetCoords());
            }

            kReply.strText = m_strLabelSendSkyranger;

            if (HANGAR().m_kSkyranger.IsFlying())
            {
                kReply.iState = eUIState_Disabled;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'UFOCrash':
            kMission = XGMission_UFOCrash(GEOSCAPE().GetMission(kGeoAlert.arrData[0].iData));
            kAlert.txtTitle.StrValue = m_strLabelUFOCrashSite;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldUFO;
            txtLabel.strLabel = m_strLabelContact;
            txtLabel.StrValue = m_strLabelUFOPrefix $ string(XGMission_UFOCrash(kMission).m_iCounter);
            txtLabel.iState = eUIState_Warning;
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelLocation;
            txtLabel.StrValue = kMission.GetLocationString();
            txtLabel.iState = eUIState_Highlight;
            kAlert.arrLabeledText.AddItem(txtLabel);

            kAlert.imgAlert2.iImage = eImage_MCUFOCrash;
            txtLabel.strLabel = m_strLabelUFOClass;
            txtLabel.iState = eUIState_Warning;

            if (GEOSCAPE().CanIdentifyCraft(EShipType(XGMission_UFOCrash(kMission).m_iUFOType)))
            {
                txtLabel.StrValue = ITEMTREE().GetShip(EShipType(XGMission_UFOCrash(kMission).m_iUFOType)).strName;
                txtLabel.iState = eUIState_Highlight;
            }
            else
            {
                txtLabel.StrValue = m_strLabelUnidentified;
                txtLabel.iState = eUIState_Bad;
            }

            kAlert.arrLabeledText.AddItem(txtLabel);

            if (HQ().IsHyperwaveActive())
            {
                txtLabel.strLabel = m_strLabelAlienObjective;
                txtLabel.StrValue = XGMission_UFOCrash(kMission).m_kUFOObjective.strName;
                kAlert.arrLabeledText.AddItem(txtLabel);

                txtLabel.strLabel = m_strLabelAlienCrewSize;
                txtLabel.StrValue = string(kMission.GetEnemyCount());
                kAlert.arrLabeledText.AddItem(txtLabel);

                txtLabel.strLabel = m_strLabelAlienSpecies;
                txtLabel.StrValue = kMission.GetSpeciesList();
                kAlert.arrLabeledText.AddItem(txtLabel);
            }

            kReply.strText = m_strLabelSendSkyranger;

            if (HANGAR().m_kSkyranger.IsFlying())
            {
                kReply.iState = eUIState_Disabled;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);
            kReply.strText = m_strLabelIgnore;
            kReply.iState = eUIState_Normal;

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kMission.GetCoords());

            break;
        case 'UFOLost':
            Sound().PlaySFX(SNDLIB().SFX_Alert_UFOLost);

            kAlert.txtTitle.StrValue = (m_strLabelContactLost @ m_strLabelUFOPrefix) $ kGeoAlert.arrData[0].iData;
            kAlert.txtTitle.iState = eUIState_Warning;

            txtTemp.StrValue = m_strLabelLostContactRequestOrder;
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelRecallInterceptors;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'SatelliteDestroyed':
            Sound().PlaySFX(SNDLIB().SFX_Alert_SatelliteLost);

            kContinent = Continent(Country(kGeoAlert.arrData[0].iData).GetContinent());

            kAlert.txtTitle.StrValue = m_strLabelStatCountryDestroyed;
            kAlert.txtTitle.iState = eUIState_Warning;

            kTag.StrValue0 = Country(kGeoAlert.arrData[0].iData).GetNameWithArticle();
            kTag.StrValue1 = kContinent.GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelLostSatFundingSuspending);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kTag.StrValue0 = kContinent.GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strPanicIncrease);
            txtTemp.iState = eUIState_Bad;
            kAlert.arrText.AddItem(txtTemp);

            if (kContinent.GetNumSatellites() == kContinent.m_arrSatBonuses.Length - 1 && kContinent.GetID() != HQ().m_iContinent)
            {
                kTag.StrValue0 = kContinent.GetBonus().strTitle;
                txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelBonusLost);
                txtTemp.iState = eUIState_Bad;
                kAlert.arrText.AddItem(txtTemp);
            }

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(Country(kGeoAlert.arrData[0].iData).GetCoords());

            break;
        case 'FCMissionActivity':
            Sound().PlaySFX(SNDLIB().SFX_Alert_FundingCouncil);

            kAlert.txtTitle.StrValue = m_strLabelIncFCCom;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldFunding;
            kAlert.imgAlert2.iImage = eImage_XComBadge;

            txtTemp.StrValue = m_strLabelFCPresenceRequest;
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            PRES().Speak(m_strSpeakIncTransmission, TTSSPEAKER_Ursula);

            kReply.strText = m_strLabelGoSituationRoom;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'ExaltMissionActivity':
            kMission = GEOSCAPE().GetMission(kGeoAlert.arrData[0].iData);
            kCountryTag.kCountry = Country(kGeoAlert.arrData[0].iData);

            kAlert.txtTitle.StrValue = m_strLabelExaltActivityTitle;
            kAlert.txtTitle.iState = eUIState_Warning;

            txtTemp.StrValue = m_strLabelExaltActivitySubtitles[kGeoAlert.arrData[1].iData];
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = Country(kGeoAlert.arrData[0].iData).GetNameWithArticle();
            kAlert.arrText.AddItem(txtTemp);

            m_eCountryFromExaltSelection = kGeoAlert.arrData[0].iData;
            txtTemp.StrValue = m_arrExaltReasons[kGeoAlert.arrData[1].iData];

            if (kGeoAlert.arrData[1].iData == 1)
            {
                kTag.StrValue0 = class'UIUtilities'.static.GetHTMLColoredText(ConvertCashToString(kGeoAlert.arrData[2].iData), eUIState_Cash);
                txtTemp.StrValue = class'XComLocalizer'.static.ExpandStringByTag(txtTemp.StrValue, kCountryTag) $ "\n\n";
            }

            txtTemp.StrValue $= m_strLabelExaltActivityBody;
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = string(Country(kGeoAlert.arrData[0].iData).GetPanicBlocks());
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = string(kGeoAlert.arrData[1].iData);
            kAlert.arrText.AddItem(txtTemp);

            kAlert.imgAlert.iImage = kGeoAlert.arrData[1].iData;

            kReply.strText = m_strLabelExaltSelSitRoom;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelExaltSelNotNow;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            GEOSCAPE().ShowHoloEarth();
            GEOSCAPE().Pause();
            PRES().CAMLookAtEarth(Country(kGeoAlert.arrData[0].iData).GetCoords());
            GEOSCAPE().PulseCountry(ECountry(kMission.GetCountry()), MakeColor(192, 0, 0, 255), MakeColor(255, 128, 0, 255), 0.750);

            break;
        case 'ExaltResearchHack':
            kMission = GEOSCAPE().GetMission(kGeoAlert.arrData[0].iData);
            kCountryTag.kCountry = Country(kGeoAlert.arrData[0].iData);

            kAlert.txtTitle.StrValue = m_strLabelExaltActivityTitle;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = kGeoAlert.arrData[1].iData;

            txtTemp.StrValue = m_strLabelExaltActivitySubtitles[kGeoAlert.arrData[1].iData];
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = m_arrExaltReasons[kGeoAlert.arrData[1].iData];
            kTag.IntValue0 = kGeoAlert.arrData[2].iData + kGeoAlert.arrData[3].iData;
            kTag.IntValue1 = kGeoAlert.arrData[3].iData;
            kTag.IntValue2 = kGeoAlert.arrData[2].iData / 24;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandStringByTag(txtTemp.StrValue, kCountryTag);
            kAlert.arrText.AddItem(txtTemp);

            kTag.IntValue0 = HQ().GetNumFacilities(eFacility_ScienceLab);
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelResearchHackNumLabs);
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = "";
            kAlert.arrText.AddItem(txtTemp);

            txtLabel.strLabel = m_strLabelResearchHackTimeLost;

            if ((kGeoAlert.arrData[2].iData + kGeoAlert.arrData[3].iData) < 24)
            {
                txtLabel.StrValue = string(kGeoAlert.arrData[2].iData + kGeoAlert.arrData[3].iData);

                if (GetLanguage() == "KOR" || GetLanguage() == "JPN")
                {
                    txtLabel.StrValue $= class'UIUtilities'.static.GetHoursString(kGeoAlert.arrData[2].iData + kGeoAlert.arrData[3].iData);
                }
                else
                {
                    txtLabel.StrValue @= class'UIUtilities'.static.GetHoursString(kGeoAlert.arrData[2].iData + kGeoAlert.arrData[3].iData);
                }
            }
            else
            {
                txtLabel.StrValue = string((kGeoAlert.arrData[2].iData + kGeoAlert.arrData[3].iData) / 24);

                if ((GetLanguage() == "KOR") || GetLanguage() == "JPN")
                {
                    txtLabel.StrValue $= class'UIUtilities'.static.GetDaysString(kGeoAlert.arrData[2].iData + (kGeoAlert.arrData[3].iData / 24));
                }
                else
                {
                    txtLabel.StrValue @= class'UIUtilities'.static.GetDaysString((kGeoAlert.arrData[2].iData + kGeoAlert.arrData[3].iData) / 24);
                }
            }

            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelResearchHackDataBackup;
            txtLabel.StrValue = string(HQ().GetNumFacilities(eFacility_ScienceLab) * 20) $ "%";
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelResearchHackTotalTimeLost;

            if (kGeoAlert.arrData[2].iData < 24)
            {
                txtLabel.StrValue = string(kGeoAlert.arrData[2].iData);

                if ((GetLanguage() == "KOR") || GetLanguage() == "JPN")
                {
                    txtLabel.StrValue $= class'UIUtilities'.static.GetHoursString(kGeoAlert.arrData[2].iData + kGeoAlert.arrData[3].iData);
                }
                else
                {
                    txtLabel.StrValue @= class'UIUtilities'.static.GetHoursString(kGeoAlert.arrData[2].iData + kGeoAlert.arrData[3].iData);
                }
            }
            else
            {
                txtLabel.StrValue = string(kGeoAlert.arrData[2].iData / 24);

                if ((GetLanguage() == "KOR") || GetLanguage() == "JPN")
                {
                    txtLabel.StrValue $= class'UIUtilities'.static.GetDaysString(kGeoAlert.arrData[2].iData + (kGeoAlert.arrData[3].iData / 24));
                }
                else
                {
                    txtLabel.StrValue @= class'UIUtilities'.static.GetDaysString((kGeoAlert.arrData[2].iData + kGeoAlert.arrData[3].iData) / 24);
                }
            }

            kAlert.arrLabeledText.AddItem(txtLabel);

            kReply.strText = m_strLabelExaltSelSitRoom;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelExaltSelNotNow;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            GEOSCAPE().ShowHoloEarth();
            GEOSCAPE().Pause();
            PRES().CAMLookAtEarth(Country(kGeoAlert.arrData[0].iData).GetCoords());
            GEOSCAPE().PulseCountry(ECountry(kMission.GetCountry()), MakeColor(192, 0, 0, 255), MakeColor(255, 128, 0, 255), 0.750);

            break;
        case 'ExaltAlert':
            kMission = GEOSCAPE().GetMission(kGeoAlert.arrData[0].iData);
            kAlert.txtTitle.StrValue = m_strLabelExaltAlertTitle;

            txtTemp.StrValue = m_strLabelExaltAlertBody;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelExaltAlertSendSquad;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelExaltAlertNotNow;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'FCActivity':
            Sound().PlaySFX(SNDLIB().SFX_Alert_FundingCouncil);

            kAlert.txtTitle.StrValue = m_strLabelIncFCCom;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldFunding;
            kAlert.imgAlert2.iImage = eImage_XComBadge;
            txtTemp.StrValue = m_strLabelFCPresenceRequest;
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            PRES().Speak(m_strSpeakIncTransmission, 6);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'FCJetTransfer':
            Sound().PlaySFX(SNDLIB().SFX_Alert_FundingCouncil);

            kAlert.txtTitle.StrValue = m_strLabelIncFCCom;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldFunding;
            kAlert.imgAlert2.iImage = eImage_XComBadge;

            kTag.StrValue0 = Country(kGeoAlert.arrData[0].iData).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelFCFinishedJetTransfer);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            PRES().Speak(m_strSpeakIncTransmission, 6);

            kReply.strText = m_strLabelGoSituationRoom;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'FCSatCountry':
            Sound().PlaySFX(SNDLIB().SFX_Alert_FundingCouncil);

            kAlert.txtTitle.StrValue = m_strLabelIncFCCom;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldFunding;
            kAlert.imgAlert2.iImage = eImage_XComBadge;

            kTag.StrValue0 = Country(kGeoAlert.arrData[0].iData).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelFCFinishedSatCountry);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            PRES().Speak(m_strSpeakIncTransmission, 6);

            kReply.strText = m_strLabelGoSituationRoom;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'FCExpiredRequest':
            kAlert.txtTitle.StrValue = m_strLabelIncFCCom;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldFunding;
            kAlert.imgAlert2.iImage = eImage_XComBadge;

            kTag.StrValue0 = Country(kGeoAlert.arrData[0].iData).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelFCRequestExpired);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            PRES().Speak(m_strSpeakIncTransmission, 6);

            kReply.strText = m_strLabelGoSituationRoom;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'ModalNotify':
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kAlert.txtTitle.StrValue = m_strLabelPriorityAlert;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_XComBadge;
            kAlert.imgAlert2.iImage = eImage_XComBadge;

            txtTemp.StrValue = m_strLabelCommanderUrgentNews;
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            PRES().Speak(m_strSpeakIncTransmission, 6);

            kReply.strText = m_strLabelGoSituationRoom;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelGoSituationRoom;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'DropArrive':
            Sound().PlaySFX(SNDLIB().SFX_Alert_DropArrive);
            kAlert.txtTitle.StrValue = m_strLabelVisualContact;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldAssault;
            kAlert.imgAlert2.iImage = eImage_MCUFOCrash;

            kSkyranger = HANGAR().m_kSkyranger;
            kTag.StrValue0 = kSkyranger.GetCallsign();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strSkyRangerArrivedSite);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelBeginAssault;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelReturnToBase;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kSkyranger.m_kMission.GetCoords());

            break;
        case 'Abduction':
            Sound().PlaySFX(SNDLIB().SFX_Alert_Abduction);

            kAlert.txtTitle.StrValue = m_strLabelAbductionsReported;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldTerror;
            kReply.strText = m_strLabelViewAbductionSites;

            if (HANGAR().m_kSkyranger.IsFlying())
            {
                kReply.iState = eUIState_Disabled;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            m_bNarrFilteringAbduction = true;

            break;
        case 'Terror':
            Sound().PlaySFX(SNDLIB().SFX_Alert_Terror);

            kMission = GEOSCAPE().GetMission(kGeoAlert.arrData[0].iData);

            txtLabel.strLabel = m_strLabelTerrorCity;
            txtLabel.StrValue = kMission.GetCity().GetName();
            kAlert.arrLabeledText.AddItem(txtLabel);

            kAlert.iNumber = Country(kMission.GetCountry()).GetPanicBlocks();
            txtLabel.strLabel = m_strLabelPanicLevel;
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelDifficulty;
            txtLabel.StrValue = GetMissionDiffString(eMissionDiff_VeryHard);
            kAlert.arrLabeledText.AddItem(txtLabel);

            kReply.strText = m_strLabelSendSkyranger;

            if (HANGAR().m_kSkyranger.IsFlying())
            {
                kReply.iState = eUIState_Disabled;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kMission.GetCoords());

            break;
        case 'FCMission':
            Sound().PlaySFX(SNDLIB().SFX_Alert_FundingCouncil);

            kMission = GEOSCAPE().GetMission(kGeoAlert.arrData[0].iData);

            kAlert.txtTitle.StrValue = m_strLabelFCMission @ XGMission_FundingCouncil(kMission).m_kTMission.strName;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldFunding;

            txtTemp.StrValue = m_strLabelLocation @ kMission.GetLocationString();
            txtTemp.iState = eUIState_Normal;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelSendSkyranger;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kMission.GetCoords());

            break;
        case 'SecretPact':
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kAlert.imgAlert.iImage = kGeoAlert.arrData[0].iData;
            kAlert.iNumber = World().m_iNumCountriesLost;

            txtLabel.strLabel = Country(kGeoAlert.arrData[0].iData).GetName();
            txtLabel.StrValue = m_strLabelCountrySignedPactLabel;
            kAlert.arrLabeledText.AddItem(txtLabel);

            kTag.StrValue0 = Country(kGeoAlert.arrData[0].iData).GetName();
            kTag.StrValue1 = Continent(Country(kGeoAlert.arrData[0].iData).GetContinent()).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelCountryCountLeave);
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = m_strLabelDoomTrackerTitle;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'CountryPanic':
            Sound().PlaySFX(SNDLIB().SFX_Alert_PanicRising);

            kAlert.imgAlert.iImage = kGeoAlert.arrData[0].iData;
            kTag.StrValue0 = Country(kGeoAlert.arrData[0].iData).GetName();
            kAlert.txtTitle.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelPanicCountry);
            kAlert.txtTitle.iState = eUIState_Bad;

            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelPanicCountryLeave);
            txtTemp.iState = eUIState_Bad;
            kAlert.arrText.AddItem(txtTemp);

            kAlert.iNumber = Country(kGeoAlert.arrData[0].iData).GetPanicBlocks();
            txtTemp.StrValue = m_strLabelPanicLevel;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(Country(kGeoAlert.arrData[0].iData).GetCoords());

            break;
        case 'AlienBase':
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kMission = GEOSCAPE().GetMission(kGeoAlert.arrData[0].iData);

            kAlert.txtTitle.StrValue = m_strLabelAssaultAlienBase;
            kAlert.txtTitle.iState = eUIState_Bad;
            kAlert.imgAlert.iImage = eImage_AlienBase;
            kAlert.imgAlert2.iImage = eImage_None;
            kReply.iState = eUIState_Normal;

            if (STORAGE().GetNumItemsAvailable(eItem_Skeleton_Key) == 0)
            {
                txtTemp.StrValue = m_strLabelSkeletonKey;
                txtTemp.iState = eUIState_Bad;
                kAlert.arrText.AddItem(txtTemp);
                kReply.iState = eUIState_Disabled;
            }

            txtLabel.strLabel = m_strLabelLocation;
            txtLabel.StrValue = Country(kMission.GetCountry()).GetName();
            txtLabel.iState = eUIState_Highlight;
            kAlert.arrLabeledText.AddItem(txtLabel);

            kReply.strText = m_strLabelAssault;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strlabelWait;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kMission.GetCoords());

            break;
        case 'Temple':
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kMission = GEOSCAPE().GetMission(kGeoAlert.arrData[0].iData);

            kAlert.txtTitle.StrValue = m_strLabelAssaultTempleShip;
            kAlert.txtTitle.iState = eUIState_Bad;
            kAlert.imgAlert.iImage = eImage_AlienBase;
            kAlert.imgAlert2.iImage = eImage_None;

            txtTemp.StrValue = m_strLabelTempleShip;
            txtTemp.iState = eUIState_Bad;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelAssault;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strlabelWait;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kMission.GetCoords());

            break;
        case 'PayDay':
            Sound().PlaySFX(SNDLIB().SFX_Alert_FundingCouncil);
            GEOSCAPE().ClearTopAlert();

            if (!GEOSCAPE().HasAlerts())
            {
                GoToView(eMCView_MainMenu);
            }

            if (GEOSCAPE().IsScanning())
            {
                OnCancelScan();
            }

            PRES().UIWorldReport();

            break;
        case 'ResearchCompleted':
            Sound().PlaySFX(SNDLIB().SFX_Alert_ResearchComplete);

            kTech = `LWCE_TECH(kGeoAlert.arrData[0].nmData);

            kAlert.txtTitle.StrValue = kTech.strName;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.strPath = kTech.ImagePath;

            kTag.StrValue0 = kTech.strName;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelTechResearchComplete);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelAssignNewResearch;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kReply.iState = eUIState_Normal;

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'ItemProjectCompleted':
            Sound().PlaySFX(SNDLIB().SFX_Alert_ItemProjectComplete);
            kItem = `LWCE_ITEM(kGeoAlert.arrData[0].nmData);

            kAlert.txtTitle.StrValue = kItem.strName;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.strPath = kItem.ImagePath;

            kTag.StrValue0 = kItem.strName;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelManufactureItemComplete);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            if (ENGINEERING().HasRebate())
            {
                if (ENGINEERING().m_arrOldRebates[kGeoAlert.arrData[2].iData].iAlloys > 0 || ENGINEERING().m_arrOldRebates[kGeoAlert.arrData[2].iData].iElerium > 0)
                {
                    txtTemp.StrValue = m_strLabelWorkshopRebate;
                    txtTemp.iState = eUIState_Warning;
                    kAlert.arrText.AddItem(txtTemp);

                    if (ENGINEERING().m_arrOldRebates[kGeoAlert.arrData[2].iData].iAlloys > 0)
                    {
                        txtTemp.StrValue = string(ENGINEERING().m_arrOldRebates[kGeoAlert.arrData[2].iData].iAlloys) @ (GetResourceLabel(eResource_Alloys));
                        txtTemp.iState = eUIState_Alloys;
                        kAlert.arrText.AddItem(txtTemp);
                    }

                    if (ENGINEERING().m_arrOldRebates[kGeoAlert.arrData[2].iData].iElerium > 0)
                    {
                        txtTemp.StrValue = string(ENGINEERING().m_arrOldRebates[kGeoAlert.arrData[2].iData].iElerium) @ (GetResourceLabel(eResource_Elerium));
                        txtTemp.iState = eUIState_Elerium;
                        kAlert.arrText.AddItem(txtTemp);
                    }
                }
            }

            kReply.strText = m_strLabelAssignNewProjects;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'NewFacilityBuilt':
            Sound().PlaySFX(SNDLIB().SFX_Alert_FacilityComplete);
            FacilityNarrative(EFacilityType(kGeoAlert.arrData[0].iData));

            if (kGeoAlert.arrData[0].iData != eFacility_AccessLift)
            {
                if (HQ().m_arrFacilityBinks[kGeoAlert.arrData[0].iData] == 0)
                {
                    HQ().m_arrFacilityBinks[kGeoAlert.arrData[0].iData] = 1;
                    PRES().PlayCinematic(eCinematic_FacilityReward, kGeoAlert.arrData[0].iData);
                }
            }

            kAlert.txtTitle.StrValue = Facility(kGeoAlert.arrData[0].iData).strName;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.iImage = Facility(kGeoAlert.arrData[0].iData).iImage;

            kTag.StrValue0 = Facility(kGeoAlert.arrData[0].iData).strName;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelConstructItemFacilityComplete);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelAssignNewConstruction;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'Augmentation':
            Sound().PlaySFX(SNDLIB().SFX_Alert_FacilityComplete);

            kAlert.txtTitle.StrValue = m_strLabelAugmentTitle;
            kAlert.txtTitle.iState = eUIState_Normal;

            kSoldier = BARRACKS().GetSoldierByID(kGeoAlert.arrData[0].iData);
            kTag.StrValue0 = kSoldier.GetName(eNameType_RankFull);
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelAugmentBody);
            txtTemp.iState = eUIState_Normal;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelGotoBuildMec;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'FoundryProjectCompleted':
            Sound().PlaySFX(SNDLIB().SFX_Alert_FoundryProjectComplete);

            kFoundryTech = `LWCE_FTECH(kGeoAlert.arrData[0].nmData);

            kAlert.txtTitle.StrValue = kFoundryTech.strName;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.strPath = kFoundryTech.ImagePath;

            kTag.StrValue0 = kFoundryTech.strName;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelFoundryItemComplete);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelAssignNewProjects;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);
            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'PsiTraining':
            Sound().PlaySFX(SNDLIB().SFX_Alert_PsiTrainingComplete);

            kAlert.txtTitle.StrValue = m_strLabelMessageFromPsiLabs;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.iImage = eImage_OldSoldier;
            kAlert.imgAlert2.iImage = eImage_Soldier;

            txtTemp.StrValue = m_strLabelPsionicTestingRoundComplete;
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelViewResults;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            if (!PSILABS().m_bSubjectZeroCinematic)
            {
                kReply.strText = m_strLabelCarryOn;
                kAlert.mnuReplies.arrOptions.AddItem(kReply);
            }

            break;
        case 'NewSoldiers':
            Sound().PlaySFX(SNDLIB().SFX_Notify_SoldiersArrived);
            kAlert.txtTitle.StrValue = m_strLabelMessageFormBarracks;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.iImage = eImage_OldSoldier;
            kAlert.imgAlert2.iImage = eImage_Soldier;

            kTag.IntValue0 = kGeoAlert.arrData[0].iData;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelNumRookiesArrived);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelVisitBarracks;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'NewEngineers':
            Sound().PlaySFX(SNDLIB().SFX_Notify_SoldiersArrived);

            kAlert.txtTitle.StrValue = m_strLabelMessageFromEngineering;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.iImage = eImage_OldManufacture;
            kAlert.imgAlert2.iImage = eImage_Engineer;

            kTag.IntValue0 = kGeoAlert.arrData[0].iData;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelNumEngineersArrived);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelVisitEngineering;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'NewScientists':
            Sound().PlaySFX(SNDLIB().SFX_Notify_SoldiersArrived);

            kAlert.txtTitle.StrValue = m_strLabelMessageFromLabs;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.iImage = eImage_OldResearch;
            kAlert.imgAlert2.iImage = eImage_Scientist;

            kTag.IntValue0 = kGeoAlert.arrData[0].iData;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelNumScientistsArrived);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelVisitLabs;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'ExaltRaidFailCountry':
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kAlert.imgAlert.iImage = kGeoAlert.arrData[0].iData;
            kAlert.iNumber = World().m_iNumCountriesLost;

            txtLabel.strLabel = Country(kGeoAlert.arrData[0].iData).GetName();
            txtLabel.StrValue = m_strLabelExaltRaidCountryFailSubtitle;
            kAlert.arrLabeledText.AddItem(txtLabel);

            kTag.StrValue0 = Country(kGeoAlert.arrData[0].iData).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelExaltRaidCountryFailLeft);
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = m_strLabelDoomTrackerTitle;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'ExaltRaidFailContinent':
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kAlert.imgAlert.iImage = kGeoAlert.arrData[0].iData;

            txtLabel.strLabel = m_strLabelExaltRaidContinentFailTitle;
            txtLabel.StrValue = "";
            kAlert.arrLabeledText.AddItem(txtLabel);

            kTag.StrValue0 = Country(kGeoAlert.arrData[0].iData).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelExaltRaidContinentFailDesc);
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = "";
            kAlert.arrText.AddItem(txtTemp);

            kTag.StrValue0 = string(kGeoAlert.arrData[1].iData);
            kTag.StrValue1 = Continent(Country(kGeoAlert.arrData[0].iData).GetContinent()).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelExaltRaidContinentFailPanic);
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'AirBaseDefenseFailed':
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kAlert.imgAlert.iImage = Continent(kGeoAlert.arrData[0].iData).GetRandomCouncilCountry();

            txtLabel.strLabel = "";
            txtLabel.StrValue = "";
            kAlert.arrLabeledText.AddItem(txtLabel);

            kTag.StrValue0 = Continent(kGeoAlert.arrData[0].iData).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelExaltRaidContinentFailSubtitle);
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        default:
            // For unrecognized alerts, just get rid of them
            GEOSCAPE().ClearTopAlert();

            if (GEOSCAPE().HasAlerts())
            {
                UpdateView();
            }

            break;
    }

    m_kCECurrentAlert = kAlert;
    m_kCECurrentAlert.AlertType = kGeoAlert.AlertType;
}

function UpdateEvents()
{
    m_kCEEvents.arrEvents.Remove(0, m_kCEEvents.arrEvents.Length);
    m_kCEEvents.arrOptions.Remove(0, m_kCEEvents.arrOptions.Length);

    LWCE_XGFacility_Labs(LABS()).LWCE_GetEvents(m_kCEEvents.arrEvents);
    LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_GetEvents(m_kCEEvents.arrEvents);
    LWCE_XGGeoscape(GEOSCAPE()).LWCE_GetEvents(m_kCEEvents.arrEvents);
    LWCE_XGHeadquarters(HQ()).LWCE_GetEvents(m_kCEEvents.arrEvents);
    LWCE_XGExaltSimulation(EXALT()).LWCE_GetEvents(m_kCEEvents.arrEvents);

    if (PSILABS() != none)
    {
        LWCE_XGFacility_PsiLabs(PSILABS()).LWCE_GetEvents(m_kCEEvents.arrEvents);
    }

    if (GENELABS() != none)
    {
        LWCE_XGFacility_GeneLabs(GENELABS()).LWCE_GetEvents(m_kCEEvents.arrEvents);
    }

    if (CYBERNETICSLAB() != none)
    {
        LWCE_XGFacility_CyberneticsLab(CYBERNETICSLAB()).LWCE_GetEvents(m_kCEEvents.arrEvents);
    }

    // Base game has a debug flag for AI events here, but this work has been skipped for now. If anyone
    // ends up wanting to use that, we can add it back in.

    /**
     * We're supposed to sort here, but for some reason every attempt to do so fails and the game logs this:
     *
     *     ScriptWarning: Dynamic array Sort: Failed to find comparison function 'LWCE_SortEvents' in object 'LWCE_XGMissionControlUI_0'
     *
     *  Instead we've just made sure that events are always inserted in order so sorting is unnecessary.
     */
    // m_kCEEvents.arrEvents.Sort(LWCE_SortEvents);


    BuildEventOptions();

    if (m_kCEEvents.arrEvents.Length > 0)
    {
        m_kCEEvents.txtEventsLabel.StrValue = m_strLabelUpcomingEvents;
    }
    else
    {
        m_kCEEvents.txtEventsLabel.StrValue = "";
    }

    m_kCEEvents.txtEventsLabel.iState = eUIState_Highlight;
    m_iLastUpdateDay = GEOSCAPE().m_kDateTime.GetDay();
}

function UpdateRequest()
{
    // No point was found where this ends up getting called, so it is simply removed
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(UpdateRequest);
}

function UpdateView()
{
    local XGShip_UFO kUFO;
    local XGMission kMission;
    local LWCE_XGGeoscape kGeoscape;
    local LWCE_TGeoscapeAlert kGeoAlert;

    kGeoscape = LWCE_XGGeoscape(GEOSCAPE());

    UpdateHeader();

    if (m_iCurrentView == eMCView_MainMenu)
    {
        UpdateButtonHelp();
        UpdateMissions();
        UpdateEvents();
        UpdateScan();
        UpdateMissionCounter();
        UpdateSelectionHighlight();
    }
    else if (m_iCurrentView == eMCView_Alert)
    {
        UpdateAlert();
    }
    else if (m_iCurrentView == eMCView_Abduction)
    {
        UpdateAbduction();
    }
    else if (m_iCurrentView == eMCView_ChooseShip)
    {
        kGeoscape.Pause();
        UpdateAlert();
    }

    super(XGScreenMgr).UpdateView();

    if (m_iCurrentView == eMCView_Abduction)
    {
        if (m_bNarrFilteringAbduction)
        {
            Narrative(`XComNarrativeMoment("MCAbduction"));
            m_bNarrFilteringAbduction = false;
        }
    }
    else
    {
        if (m_iCurrentView == eMCView_Alert)
        {
            kGeoAlert = kGeoscape.LWCE_GetTopAlert();

            if (m_kCECurrentAlert.AlertType == 'UFOCrash')
            {
                kMission = XGMission_UFOCrash(kGeoscape.GetMission(kGeoAlert.arrData[0].iData));

                if (XGMission_UFOCrash(kMission).m_iUFOType == /* Transport */ eShip_UFOSupply)
                {
                    if (Narrative(`XComNarrativeMoment("FirstUFOShotDown_LeadOut_CS")))
                    {
                        return;
                    }
                }

                if (XGMission_UFOCrash(kMission).m_iUFOType == /* Battleship */ eShip_UFOBattle)
                {
                    if (Narrative(`XComNarrativeMoment("FirstUFOShotDown_LeadOut_CEN")))
                    {
                        return;
                    }
                }
            }
            else
            {
                if (m_kCECurrentAlert.AlertType == 'UFODetected')
                {
                    Narrative(`XComNarrativeMoment("RoboHQ_UFODetected"));
                    kUFO = AI().GetUFO(kGeoAlert.arrData[0].iData);

                    if (kUFO.m_kObjective.GetType() == eObjective_Hunt)
                    {
                        Narrative(`XComNarrativeMoment("MCSatelliteHunterDetected"));
                        return;
                    }

                    switch (kUFO.GetType())
                    {
                        case eShip_UFOLargeScout:
                            Narrative(`XComNarrativeMoment("MCLargeScout"));
                            break;
                        case eShip_UFOAbductor:
                            Narrative(`XComNarrativeMoment("MCAbductor"));
                            break;
                        case eShip_UFOSupply:
                            Narrative(`XComNarrativeMoment("MCSupply"));
                            break;
                        case eShip_UFOBattle:
                            Narrative(`XComNarrativeMoment("MCBattleship"));
                            break;
                        case eShip_UFOEthereal:
                            if (!HQ().m_kMC.m_bDetectedOverseer)
                            {
                                PRES().UINarrative(`XComNarrativeMoment("MCOverseer"), none, PostOverseerMatinee,, HQ().m_kBase.GetFacility3DLocation(eFacility_HyperwaveRadar));
                                Narrative(`XComNarrativeMoment("HyperwaveBeaconActivated_LeadOut_CE"));
                                Narrative(`XComNarrativeMoment("HyperwaveBeaconActivated_LeadOut_CS"));
                                HQ().m_kMC.m_bDetectedOverseer = true;
                            }

                            break;
                        default:
                            break;
                    }
                }

                if (m_kCECurrentAlert.AlertType == 'PsiTraining')
                {
                    if (PSILABS().m_bSubjectZeroCinematic)
                    {
                        PRES().UINarrative(`XComNarrativeMoment("PsiLabsGift"));
                    }
                }
                else if (m_kCECurrentAlert.AlertType == 'AlienBase')
                {
                    if (STORAGE().GetNumItemsAvailable(eItem_Skeleton_Key) == 0 && !ENGINEERING().IsBuildingItem(eItem_Skeleton_Key))
                    {
                        Narrative(`XComNarrativeMoment("BuildBasePassKeyReminder"));
                    }
                }
                else if (m_kCECurrentAlert.AlertType == 'ItemProjectCompleted')
                {
                    if (kGeoAlert.arrData[0].iData == eItem_Satellite)
                    {
                        Narrative(`XComNarrativeMoment("MCSatellitesReady"));
                    }
                }
                else if (m_kCECurrentAlert.AlertType == 'NewFacilityBuilt')
                {
                }
                else if (m_kCECurrentAlert.AlertType == 'SatelliteDestroyed')
                {
                    Narrative(`XComNarrativeMoment("RoboHQ_SatelliteLost"));
                    Narrative(`XComNarrativeMoment("MCSatelliteShotDown"));
                }
                else if (m_kCECurrentAlert.AlertType == 'FCActivity')
                {
                    Narrative(`XComNarrativeMoment("RoboHQ_IncomingTransmission"));
                    Narrative(`XComNarrativeMoment("FC_RGenericRequestIntro"));
                }
                else if (m_kCECurrentAlert.AlertType == 'FCMissionActivity')
                {
                    Narrative(`XComNarrativeMoment("RoboHQ_IncomingTransmission"));
                    Narrative(`XComNarrativeMoment("FC_RMissionLeadIn"));
                }
                else if (m_kCECurrentAlert.AlertType == 'UFOLost')
                {
                    Narrative(`XComNarrativeMoment("RoboHQ_ContactLost"));
                }
                else if (m_kCECurrentAlert.AlertType == 'UFOLanded')
                {
                    Narrative(`XComNarrativeMoment("RoboHQ_ContactDetected"));
                }
                else if (m_kCECurrentAlert.AlertType == 'DropArrive')
                {
                    Narrative(`XComNarrativeMoment("SkyrangerArrives"));
                }
            }
        }
        else if (m_iCurrentView == eMCView_MainMenu)
        {
            if (!HANGAR().m_kSkyranger.IsFlying())
            {
                if (HANGAR().HasNoJets() && HQ().m_kMC.m_iNoJetsCounter <= 0)
                {
                    Narrative(`XComNarrativeMoment("UrgeInterceptors"));
                    HQ().m_kMC.m_iNoJetsCounter = 4;
                }
            }

            if (HANGAR().m_iJetsLost >= 2 && LWCE_XGFacility_Hangar(HANGAR()).m_nmCEBestWeaponEquipped == 'Item_AvalancheMissiles')
            {
                Narrative(`XComNarrativeMoment("EngineeringBetterJet"));
            }

            if (GEOSCAPE().m_bUFOIgnored)
            {
                Narrative(`XComNarrativeMoment("MCUFOIgnored"));
                GEOSCAPE().m_bUFOIgnored = false;
            }
        }
    }

    ChooseMusic();
}

function int LWCE_SortEvents(LWCE_THQEvent e1, LWCE_THQEvent e2)
{
    return e1.iHours < e2.iHours ? 0 : -1;
}