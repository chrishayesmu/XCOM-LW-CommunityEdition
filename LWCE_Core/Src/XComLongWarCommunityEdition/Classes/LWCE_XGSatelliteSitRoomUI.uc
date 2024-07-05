class LWCE_XGSatelliteSitRoomUI extends XGSatelliteSitRoomUI
    implements(LWCE_IFCRequestInterface)
    dependson(LWCE_XGFundingCouncil);

var name m_nmCountry;
var name m_nmContinent;

function string BuildBonusString(int iNumSatellites, XGContinent kContinent)
{
    `LWCE_LOG_DEPRECATED_CLS(BuildBonusString);

    return "DEPRECATED";
}

function string LWCE_BuildBonusString(LWCE_XGCountry kCountry)
{
    local string strBonus;
    local int iScientists, iEngineers;

    iScientists = kCountry.m_kTemplate.iScientistsPerMonth;
    iEngineers = kCountry.m_kTemplate.iEngineersPerMonth;

    if (iScientists > 0)
    {
        strBonus $= "+" $ iScientists @ (iScientists > 1 ? m_strLabelScientists : m_strLabelScientist);
    }

    if (iEngineers > 0)
    {
        if (strBonus != "")
        {
            strBonus $= ", ";
        }

        strBonus $= "+" $ iEngineers @ (iEngineers > 1 ? m_strLabelEngineers : m_strLabelEngineer);
    }

    strBonus @= m_strLabelPerMonth;

    return strBonus;
}

simulated function GetRequestData(out TFCRequest kRequestRef)
{
    // This doesn't seem to ever have real data populated, so we don't bother with it
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetRequestData);
}

simulated function LWCE_GetRequestData(out LWCE_TFCRequest kRequestRef)
{
    // This is added just to meet the interface requirements and avoid log errors
}

function bool HasUplinkCapacity()
{
    return LWCE_XGHeadquarters(HQ()).m_arrCESatellites.Length < HQ().GetSatelliteLimit();
}

function OnConfirmLaunch()
{
    local bool bAlreadyHadBonus;

    if (!HasUplinkCapacity())
    {
        PlayBadSound();
        GoToView(eSatelliteView_Main);
    }
    else
    {
        Sound().PlaySFX(SNDLIB().SFX_UI_SatelliteLaunch);
        m_bLaunched = true;
        bAlreadyHadBonus = `LWCE_XGCONTINENT(m_nmContinent).HasBonus();
        LWCE_XGHeadquarters(HQ()).LWCE_AddSatelliteNode(m_nmCountry, 'Item_Satellite');
        CheckUplinkCapacity();

        if (ShowBonus() && !bAlreadyHadBonus)
        {
            GoToView(eSatelliteView_Bonus);
        }
        else if (ShowAlert())
        {
            GoToView(eSatelliteView_Alert);
        }
        else
        {
            GoToView(eSatelliteView_Main);
        }
    }
}

function SetTargetCountry(int targetCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(SetTargetCountry);
}

function LWCE_SetTargetCountry(name nmTargetCountry)
{
    m_nmCountry = nmTargetCountry;
    m_nmContinent = `LWCE_XGCOUNTRY(m_nmCountry).LWCE_GetContinent();

    UpdateCountryHelp();
    UpdateView();
}

/// <summary>
/// Whether to show an alert that a just-launched satellite has no ships to protect it.
/// </summary>
function bool ShowAlert()
{
    local LWCE_XGFacility_Hangar kHangar;
    local LWCE_XGHeadquarters kHQ;
    local name nmCountry;
    local int iSatellite;

    if (`HQPRES.IsInState('State_FundingCouncilRequest'))
    {
        return false;
    }

    kHQ = LWCE_XGHeadquarters(HQ());
    kHangar = LWCE_XGFacility_Hangar(HANGAR());

    iSatellite = kHQ.m_arrCESatellites.Length - 1;
    nmCountry = kHQ.m_arrCESatellites[iSatellite].nmCountry;

    return kHangar.LWCE_GetNumShips(`LWCE_XGCOUNTRY(nmCountry).LWCE_GetContinent()) == 0;
}

/// <summary>
/// Whether the continent bonus for the selected continent should be shown as achieved.
/// </summary>
function bool ShowBonus()
{
    return `LWCE_XGCONTINENT(m_nmContinent).HasBonus();
}

/// <summary>
/// Populates the alert dialog warning that a just-launched satellite has no ships to protect it.
/// </summary>
function UpdateAlert()
{
    local name nmCountry;
    local int iSatellite;
    local TMenuOption txtOption;
    local TSatAlert kAlert;
    local LWCE_XGContinent kContinent;
    local LWCE_XGHeadquarters kHQ;
    local XGParamTag kTag;

    kHQ = LWCE_XGHeadquarters(HQ());
    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

    iSatellite = kHQ.m_arrCESatellites.Length - 1;
    nmCountry = kHQ.m_arrCESatellites[iSatellite].nmCountry;
    kContinent = `LWCE_XGCONTINENT(`LWCE_XGCOUNTRY(nmCountry).LWCE_GetContinent());

    kTag.StrValue0 = kContinent.GetName();
    kAlert.txtTitle.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelNoInterceptorsInRegion);
    kAlert.txtTitle.iState = eUIState_Bad;
    kAlert.txtBody.StrValue = m_strLabelNoInterceptorsInRange;
    kAlert.txtBody.iState = eUIState_Warning;

    txtOption.strText = m_strLabelOk;
    kAlert.mnuOptions.arrOptions.AddItem(txtOption);

    m_kAlert = kAlert;
}

function UpdateBonus()
{
    local TSatBonusUI kUI;
    local LWCE_XGContinent kContinent;
    local LWCEBonusTemplate kBonusTemplate;
    local LWCEBonusTag kBonusTag;
    local XGParamTag kParamTag;
    local int iBonusLevel;
    local name nmBonus;

    kContinent = `LWCE_XGCONTINENT(m_nmContinent);
    nmBonus = kContinent.LWCE_GetBonus();
    kBonusTemplate = `LWCE_BONUS(nmBonus);

    iBonusLevel = `LWCE_HQ.GetBonusLevel(nmBonus);

    if (iBonusLevel == 0)
    {
        iBonusLevel = class'LWCE_XGHeadquarters'.const.CONTINENT_SATELLITE_BONUS_LEVEL_AMOUNT;
    }

    kBonusTag = `LWCE_ENGINE.m_kCEBonusTag;
    kBonusTag.BonusLevel = iBonusLevel;

    kParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
    kParamTag.StrValue0 = kContinent.GetName();

    kUI.txtTitle.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelBonusInRegion);
    kUI.txtTitle.iState = eUIState_Warning;

    kUI.txtBonusName.StrValue = kBonusTemplate.strName;
    kUI.txtBonusName.iState = eUIState_Highlight;

    kUI.txtBonusDesc.StrValue = `LWCE_XEXPAND(kBonusTemplate.GetDescription());
    kUI.txtBonusDesc.iState = eUIState_Warning;

    kUI.btxtOk.iButton = 1;
    kUI.btxtOk.StrValue = m_strLabelOk;

    m_kBonusUI = kUI;
}

function UpdateConfirmUI()
{
    local TSatConfirm kUI;
    local LWCE_XGContinent kContinent;
    local LWCE_XGCountry kCountry;
    local XGParamTag kTag;
    local int iFunding;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kCountry = `LWCE_XGCOUNTRY(m_nmCountry);
    kContinent = `LWCE_XGCONTINENT(m_nmContinent);

    if (kCountry.LeftXCom())
    {
        kUI.txtSpecialists.strLabel = m_strLabelLeftXCom;
    }
    else
    {
        kUI.txtSpecialists.strLabel = m_strLabelReward;
        kUI.txtSpecialists.StrValue = LWCE_BuildBonusString(kCountry);
        iFunding = kCountry.LWCE_CalcFunding(/* bPretendHasSatellite */ true) - kCountry.LWCE_CalcFunding();
    }

    kUI.txtTitle.StrValue = m_strLabelConfirmLaunch;
    kUI.txtTitle.iState = eUIState_Warning;

    kUI.txtCountryLabel.StrValue = m_strLabelCountry;
    kUI.txtCountryLabel.iState = eUIState_Highlight;

    kUI.txtTravelTimeLabel.StrValue = m_strLabelTravelTime;
    kUI.txtTravelTimeLabel.iState = eUIState_Highlight;

    kUI.txtFundingLabel.StrValue = m_strLabelFundingIncrease;
    kUI.txtFundingLabel.iState = eUIState_Highlight;

    kUI.txtCountry.StrValue = kCountry.GetName();
    kUI.txtCountry.iState = eUIState_Highlight;

    kUI.txtTravelTime.StrValue = LWCE_XGGeoscape(GEOSCAPE()).LWCE_GetSatTravelTime(m_nmCountry) @ m_strLabelDays;
    kUI.txtTravelTime.iState = eUIState_Highlight;

    kUI.txtFunding.StrValue = ConvertCashToString(iFunding) @ m_strLabelPerMonth;
    kUI.txtFunding.iState = eUIState_Cash;

    kTag.IntValue0 = kContinent.GetNumSatellites() + 1;
    kTag.IntValue1 = kContinent.GetNumSatNodes();
    kTag.StrValue0 = kContinent.GetName();
    kUI.txtContinentCollection.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelMonitoring);

    kUI.btxtLaunch.iButton = 1;
    kUI.btxtLaunch.StrValue = m_strLabelLaunchSatelliteLower;

    kUI.btxtCancel.iButton = 4;
    kUI.btxtCancel.StrValue = m_strLabelCancelSatelliteLower;

    m_kConfirm = kUI;
}

/// <summary>
/// When a country is selected, its staff-per-month, continent bonus, and country bonus are displayed in the
/// bottom center of the screen. That is the data being updated by this function.
/// </summary>
function UpdateContinent()
{
    local TSatContinentUI kUI;
    local LWCEBonusTag kBonusTag;
    local LWCEBonusTemplate kBonusTemplate;
    local LWCEBonusTemplateManager kBonusTemplateMgr;
    local LWCE_XGContinent kContinent;
    local LWCE_XGCountry kCountry;
    local LWCE_XGHeadquarters kHQ;

    kUI.iHighlightedBonus = -1;

    if (m_nmCountry == '' || m_nmContinent == '')
    {
        m_kContinentUI = kUI;
        return;
    }

    kBonusTag = `LWCE_ENGINE.m_kCEBonusTag;
    kBonusTemplateMgr = `LWCE_BONUS_TEMPLATE_MGR;
    kContinent = `LWCE_XGCONTINENT(m_nmContinent);
    kCountry = `LWCE_XGCOUNTRY(m_nmCountry);
    kHQ = `LWCE_HQ;

    kUI.txtContinent.StrValue = kContinent.GetName();
    kUI.txtContinent.iState = eUIState_Highlight;

    // Start by displaying engineer/scientist bonuses from the highlighted country
    kUI.arrBonusLabels.AddItem(FormatBonusLabel(m_strLabelBonus, kCountry.HasSatelliteCoverage(), /* bForceNoFormatting */ true)); // m_strLabelBonus already has formatting in it
    kUI.arrBonuses.AddItem(FormatBonusValue(LWCE_BuildBonusString(kCountry), kCountry.HasSatelliteCoverage()));

    // The first bonus is the continent
    kBonusTemplate = kBonusTemplateMgr.FindBonusTemplate(kContinent.LWCE_GetBonus());
    kBonusTag.BonusLevel = kContinent.HasBonus() ? kHQ.GetBonusLevel(kContinent.m_nmBonus) : class'LWCE_XGHeadquarters'.const.CONTINENT_SATELLITE_BONUS_LEVEL_AMOUNT;

    kUI.arrBonusLabels.AddItem(FormatBonusLabel(kBonusTemplate.strName, kContinent.HasBonus()));
    kUI.arrBonuses.AddItem(FormatBonusValue(`LWCE_XEXPAND(kBonusTemplate.GetDescription()), kContinent.HasBonus()));

    // Second bonus is the selected country's
    kBonusTemplate = kBonusTemplateMgr.FindBonusTemplate(kCountry.m_nmBonus);
    kBonusTag.BonusLevel = kCountry.IsGrantingBonus() ? kHQ.GetBonusLevel(kCountry.m_nmBonus) : class'LWCE_XGHeadquarters'.const.COUNTRY_SATELLITE_BONUS_LEVEL_AMOUNT;

    kUI.arrBonusLabels.AddItem(FormatBonusLabel(kBonusTemplate.strName, kCountry.IsGrantingBonus()));
    kUI.arrBonuses.AddItem(FormatBonusValue(`LWCE_XEXPAND(kBonusTemplate.GetDescription()), kCountry.IsGrantingBonus()));

    m_kContinentUI = kUI;
}

function UpdateCountry()
{
    local TSatCountryUI kUI;
    local LWCE_XGCountry kCountry;
    local int iFunding;

    if (m_nmCountry != '')
    {
        kCountry = `LWCE_XGCOUNTRY(m_nmCountry);
        kUI.txtCountry.StrValue = kCountry.GetName();
        kUI.iPanicLevel = kCountry.GetPanicBlocks();
        kUI.bHasSatCoverage = kCountry.HasSatelliteCoverage();

        if (kCountry.LeftXCom())
        {
            kUI.txtCountry.iState = eUIState_Good;
        }
        else
        {
            kUI.txtCountry.iState = eUIState_Cash;
        }

        if (kUI.bHasSatCoverage)
        {
            kUI.txtCountry.iState -= 1;
        }

        if (m_kCursorUI.bEnabled)
        {
            kUI.txtFunding.iState = eUIState_Cash;
        }
        else if (kCountry.LeftXCom())
        {
            kUI.txtFunding.iState = eUIState_Disabled;
        }
        else
        {
            kUI.txtFunding.iState = eUIState_Highlight;
        }

        iFunding = kCountry.LWCE_CalcFunding();
        kUI.txtFunding.StrValue = ConvertCashToString(iFunding) @ m_strLabelPerMonth;
    }

    m_kCountryUI = kUI;
}

function UpdateCountryHelp()
{
    local TSatCursorUI kUI;

    kUI.txtHelp.StrValue = "";
    kUI.txtHelp.iState = eUIState_Bad;

    if (m_nmCountry == '')
    {
        kUI.bEnabled = false;
    }
    else
    {
        if (`LWCE_XGCOUNTRY(m_nmCountry).HasSatelliteCoverage())
        {
            kUI.bEnabled = false;
            kUI.txtHelp.StrValue = m_strLabelHasSatellite;
            kUI.txtHelp.iState = eUIState_Disabled;
        }
        else if (!HasUplinkCapacity())
        {
            kUI.bEnabled = false;
            kUI.txtHelp.StrValue = m_strLabelNoCapacity;
            kUI.txtHelp.iState = eUIState_Bad;
        }
        else if (LWCE_XGStorage(STORAGE()).LWCE_GetNumItemsAvailable('Item_Satellite') == 0)
        {
            kUI.bEnabled = false;
            kUI.txtHelp.StrValue = m_strLabelNoSatellites;
            kUI.txtHelp.iState = eUIState_Bad;
        }
        else
        {
            kUI.bEnabled = true;
            kUI.txtHelp.iButton = 1;
            kUI.txtHelp.StrValue = m_strLabelLaunchSatellite;
            kUI.txtHelp.iState = eUIState_Good;
        }
    }

    m_kCursorUI = kUI;
}

function UpdateHelp()
{
    local LWCEBonusTag kBonusTag;
    local LWCEBonusTemplate kBonusTemplate;
    local LWCEBonusTemplateManager kBonusTemplateMgr;
    local LWCE_XGHeadquarters kHQ;
    local array<LWCE_TBonus> arrBonuses;
    local XGParamTag kParamTag;
    local int Index;

    kBonusTag = `LWCE_ENGINE.m_kCEBonusTag;
    kBonusTemplateMgr = `LWCE_BONUS_TEMPLATE_MGR;
    kHQ = LWCE_XGHeadquarters(HQ());
    arrBonuses = kHQ.GetActiveBonuses();

    kParamTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kParamTag.IntValue0 = 0;

    m_kHelp.txtBody.StrValue = "";

    for (Index = 0; Index < arrBonuses.Length; Index++)
    {
        kBonusTemplate = kBonusTemplateMgr.FindBonusTemplate(arrBonuses[Index].BonusName);
        kBonusTag.BonusLevel = kHQ.GetBonusLevel(arrBonuses[Index].BonusName);

        m_kHelp.txtBody.StrValue $= class'UIUtilities'.static.GetHTMLColoredText(kBonusTemplate.strName, eUIState_Warning, 18) $ ": ";
        m_kHelp.txtBody.StrValue $= class'UIUtilities'.static.GetHTMLColoredText(class'XComLocalizer'.static.ExpandString(kBonusTemplate.GetDescription()), eUIState_Highlight, 18);
        m_kHelp.txtBody.StrValue $= "\n";
    }

    m_kHelp.txtTitle.StrValue = m_strLabelSatelliteTitle;
    m_kHelp.txtBody.StrValue $= "\n";
    m_kHelp.txtBody.StrValue $= m_strLabelSatelliteBody;
    m_kHelp.btxtOk.iButton = 1;
    m_kHelp.btxtOk.StrValue = m_strLabelContinue;
}

function UpdateMain()
{
    local string strSatellite;
    local int iSatellite;
    local TMenu mnuSatellites;
    local TMenuOption txtOption;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGStorage kStorage;

    kHQ = LWCE_XGHeadquarters(HQ());
    kStorage = LWCE_XGStorage(STORAGE());

    m_kUI.Current = kHQ.m_arrCESatellites.Length;
    m_kUI.Max = kHQ.GetSatelliteLimit();
    m_kUI.ltxtCapacity.strLabel = m_strLabelUplinkCapacity;
    m_kUI.ltxtCapacity.StrValue = kHQ.m_arrCESatellites.Length $ "/" $ kHQ.GetSatelliteLimit();

    if (!HasUplinkCapacity())
    {
        m_kUI.ltxtCapacity.iState = eUIState_Bad;
    }
    else
    {
        m_kUI.ltxtCapacity.iState = eUIState_Good;
    }

    if (kStorage.LWCE_GetNumItemsAvailable('Item_Satellite') == 0)
    {
        mnuSatellites.strLabel = m_strLabelNoSatellitesToLaunch;
    }
    else
    {
        strSatellite = `LWCE_ITEM('Item_Satellite').strName;

        for (iSatellite = 0; iSatellite < kStorage.LWCE_GetNumItemsAvailable('Item_Satellite'); iSatellite++)
        {
            txtOption.strText = strSatellite $ "-" $ iSatellite;
            mnuSatellites.arrOptions.AddItem(txtOption);
        }
    }

    m_kUI.mnuSatellites = mnuSatellites;
}

protected function TText FormatBonusLabel(string strBonusName, bool bHasBonus, optional bool bForceNoFormatting = false)
{
    local TText txt;

    txt.StrValue = strBonusName $ (bForceNoFormatting ? "" : ": ");
    txt.iState = bHasBonus ? eUIState_Warning : eUIState_Disabled;

    return txt;
}

protected function TText FormatBonusValue(string strBonusValue, bool bHasBonus)
{
    local TText txt;

    txt.StrValue = strBonusValue;
    txt.iState = bHasBonus ? eUIState_Highlight : eUIState_Disabled;

    return txt;
}