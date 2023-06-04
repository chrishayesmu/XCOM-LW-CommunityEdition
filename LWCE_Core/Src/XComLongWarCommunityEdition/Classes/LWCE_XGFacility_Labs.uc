class LWCE_XGFacility_Labs extends XGFacility_Labs
    dependson(LWCETypes);

struct LWCE_TResearchProgress
{
    var name TechName;
    var int iHoursCompleted; // Scientist-hours of this research that have been completed
    var int iHoursSpent; // Number of clock hours the research has been worked on
    var XGDateTime kCompletionTime;
};

struct LWCE_TResearchProject
{
    var name TechName;
    var int iProgress;
    var int iActualHoursLeft;
    var int iEstimate;
    var string strETA;
};

struct CheckpointRecord_LWCE_XGFacility_Labs extends CheckpointRecord_XGFacility_Labs
{
    var LWCE_TResearchProject m_kCEProject;
    var array<name> m_arrCEResearched;
    var name m_nmLastResearchedTech;
    var array<LWCE_TResearchProgress> m_arrCEProgress;
    var array<name> m_arrEarnedResearchCredits;
    var array<LWCE_TTechState> m_arrCEMissionResults;
    var array<name> m_arrCEUnlockedFacilities;
    var array<name> m_arrCEUnlockedFoundryProjects;
    var array<int> m_arrCEUnlockedItems;
};

var LWCE_TResearchProject m_kCEProject;
var array<name> m_arrCEResearched;
var name m_nmLastResearchedTech;
var array<LWCE_TResearchProgress> m_arrCEProgress;
var array<name> m_arrEarnedResearchCredits;

var array<LWCE_TTechState> m_arrCEMissionResults;
var array<name> m_arrCEUnlockedFacilities;
var array<name> m_arrCEUnlockedFoundryProjects;
var array<name> m_arrCEUnlockedItems;

var private LWCETechTemplateManager m_kTechTemplateMgr;

function Init(bool bLoadingFromSave)
{
    m_kTechTemplateMgr = `LWCE_TECH_TEMPLATE_MGR;

    m_kTree = Spawn(class'LWCE_XGTechTree');
    m_kTree.Init();

    BaseInit();
    UpdateLabBonus();

    if (m_arrCredits.Length == 0)
    {
        m_arrCredits.Add(10);
    }

    if (m_arrMusingTracker.Length == 0)
    {
        m_arrMusingTracker.Add(8);
    }
}

function InitNewGame()
{
    m_iNumScientists = class'XGTacticalGameCore'.default.NUM_STARTING_SCIENTISTS;
    m_bRequiresAttention = true;
    m_bFirstTechSelected = true;
    m_iTechConfirms = 3;
    m_iExplosiveNags = 1;

    if (Game().m_kNarrative != none && Game().m_kNarrative.SilenceNewbieMoments())
    {
        m_iExplosiveNags = 0;
        m_bGreyWarning = true;
    }
}

function Update()
{
    local int iHoursCompleted;
    local int iProgressIndex;

    if (m_iRequestCounter > 0)
    {
        m_iRequestCounter -= 1;
    }

    if (HasProject())
    {
        iProgressIndex = m_arrCEProgress.Find('TechName', m_kCEProject.TechName);
        iHoursCompleted = GetResearchPerHour();
        m_kCEProject.iActualHoursLeft -= iHoursCompleted;
        m_arrCEProgress[iProgressIndex].iHoursCompleted += iHoursCompleted;
        m_arrCEProgress[iProgressIndex].iHoursSpent += 1;

        if (m_kCEProject.iActualHoursLeft <= 0)
        {
            if (GEOSCAPE().IsBusy())
            {
                return;
            }

            OnResearchCompleted();
        }
        else
        {
            UpdateProgress();
        }
    }
}

function AddResearchCredit(EResearchCredits eCredit)
{
    `LWCE_LOG_DEPRECATED_CLS(AddResearchCredit);
}

function LWCE_AddResearchCredit(name CreditName)
{
    local int Index;
    local TResearchCredit kCredit;
    local LWCE_XGTechTree kTechTree;
    local LWCE_XGFacility_Engineering kEngineering;

    if (m_arrEarnedResearchCredits.Find(CreditName) != INDEX_NONE)
    {
        return;
    }

    kTechTree = LWCE_XGTechTree(TECHTREE());
    kCredit = kTechTree.LWCE_GetResearchCredit(CreditName);
    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());

    m_arrEarnedResearchCredits.AddItem(CreditName);

    // Iterate any current Foundry projects and adjust their remaining time if they benefit
    for (Index = 0; Index < kEngineering.m_arrCEFoundryProjects.Length; Index++)
    {
        if (kTechTree.LWCE_CreditAppliesToFoundryTech(CreditName, kEngineering.m_arrCEFoundryProjects[Index].ProjectName))
        {
            kEngineering.m_arrCEFoundryProjects[Index].iHoursLeft *= kCredit.iBonus / 100.0;
        }
    }
}

function AddScientists(int iNumScientists)
{
    m_iNumScientists += iNumScientists;
    m_bGivenScientists = true;

    STAT_AddStat(eRecap_ScientistsCollected, iNumScientists);

    if (m_iNumScientists >= 80)
    {
        Achieve(AT_Oppenheimer);
    }

    if (HasProject())
    {
        UpdateProgress();
    }
}

function bool CanAffordTech(int iTech)
{
    `LWCE_LOG_DEPRECATED_CLS(CanAffordTech);

    return false;
}

function bool LWCE_CanAffordTech(name TechName)
{
    local LWCE_TCost kCost;
    local LWCETechTemplate kTech;
    local LWCE_XGStorage kStorage;
    local int iItem;

    kStorage = LWCE_XGStorage(STORAGE());
    kTech = `LWCE_TECH(TechName);
    kCost = kTech.GetCost();

    if (kCost.iCash > 0 && kCost.iCash > GetResource(eResource_Money))
    {
        return false;
    }

    if (kCost.iAlloys > 0 && kCost.iAlloys > GetResource(eResource_Alloys))
    {
        return false;
    }

    if (kCost.iElerium > 0 && kCost.iElerium > GetResource(eResource_Elerium))
    {
        return false;
    }

    if (kCost.iMeld > 0 && kCost.iMeld > GetResource(eResource_Meld))
    {
        return false;
    }

    if (kCost.iWeaponFragments > 0 && kCost.iWeaponFragments > kStorage.LWCE_GetNumItemsAvailable('Item_WeaponFragment'))
    {
        return false;
    }

    if (kCost.arrItems.Length > 0)
    {
        for (iItem = 0; iItem < kCost.arrItems.Length; iItem++)
        {
            if (kCost.arrItems[iItem].iQuantity > kStorage.LWCE_GetNumItemsAvailable(kCost.arrItems[iItem].ItemName))
            {
                return false;
            }
        }
    }

    return true;
}

// "Edison" achievement: In a single game, complete every Research Project.
function bool CheckForEdison()
{
    local array<name> arrTechNames;

    arrTechNames = m_kTechTemplateMgr.GetTemplateNames();

    return arrTechNames.Length == m_arrCEResearched.Length;
}

// "All Employees Must Wash Hands..." achievement: In a single game, complete every Autopsy.
function bool CheckForAllEmployees()
{
    local array<LWCETechTemplate> arrTemplates;
    local LWCETechTemplate kTech;

    arrTemplates = m_kTechTemplateMgr.GetAllTechTemplates();

    foreach arrTemplates(kTech)
    {
        if (kTech.bIsAutopsy && !LWCE_IsResearched(kTech.GetTechName()))
        {
            return false;
        }
    }

    return true;
}

function CompilePostMissionReport(array<int> arrPreLandTechs, array<int> arrPostLandTechs)
{
    `LWCE_LOG_DEPRECATED_CLS(CompilePostMissionReport);
}

function LWCE_CompilePostMissionReport(array<LWCE_TTechState> arrPreLandTechs, array<LWCE_TTechState> arrPostLandTechs)
{
    local int Index;
    local LWCE_TTechState kTechState;

    `assert(arrPreLandTechs.Length == arrPostLandTechs.Length);

    for (Index = 0; Index < arrPreLandTechs.Length; Index++)
    {
        // Techs should always be iterated in the same order
        `assert(arrPreLandTechs[Index].TechName == arrPostLandTechs[Index].TechName);
        kTechState.TechName = arrPreLandTechs[Index].TechName;
        kTechState.eAvailabilityState = eTechState_Unavailable;

        if (arrPreLandTechs[Index].eAvailabilityState != arrPostLandTechs[Index].eAvailabilityState)
        {
            if (arrPreLandTechs[Index].eAvailabilityState == eTechState_Unavailable)
            {
                // We always care about a state change away from unavailable
                kTechState.eAvailabilityState = eTechState_Available;

                // Make sure we can do interrogations if relevant (captives may not be converted to corpses at this point)
                if (LWCE_IsInterrogationTech(kTechState.TechName) && !LWCE_XGHeadquarters(HQ()).LWCE_HasFacility('Facility_AlienContainment'))
                {
                    kTechState.eAvailabilityState = eTechState_Unavailable;
                }
            }
            else if (arrPostLandTechs[Index].eAvailabilityState == eTechState_Affordable)
            {
                // Otherwise we only care about a state change from available to affordable
                kTechState.eAvailabilityState = eTechState_Affordable;
            }
        }

        if (kTechState.eAvailabilityState != eTechState_Unavailable)
        {
            m_arrCEMissionResults.AddItem(kTechState);
        }
    }
}

function Enter(int iView)
{
    // We don't have any real changes to this function, but there's an empty if block that uses
    // GetCurrentTech in the base function, so we just override it without that
    super(XGFacility).Enter(iView);

    if (m_bRequiresAttention)
    {
        CheckForAlerts();
        m_bRequiresAttention = false;
    }

    if (m_bFirstVisit)
    {
        m_bFirstVisit = false;
    }
}

function GetAvailableTechs(out array<TTech> arrTechs)
{
    `LWCE_LOG_DEPRECATED_CLS(GetAvailableTechs);
}

function LWCE_GetAvailableTechs(out array<LWCETechTemplate> arrTechs)
{
    local array<LWCETechTemplate> arrTemplates;
    local LWCETechTemplate kTech;

    arrTemplates = m_kTechTemplateMgr.GetAllTechTemplates();

    arrTechs.Remove(0, arrTechs.Length);

    foreach arrTemplates(kTech)
    {
        if (m_kCEProject.TechName != kTech.GetTechName() && LWCE_IsTechAvailable(kTech.GetTechName()))
        {
            if (LWCE_IsPriorityTech(kTech.GetTechName()))
            {
                arrTechs.InsertItem(0, kTech);
            }
            else
            {
                arrTechs.AddItem(kTech);
            }
        }
    }
}

function bool GetCostSummary(out TCostSummary kCostSummary, out TResearchCost kCost)
{
    `LWCE_LOG_DEPRECATED_CLS(GetCostSummary);

    return false;
}

function bool LWCE_GetCostSummary(out TCostSummary kCostSummary, out LWCE_TProjectCost kProjectCost)
{
    local TText txtCost;
    local bool bCanAfford;
    local int iItem;
    local LWCEItemTemplate kItem;
    local LWCE_XGStorage kStorage;
    local XGParamTag kTag;

    kStorage = LWCE_XGStorage(STORAGE());
    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    bCanAfford = true;

    // TODO: reduce repetitiveness in this function
    if (kProjectCost.kCost.iCash > 0)
    {
        txtCost.StrValue = class'XGScreenMgr'.static.ConvertCashToString(kProjectCost.kCost.iCash);
        txtCost.iState = eUIState_Cash;

        if (kProjectCost.kCost.iCash > GetResource(eResource_Money))
        {
            bCanAfford = false;
            txtCost.iState = eUIState_Bad;
            kCostSummary.strHelp = m_strErrInsufficientFunds;
        }

        kCostSummary.arrRequirements.AddItem(txtCost);
    }

    if (kProjectCost.kCost.iElerium > 0)
    {
        kTag.IntValue0 = kProjectCost.kCost.iElerium;
        kTag.StrValue0 = m_strCostElerium;
        txtCost.StrValue = class'XComLocalizer'.static.ExpandString(m_strCostLabel);
        txtCost.iState = eUIState_Elerium;

        if (kProjectCost.kCost.iElerium > GetResource(eResource_Elerium))
        {
            bCanAfford = false;
            txtCost.iState = eUIState_Bad;
            kCostSummary.strHelp = m_strErrInsufficientElerium;
        }

        kCostSummary.arrRequirements.AddItem(txtCost);
    }

    if (kProjectCost.kCost.iAlloys > 0)
    {
        kTag.IntValue0 = kProjectCost.kCost.iAlloys;
        kTag.StrValue0 = m_strCostAlloys;
        txtCost.StrValue = class'XComLocalizer'.static.ExpandString(m_strCostLabel);
        txtCost.iState = eUIState_Alloys;

        if (kProjectCost.kCost.iAlloys > GetResource(eResource_Alloys))
        {
            bCanAfford = false;
            txtCost.iState = eUIState_Bad;
            kCostSummary.strHelp = m_strErrInsufficientAlloys;
        }

        kCostSummary.arrRequirements.AddItem(txtCost);
    }

    if (kProjectCost.kCost.iMeld > 0)
    {
        kItem = `LWCE_ITEM('Item_Meld');

        if (kProjectCost.kCost.iMeld > 1)
        {
            txtCost.StrValue = kProjectCost.kCost.iMeld $ "x" @ kItem.strNamePlural;
        }
        else
        {
            txtCost.StrValue = kProjectCost.kCost.iMeld $ "x" @ kItem.strName;
        }

        txtCost.iState = eUIState_Meld;

        if (kProjectCost.kCost.iMeld > GetResource(eResource_Meld))
        {
            bCanAfford = false;
            txtCost.iState = eUIState_Bad;

            kTag.IntValue0 = kProjectCost.kCost.iMeld - GetResource(eResource_Meld);
            kTag.StrValue0 = kItem.strName;
            kCostSummary.strHelp = class'XComLocalizer'.static.ExpandString(m_strErrInsufficientResources);
        }

        kCostSummary.arrRequirements.AddItem(txtCost);
    }

    if (kProjectCost.kCost.iWeaponFragments > 0)
    {
        kItem = `LWCE_ITEM('Item_WeaponFragment');

        if (kProjectCost.kCost.iWeaponFragments > 1)
        {
            txtCost.StrValue = kProjectCost.kCost.iWeaponFragments $ "x" @ kItem.strNamePlural;
        }
        else
        {
            txtCost.StrValue = kProjectCost.kCost.iWeaponFragments $ "x" @ kItem.strName;
        }

        txtCost.iState = eUIState_Normal;

        if (kProjectCost.kCost.iWeaponFragments > kStorage.LWCE_GetNumItemsAvailable('Item_WeaponFragment'))
        {
            bCanAfford = false;
            txtCost.iState = eUIState_Bad;

            kTag.IntValue0 = kProjectCost.kCost.iWeaponFragments - kStorage.LWCE_GetNumItemsAvailable('Item_WeaponFragment');
            kTag.StrValue0 = kItem.strName;
            kCostSummary.strHelp = class'XComLocalizer'.static.ExpandString(m_strErrInsufficientResources);
        }

        kCostSummary.arrRequirements.AddItem(txtCost);
    }

    if (kProjectCost.kCost.arrItems.Length > 0)
    {
        for (iItem = 0; iItem < kProjectCost.kCost.arrItems.Length; iItem++)
        {
            kItem = `LWCE_ITEM(kProjectCost.kCost.arrItems[iItem].ItemName);

            if (kProjectCost.kCost.arrItems[iItem].iQuantity > 1)
            {
                txtCost.StrValue = kProjectCost.kCost.arrItems[iItem].iQuantity $ "x" @ kItem.strNamePlural;
            }
            else
            {
                txtCost.StrValue = kProjectCost.kCost.arrItems[iItem].iQuantity $ "x" @ kItem.strName;
            }

            txtCost.iState = eUIState_Normal;

            if (kProjectCost.kCost.arrItems[iItem].iQuantity > kStorage.LWCE_GetNumItemsAvailable(kProjectCost.kCost.arrItems[iItem].ItemName))
            {
                bCanAfford = false;
                txtCost.iState = eUIState_Bad;

                kTag.IntValue0 = kProjectCost.kCost.arrItems[iItem].iQuantity - kStorage.LWCE_GetNumItemsAvailable(kProjectCost.kCost.arrItems[iItem].ItemName);
                kTag.StrValue0 = kItem.strName;
                kCostSummary.strHelp = class'XComLocalizer'.static.ExpandString(m_strErrInsufficientResources);
            }

            if (kProjectCost.kCost.arrItems[iItem].iQuantity > 0)
            {
                kCostSummary.arrRequirements.AddItem(txtCost);
            }
        }
    }

    return bCanAfford;
}

function float GetCurrentResearchProgressPercentage()
{
    local float fPercentage;

    if (HasProject())
    {
        fPercentage = float(GetHoursLeftOnProject()) / float(m_kCEProject.iEstimate * 24);
        return FClamp(1.0 - fPercentage, 0.0, 1.0);
    }
    else
    {
        return 0.0;
    }
}

function TLabeledText GetCurrentProgressText()
{
    local TLabeledText txtProgress;

    txtProgress = GetProgressText(EResearchProgress(m_kCEProject.iProgress));
    txtProgress.StrValue $= " (" $ m_kCEProject.strETA $ ")";
    return txtProgress;
}

function TResearchProject GetCurrentProject()
{
    local TResearchProject kProject;

    `LWCE_LOG_DEPRECATED_CLS(GetCurrentProject);

    return kProject;
}

function LWCE_TResearchProject LWCE_GetCurrentProject()
{
    return m_kCEProject;
}

function TTech GetCurrentTech()
{
    `LWCE_LOG_DEPRECATED_CLS(GetCurrentTech);
    return super.GetCurrentTech();
}

function LWCETechTemplate LWCE_GetCurrentTech()
{
    if (m_kCEProject.TechName == '')
    {
        return none;
    }

    return m_kTechTemplateMgr.FindTechTemplate(m_kCEProject.TechName);
}

function TTech GetCurrentTechTemplate()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetCurrentTechTemplate);
    return super.GetCurrentTechTemplate();
}

function array<int> GetCurrentTechStates()
{
    local array<int> arrTechStates;
    arrTechStates.Add(0); // Shuts up a compiler warning

    `LWCE_LOG_DEPRECATED_CLS(GetCurrentTechStates);

    return arrTechStates;
}

function array<LWCE_TTechState> LWCE_GetCurrentTechStates()
{
    local int Index;
    local array<LWCETechTemplate> arrTemplates;
    local LWCETechTemplate kTech;
    local array<LWCE_TTechState> arrTechStates;
    local LWCE_TTechState kTechState;

    arrTemplates = m_kTechTemplateMgr.GetAllTechTemplates();
    arrTechStates.Add(arrTemplates.Length);

    for (Index = 0; Index < arrTemplates.Length; Index++)
    {
        kTech = arrTemplates[Index];

        kTechState.TechName = kTech.GetTechName();
        kTechState.eAvailabilityState = eTechState_Unavailable;

        if (m_kCEProject.TechName != kTech.GetTechName())
        {
            if (LWCE_IsTechAvailable(kTech.GetTechName()))
            {
                if (LWCE_CanAffordTech(kTech.GetTechName()))
                {
                    kTechState.eAvailabilityState = eTechState_Affordable;
                }
                else
                {
                    kTechState.eAvailabilityState = eTechState_Available;
                }
            }
        }

        arrTechStates.AddItem(kTechState);
    }

    return arrTechStates;
}

function string GetEstimateString(int iTech)
{
    `LWCE_LOG_DEPRECATED_CLS(GetEstimateString);

    return "";
}

function string LWCE_GetEstimateString(name TechName)
{
    local int iHours, iDaysLeft;
    local XGParamTag kTag;

    iHours = `LWCE_TECH(TechName).GetPointsToComplete();

    if (iHours == 0)
    {
        return m_strETAInstant;
    }
    else
    {
        kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
        iDaysLeft = LabHoursToDays(iHours);

        if (iDaysLeft < 0)
        {
            iDaysLeft = 1;
        }

        kTag.IntValue0 = iDaysLeft;
        return class'XComLocalizer'.static.ExpandString(iDaysLeft != 1 ? m_strETADays : m_strETADay);
    }
}

function GetEvents(out array<THQEvent> arrEvents)
{
    `LWCE_LOG_DEPRECATED_CLS(GetEvents);
}

function LWCE_GetEvents(out array<LWCE_THQEvent> arrEvents)
{
    local int iEvent;
    local LWCE_THQEvent kEvent;

    if (!HasProject())
    {
        return;
    }

    kEvent.EventType = 'Research';
    kEvent.iHours = GetHoursLeftOnProject();
    kEvent.kData = class'LWCEDataContainer'.static.NewName('THQEventData', m_kCEProject.TechName);

    for (iEvent = 0; iEvent < arrEvents.Length; iEvent++)
    {
        if (arrEvents[iEvent].iHours > kEvent.iHours)
        {
            arrEvents.InsertItem(iEvent, kEvent);
            return;
        }
    }

    arrEvents.AddItem(kEvent);
}

function int GetHoursLeftOnProject()
{
    local int iHours;

    iHours = m_kCEProject.iActualHoursLeft / GetResearchPerHour();

    if ((m_kCEProject.iActualHoursLeft % GetResearchPerHour()) > 0)
    {
        iHours += 1;
    }

    return iHours;
}

function int GetNumAutopsiesPerformed()
{
    local int iNumAutopsies;
    local name TechName;

    foreach m_arrCEResearched(TechName)
    {
        if (m_kTechTemplateMgr.FindTechTemplate(TechName).bIsAutopsy)
        {
            iNumAutopsies++;
        }
    }

    return iNumAutopsies;
}

function int GetNumTechsResearched()
{
    return m_arrCEResearched.Length;
}

function EResearchProgress GetProgress(int iTech)
{
    `LWCE_LOG_DEPRECATED_CLS(GetProgress);

    return eResearchProgress_None;
}

function EResearchProgress LWCE_GetProgress(name TechName)
{
    local LWCETechTemplate kTech;
    local int iDaysRemaining;

    kTech = `LWCE_TECH(TechName);
    iDaysRemaining = LabHoursToDays(kTech.GetPointsToComplete());

    if (iDaysRemaining <= 5)
    {
        return eResearchProgress_Fast;
    }
    else if (iDaysRemaining <= 10)
    {
        return eResearchProgress_Normal;
    }
    else
    {
        return eResearchProgress_Slow;
    }
}

function bool HasInterrogatedCaptive()
{
    local name TechName;

    foreach m_arrCEResearched(TechName)
    {
        if (m_kTechTemplateMgr.FindTechTemplate(TechName).bIsInterrogation)
        {
            return true;
        }
    }

    return false;
}

function bool HasProject()
{
    return m_kCEProject.TechName != '';
}

function bool HasResearchCredit(EResearchCredits eCredit)
{
    `LWCE_LOG_DEPRECATED_CLS(HasResearchCredit);
    return false;
}

function bool LWCE_HasResearchCredit(name CreditName)
{
    return m_arrEarnedResearchCredits.Find(CreditName) != INDEX_NONE;
}

function bool HasTechsAvailable()
{
    local array<LWCETechTemplate> arrTechs;

    LWCE_GetAvailableTechs(arrTechs);
    return arrTechs.Length > 0;
}

function bool IsAutopsyTech(int iTech)
{
    `LWCE_LOG_DEPRECATED_CLS(IsAutopsyTech);

    return false;
}

function bool LWCE_IsAutopsyTech(name TechName)
{
    local LWCETechTemplate kTech;

    kTech = m_kTechTemplateMgr.FindTechTemplate(TechName);

    if (kTech == none)
    {
        `LWCE_LOG_CLS("WARNING: LWCE_IsAutopsyTech: requested tech name " $ TechName $ " not found");
        return false;
    }

    return kTech.bIsAutopsy;
}

function bool IsInterrogationTech(int iTech)
{
    `LWCE_LOG_DEPRECATED_CLS(IsInterrogationTech);

    return false;
}

function bool LWCE_IsInterrogationTech(name TechName)
{
    local LWCETechTemplate kTech;

    kTech = m_kTechTemplateMgr.FindTechTemplate(TechName);

    if (kTech == none)
    {
        `LWCE_LOG_CLS("WARNING: LWCE_IsInterrogationTech: requested tech name " $ TechName $ " not found");
        return false;
    }

    return kTech.bIsInterrogation;
}

function bool IsInterrogationTechAvailable()
{
    local array<LWCETechTemplate> arrTechs;
    local LWCETechTemplate kTech;

    LWCE_GetAvailableTechs(arrTechs);

    foreach arrTechs(kTech)
    {
        if (kTech.bIsInterrogation)
        {
            return true;
        }
    }

    return false;
}

function bool IsPriorityTech(int iTech)
{
    `LWCE_LOG_DEPRECATED_CLS(IsPriorityTech);

    return false;
}

function bool LWCE_IsPriorityTech(name TechName)
{
    local LWCETechTemplate kTemplate;

    kTemplate = m_kTechTemplateMgr.FindTechTemplate(TechName);

    if (kTemplate.IsPriorityFn != none)
    {
        return kTemplate.IsPriorityFn();
    }

    return false;
}

function bool IsResearched(int iTech)
{
    local name TechName;

    // This function is only half-deprecated; some base game code can't quite be reached to
    // move it to LWCE_IsResearched yet, so we do this for now.
    if (iTech == 0)
    {
        return true;
    }

    TechName = class'LWCE_XGTechTree'.static.TechNameFromInteger(iTech);

    if (TechName == '')
    {
        `LWCE_LOG_DEPRECATED_CLS(IsResearched);
        return false;
    }

    return LWCE_IsResearched(TechName);
}

function bool LWCE_IsResearched(name TechName)
{
    return TechName == '' || m_arrCEResearched.Find(TechName) != INDEX_NONE;
}

function bool IsTechAvailable(ETechType eTech)
{
    `LWCE_LOG_DEPRECATED_CLS(IsTechAvailable);
    return super.IsTechAvailable(eTech);
}

function bool LWCE_IsTechAvailable(name TechName)
{
    if (TechName == '')
    {
        return false;
    }

    if (LWCE_IsResearched(TechName))
    {
        return false;
    }

    if (!LWCE_XGTechTree(TECHTREE()).LWCE_HasPrereqs(TechName))
    {
        return false;
    }

    if (LWCE_IsInterrogationTech(TechName) && !LWCE_XGHeadquarters(HQ()).LWCE_HasFacility('Facility_AlienContainment'))
    {
        return false;
    }

    if (LWCE_IsInterrogationTech(TechName) && !LWCE_CanAffordTech(TechName))
    {
        return false;
    }

    return true;
}

function bool NeedsScientists()
{
    local array<LWCETechTemplate> arrTechs;
    local LWCETechTemplate kTech;
    local int iNumFastTechs, iNumNormalTechs, iNumSlowTechs;
    local EResearchProgress eProgress;

    if (m_iRequestCounter > 0 || GetAvailableScientists() > 30)
    {
        return false;
    }

    LWCE_GetAvailableTechs(arrTechs);

    foreach arrTechs(kTech)
    {
        // Autopsies/interrogations don't count, presumably because they could be made instant in Enemy Within
        if (kTech.bIsAutopsy || kTech.bIsInterrogation)
        {
            continue;
        }

        eProgress = LWCE_GetProgress(kTech.GetTechName());

        if (eProgress == eResearchProgress_Slow)
        {
            iNumSlowTechs += 1;
        }
        else if (eProgress == eResearchProgress_Normal)
        {
            iNumNormalTechs += 1;
        }
        else if (eProgress == eResearchProgress_Fast)
        {
            iNumFastTechs += 1;
        }
    }

    if (iNumNormalTechs == 0 && iNumFastTechs == 0 && iNumSlowTechs > 1)
    {
        ResetRequestCounter();
        return true;
    }
    else
    {
        return false;
    }
}

function PayCost(TResearchCost kCost)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function PayCost was called. This needs to be replaced with LWCE_XGHeadquarters.PayCost. Stack trace follows.");
    ScriptTrace();
}

function OnResearchCompleted()
{
    local name TechName;
    local int iCorpseId, iProgressIndex, Index;
    local bool bNeverInterrogated;
    local XComNarrativeMoment kNarrative;
    local LWCETechTemplate kCompletedTech;
    local LWCE_XGGeoscape kGeoscape;
    local LWCE_XGItemTree kItemTree;
    local LWCE_TResearchProject kBlankProject;

    kGeoscape = LWCE_XGGeoscape(GEOSCAPE());
    kItemTree = LWCE_XGItemTree(ITEMTREE());

    bNeverInterrogated = !HasInterrogatedCaptive();
    m_bRequiresAttention = true;

    TechName = m_kCEProject.TechName;
    m_nmLastResearchedTech = TechName;
    kCompletedTech = `LWCE_TECH(TechName);
    m_arrCEResearched.AddItem(TechName);

    // Record when the research was finished, for the report/archives
    iProgressIndex = m_arrCEProgress.Find('TechName', TechName);
    m_arrCEProgress[iProgressIndex].kCompletionTime = Spawn(class'LWCE_XGDateTime', self);
    m_arrCEProgress[iProgressIndex].kCompletionTime.CopyDateTime(GEOSCAPE().m_kDateTime);

    STAT_AddAvgStat(eRecap_AvgTechDaysCount, eRecap_AvgTechDaysSum, int(float(m_arrCEProgress[iProgressIndex].iHoursSpent) / 24.0));

    m_arrCEUnlockedItems.Remove(0, m_arrCEUnlockedItems.Length);
    m_arrUnlockedGeneMods.Remove(0, m_arrUnlockedGeneMods.Length);
    m_arrCEUnlockedFacilities.Remove(0, m_arrCEUnlockedFacilities.Length);
    m_arrCEUnlockedFoundryProjects.Remove(0, m_arrCEUnlockedFoundryProjects.Length);

    if (ENGINEERING().IsDisabled())
    {
        ENGINEERING().m_bRequiresAttention = true;
    }

    for (Index = 0; Index < kCompletedTech.arrCreditsGranted.Length; Index++)
    {
        LWCE_AddResearchCredit(kCompletedTech.arrCreditsGranted[Index]);
    }

    m_bNeedsScientists = NeedsScientists();
    Continent(HQ().GetContinent()).m_kMonthly.iTechsResearched += 1;
    STAT_AddStat(eRecap_TechsResearched, 1);
    Achieve(AT_WhatWondersAwait);
    m_kCEProject = kBlankProject;

    if (CheckForEdison())
    {
        Achieve(AT_Edison);
    }

    if (kCompletedTech.TechCompleteNarrative != "")
    {
        `LWCE_LOG_CLS("Attempting to load tech post-completion narrative " $ kCompletedTech.TechCompleteNarrative);

        kNarrative = XComNarrativeMoment(DynamicLoadObject(kCompletedTech.TechCompleteNarrative, class'XComNarrativeMoment'));

        if (kNarrative != none)
        {
            PRES().UINarrative(kNarrative, none, ResearchCinematicComplete);
        }
    }

    if (LWCE_IsInterrogationTech(m_nmLastResearchedTech))
    {
        // Give the captive's corpse after interrogations
        iCorpseId = kItemTree.CharacterToCorpse(kCompletedTech.iSubjectCharacterId);

        if (iCorpseId != 0)
        {
            STORAGE().AddItem(iCorpseId);
        }

        if (bNeverInterrogated)
        {
            STAT_SetStat(eRecap_ObjInterrogateAlien, Game().GetDays());
            XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).DoRemoteEvent('ContainmentDoors_Open');
            PRES().UINarrative(`XComNarrativeMoment("PostInterrogation"), none, ResearchCinematicComplete, , HQ().m_kBase.GetFacility3DLocation(eFacility_AlienContain));
        }
        else
        {
            ResearchCinematicComplete();
        }
    }
    else if (m_nmLastResearchedTech == 'Tech_AlienOperations')
    {
        STAT_SetStat(eRecap_ObjResearchOutsiderShards, Game().GetDays());
        SITROOM().OnCodeCracked();
    }

    if (LWCE_IsAutopsyTech(m_nmLastResearchedTech))
    {
        if (CheckForAllEmployees())
        {
            Achieve(AT_AllEmployees);
        }
    }

    `LWCE_MOD_LOADER.OnResearchCompleted(TechName);

    kGeoscape.LWCE_Alert(`LWCE_ALERT('ResearchCompleted').AddName(TechName).Build());
}

function string RecordStartedResearchProject(TResearchProject Project)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordStartedResearchProject);

    return "";
}

function RefundCost(TResearchCost kCost, optional bool bXeno)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function RefundCost was called. This needs to be replaced with LWCE_XGHeadquarters.RefundCost. Stack trace follows.");
    ScriptTrace();
}

function RemoveScientists(int iNumScientists)
{
    m_iNumScientists -= iNumScientists;

    if (HasProject())
    {
        UpdateProgress();
    }
}

function ResearchCinematicComplete()
{
    m_bChooseTechAfterReport = true;

    if (LWCE_IsInterrogationTech(m_nmLastResearchedTech))
    {
        `HQGAME.GetGameCore().GetHQ().m_kBase.OnFaciltyStreamed_AlienContainment('None');
    }
}

function SetNewProject(int iTech)
{
    `LWCE_LOG_DEPRECATED_CLS(SetNewProject);
}

function LWCE_SetNewProject(name TechName)
{
    local int iCaptiveItemId;
    local XComNarrativeMoment kNarrative;
    local LWCE_TResearchProgress kProgress;
    local LWCETechTemplate kTech;
    local LWCE_TCost kCost;

    if (m_kCEProject.TechName != '')
    {
        kTech = `LWCE_TECH(m_kCEProject.TechName);
        kCost = kTech.GetCost();

        // TODO: since mods could potentially discount research dynamically, we should store the actual paid cost like engineering does, and refund that

        // In LW 1.0, Xenobiology doesn't refund its item costs for some reason, and there's an extra parameter in XGFacility_Labs.RefundCost to handle that.
        // Since that makes no sense and complicates our logic, and most people probably don't even know about it, we just got rid of that behavior.
        LWCE_XGHeadquarters(HQ()).RefundCost(kCost);
    }

    if (m_arrCEProgress.Find('TechName', TechName) == INDEX_NONE)
    {
        kProgress.TechName = TechName;
        kProgress.iHoursCompleted = 0;
        m_arrCEProgress.AddItem(kProgress);
    }

    kTech = `LWCE_TECH(TechName);
    kCost = kTech.GetCost();

    if (kTech.TechBegunNarrative != "")
    {
        `LWCE_LOG_CLS("Attempting to load tech on-begin narrative " $ kTech.TechBegunNarrative);

        kNarrative = XComNarrativeMoment(DynamicLoadObject(kTech.TechBegunNarrative, class'XComNarrativeMoment'));

        if (kNarrative != none)
        {
            Narrative(kNarrative);
        }
    }
    else if (!LWCE_IsInterrogationTech(TechName) && m_iTechConfirms-- > 0)
    {
        // Default narrative; don't play for interrogations, they have special handling below
        Narrative(`XComNarrativeMoment("TechSelected"));
    }

    m_kCEProject.TechName = TechName;
    m_kCEProject.iEstimate = LabHoursToDays(kTech.GetPointsToComplete());
    m_kCEProject.iActualHoursLeft = Max(0, kTech.GetPointsToComplete());
    m_kCEProject.iProgress = LWCE_GetProgress(TechName);
    m_kCEProject.strETA = LWCE_GetEstimateString(TechName);

    `LWCE_HQ.PayCost(kCost);

    if (LWCE_IsInterrogationTech(TechName))
    {
        // TODO move this data into template
        switch (kTech.iSubjectCharacterId)
        {
            case eChar_Sectoid:
                iCaptiveItemId = 150;
                break;
            case eChar_Floater:
                iCaptiveItemId = 152;
                break;
            case eChar_Muton:
                iCaptiveItemId = 155;
                break;
            case eChar_ThinMan:
                iCaptiveItemId = 154;
                break;
            case eChar_MutonBerserker:
                iCaptiveItemId = 157;
                break;
            case eChar_FloaterHeavy:
                iCaptiveItemId = 153;
                break;
            case eChar_SectoidCommander:
                iCaptiveItemId = 151;
                break;
            case eChar_Ethereal:
                iCaptiveItemId = 158;
                break;
            case eChar_MutonElite:
                iCaptiveItemId = 156;
                break;
            default:
                `LWCE_LOG_CLS("Unknown or unset iSubjectCharacterId " $ kTech.iSubjectCharacterId $ ". Not triggering any narrative moment.");
                break;
        }

        if (iCaptiveItemId > 0 && iCaptiveItemId <= 255)
        {
            // Captives from mods currently will not trigger the alien containment cutscenes
            Base().DoAlienInterrogation(EItemType(iCaptiveItemId));
        }
    }

    `LWCE_MOD_LOADER.OnResearchStarted(TechName);

    if (m_kCEProject.iActualHoursLeft == 0)
    {
        OnResearchCompleted();
    }
}

function UpdateLabBonus()
{
    m_fLabBonus = class'XGTacticalGameCore'.default.LAB_BONUS * LWCE_XGHeadquarters(HQ()).LWCE_GetNumFacilities('Facility_Laboratory');

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(JaiVidwan)) > 0)
    {
        m_fAdjLabBonus = ((HQ().HasBonus(`LW_HQ_BONUS_ID(JaiVidwan)) / 100.0f) + class'XGTacticalGameCore'.default.LAB_ADJACENCY_BONUS) * LWCE_XGBase(Base()).LWCE_GetAdjacencies('Laboratory');
    }
    else
    {
        m_fAdjLabBonus = class'XGTacticalGameCore'.default.LAB_ADJACENCY_BONUS * LWCE_XGBase(Base()).LWCE_GetAdjacencies('Laboratory');
    }

    if (HasProject())
    {
        UpdateProgress();
    }
}

function UpdateProgress()
{
    local int iDaysLeft;
    local XGParamTag kTag;

    m_kCEProject.iProgress = LWCE_GetProgress(m_kCEProject.techName);
    iDaysLeft = GetHoursLeftOnProject() / 24;

    if ((GetHoursLeftOnProject() % 24) > 0)
    {
        iDaysLeft += 1;
    }

    if (iDaysLeft < 0)
    {
        iDaysLeft = 0;
    }

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kTag.IntValue0 = iDaysLeft;

    m_kCEProject.strETA = class'XComLocalizer'.static.ExpandString(iDaysLeft != 1 ? m_strETADays : m_strETADay);
}