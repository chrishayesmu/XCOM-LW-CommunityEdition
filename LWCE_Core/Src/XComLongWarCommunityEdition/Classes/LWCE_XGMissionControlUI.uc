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

    // Supplemental data for handling the alert. Generally it's best to process everything into the above fields, so
    // that the UI layer doesn't have too much logic in it. When that's not possible, this arbitrary data can be used.
    var LWCEDataContainer kData;
};

var name m_nmCountryFromExaltSelection;

var LWCE_TMCEventMenu m_kCEEvents;
var LWCE_TMCAlert m_kCECurrentAlert;

function AddNotice(EGeoscapeAlert eNotice, optional int iData1, optional int iData2, optional int iData3)
{
    local LWCEDataContainer kData;
    local name AlertName;

    kData = class'LWCEDataContainer'.static.New('NotifyData');
    kData.AddInt(iData1);
    kData.AddInt(iData2);
    kData.AddInt(iData3);

    AlertName = class'LWCE_XGGeoscape'.static.AlertNameFromEnum(eNotice);

    LWCE_AddNotice(AlertName, kData);
}

function LWCE_AddNotice(name AlertName, LWCEDataContainer kData)
{
    local int iData1, iData2, iData3;
    local LWCECountryTemplate kCountryTemplate;
    local TMCNotice kNotice;
    local XGParamTag kTag;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kNotice.fTimer = 6.0;

    switch (AlertName)
    {
        case 'CountryBombed':
            kTag.StrValue0 = `LWCE_XGCOUNTRY(kData.Data[0].Nm).GetNameWithArticle(true);
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelWarningContactLost);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_Interceptor;
            break;
        case 'ExaltCellHides':
            kTag.StrValue0 = `LWCE_XGCOUNTRY(kData.Data[0].Nm).GetName();
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strCellHides);
            kNotice.txtNotice.iState = eUIState_Warning;
            break;
        case 'ExcavationComplete':
            Narrative(`XComNarrativeMoment("RoboHQ_ExcavationComplete"));
            Sound().PlaySFX(SNDLIB().SFX_Notify_ExcavationComplete);
            kNotice.txtNotice.StrValue = m_strLabelExcavationComplete;
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_TileConstruction;
            break;
        case 'FacilityRemoved':
            kNotice.txtNotice.StrValue = m_strLabelFacilityRemoved;
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_TileConstruction;
            break;
        case 'FCExpiredRequest':
            kTag.StrValue0 = `LWCE_XGCOUNTRY(kData.Data[0].Nm).GetNameWithArticle(true);
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelFCRequestExpired);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_Interceptor;
            break;
        case 'FCNewRequest':
            kTag.StrValue0 = `LWCE_XGCOUNTRY(kData.Data[0].Nm).GetNameWithArticle(true);
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelFCRequestDelayed);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_Interceptor;
            break;
        case 'GeneModComplete':
            kTag.StrValue0 = BARRACKS().GetSoldierByID(kData.Data[0].I).GetName(eNameType_RankFull);
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strGeneModCompleteNotify);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_Soldier;
            break;
        case 'ItemRepairsComplete':
            kTag.StrValue0 = `LWCE_ITEM(kData.Data[0].Nm).strName;
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strSpeakSatDestroyed);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_FacilityGear;
            break;
        case 'MissionAboutToExpire':
            kTag.StrValue0 = GEOSCAPE().m_arrMissions[kData.Data[0].I].GetTitle();
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelDays);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_Interceptor;
            break;
        case 'NewInterceptors':
            Sound().PlaySFX(SNDLIB().SFX_Notify_JetArrived);
            kTag.IntValue0 = kData.Data[0].I;
            kTag.StrValue0 = `LWCE_XGCONTINENT(kData.Data[0].Nm).GetName();
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelNewInterceptorArrival);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_Interceptor;
            break;
        case 'NewItemBuilt':
            Sound().PlaySFX(SNDLIB().SFX_Notify_ItemBuilt);
            kTag.IntValue0 = kData.Data[1].I;
            kTag.StrValue0 = `LWCE_ITEM(kData.Data[0].Nm).strName;
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelItemBuilt);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_FacilityGear;
            break;
        case 'NewSoldiers':
            Sound().PlaySFX(SNDLIB().SFX_Notify_SoldiersArrived);
            kTag.IntValue0 = kData.Data[0].I;
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelNewSoldiers);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_Soldier;
            break;
        case 'SatelliteOnline':
            kCountryTemplate = `LWCE_COUNTRY(`LWCE_HQ.m_arrCESatellites[kData.Data[0].I].nmCountry);
            Sound().PlaySFX(SNDLIB().SFX_Notify_SatelliteOperational);
            kTag.StrValue0 = `LWCE_ITEM(`LWCE_HQ.m_arrCESatellites[kData.Data[0].I].nmType).strName;
            kTag.StrValue1 = `LWCE_XGCOUNTRY(kCountryTemplate.GetCountryName()).GetName();
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelSatOnline);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_Interceptor;

            if (kCountryTemplate.strSatelliteNarrativePath != "")
            {
                Narrative(XComNarrativeMoment(DynamicLoadObject(kCountryTemplate.strSatelliteNarrativePath, class'XComNarrativeMoment')));
            }

            break;
        case 'ShipActivityOverCountry':
            kTag.StrValue0 = `LWCE_XGCOUNTRY(kData.Data[0].Nm).GetNameWithArticle(true);
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelWarningUFOOnGround);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_Interceptor;
            break;
        case 'ShipArmed':
            Sound().PlaySFX(SNDLIB().SFX_Notify_JetArmed);
            kTag.StrValue0 = LWCE_XGFacility_Hangar(HANGAR()).m_arrCEShips[kData.Data[0].I].GetCallsign();
            kTag.StrValue1 = LWCE_XGFacility_Hangar(HANGAR()).m_arrCEShips[kData.Data[0].I].GetWeaponString();
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelShipRearmed);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_Interceptor;
            break;
        case 'ShipEnRouteToXComHQ':
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelSignatureNotIdentified);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_Interceptor;
            break;
        case 'ShipOnline':
            Sound().PlaySFX(SNDLIB().SFX_Notify_JetRepaired);
            kTag.StrValue0 = LWCE_XGFacility_Hangar(HANGAR()).m_arrCEShips[kData.Data[0].I].GetCallsign();
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelShipOnline);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_Interceptor;
            break;
        case 'ShipTransferred':
            Sound().PlaySFX(SNDLIB().SFX_Notify_JetTransferred);
            Narrative(`XComNarrativeMoment("RoboHQ_AircraftTransferComplete"));
            kTag.StrValue0 = LWCE_XGFacility_Hangar(HANGAR()).m_arrCEShips[kData.Data[0].I].GetCallsign();
            kTag.StrValue1 = `LWCE_XGCONTINENT(LWCE_XGFacility_Hangar(HANGAR()).m_arrCEShips[kData.Data[0].I].GetContinent()).GetName();
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelShipTransferArrival);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_Interceptor;
            break;
        case 'SoldierHealed':
            Sound().PlaySFX(SNDLIB().SFX_Notify_SoldierHealed);
            kTag.StrValue0 = BARRACKS().GetSoldierByID(kData.Data[0].I).GetName(eNameType_RankFull);
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelSoldierHealed);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_Soldier;
            break;
        default:
            iData1 = kData.Data.Length > 0 ? kData.Data[0].I : 0;
            iData2 = kData.Data.Length > 1 ? kData.Data[1].I : 0;
            iData3 = kData.Data.Length > 2 ? kData.Data[2].I : 0;

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
                kTech = `LWCE_TECH(m_kCEEvents.arrEvents[iEvent].kData.Data[0].Nm);

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
                kOption.txtOption.StrValue = `LWCE_ITEM(m_kCEEvents.arrEvents[iEvent].kData.Data[0].Nm).strName;

                if (m_kCEEvents.arrEvents[iEvent].kData.Data[1].I > 1)
                {
                    kOption.txtOption.StrValue @= "(" $ m_kCEEvents.arrEvents[iEvent].kData.Data[1].I $ ")";
                }

                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 100, 0, byte(175 / 3));
                break;
            case 'Facility':
                kOption.EventType = 'Facility';
                kOption.iPriority = 3;
                kOption.imgOption.iImage = eImage_OldManufacture;
                kOption.txtOption.StrValue = `LWCE_FACILITY(m_kCEEvents.arrEvents[iEvent].kData.Data[0].Nm).strName;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(100, 100, 100, byte(175 / 3));
                break;
            case 'Foundry':
                kFoundryTech = `LWCE_FOUNDRY_PROJECT(m_kCEEvents.arrEvents[iEvent].kData.Data[0].Nm);

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

                if (m_kCEEvents.arrEvents[iEvent].kData.Data[1].I > 1)
                {
                    kOption.txtOption.StrValue @= "(" $ m_kCEEvents.arrEvents[iEvent].kData.Data[1].I $ ")";
                }

                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case 'InterceptorOrdering':
                kTag.StrValue0 = `LWCE_XGCONTINENT(m_kCEEvents.arrEvents[iEvent].kData.Data[0].Nm).GetName();
                kOption.EventType = 'InterceptorOrdering';
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldInterception;
                kOption.txtOption.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelNewInterceptors);

                if (m_kCEEvents.arrEvents[iEvent].kData.Data[1].I > 1)
                {
                    kOption.txtOption.StrValue @= "(" $ m_kCEEvents.arrEvents[iEvent].kData.Data[1].I $ ")";
                }

                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case 'SatOperational':
                kTag.StrValue0 = `LWCE_XGCOUNTRY(m_kCEEvents.arrEvents[iEvent].kData.Data[0].Nm).GetName();
                kOption.EventType = 'SatOperational';
                kOption.iPriority = 2;
                kOption.txtOption.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelSatOperational);
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case 'ShipTransfers':
                kTag.StrValue0 = `LWCE_XGCONTINENT(m_kCEEvents.arrEvents[iEvent].kData.Data[0].Nm).GetName();
                kOption.EventType = 'ShipTransfers';
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldInterception;
                kOption.txtOption.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelShipTransfer);
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case 'FCRequest':
                kTag.StrValue0 = `LWCE_XGCONTINENT(m_kCEEvents.arrEvents[iEvent].kData.Data[0].Nm).GetName();
                kOption.kData = m_kCEEvents.arrEvents[iEvent].kData;
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
                kTag.StrValue0 = `LWCE_ITEM(m_kCEEvents.arrEvents[iEvent].kData.Data[0].Nm).strName;

                // Include the quantity being repaired
                if (m_kCEEvents.arrEvents[iEvent].kData.Data[1].I > 1)
                {
                    kTag.StrValue0 $= " (" $ m_kCEEvents.arrEvents[iEvent].kData.Data[1].I $ ")";
                }

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

/// <summary>
/// Checks whether it's currently possible to activate a mission. Activation is prevented if
/// the Skyranger or any other XCOM ships are currently flying.
/// </summary>
function bool CanActivateMission()
{
    local LWCE_XGShip kShip;

    if (HANGAR().GetDropship().IsFlying())
    {
        return false;
    }

    foreach LWCE_XGFacility_Hangar(HANGAR()).m_arrCEShips(kShip)
    {
        if (kShip.IsFlying() && kShip.m_kEngagement != none)
        {
            return false;
        }
    }

    return true;
}

function bool CheckForInterrupt()
{
    local LWCE_TGeoscapeAlert kAlert;

    kAlert = LWCE_XGGeoscape(GEOSCAPE()).LWCE_GetTopAlert();

    switch (kAlert.AlertType)
    {
        case 'EnemyShipDetected':
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
            return kAlert.AlertType == 'ItemProjectCompleted' && kAlert.kData.Data[0].I == m_kCEEvents.arrEvents[m_iEvent].kData.Data[0].I;
        case 'Facility':
            return kAlert.AlertType == 'NewFacilityBuilt' && kAlert.kData.Data[0].I == m_kCEEvents.arrEvents[m_iEvent].kData.Data[0].I;
        case 'Foundry':
            return kAlert.AlertType == 'FoundryProjectCompleted' && kAlert.kData.Data[0].I == m_kCEEvents.arrEvents[m_iEvent].kData.Data[0].I;
        case 'Research':
            return kAlert.AlertType == 'ResearchCompleted' && kAlert.kData.Data[0].I == m_kCEEvents.arrEvents[m_iEvent].kData.Data[0].I;
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
    local LWCE_XComHQPresentationLayer kPres;
    local LWCE_XGGeoscape kGeoscape;
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

    kPres = LWCE_XComHQPresentationLayer(PRES());
    kGeoscape = LWCE_XGGeoscape(GEOSCAPE());
    kAlert = LWCE_XGGeoscape(GEOSCAPE()).LWCE_GetTopAlert();

    PlaySmallCloseSound();
    kGeoscape.ClearTopAlert();

    switch (m_kCECurrentAlert.AlertType)
    {
        case 'SecretPact':
            if (Game().CheckForLoseGame() <= 0)
            {
                kGeoscape.Pause();
            }
            else
            {
                HQ().CheckForOperatingLoss(GetUIScreen());
            }

            break;
        case 'SatelliteDestroyed':
            HQ().CheckForOperatingLoss(GetUIScreen());
            break;
        case 'EnemyShipDetected':
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
                kPres.LWCE_UIIntercept(LWCE_XGStrategyAI(AI()).LWCE_GetShip(m_kCECurrentAlert.kData.Data[0].I));

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
                    kPres.UIChooseSquad(kGeoscape.GetMission(kAlert.kData.Data[0].I));
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
                    kPres.UIChooseSquad(kGeoscape.GetMission(kAlert.kData.Data[0].I));
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
                else if (LWCE_XGStorage(STORAGE()).LWCE_GetNumItemsAvailable('Item_SkeletonKey') == 0)
                {
                    PlayBadSound();
                }
                else
                {
                    GoToView(eMCView_MainMenu);
                    kPres.UIChooseSquad(kGeoscape.GetMission(kAlert.kData.Data[0].I));
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
                kPres.bShouldUpdateSituationRoomMenu = false;
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
                kGeoscape.ShowRealEarth();
            }
            else
            {
                kGeoscape.ShowRealEarth();
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
                kPres.ShouldPause(false);
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
                kPres.ShouldPause(true);
                PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
                kGeoscape.SkyrangerReturnToBase(kSkyranger, true);
                kGeoscape.Resume();
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

                    for (iIndex = 0; iIndex < kGeoscape.m_arrMissions.Length; iIndex++)
                    {
                        kMission = kGeoscape.m_arrMissions[iIndex];

                        if (kMission.IsA('XGMission_CovertOpsExtraction') || kMission.IsA('XGMission_CaptureAndHold'))
                        {
                            SITROOM().SetInfiltratorMission(kMission);
                            break;
                        }
                    }

                    kPres.bShouldUpdateSituationRoomMenu = false;
                    SITROOM().m_bDisplayInfiltratorMissionDetails = true;
                    JumpToFacility(SITROOM(), eSitView_CovertOpsExtractionMission);
                    kPres.UIInfiltratorMission();
                }
            }
            else
            {
                kPres.CAMLookAtEarth(HQ().GetCoords());
            }

            break;
        default:
            if (!kGeoscape.HasAlerts())
            {
                kPres.CAMLookAtEarth(HQ().GetCoords());
            }

            break;
    }

    if (bCanceledAction)
    {
        kGeoscape.LWCE_PreloadSquadIntoSkyranger(m_kCECurrentAlert.AlertType, true);
    }

    if (kGeoscape.HasAlerts())
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

    // The last entry in the list is always start/stop scanning the Geoscape
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

/// <summary>
/// Brings up the UI for the initial choice to intercept or ignore a ship contact.
/// Despite still being named "UFO", works with LWCE ships.
/// </summary>
function ShowUFOInterceptAlert(int iShipIndex)
{
    local LWCE_XGGeoscape kGeoscape;
    local LWCE_XGStrategyAI kAI;

    kAI = LWCE_XGStrategyAI(AI());
    kGeoscape = LWCE_XGGeoscape(GEOSCAPE());

    kGeoscape.LWCE_Alert(`LWCE_ALERT('EnemyShipDetected').AddInt(iShipIndex).Build());
    GoToView(eMCView_ChooseShip);
    kGeoscape.ClearTopAlert(true);
    LWCE_XComHQPresentationLayer(PRES()).LWCE_UIIntercept(kAI.LWCE_GetShip(iShipIndex));
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
    local LWCEFacilityTemplate kFacility;
    local LWCEFoundryProjectTemplate kFoundryTech;
    local LWCEItemTemplate kItem;
    local LWCETechTemplate kTech;
    local LWCE_XGContinent kContinent;
    local LWCE_XGCountry kCountry;
    local LWCE_XGGeoscape kGeoscape;
    local LWCE_XGFacility_Hangar kHangar;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGShip kShip;
    local LWCE_XGStorage kStorage;
    local LWCE_XGStrategyAI kAI;
    local LWCE_TGeoscapeAlert kGeoAlert;
    local LWCE_TMCAlert kAlert;
    local TLabeledText txtLabel;
    local TText txtTemp;
    local TMenuOption kReply;
    local XGMission kMission;
    local XGShip_Dropship kSkyranger;
    local XGParamTag kTag;
    local XGCountryTag kCountryTag;
    local XGStrategySoldier kSoldier;
    local string strNarrative;

    if (!GEOSCAPE().HasAlerts())
    {
        return;
    }

    kGeoscape = LWCE_XGGeoscape(GEOSCAPE());
    kHangar = LWCE_XGFacility_Hangar(HANGAR());
    kAI = LWCE_XGStrategyAI(AI());
    kHQ = LWCE_XGHeadquarters(HQ());
    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kStorage = LWCE_XGStorage(STORAGE());
    kCountryTag = new class'XGCountryTag';

    kGeoAlert = kGeoscape.LWCE_GetTopAlert();

    switch (kGeoAlert.AlertType)
    {
        case 'EnemyShipDetected':
            kShip = kAI.LWCE_GetShip(kGeoAlert.kData.Data[0].I);

            // For our first Overseer, don't play the sound because we're going to do a cinematic instead
            if (kShip.IsType('UFOOverseer') && !HQ().m_kMC.m_bDetectedOverseer)
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

            kAlert.kData = class'LWCEDataContainer'.static.NewInt('AlertData', kGeoAlert.kData.Data[0].I);

            txtLabel.strLabel = m_strLabelContact;
            txtLabel.StrValue = m_strLabelUFOPrefix $ kShip.m_iCounter;
            txtLabel.iState = eUIState_Warning;
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelLocation;
            txtLabel.StrValue = `LWCE_XGCOUNTRY(kShip.GetCountry()).GetName();
            txtLabel.StrValue $= kShip.GetAltitudeString();
            txtLabel.iState = eUIState_Highlight;
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelSize;
            txtLabel.StrValue = kShip.GetSizeString();
            txtLabel.iState = eUIState_Highlight;
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelUFOClass;

            if (kGeoscape.LWCE_CanIdentifyShip(kShip.m_nmShipTemplate))
            {
                kAlert.imgAlert2.iImage = kShip.m_kTShip.iImage;
                txtLabel.StrValue = kShip.m_kTShip.strName;
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
                txtLabel.StrValue = kShip.m_kObjective.m_kTObjective.strName;
                kAlert.arrLabeledText.AddItem(txtLabel);
            }

            if (kHangar.LWCE_GetNumShipsInRangeAndAvailable(kShip) == 0)
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

            PRES().CAMLookAtEarth(kShip.GetCoords());

            break;
        case 'UFOLanded':
            Sound().PlaySFX(SNDLIB().SFX_Alert_UFOLanded);

            `LWCE_LOG_ERROR("LWCE_XGMissionControlUI: UFOLanded alert requires updates to XGMission_UFOLanded");
            //kShip = XGMission_UFOLanded(GEOSCAPE().GetMission(kGeoAlert.kData.Data[0].I)).kUFO;
            kMission = XGMission_UFOLanded(GEOSCAPE().GetMission(kGeoAlert.kData.Data[0].I));

            if (kMission.m_kDesc.m_strMapName == "EWI_HQAssault_MP (Airbase Defense)")
            {
                kTag.StrValue0 = m_strLabelUFOPrefix $ string(kShip.m_iCounter);
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
                kTag.StrValue0 = m_strLabelUFOPrefix $ string(kShip.m_iCounter);
                kAlert.txtTitle.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelUFOHasLanded);
                kAlert.txtTitle.iState = eUIState_Warning;
                kAlert.imgAlert.iImage = eImage_OldUFO;
                txtLabel.strLabel = m_strLabelContact;
                txtLabel.StrValue = m_strLabelUFOPrefix $ string(kShip.m_iCounter);
                txtLabel.iState = eUIState_Warning;
                kAlert.arrLabeledText.AddItem(txtLabel);

                txtLabel.strLabel = m_strLabelLocation;
                txtLabel.StrValue = kMission.GetLocationString();
                txtLabel.iState = eUIState_Highlight;
                kAlert.arrLabeledText.AddItem(txtLabel);

                kAlert.imgAlert2.iImage = eImage_MCUFOLanded;
                txtLabel.strLabel = m_strLabelUFOClass;
                txtLabel.iState = eUIState_Warning;

                if (kGeoscape.LWCE_CanIdentifyShip(kShip.m_nmShipTemplate))
                {
                    txtLabel.StrValue = kShip.m_kTShip.strName;
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
                    txtLabel.StrValue = kShip.m_kObjective.m_kTObjective.strName;
                    kAlert.arrLabeledText.AddItem(txtLabel);

                    txtLabel.strLabel = m_strLabelAlienCrewSize;
                    txtLabel.StrValue = string(kMission.GetEnemyCount());
                    kAlert.arrLabeledText.AddItem(txtLabel);

                    txtLabel.strLabel = m_strLabelAlienSpecies;
                    txtLabel.StrValue = kMission.GetSpeciesList();
                    kAlert.arrLabeledText.AddItem(txtLabel);

                }

                PRES().CAMLookAtEarth(kShip.GetCoords());
            }

            kReply.strText = m_strLabelSendSkyranger;

            if (kHangar.m_kSkyranger.IsFlying())
            {
                kReply.iState = eUIState_Disabled;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'UFOCrash':
            kMission = XGMission_UFOCrash(GEOSCAPE().GetMission(kGeoAlert.kData.Data[0].I));
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

            if (kHangar.m_kSkyranger.IsFlying())
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

            kAlert.txtTitle.StrValue = (m_strLabelContactLost @ m_strLabelUFOPrefix) $ kGeoAlert.kData.Data[0].I;
            kAlert.txtTitle.iState = eUIState_Warning;

            txtTemp.StrValue = m_strLabelLostContactRequestOrder;
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelRecallInterceptors;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'SatelliteDestroyed':
            Sound().PlaySFX(SNDLIB().SFX_Alert_SatelliteLost);

            kCountry = `LWCE_XGCOUNTRY(kGeoAlert.kData.Data[0].Nm);
            kContinent = `LWCE_XGCONTINENT(kCountry.LWCE_GetContinent());

            kAlert.txtTitle.StrValue = m_strLabelStatCountryDestroyed;
            kAlert.txtTitle.iState = eUIState_Warning;

            kTag.StrValue0 = kCountry.GetNameWithArticle();
            kTag.StrValue1 = kContinent.GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelLostSatFundingSuspending);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kTag.StrValue0 = kContinent.GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strPanicIncrease);
            txtTemp.iState = eUIState_Bad;
            kAlert.arrText.AddItem(txtTemp);

            // TODO: LW retained a check that the lost sat wasn't in the starting continent, which seems like a bug.
            // Repro and file an issue if so
            if (kContinent.GetNumSatellites() == kContinent.m_arrCECountries.Length - 1)
            {
                kTag.StrValue0 = kContinent.GetBonus().strTitle;
                txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelBonusLost);
                txtTemp.iState = eUIState_Bad;
                kAlert.arrText.AddItem(txtTemp);
            }

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kCountry.GetCoords());

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
            kMission = GEOSCAPE().GetMission(kGeoAlert.kData.Data[0].I); // TODO: this is broken in base game too?
            kCountry = `LWCE_XGCOUNTRY(kGeoAlert.kData.Data[0].Nm);
            kCountryTag.kCountry = kCountry;

            kAlert.txtTitle.StrValue = m_strLabelExaltActivityTitle;
            kAlert.txtTitle.iState = eUIState_Warning;

            txtTemp.StrValue = m_strLabelExaltActivitySubtitles[kGeoAlert.kData.Data[1].I];
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = kCountry.GetNameWithArticle();
            kAlert.arrText.AddItem(txtTemp);

            m_nmCountryFromExaltSelection = kGeoAlert.kData.Data[0].Nm;
            txtTemp.StrValue = m_arrExaltReasons[kGeoAlert.kData.Data[1].I];

            if (kGeoAlert.kData.Data[1].I == eExaltCellExposeReason_SabatogeOperation)
            {
                kTag.StrValue0 = class'UIUtilities'.static.GetHTMLColoredText(ConvertCashToString(kGeoAlert.kData.Data[2].I), eUIState_Cash);
                txtTemp.StrValue = class'XComLocalizer'.static.ExpandStringByTag(txtTemp.StrValue, kCountryTag) $ "\n\n";
            }

            txtTemp.StrValue $= m_strLabelExaltActivityBody;
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = string(kCountry.GetPanicBlocks());
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = string(kGeoAlert.kData.Data[1].I);
            kAlert.arrText.AddItem(txtTemp);

            kAlert.imgAlert.iImage = kGeoAlert.kData.Data[1].I;

            kReply.strText = m_strLabelExaltSelSitRoom;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelExaltSelNotNow;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            GEOSCAPE().ShowHoloEarth();
            GEOSCAPE().Pause();
            PRES().CAMLookAtEarth(kCountry.GetCoords());
            GEOSCAPE().PulseCountry(ECountry(kMission.GetCountry()), MakeColor(192, 0, 0, 255), MakeColor(255, 128, 0, 255), 0.750);

            break;
        case 'ExaltResearchHack':
            kMission = GEOSCAPE().GetMission(kGeoAlert.kData.Data[0].I); // TODO: this is broken in base game too?
            kCountry = `LWCE_XGCOUNTRY(kGeoAlert.kData.Data[0].Nm);
            kCountryTag.kCountry = kCountry;

            kAlert.txtTitle.StrValue = m_strLabelExaltActivityTitle;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = kGeoAlert.kData.Data[1].I;

            txtTemp.StrValue = m_strLabelExaltActivitySubtitles[kGeoAlert.kData.Data[1].I];
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            // kGeoAlert.kData.Data[2].I = research hours lost due to the hack
            // kGeoAlert.kData.Data[3].I = research hours saved due to having labs
            txtTemp.StrValue = m_arrExaltReasons[kGeoAlert.kData.Data[1].I];
            kTag.IntValue0 = kGeoAlert.kData.Data[2].I + kGeoAlert.kData.Data[3].I;
            kTag.IntValue1 = kGeoAlert.kData.Data[3].I;
            kTag.IntValue2 = kGeoAlert.kData.Data[2].I / 24;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandStringByTag(txtTemp.StrValue, kCountryTag);
            kAlert.arrText.AddItem(txtTemp);

            kTag.IntValue0 = kHQ.LWCE_GetNumFacilities('Facility_Laboratory');
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelResearchHackNumLabs);
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = "";
            kAlert.arrText.AddItem(txtTemp);

            txtLabel.strLabel = m_strLabelResearchHackTimeLost;

            if ((kGeoAlert.kData.Data[2].I + kGeoAlert.kData.Data[3].I) < 24)
            {
                txtLabel.StrValue = string(kGeoAlert.kData.Data[2].I + kGeoAlert.kData.Data[3].I);

                if (GetLanguage() == "KOR" || GetLanguage() == "JPN")
                {
                    txtLabel.StrValue $= class'UIUtilities'.static.GetHoursString(kGeoAlert.kData.Data[2].I + kGeoAlert.kData.Data[3].I);
                }
                else
                {
                    txtLabel.StrValue @= class'UIUtilities'.static.GetHoursString(kGeoAlert.kData.Data[2].I + kGeoAlert.kData.Data[3].I);
                }
            }
            else
            {
                txtLabel.StrValue = string((kGeoAlert.kData.Data[2].I + kGeoAlert.kData.Data[3].I) / 24);

                if ((GetLanguage() == "KOR") || GetLanguage() == "JPN")
                {
                    txtLabel.StrValue $= class'UIUtilities'.static.GetDaysString(kGeoAlert.kData.Data[2].I + (kGeoAlert.kData.Data[3].I / 24));
                }
                else
                {
                    txtLabel.StrValue @= class'UIUtilities'.static.GetDaysString((kGeoAlert.kData.Data[2].I + kGeoAlert.kData.Data[3].I) / 24);
                }
            }

            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelResearchHackDataBackup;
            txtLabel.StrValue = string(kHQ.LWCE_GetNumFacilities('Facility_Laboratory') * 20) $ "%";
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelResearchHackTotalTimeLost;

            if (kGeoAlert.kData.Data[2].I < 24)
            {
                txtLabel.StrValue = string(kGeoAlert.kData.Data[2].I);

                if (GetLanguage() == "KOR" || GetLanguage() == "JPN")
                {
                    txtLabel.StrValue $= class'UIUtilities'.static.GetHoursString(kGeoAlert.kData.Data[2].I + kGeoAlert.kData.Data[3].I);
                }
                else
                {
                    txtLabel.StrValue @= class'UIUtilities'.static.GetHoursString(kGeoAlert.kData.Data[2].I + kGeoAlert.kData.Data[3].I);
                }
            }
            else
            {
                txtLabel.StrValue = string(kGeoAlert.kData.Data[2].I / 24);

                if ((GetLanguage() == "KOR") || GetLanguage() == "JPN")
                {
                    txtLabel.StrValue $= class'UIUtilities'.static.GetDaysString(kGeoAlert.kData.Data[2].I + (kGeoAlert.kData.Data[3].I / 24));
                }
                else
                {
                    txtLabel.StrValue @= class'UIUtilities'.static.GetDaysString((kGeoAlert.kData.Data[2].I + kGeoAlert.kData.Data[3].I) / 24);
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
            PRES().CAMLookAtEarth(kCountry.GetCoords());
            GEOSCAPE().PulseCountry(ECountry(kMission.GetCountry()), MakeColor(192, 0, 0, 255), MakeColor(255, 128, 0, 255), 0.750);

            break;
        case 'ExaltAlert':
            kMission = GEOSCAPE().GetMission(kGeoAlert.kData.Data[0].I);
            kAlert.txtTitle.StrValue = m_strLabelExaltAlertTitle;

            txtTemp.StrValue = m_strLabelExaltAlertBody;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelExaltAlertSendSquad;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelExaltAlertNotNow;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'FCJetTransfer':
            Sound().PlaySFX(SNDLIB().SFX_Alert_FundingCouncil);

            kAlert.txtTitle.StrValue = m_strLabelIncFCCom;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldFunding;
            kAlert.imgAlert2.iImage = eImage_XComBadge;

            kTag.StrValue0 = `LWCE_XGCOUNTRY(kGeoAlert.kData.Data[0].Nm).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelFCFinishedJetTransfer);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            PRES().Speak(m_strSpeakIncTransmission, TTSSPEAKER_Ursula);

            kReply.strText = m_strLabelGoSituationRoom;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'DropArrive':
            Sound().PlaySFX(SNDLIB().SFX_Alert_DropArrive);
            kAlert.txtTitle.StrValue = m_strLabelVisualContact;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldAssault;
            kAlert.imgAlert2.iImage = eImage_MCUFOCrash;

            kSkyranger = kHangar.m_kSkyranger;
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

            if (kHangar.m_kSkyranger.IsFlying())
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

            kMission = GEOSCAPE().GetMission(kGeoAlert.kData.Data[0].I);

            txtLabel.strLabel = m_strLabelTerrorCity;
            txtLabel.StrValue = kMission.GetCity().GetName();
            kAlert.arrLabeledText.AddItem(txtLabel);

            // TODO mission support
            kAlert.kData = class'LWCEDataContainer'.static.NewInt('AlertData', Country(kMission.GetCountry()).GetPanicBlocks()); // `LWCE_XGCOUNTRY(kMission.GetCountry()).GetPanicBlocks();
            txtLabel.strLabel = m_strLabelPanicLevel;
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelDifficulty;
            txtLabel.StrValue = GetMissionDiffString(eMissionDiff_VeryHard);
            kAlert.arrLabeledText.AddItem(txtLabel);

            kReply.strText = m_strLabelSendSkyranger;

            if (kHangar.m_kSkyranger.IsFlying())
            {
                kReply.iState = eUIState_Disabled;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kMission.GetCoords());

            break;
        case 'SecretPact':
            kCountry = `LWCE_XGCOUNTRY(kGeoAlert.kData.Data[0].Nm);
            kContinent = `LWCE_XGCONTINENT(kCountry.LWCE_GetContinent());

            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kAlert.imgAlert.iImage = kGeoAlert.kData.Data[0].I;
            kAlert.kData = class'LWCEDataContainer'.static.NewInt('AlertData', World().m_iNumCountriesLost);

            txtLabel.strLabel = kCountry.GetName();
            txtLabel.StrValue = m_strLabelCountrySignedPactLabel;
            kAlert.arrLabeledText.AddItem(txtLabel);

            kTag.StrValue0 = kCountry.GetName();
            kTag.StrValue1 = kContinent.GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelCountryCountLeave);
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = m_strLabelDoomTrackerTitle;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'CountryPanic':
            kCountry = `LWCE_XGCOUNTRY(kGeoAlert.kData.Data[0].Nm);
            Sound().PlaySFX(SNDLIB().SFX_Alert_PanicRising);

            kAlert.imgAlert.iImage = kGeoAlert.kData.Data[0].I; // TODO ???
            kTag.StrValue0 = kCountry.GetName();
            kAlert.txtTitle.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelPanicCountry);
            kAlert.txtTitle.iState = eUIState_Bad;

            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelPanicCountryLeave);
            txtTemp.iState = eUIState_Bad;
            kAlert.arrText.AddItem(txtTemp);

            kAlert.kData = class'LWCEDataContainer'.static.NewInt('AlertData', kCountry.GetPanicBlocks());
            txtTemp.StrValue = m_strLabelPanicLevel;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kCountry.GetCoords());

            break;
        case 'AlienBase':
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kMission = GEOSCAPE().GetMission(kGeoAlert.kData.Data[0].I);

            kAlert.txtTitle.StrValue = m_strLabelAssaultAlienBase;
            kAlert.txtTitle.iState = eUIState_Bad;
            kAlert.imgAlert.iImage = eImage_AlienBase;
            kAlert.imgAlert2.iImage = eImage_None;
            kReply.iState = eUIState_Normal;

            if (kStorage.LWCE_GetNumItemsAvailable('Item_SkeletonKey') == 0)
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

            kMission = GEOSCAPE().GetMission(kGeoAlert.kData.Data[0].I);

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

            kTech = `LWCE_TECH(kGeoAlert.kData.Data[0].Nm);

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
            kItem = `LWCE_ITEM(kGeoAlert.kData.Data[0].Nm);

            kAlert.txtTitle.StrValue = kItem.strName;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.strPath = kItem.ImagePath;

            kTag.StrValue0 = kItem.strName;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelManufactureItemComplete);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            if (ENGINEERING().HasRebate())
            {
                if (ENGINEERING().m_arrOldRebates[kGeoAlert.kData.Data[2].I].iAlloys > 0 || ENGINEERING().m_arrOldRebates[kGeoAlert.kData.Data[2].I].iElerium > 0)
                {
                    txtTemp.StrValue = m_strLabelWorkshopRebate;
                    txtTemp.iState = eUIState_Warning;
                    kAlert.arrText.AddItem(txtTemp);

                    if (ENGINEERING().m_arrOldRebates[kGeoAlert.kData.Data[2].I].iAlloys > 0)
                    {
                        txtTemp.StrValue = string(ENGINEERING().m_arrOldRebates[kGeoAlert.kData.Data[2].I].iAlloys) @ (GetResourceLabel(eResource_Alloys));
                        txtTemp.iState = eUIState_Alloys;
                        kAlert.arrText.AddItem(txtTemp);
                    }

                    if (ENGINEERING().m_arrOldRebates[kGeoAlert.kData.Data[2].I].iElerium > 0)
                    {
                        txtTemp.StrValue = string(ENGINEERING().m_arrOldRebates[kGeoAlert.kData.Data[2].I].iElerium) @ (GetResourceLabel(eResource_Elerium));
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
            kFacility = `LWCE_FACILITY(kGeoAlert.kData.Data[0].Nm);

            Sound().PlaySFX(SNDLIB().SFX_Alert_FacilityComplete);

            strNarrative = kFacility.strPostBuildNarrative != "" ? kFacility.strPostBuildNarrative : "NarrativeMoment.RoboHQ_NewFacility";
            Narrative(XComNarrativeMoment(DynamicLoadObject(strNarrative, class'XComNarrativeMoment')));

            if (kFacility.strBinkReveal != "")
            {
                if (kHQ.m_arrCEFacilityBinksPlayed.Find(kFacility.GetFacilityName()) == INDEX_NONE)
                {
                    kHQ.m_arrCEFacilityBinksPlayed.AddItem(kFacility.GetFacilityName());
                    PRES().UIPlayMovie(kFacility.strBinkReveal, /* bWait */ true);
                }
            }

            kAlert.txtTitle.StrValue = kFacility.strName;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.strPath = kFacility.ImageLabel;

            kTag.StrValue0 = kFacility.strName;
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

            kSoldier = BARRACKS().GetSoldierByID(kGeoAlert.kData.Data[0].I);
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

            kFoundryTech = `LWCE_FOUNDRY_PROJECT(kGeoAlert.kData.Data[0].Nm);

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

            kTag.IntValue0 = kGeoAlert.kData.Data[0].I;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelNumRookiesArrived);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelVisitBarracks;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'ExaltRaidFailCountry':
            kCountry = `LWCE_XGCOUNTRY(kGeoAlert.kData.Data[0].Nm);
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kAlert.imgAlert.iImage = kGeoAlert.kData.Data[0].I;
            kAlert.kData = class'LWCEDataContainer'.static.NewInt('AlertData', World().m_iNumCountriesLost);

            txtLabel.strLabel = kCountry.GetName();
            txtLabel.StrValue = m_strLabelExaltRaidCountryFailSubtitle;
            kAlert.arrLabeledText.AddItem(txtLabel);

            kTag.StrValue0 = kCountry.GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelExaltRaidCountryFailLeft);
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = m_strLabelDoomTrackerTitle;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'ExaltRaidFailContinent':
            kCountry = `LWCE_XGCOUNTRY(kGeoAlert.kData.Data[0].Nm);
            kContinent = `LWCE_XGCONTINENT(kCountry.LWCE_GetContinent());

            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kAlert.imgAlert.iImage = kGeoAlert.kData.Data[0].I;

            txtLabel.strLabel = m_strLabelExaltRaidContinentFailTitle;
            txtLabel.StrValue = "";
            kAlert.arrLabeledText.AddItem(txtLabel);

            kTag.StrValue0 = kCountry.GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelExaltRaidContinentFailDesc);
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = "";
            kAlert.arrText.AddItem(txtTemp);

            kTag.StrValue0 = string(kGeoAlert.kData.Data[1].I);
            kTag.StrValue1 = kContinent.GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelExaltRaidContinentFailPanic);
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 'AirBaseDefenseFailed':
            kContinent = `LWCE_XGCONTINENT(kGeoAlert.kData.Data[0].Nm);

            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kAlert.imgAlert.iImage = kContinent.GetRandomCouncilCountry(); // TODO

            txtLabel.strLabel = "";
            txtLabel.StrValue = "";
            kAlert.arrLabeledText.AddItem(txtLabel);

            kTag.StrValue0 = kContinent.GetName();
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

function UpdateMissions()
{
    local LWCE_XGShip kShip;
    local LWCE_XGStrategyAI kAI;
    local XGMission kMission;
    local TMCMission kOption;
    local bool bAbductionAdded;
    local int iMission, iShip;

    kAI = LWCE_XGStrategyAI(AI());

    m_arrMenuUFOs.Remove(0, m_arrMenuUFOs.Length);
    m_arrMenuMissions.Remove(0, m_arrMenuMissions.Length);
    m_kMenu.arrMissions.Remove(0, m_kMenu.arrMissions.Length);
    m_kMenu.iHighlight = 0;

    PRES().bShouldUpdateSituationRoomMenu = true;

    if (!CanActivateMission())
    {
        return;
    }

    for (iShip = 0; iShip < kAI.m_arrCEShips.Length; iShip++)
    {
        kShip = kAI.m_arrCEShips[iShip];

        if (!kShip.IsDetected())
        {
            continue;
        }

        // Landed UFOs will have a mission spawned already, so they'll get covered later
        if (kShip.m_bLanded)
        {
            continue;
        }

        kOption.imgOption.iImage = eImage_OldAssault;
        kOption.txtOption.StrValue = m_strLabelUFOPrefix $ kShip.m_iCounter;
        kOption.txtOption.iState = eUIState_Warning;
        kOption.clrOption = MakeColor(200, 0, 0, 175);
        kOption.txtOption.iButton = 0;

        m_arrMenuUFOs.AddItem(iShip);
        m_arrMenuMissions.AddItem(-1); // makes sure that m_arrMenuMissions is always at least the length of m_arrMenuUFOs, for OnMissionInput later
        m_kMenu.arrMissions.AddItem(kOption);
    }

    for (iMission = 0; iMission < GEOSCAPE().m_arrMissions.Length; iMission++)
    {
        kMission = GEOSCAPE().m_arrMissions[iMission];

        if (!kMission.IsDetected())
        {
            continue;
        }

        if (kMission.m_iMissionType == eMission_Abduction && bAbductionAdded)
        {
            continue;
        }
        else if (kMission.m_iMissionType == eMission_Abduction)
        {
            bAbductionAdded = true;
        }

        switch (kMission.m_iMissionType)
        {
            case 2:
                kOption.imgOption.iImage = eImage_OldUFO;
                break;
            case 13:
            case 5:
                kOption.imgOption.iImage = eImage_OldFunding;
                break;
            case 6:
                kOption.imgOption.iImage = eImage_OldFunding;
                break;
            case 9:
                kOption.imgOption.iImage = eImage_OldTerror;
                break;
            case 3:
                kOption.imgOption.iImage = eImage_MCUFOCrash;
                break;
            case 4:
                kOption.imgOption.iImage = eImage_OldAssault;
                break;
            case 8:
                kOption.imgOption.iImage = eImage_AlienBase;
                break;
            case 10:
                kOption.imgOption.iImage = eImage_Temple;
                break;
            case 11:
                kOption.imgOption.iImage = eImage_OldFunding;
                break;
        }

        if (kMission.m_iMissionType == eMission_Abduction)
        {
            kOption.txtOption.StrValue = m_strLabelAlienAbductions;
        }
        else
        {
            kOption.txtOption.StrValue = kMission.GetTitle();
        }

        if (kMission.m_iDuration >= 0)
        {
            kOption.txtOption.StrValue @= "<p align=\"right\"><img src=\"img:///LongWar.Icons.queueClock\" height=\"20\" width=\"20\" vspace=\"-10\">" $ (kMission.m_iDuration / 2) $ m_strLabelHours;
        }

        kOption.txtOption.iState = eUIState_Warning;
        kOption.clrOption = MakeColor(200, 0, 0, 175);
        kOption.txtOption.iButton = 0;
        m_arrMenuMissions.AddItem(iMission);
        m_kMenu.arrMissions.AddItem(kOption);
    }

    if (GetNumMissionOptions() > 0)
    {
        m_kMenu.txtMissionsLabel.StrValue = m_strAvailableMissions;
    }
    else
    {
        m_kMenu.txtMissionsLabel.StrValue = "";
    }

    m_kMenu.txtMissionsLabel.iState = eUIState_Warning;
}

function UpdateRequest()
{
    // No point was found where this ends up getting called, so it is simply removed
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(UpdateRequest);
}

function UpdateView()
{
    local LWCE_XGShip kShip;
    local XGMission kMission;
    local LWCE_XGBase kBase;
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
    else if (m_iCurrentView == eMCView_Alert)
    {
        kGeoAlert = kGeoscape.LWCE_GetTopAlert();

        if (m_kCECurrentAlert.AlertType == 'UFOCrash')
        {
            kMission = XGMission_UFOCrash(kGeoscape.GetMission(kGeoAlert.kData.Data[0].I));

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
        else if (m_kCECurrentAlert.AlertType == 'EnemyShipDetected')
        {
            Narrative(`XComNarrativeMoment("RoboHQ_UFODetected"));
            kShip = LWCE_XGStrategyAI(AI()).LWCE_GetShip(kGeoAlert.kData.Data[0].I);

            if (kShip.m_kObjective.LWCE_GetType() == 'Hunt')
            {
                Narrative(`XComNarrativeMoment("MCSatelliteHunterDetected"));
                return;
            }

            switch (kShip.m_nmShipTemplate)
            {
                case 'UFODestroyer':
                    Narrative(`XComNarrativeMoment("MCLargeScout"));
                    break;
                case 'UFOAbductor':
                    Narrative(`XComNarrativeMoment("MCAbductor"));
                    break;
                case 'UFOTransport':
                    Narrative(`XComNarrativeMoment("MCSupply"));
                    break;
                case 'UFOBattleship':
                    Narrative(`XComNarrativeMoment("MCBattleship"));
                    break;
                case 'UFOOverseer':
                    if (!HQ().m_kMC.m_bDetectedOverseer)
                    {
                        kBase = LWCE_XGBase(HQ().m_kBase);
                        PRES().UINarrative(`XComNarrativeMoment("MCOverseer"), none, PostOverseerMatinee,, kBase.LWCE_GetFacility3DLocation('Facility_HyperwaveRelay'));
                        Narrative(`XComNarrativeMoment("HyperwaveBeaconActivated_LeadOut_CE"));
                        Narrative(`XComNarrativeMoment("HyperwaveBeaconActivated_LeadOut_CS"));
                        HQ().m_kMC.m_bDetectedOverseer = true;
                    }

                    break;
                default:
                    break;
            }
        }
        else if (m_kCECurrentAlert.AlertType == 'PsiTraining')
        {
            if (PSILABS().m_bSubjectZeroCinematic)
            {
                PRES().UINarrative(`XComNarrativeMoment("PsiLabsGift"));
            }
        }
        else if (m_kCECurrentAlert.AlertType == 'AlienBase')
        {
            if (LWCE_XGStorage(STORAGE()).LWCE_GetNumItemsAvailable('Item_SkeletonKey') == 0 && !LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_IsBuildingItem('Item_SkeletonKey'))
            {
                Narrative(`XComNarrativeMoment("BuildBasePassKeyReminder"));
            }
        }
        else if (m_kCECurrentAlert.AlertType == 'ItemProjectCompleted')
        {
            if (kGeoAlert.kData.Data[0].I == eItem_Satellite)
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

    ChooseMusic();
}

function int LWCE_SortEvents(LWCE_THQEvent e1, LWCE_THQEvent e2)
{
    return e1.iHours < e2.iHours ? 0 : -1;
}