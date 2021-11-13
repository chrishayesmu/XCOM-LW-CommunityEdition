class Highlander_XGFacility_Labs extends XGFacility_Labs
    dependson(XGGameData);

struct CheckpointRecord_Highlander_XGFacility_Labs extends CheckpointRecord_XGFacility_Labs
{
    var int m_iHLLastResearched;
    var array<HL_TResearchProgress> m_arrHLProgress;
    var array<int> m_arrHLUnlockedFoundryProjects;
};

var int m_iHLLastResearched;
var array<HL_TResearchProgress> m_arrHLProgress;
var array<HL_TTechState> m_arrHLMissionResults;
var array<int> m_arrHLUnlockedFoundryProjects;

function Init(bool bLoadingFromSave)
{
    m_kTree = Spawn(class'Highlander_XGTechTree');
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
        iProgressIndex = m_arrHLProgress.Find('iTechId', m_kProject.iTech);
        iHoursCompleted = GetResearchPerHour();
        m_kProject.iActualHoursLeft -= iHoursCompleted;
        m_arrHLProgress[iProgressIndex].iHoursCompleted += iHoursCompleted;
        m_arrHLProgress[iProgressIndex].iHoursSpent += 1;

        if (ISCONTROLLED() && m_kProject.iTech == eTech_Xenobiology)
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
    local HL_TTech kTech;
    local int iItem;

    kTech = `HL_TECH(iTech);

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
    return `HL_TECHTREE.m_arrHLTechs.Length == m_arrResearched.Length;
}

// "All Employees Must Wash Hands..." achievement: In a single game, complete every Autopsy.
function bool CheckForAllEmployees()
{
    local HL_TTech kTech;

    foreach `HL_TECHTREE.m_arrHLTechs(kTech)
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
    `HL_LOG_DEPRECATED_CLS(CompilePostMissionReport);
}

function HL_CompilePostMissionReport(array<HL_TTechState> arrPreLandTechs, array<HL_TTechState> arrPostLandTechs)
{
    local int Index;
    local HL_TTechState kTechState;

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
            m_arrHLMissionResults.AddItem(kTechState);
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
    `HL_LOG_DEPRECATED_CLS(GetAvailableTechs);
}

function HL_GetAvailableTechs(out array<HL_TTech> arrTechs)
{
    local HL_TTECH kTech;
    local Highlander_XGTechTree kTechTree;

    kTechTree = `HL_TECHTREE;

    arrTechs.Remove(0, arrTechs.Length);

    foreach kTechTree.m_arrHLTechs(kTech)
    {
        if (m_kProject.iTech != kTech.iTechId && HL_IsTechAvailable(kTech.iTechId))
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

function TTech GetCurrentTech()
{
    `HL_LOG_DEPRECATED_CLS(GetCurrentTech);
    return super.GetCurrentTech();
}

function HL_TTech HL_GetCurrentTech()
{
    local int Index;
    local HL_TTech BlankTech;
    local Highlander_XGTechTree kTechTree;

    kTechTree = `HL_TECHTREE;
    Index = kTechTree.m_arrHLTechs.Find('iTechId', m_kProject.iTech);

    if (Index == INDEX_NONE)
    {
        return BlankTech;
    }

    return kTechTree.m_arrHLTechs[Index];
}

function TTech GetCurrentTechTemplate()
{
    `HL_LOG_DEPRECATED_CLS(GetCurrentTechTemplate);
    return super.GetCurrentTechTemplate();
}

function HL_TTech HL_GetCurrentTechTemplate()
{
    return `HL_TECHTREE.HL_GetTech(m_kProject.iTech, false);
}

function array<int> GetCurrentTechStates()
{
    local array<int> arrTechStates;
    arrTechStates.Add(0); // Shuts up a compiler warning

    `HL_LOG_DEPRECATED_CLS(GetCurrentTechStates);

    return arrTechStates;
}

function array<HL_TTechState> HL_GetCurrentTechStates()
{
    local int Index;
    local HL_TTech kTech;
    local Highlander_XGTechTree kTree;
    local array<HL_TTechState> arrTechStates;
    local HL_TTechState kTechState;

    kTree = `HL_TECHTREE;
    arrTechStates.Add(kTree.m_arrHLTechs.Length);

    for (Index = 0; Index < kTree.m_arrHLTechs.Length; Index++)
    {
        kTech = kTree.m_arrHLTechs[Index];
        kTechState.iTechId = kTech.iTechId;
        kTechState.eAvailabilityState = eTechState_Unavailable;

        if (m_kProject.iTech != kTech.iTechId)
        {
            if (HL_IsTechAvailable(kTech.iTechId))
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

    iHours = `HL_TECH(iTech).iHours;

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
    local HL_TTech kTech;
    local Highlander_XGTechTree kTechTree;

    kTechTree = `HL_TECHTREE;

    foreach m_arrResearched(iTechId)
    {
        kTech = kTechTree.HL_GetTech(iTechId, false);

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
    local HL_TTech kTech;

    kTech = `HL_TECH(iTech);

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
    local HL_TTech kTech;
    local Highlander_XGTechTree kTechTree;

    kTechTree = `HL_TECHTREE;

    foreach m_arrResearched(iTechId)
    {
        kTech = kTechTree.HL_GetTech(iTechId, false);

        if (kTech.bIsInterrogation)
        {
            return true;
        }
    }

    return false;
}

function bool HasTechsAvailable()
{
    local array<HL_TTech> arrTechs;

    HL_GetAvailableTechs(arrTechs);
    return arrTechs.Length > 0;
}

function bool IsAutopsyTech(int iTech)
{
    return `HL_TECHTREE.HL_GetTech(iTech).bIsAutopsy;
}

function bool IsInterrogationTech(int iTech)
{
    return `HL_TECHTREE.HL_GetTech(iTech).bIsInterrogation;
}

function bool IsInterrogationTechAvailable()
{
    local array<HL_TTech> arrTechs;
    local HL_TTech kTech;

    HL_GetAvailableTechs(arrTechs);

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
    if (iTech == 255)
    {
        if (IsOptionEnabled(8))
        {
            return IsResearched(eTech_InterrogateEthereal) || IsResearched(eTech_InterrogateSectoidCommander);
        }
        else
        {
            return IsResearched(eTech_AutopsyEthereal) || IsResearched(eTech_AutopsySectoidCommander) || IsResearched(eTech_InterrogateEthereal) || IsResearched(eTech_InterrogateSectoidCommander);
        }
    }

    return m_arrResearched.Find(iTech) != INDEX_NONE;
}

function bool IsTechAvailable(ETechType eTech)
{
    `HL_LOG_DEPRECATED_CLS(IsTechAvailable);
    return super.IsTechAvailable(eTech);
}

function bool HL_IsTechAvailable(int iTech)
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
    local array<HL_TTech> arrTechs;
    local HL_TTech kTech;
    local int iNumFastTechs, iNumNormalTechs, iNumSlowTechs;
    local EResearchProgress eProgress;

    if (m_iRequestCounter > 0 || GetAvailableScientists() > 30)
    {
        return false;
    }

    HL_GetAvailableTechs(arrTechs);

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
    local TResearchProject kNewProject;
    local bool bNeverInterrogated;

    bNeverInterrogated = !HasInterrogatedCaptive();
    iTech = m_kProject.iTech;
    m_bRequiresAttention = true;
    m_arrResearched.AddItem(m_kProject.iTech);

    // Record when the research was finished, for the report/archives
    iProgressIndex = m_arrHLProgress.Find('iTechId', iTech);
    m_arrHLProgress[iProgressIndex].kCompletionTime = Spawn(class'Highlander_XGDateTime', self);
    m_arrHLProgress[iProgressIndex].kCompletionTime.CopyDateTime(GEOSCAPE().m_kDateTime);

    m_iHLLastResearched = iTech;

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(RecordTechResearched(m_kProject));
    }

    if (ISCONTROLLED() && m_iHLLastResearched == eTech_Exp_Warfare)
    {
        HANGAR().SetDisabled(false);
    }

    STAT_AddAvgStat(eRecap_AvgTechDaysCount, eRecap_AvgTechDaysSum, int(float(m_arrHLProgress[iProgressIndex].iHoursSpent) / 24.0));

    m_arrUnlockedItems.Remove(0, m_arrUnlockedItems.Length);
    m_arrUnlockedGeneMods.Remove(0, m_arrUnlockedGeneMods.Length);
    m_arrUnlockedFacilities.Remove(0, m_arrUnlockedFacilities.Length);
    m_arrHLUnlockedFoundryProjects.Remove(0, m_arrHLUnlockedFoundryProjects.Length);

    if (ENGINEERING().IsDisabled())
    {
        ENGINEERING().SetDisabled(true);
        ENGINEERING().m_bRequiresAttention = true;
    }

    AddResearchCredit(EResearchCredits(`HL_TECH(iTech).iCreditGranted));
    m_bNeedsScientists = NeedsScientists();
    Continent(HQ().GetContinent()).m_kMonthly.iTechsResearched += 1;
    m_kProject = kNewProject;
    STAT_AddStat(eRecap_TechsResearched, 1);
    Achieve(AT_WhatWondersAwait);

    if (CheckForEdison())
    {
        Achieve(AT_Edison);
    }

    if (m_iHLLastResearched == eTech_Meld)
    {
        // In vanilla EW, completing the meld research gave ~40 bonus meld; none in LW (maybe make configurable?)
        STORAGE().AddItem(eItem_Meld, 0);
        PRES().UINarrative(`XComNarrativeMoment("MeldIntro"), none, ResearchCinematicComplete);
    }

    if (m_iHLLastResearched == eTech_Xenobiology)
    {
        if (!ISCONTROLLED())
        {
            PRES().UINarrative(`XComNarrativeMoment("ArcThrower"), none, ResearchCinematicComplete);
        }
    }
    else if (IsInterrogationTech(m_iHLLastResearched))
    {
        // Give the captive's corpse after interrogations
        iCorpseId = class'XGGameData'.static.CharToCorpse(EItemType(`HL_TECH(m_iHLLastResearched).iSubjectCharacterId));

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
    else if (m_iHLLastResearched == eTech_BaseShard)
    {
        STAT_SetStat(eRecap_ObjResearchOutsiderShards, Game().GetDays());
        SITROOM().OnCodeCracked();
    }

    if (IsAutopsyTech(m_iHLLastResearched))
    {
        if (CheckForAllEmployees())
        {
            Achieve(AT_AllEmployees);
        }
    }

    `HL_MOD_LOADER.OnResearchCompleted(iTech);

    GEOSCAPE().Alert(GEOSCAPE().MakeAlert(eGA_ResearchCompleted, iTech));
}

function SetNewProject(int iTech)
{
    local int iCaptiveItemId;
    local HL_TResearchProgress kProgress;
    local HL_TTech kTech;
    local TResearchCost kCost;

    if (m_kProject.iTech != 0)
    {
        kTech = `HL_TECH(m_kProject.iTech);
        kCost = class'HighlanderTypes'.static.ConvertTCostToTResearchCost(kTech.kCost);

        // TODO: since mods could potentially discount research dynamically, we should store the actual paid cost like engineering does, and refund that
        // TODO: Xenobiology doesn't refund its corpses for some reason? seems like maybe that should be configurable
        RefundCost(kCost, m_kProject.iTech == eTech_Xenobiology);
    }

    if (!ISCONTROLLED())
    {
        if (iTech == eTech_PsiLink) // Alien Command and Control
        {
            Narrative(`XComNarrativeMoment("EtherealDeviceRetrieved_LeadOut_CS"));
        }
        else if (iTech == eTech_Hyperwave) // Alien Communications
        {
            Narrative(`XComNarrativeMoment("HyperwaveBeaconRetrieved_LeadOut_CS"));
        }
        else if (iTech != eTech_BaseShard) // Alien Operations
        {
            if (!IsAutopsyTech(iTech) && !IsInterrogationTech(iTech) && --m_iTechConfirms > 0)
            {
                Narrative(`XComNarrativeMoment("TechSelected"));
            }
        }
    }

    if (m_arrHLProgress.Find('iTechId', iTech) == INDEX_NONE)
    {
        kProgress.iTechId = iTech;
        kProgress.iHoursCompleted = 0;
        m_arrHLProgress.AddItem(kProgress);
    }

    kTech = `HL_TECH(iTech);
    kCost = class'HighlanderTypes'.static.ConvertTCostToTResearchCost(kTech.kCost);

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
                `HL_LOG_CLS("Unknown or unset iSubjectCharacterId " $ kTech.iSubjectCharacterId $ ". Not triggering any narrative moment.");
                break;
        }

        if (iCaptiveItemId != 0)
        {
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
                Narrative(`XComNarrativeMoment("LabsAutopsyMechtoid"));
                break;
            case eChar_Seeker:
                Narrative(`XComNarrativeMoment("LabsAutopsySeeker"));
                break;
            default:
                `HL_LOG_CLS("Unknown or unset iSubjectCharacterId " $ kTech.iSubjectCharacterId $ ". Not triggering any narrative moment.");
                break;
        }
    }

    `HL_MOD_LOADER.OnResearchStarted(iTech);

    if (m_kProject.iActualHoursLeft == 0)
    {
        OnResearchCompleted();
    }
}