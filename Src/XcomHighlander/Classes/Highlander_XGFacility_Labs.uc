class Highlander_XGFacility_Labs extends XGFacility_Labs;

struct CheckpointRecord_Highlander_XGFacility_Labs extends CheckpointRecord_XGFacility_Labs
{
    var array<int> m_arrHLUnlockedFoundryProjects;
};

var array<int> m_arrHLUnlockedFoundryProjects;

function Init(bool bLoadingFromSave)
{
    m_kTree = Spawn(class'Highlander_XGTechTree');
    m_kTree.Init();
    BaseInit();
    UpdateLabBonus();

    if (m_arrProgress.Length == 0)
    {
        m_arrProgress.Add(76);
    }

    if (m_arrTimeSpent.Length == 0)
    {
        m_arrTimeSpent.Add(76);
    }

    if (m_arrCredits.Length == 0)
    {
        m_arrCredits.Add(10);
    }

    if (m_arrMusingTracker.Length == 0)
    {
        m_arrMusingTracker.Add(8);
    }
}

function OnResearchCompleted()
{
    local int iTech;
    local TResearchProject kNewProject;
    local bool bNeverInterrogated;

    bNeverInterrogated = !HasInterrogatedCaptive();
    iTech = m_kProject.iTech;
    m_bRequiresAttention = true;
    m_arrResearched[m_kProject.iTech] = 1;

    if (m_arrResearchedTimes[m_kProject.iTech] == none)
    {
        m_arrResearchedTimes[m_kProject.iTech] = Spawn(class'Highlander_XGDateTime', self);
    }

    m_arrResearchedTimes[m_kProject.iTech].CopyDateTime(GEOSCAPE().m_kDateTime);
    m_eLastResearched = ETechType(iTech);

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(RecordTechResearched(m_kProject));
    }

    if (ISCONTROLLED() && m_eLastResearched == eTech_Exp_Warfare)
    {
        HANGAR().SetDisabled(false);
    }

    STAT_AddAvgStat(eRecap_AvgTechDaysCount, eRecap_AvgTechDaysSum, int(float(m_arrTimeSpent[iTech]) / 24.0));

    m_arrUnlockedItems.Remove(0, m_arrUnlockedItems.Length);
    m_arrUnlockedGeneMods.Remove(0, m_arrUnlockedGeneMods.Length);
    m_arrUnlockedFacilities.Remove(0, m_arrUnlockedFacilities.Length);
    m_arrHLUnlockedFoundryProjects.Remove(0, m_arrHLUnlockedFoundryProjects.Length);

    if (ENGINEERING().IsDisabled())
    {
        ENGINEERING().SetDisabled(true);
        ENGINEERING().m_bRequiresAttention = true;
    }

    AddResearchCredit(TECH(iTech).eCreditGranted);
    m_bNeedsScientists = NeedsScientists();
    Continent(HQ().GetContinent()).m_kMonthly.iTechsResearched += 1;
    m_kProject = kNewProject;
    STAT_AddStat(eRecap_TechsResearched, 1);
    Achieve(AT_WhatWondersAwait);

    if (CheckForEdison())
    {
        Achieve(AT_Edison);
    }

    if (m_eLastResearched == eTech_Meld)
    {
        // In vanilla EW, completing the meld research gave ~40 bonus meld; none in LW (maybe make configurable?)
        STORAGE().AddItem(eItem_Meld, 0);
        PRES().UINarrative(XComNarrativeMoment'MeldIntro', none, ResearchCinematicComplete);
    }

    if (m_eLastResearched == eTech_Xenobiology)
    {
        if (!ISCONTROLLED())
        {
            PRES().UINarrative(XComNarrativeMoment'ArcThrower', none, ResearchCinematicComplete);
        }
    }
    else if (IsInterrogationTech(m_eLastResearched))
    {
        STORAGE().AddItem(ITEMTREE().CaptiveToCorpse(EItemType(TECH(m_eLastResearched).iItemReq)));

        if (bNeverInterrogated)
        {
            STAT_SetStat(eRecap_ObjInterrogateAlien, Game().GetDays());
            XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).DoRemoteEvent('ContainmentDoors_Open');
            PRES().UINarrative(XComNarrativeMoment'PostInterrogation', none, ResearchCinematicComplete,, HQ().m_kBase.GetFacility3DLocation(13));
        }
        else
        {
            ResearchCinematicComplete();
        }
    }
    else if (m_eLastResearched == eTech_BaseShard)
    {
        STAT_SetStat(eRecap_ObjResearchOutsiderShards, Game().GetDays());
        SITROOM().OnCodeCracked();
    }

    if (IsAutopsyTech(m_eLastResearched))
    {
        if (CheckForAllEmployees())
        {
            Achieve(AT_AllEmployees);
        }
    }
}