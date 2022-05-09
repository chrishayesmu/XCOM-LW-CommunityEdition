class LWCE_XGFacility_Labs extends XGFacility_Labs
    dependson(XGGameData);

struct CheckpointRecord_LWCE_XGFacility_Labs extends CheckpointRecord_XGFacility_Labs
{
    var int m_iCELastResearched;
    var array<LWCE_TResearchProgress> m_arrCEProgress;
    var array<int> m_arrCEUnlockedFoundryProjects;
};

var int m_iCELastResearched;
var array<LWCE_TResearchProgress> m_arrCEProgress;
var array<LWCE_TTechState> m_arrCEMissionResults;
var array<int> m_arrCEUnlockedFoundryProjects;
var array<int> m_arrCEUnlockedItems;

function Init(bool bLoadingFromSave)
{
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
        iProgressIndex = m_arrCEProgress.Find('iTechId', m_kProject.iTech);
        iHoursCompleted = GetResearchPerHour();
        m_kProject.iActualHoursLeft -= iHoursCompleted;
        m_arrCEProgress[iProgressIndex].iHoursCompleted += iHoursCompleted;
        m_arrCEProgress[iProgressIndex].iHoursSpent += 1;

        if (ISCONTROLLED() && m_kProject.iTech == `LW_TECH_ID(Xenobiology))
        {
            if (GEOSCAPE().m_kDateTime.GetDay() > START_DAY + 7)
            {
                m_kProject.iActualHoursLeft = 0;
            }
        }

        if (m_kProject.iActualHoursLeft <= 0)
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

function bool CanAffordTech(int iTech)
{
    local LWCE_TTech kTech;
    local int iItem;

    kTech = `LWCE_TECH(iTech);

    if (kTech.kCost.iCash > 0 && kTech.kCost.iCash > GetResource(eResource_Money))
    {
        return false;
    }

    if (kTech.kCost.iAlloys > 0 && kTech.kCost.iAlloys > GetResource(eResource_Alloys))
    {
        return false;
    }

    if (kTech.kCost.iElerium > 0 && kTech.kCost.iElerium > GetResource(eResource_Elerium))
    {
        return false;
    }

    if (kTech.kCost.iMeld > 0 && kTech.kCost.iMeld > GetResource(eResource_Meld))
    {
        return false;
    }

    if (kTech.kCost.iWeaponFragments > 0 && kTech.kCost.iWeaponFragments > STORAGE().GetNumItemsAvailable(eItem_WeaponFragment))
    {
        return false;
    }

    if (kTech.kCost.arrItems.Length > 0)
    {
        for (iItem = 0; iItem < kTech.kCost.arrItems.Length; iItem++)
        {
            if (kTech.kCost.arrItems[iItem].iQuantity > STORAGE().GetNumItemsAvailable(kTech.kCost.arrItems[iItem].iItemId))
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
    return `LWCE_TECHTREE.m_arrCETechs.Length == m_arrResearched.Length;
}

// "All Employees Must Wash Hands..." achievement: In a single game, complete every Autopsy.
function bool CheckForAllEmployees()
{
    local LWCE_TTech kTech;

    foreach `LWCE_TECHTREE.m_arrCETechs(kTech)
    {
        if (IsAutopsyTech(kTech.iTechId) && !IsResearched(kTech.iTechId))
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
        `assert(arrPreLandTechs[Index].iTechId == arrPostLandTechs[Index].iTechId);
        kTechState.iTechId = arrPreLandTechs[Index].iTechId;
        kTechState.eAvailabilityState = eTechState_Unavailable;

        if (arrPreLandTechs[Index].eAvailabilityState != arrPostLandTechs[Index].eAvailabilityState)
        {
            if (arrPreLandTechs[Index].eAvailabilityState == eTechState_Unavailable)
            {
                // We always care about a state change away from unavailable
                kTechState.eAvailabilityState = eTechState_Available;

                // Make sure we can do interrogations if relevant (captives may not be converted to corpses at this point)
                if (IsInterrogationTech(kTechState.iTechId) && !HQ().HasFacility(eFacility_AlienContain))
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

function LWCE_GetAvailableTechs(out array<LWCE_TTech> arrTechs)
{
    local LWCE_TTECH kTech;
    local LWCE_XGTechTree kTechTree;

    kTechTree = `LWCE_TECHTREE;

    arrTechs.Remove(0, arrTechs.Length);

    foreach kTechTree.m_arrCETechs(kTech)
    {
        if (m_kProject.iTech != kTech.iTechId && LWCE_IsTechAvailable(kTech.iTechId))
        {
            if (IsPriorityTech(kTech.iTechId))
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
    local TText txtCost;
    local bool bCanAfford;
    local int iItem;
    local LWCE_TItem kItem;
    local XGParamTag kTag;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    bCanAfford = true;

    if (kCost.iCash > 0)
    {
        txtCost.StrValue = class'XGScreenMgr'.static.ConvertCashToString(kCost.iCash);
        txtCost.iState = eUIState_Cash;

        if (kCost.iCash > GetResource(eResource_Money))
        {
            bCanAfford = false;
            txtCost.iState = eUIState_Bad;
            kCostSummary.strHelp = m_strErrInsufficientFunds;
        }

        kCostSummary.arrRequirements.AddItem(txtCost);
    }

    if (kCost.iElerium > 0)
    {
        kTag.IntValue0 = kCost.iElerium;
        kTag.StrValue0 = m_strCostElerium;
        txtCost.StrValue = class'XComLocalizer'.static.ExpandString(m_strCostLabel);
        txtCost.iState = eUIState_Elerium;

        if (kCost.iElerium > GetResource(eResource_Elerium))
        {
            bCanAfford = false;
            txtCost.iState = eUIState_Bad;
            kCostSummary.strHelp = m_strErrInsufficientElerium;
        }

        kCostSummary.arrRequirements.AddItem(txtCost);
    }

    if (kCost.iAlloys > 0)
    {
        kTag.IntValue0 = kCost.iAlloys;
        kTag.StrValue0 = m_strCostAlloys;
        txtCost.StrValue = class'XComLocalizer'.static.ExpandString(m_strCostLabel);
        txtCost.iState = eUIState_Alloys;

        if (kCost.iAlloys > GetResource(eResource_Alloys))
        {
            bCanAfford = false;
            txtCost.iState = eUIState_Bad;
            kCostSummary.strHelp = m_strErrInsufficientAlloys;
        }

        kCostSummary.arrRequirements.AddItem(txtCost);
    }

    if (kCost.arrItems.Length > 0)
    {
        for (iItem = 0; iItem < kCost.arrItems.Length; iItem++)
        {
            kItem = `LWCE_ITEM(kCost.arrItems[iItem]);

            if (kCost.arrItemQuantities[iItem] > 1)
            {
                txtCost.StrValue = (string(kCost.arrItemQuantities[iItem]) $ "x") @ kItem.strNamePlural;
            }
            else
            {
                txtCost.StrValue = (string(kCost.arrItemQuantities[iItem]) $ "x") @ kItem.strName;
            }

            txtCost.iState = eUIState_Normal;

            if (kCost.arrItemQuantities[iItem] > STORAGE().GetNumItemsAvailable(kCost.arrItems[iItem]))
            {
                bCanAfford = false;
                txtCost.iState = eUIState_Bad;
                kTag.IntValue0 = kCost.arrItemQuantities[iItem] - STORAGE().GetNumItemsAvailable(kCost.arrItems[iItem]);
                kTag.StrValue0 = kItem.strName;
                kCostSummary.strHelp = class'XComLocalizer'.static.ExpandString(m_strErrInsufficientResources);
            }

            if (kCost.arrItemQuantities[iItem] > 0)
            {
                kCostSummary.arrRequirements.AddItem(txtCost);
            }
        }
    }

    return bCanAfford;
}

function TTech GetCurrentTech()
{
    `LWCE_LOG_DEPRECATED_CLS(GetCurrentTech);
    return super.GetCurrentTech();
}

function LWCE_TTech LWCE_GetCurrentTech()
{
    local int Index;
    local LWCE_TTech BlankTech;
    local LWCE_XGTechTree kTechTree;

    kTechTree = `LWCE_TECHTREE;
    Index = kTechTree.m_arrCETechs.Find('iTechId', m_kProject.iTech);

    if (Index == INDEX_NONE)
    {
        return BlankTech;
    }

    return kTechTree.m_arrCETechs[Index];
}

function TTech GetCurrentTechTemplate()
{
    `LWCE_LOG_DEPRECATED_CLS(GetCurrentTechTemplate);
    return super.GetCurrentTechTemplate();
}

function LWCE_TTech LWCE_GetCurrentTechTemplate()
{
    return `LWCE_TECHTREE.LWCE_GetTech(m_kProject.iTech, false);
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
    local LWCE_TTech kTech;
    local LWCE_XGTechTree kTree;
    local array<LWCE_TTechState> arrTechStates;
    local LWCE_TTechState kTechState;

    kTree = `LWCE_TECHTREE;
    arrTechStates.Add(kTree.m_arrCETechs.Length);

    for (Index = 0; Index < kTree.m_arrCETechs.Length; Index++)
    {
        kTech = kTree.m_arrCETechs[Index];
        kTechState.iTechId = kTech.iTechId;
        kTechState.eAvailabilityState = eTechState_Unavailable;

        if (m_kProject.iTech != kTech.iTechId)
        {
            if (LWCE_IsTechAvailable(kTech.iTechId))
            {
                if (CanAffordTech(kTech.iTechId))
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
    local int iHours, iDaysLeft;
    local XGParamTag kTag;

    iHours = `LWCE_TECH(iTech).iHours;

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

function int GetNumAutopsiesPerformed()
{
    local int iNumAutopsies, iTechId;
    local LWCE_TTech kTech;
    local LWCE_XGTechTree kTechTree;

    kTechTree = `LWCE_TECHTREE;

    foreach m_arrResearched(iTechId)
    {
        kTech = kTechTree.LWCE_GetTech(iTechId, false);

        if (kTech.bIsAutopsy)
        {
            iNumAutopsies++;
        }
    }

    return iNumAutopsies;
}

function int GetNumTechsResearched()
{
    return m_arrResearched.Length;
}

function EResearchProgress GetProgress(int iTech)
{
    local LWCE_TTech kTech;

    kTech = `LWCE_TECH(iTech);

    if (LabHoursToDays(kTech.iHours) <= 5)
    {
        return eResearchProgress_Fast;
    }
    else
    {
        if (LabHoursToDays(kTech.iHours) <= 10)
        {
            return eResearchProgress_Normal;
        }
        else
        {
            return eResearchProgress_Slow;
        }
    }
}

function bool HasInterrogatedCaptive()
{
    local int iTechId;
    local LWCE_TTech kTech;
    local LWCE_XGTechTree kTechTree;

    kTechTree = `LWCE_TECHTREE;

    foreach m_arrResearched(iTechId)
    {
        kTech = kTechTree.LWCE_GetTech(iTechId, false);

        if (kTech.bIsInterrogation)
        {
            return true;
        }
    }

    return false;
}

function bool HasTechsAvailable()
{
    local array<LWCE_TTech> arrTechs;

    LWCE_GetAvailableTechs(arrTechs);
    return arrTechs.Length > 0;
}

function bool IsAutopsyTech(int iTech)
{
    return `LWCE_TECHTREE.LWCE_GetTech(iTech).bIsAutopsy;
}

function bool IsInterrogationTech(int iTech)
{
    return `LWCE_TECHTREE.LWCE_GetTech(iTech).bIsInterrogation;
}

function bool IsInterrogationTechAvailable()
{
    local array<LWCE_TTech> arrTechs;
    local LWCE_TTech kTech;

    LWCE_GetAvailableTechs(arrTechs);

    foreach arrTechs(kTech)
    {
        if (IsInterrogationTech(kTech.iTechId))
        {
            return true;
        }
    }

    return false;
}

function bool IsResearched(int iTech)
{
    return iTech == 0 || m_arrResearched.Find(iTech) != INDEX_NONE;
}

function bool IsTechAvailable(ETechType eTech)
{
    `LWCE_LOG_DEPRECATED_CLS(IsTechAvailable);
    return super.IsTechAvailable(eTech);
}

function bool LWCE_IsTechAvailable(int iTech)
{
    if (iTech == 0 || iTech == 76)
    {
        return false;
    }

    if (IsResearched(iTech))
    {
        return false;
    }

    if (!TECHTREE().HasPrereqs(iTech))
    {
        return false;
    }

    if (IsInterrogationTech(iTech) && !HQ().HasFacility(eFacility_AlienContain))
    {
        return false;
    }

    if (IsInterrogationTech(iTech) && !CanAffordTech(iTech))
    {
        return false;
    }

    return true;
}

function bool NeedsScientists()
{
    local array<LWCE_TTech> arrTechs;
    local LWCE_TTech kTech;
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
        if (IsInterrogationTech(kTech.iTechId) || IsAutopsyTech(kTech.iTechId))
        {
            continue;
        }

        eProgress = GetProgress(kTech.iTechId);

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

function OnResearchCompleted()
{
    local int iCorpseId, iProgressIndex, iTech;
    local bool bNeverInterrogated;
    local LWCE_XGItemTree kItemTree;
    local TResearchProject kNewProject;

    kItemTree = `LWCE_ITEMTREE;

    bNeverInterrogated = !HasInterrogatedCaptive();
    iTech = m_kProject.iTech;
    m_bRequiresAttention = true;
    m_arrResearched.AddItem(m_kProject.iTech);

    // Record when the research was finished, for the report/archives
    iProgressIndex = m_arrCEProgress.Find('iTechId', iTech);
    m_arrCEProgress[iProgressIndex].kCompletionTime = Spawn(class'LWCE_XGDateTime', self);
    m_arrCEProgress[iProgressIndex].kCompletionTime.CopyDateTime(GEOSCAPE().m_kDateTime);

    m_iCELastResearched = iTech;

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(RecordTechResearched(m_kProject));
    }

    if (ISCONTROLLED() && m_iCELastResearched == `LW_TECH_ID(ExperimentalWarfare))
    {
        HANGAR().SetDisabled(false);
    }

    STAT_AddAvgStat(eRecap_AvgTechDaysCount, eRecap_AvgTechDaysSum, int(float(m_arrCEProgress[iProgressIndex].iHoursSpent) / 24.0));

    m_arrUnlockedItems.Remove(0, m_arrUnlockedItems.Length);
    m_arrUnlockedGeneMods.Remove(0, m_arrUnlockedGeneMods.Length);
    m_arrUnlockedFacilities.Remove(0, m_arrUnlockedFacilities.Length);
    m_arrCEUnlockedFoundryProjects.Remove(0, m_arrCEUnlockedFoundryProjects.Length);

    if (ENGINEERING().IsDisabled())
    {
        ENGINEERING().SetDisabled(true);
        ENGINEERING().m_bRequiresAttention = true;
    }

    AddResearchCredit(EResearchCredits(`LWCE_TECH(iTech).iCreditGranted));
    m_bNeedsScientists = NeedsScientists();
    Continent(HQ().GetContinent()).m_kMonthly.iTechsResearched += 1;
    m_kProject = kNewProject;
    STAT_AddStat(eRecap_TechsResearched, 1);
    Achieve(AT_WhatWondersAwait);

    if (CheckForEdison())
    {
        Achieve(AT_Edison);
    }

    if (m_iCELastResearched == `LW_TECH_ID(Xenogenetics))
    {
        // In vanilla EW, completing the meld research gave ~40 bonus meld; none in LW (maybe make configurable?)
        STORAGE().AddItem(eItem_Meld, 0);
        PRES().UINarrative(`XComNarrativeMomentEW("MeldIntro"), none, ResearchCinematicComplete);
    }

    if (m_iCELastResearched == `LW_TECH_ID(Xenobiology))
    {
        if (!ISCONTROLLED())
        {
            PRES().UINarrative(`XComNarrativeMoment("ArcThrower"), none, ResearchCinematicComplete);
        }
    }
    else if (IsInterrogationTech(m_iCELastResearched))
    {
        // Give the captive's corpse after interrogations
        iCorpseId = kItemTree.CharacterToCorpse(`LWCE_TECH(m_iCELastResearched).iSubjectCharacterId);

        if (iCorpseId != 0)
        {
            STORAGE().AddItem(iCorpseId);
        }

        if (bNeverInterrogated)
        {
            STAT_SetStat(eRecap_ObjInterrogateAlien, Game().GetDays());
            XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).DoRemoteEvent('ContainmentDoors_Open');
            PRES().UINarrative(`XComNarrativeMoment("PostInterrogation"), none, ResearchCinematicComplete,, HQ().m_kBase.GetFacility3DLocation(13));
        }
        else
        {
            ResearchCinematicComplete();
        }
    }
    else if (m_iCELastResearched == `LW_TECH_ID(AlienOperations))
    {
        STAT_SetStat(eRecap_ObjResearchOutsiderShards, Game().GetDays());
        SITROOM().OnCodeCracked();
    }

    if (IsAutopsyTech(m_iCELastResearched))
    {
        if (CheckForAllEmployees())
        {
            Achieve(AT_AllEmployees);
        }
    }

    `LWCE_MOD_LOADER.OnResearchCompleted(iTech);

    GEOSCAPE().Alert(GEOSCAPE().MakeAlert(eGA_ResearchCompleted, iTech));
}

function SetNewProject(int iTech)
{
    local int iCaptiveItemId;
    local LWCE_TResearchProgress kProgress;
    local LWCE_TTech kTech;
    local TResearchCost kCost;

    if (m_kProject.iTech != 0)
    {
        kTech = `LWCE_TECH(m_kProject.iTech);
        kCost = class'LWCETypes'.static.ConvertTCostToTResearchCost(kTech.kCost);

        // TODO: since mods could potentially discount research dynamically, we should store the actual paid cost like engineering does, and refund that
        // TODO: Xenobiology doesn't refund its corpses for some reason? seems like maybe that should be configurable
        RefundCost(kCost, m_kProject.iTech == `LW_TECH_ID(Xenobiology));
    }

    if (!ISCONTROLLED())
    {
        if (iTech == `LW_TECH_ID(AlienCommandAndControl))
        {
            Narrative(`XComNarrativeMoment("EtherealDeviceRetrieved_LeadOut_CS"));
        }
        else if (iTech == `LW_TECH_ID(AlienCommunications))
        {
            Narrative(`XComNarrativeMoment("HyperwaveBeaconRetrieved_LeadOut_CS"));
        }
        else if (iTech != `LW_TECH_ID(AlienOperations))
        {
            if (!IsAutopsyTech(iTech) && !IsInterrogationTech(iTech) && --m_iTechConfirms > 0)
            {
                Narrative(`XComNarrativeMoment("TechSelected"));
            }
        }
    }

    if (m_arrCEProgress.Find('iTechId', iTech) == INDEX_NONE)
    {
        kProgress.iTechId = iTech;
        kProgress.iHoursCompleted = 0;
        m_arrCEProgress.AddItem(kProgress);
    }

    kTech = `LWCE_TECH(iTech);
    kCost = class'LWCETypes'.static.ConvertTCostToTResearchCost(kTech.kCost);

    m_kProject.iTech = iTech;
    m_kProject.iEstimate = LabHoursToDays(kTech.iHours);
    m_kProject.iActualHoursLeft = kTech.iHours < 0 ? 1 : kTech.iHours;
    m_kProject.iProgress = GetProgress(iTech);
    m_kProject.strETA = GetEstimateString(iTech);

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(RecordStartedResearchProject(m_kProject));
    }

    PayCost(kCost);

    if (IsInterrogationTech(iTech))
    {
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
            // TODO: Captives from mods currently will not trigger the alien containment cutscenes
            Base().DoAlienInterrogation(EItemType(iCaptiveItemId));
        }
    }
    else if (IsAutopsyTech(iTech))
    {
        switch (kTech.iSubjectCharacterId)
        {
            case eChar_Sectoid:
                Narrative(`XComNarrativeMoment("LabsAutopsySectoid"));
                break;
            case eChar_Floater:
                Narrative(`XComNarrativeMoment("LabsAutopsyFloater"));
                break;
            case eChar_Muton:
                Narrative(`XComNarrativeMoment("LabsAutopsyMuton"));
                break;
            case eChar_ThinMan:
                Narrative(`XComNarrativeMoment("LabsAutopsyThinman"));
                break;
            case eChar_Cyberdisc:
                Narrative(`XComNarrativeMoment("LabsAutopsyCyberdisc"));
                break;
            case eChar_Chryssalid:
                Narrative(`XComNarrativeMoment("LabsAutopsyCryssalid"));
                break;
            case eChar_MutonBerserker:
                Narrative(`XComNarrativeMoment("LabsAutopsyBerserker"));
                break;
            case eChar_FloaterHeavy:
                Narrative(`XComNarrativeMoment("LabsAutopsyHeavyFloater"));
                break;
            case eChar_SectoidCommander:
                Narrative(`XComNarrativeMoment("LabsAutopsySectoidCommander"));
                break;
            case eChar_Sectopod:
                Narrative(`XComNarrativeMoment("LabsAutopsySectopod"));
                break;
            case eChar_Ethereal:
                Narrative(`XComNarrativeMoment("LabsAutopsyEthereal"));
                break;
            case eChar_MutonElite:
                Narrative(`XComNarrativeMoment("LabsAutopsyEliteMuton"));
                break;
            case eChar_Drone:
                Narrative(`XComNarrativeMoment("LabsAutopsyDrone"));
                break;
            case eChar_Mechtoid:
                Narrative(`XComNarrativeMomentEW("LabsAutopsyMechtoid"));
                break;
            case eChar_Seeker:
                Narrative(`XComNarrativeMomentEW("LabsAutopsySeeker"));
                break;
            default:
                `LWCE_LOG_CLS("Unknown or unset iSubjectCharacterId " $ kTech.iSubjectCharacterId $ ". Not triggering any narrative moment.");
                break;
        }
    }

    `LWCE_MOD_LOADER.OnResearchStarted(iTech);

    if (m_kProject.iActualHoursLeft == 0)
    {
        OnResearchCompleted();
    }
}