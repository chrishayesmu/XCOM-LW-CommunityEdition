class LWCE_XGFacility_Engineering extends XGFacility_Engineering
    dependson(LWCETypes, LWCE_XGMissionControlUI);

struct LWCE_TFoundryProject
{
    var name ProjectName;
    var int iEngineers;
    var int iMaxEngineers;
    var int iHoursLeft;
    var int iIndex;
    var bool bRush;
    var bool bNotify;
    var bool bAdjusted;
    var TProjectCost kRebate;
    var TProjectCost kOriginalCost;
};

struct CheckpointRecord_LWCE_XGFacility_Engineering extends CheckpointRecord_XGFacility_Engineering
{
    var array<LWCE_TFoundryProject> m_arrCEFoundryProjects;
    var array<LWCE_TItemProject> m_arrCEItemProjects;
    var array<name> m_arrCEFoundryHistory;
};

var array<LWCE_TFoundryProject> m_arrCEFoundryProjects;
var array<LWCE_TItemProject> m_arrCEItemProjects;
var array<name> m_arrCEFoundryHistory;

function Init(bool bLoadingFromSave)
{
    BaseInit();

    m_kItems = Spawn(class'LWCE_XGItemTree');
    m_kItems.Init();

    if (m_arrMusingTracker.Length == 0)
    {
        m_arrMusingTracker.Add(9);
    }
}

function InitNewGame()
{
    m_iNumEngineers = class'XGTacticalGameCore'.default.NUM_STARTING_ENGINEERS;

    m_kStorage = Spawn(class'LWCE_XGStorage');
    m_kStorage.Init();
    GrantInitialStores();

    // TODO: move everything here to macros, or even better, make starting bonuses template-based
    if (HQ().HasBonus(`LW_HQ_BONUS_ID(Resourceful)) > 0)
    {
        m_arrCEFoundryHistory.AddItem('Foundry_AlienMetallurgy');
        m_arrCEFoundryHistory.AddItem('Foundry_ImprovedSalvage');
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(JaiJawan)) > 0)
    {
        m_arrCEFoundryHistory.AddItem('Foundry_EleriumAfterburners');
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(SukhoiCompany)) > 0)
    {
        m_arrCEFoundryHistory.AddItem('Foundry_ImprovedAvionics');
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(JungleScoutsOld)) > 0)
    {
        m_arrCEFoundryHistory.AddItem('Foundry_TacticalRigging');
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(TheirFinestHour)) > 0)
    {
        m_arrCEFoundryHistory.AddItem('Foundry_PenetratorWeapons');
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(ForTheSakeOfGlory)) > 0)
    {
        m_arrCEFoundryHistory.AddItem('Foundry_AdvancedRepair');
    }

    m_bRequiresAttention = true;
    m_bCanBuildFacilities = true;
    m_bCanBuildItems = true;
    m_iEngineerReminder = 45 * 24;
    m_iEleriumHalfLife = int(class'XGTacticalGameCore'.default.SW_ELERIUM_HALFLIFE);
}

// #region Functions related to facilities

function OnFacilityCompleted(int iProject)
{
    if (m_arrFacilityProjects[iProject].bNotify)
    {
        m_arrOldRebates.AddItem(m_arrFacilityProjects[iProject].kRebate);
        LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('NewFacilityBuilt').AddInt(m_arrFacilityProjects[iProject].eFacility).AddInt(m_arrOldRebates.Length - 1).Build());
    }
    else
    {
        PRES().Notify(eGA_NewFacilityBuilt, m_arrFacilityProjects[iProject].eFacility);

        if (HasRebate())
        {
            PRES().Notify(eGA_WorkshopRebate, m_arrFacilityProjects[iProject].kRebate.iCash, m_arrFacilityProjects[iProject].kRebate.iAlloys, m_arrFacilityProjects[iProject].kRebate.iElerium);
        }
    }

    Base().PerformAction(eBCS_BuildFacility, m_arrFacilityProjects[iProject].X, m_arrFacilityProjects[iProject].Y, m_arrFacilityProjects[iProject].eFacility);

    switch (m_arrFacilityProjects[iProject].eFacility)
    {
        case eFacility_ScienceLab:
            STAT_AddStat(eRecap_LabsBuilt, 1);
            Achieve(AT_Theory);
            LABS().UpdateLabBonus();
            break;
        case eFacility_PsiLabs:
        case eFacility_GeneticsLab:
            LABS().UpdateLabBonus();
            break;
        case eFacility_Workshop:
            STAT_AddStat(eRecap_WorkshopsBuilt, 1);
            Achieve(AT_AndPractice);
            break;
        case eFacility_DeusEx:
            STAT_SetStat(eRecap_ObjBuildGollop, Game().GetDays());
            Achieve(AT_OnTheShoulders);
            break;
        case eFacility_HyperwaveRadar:
            STAT_SetStat(eRecap_ObjBuildHyperwave, Game().GetDays());
            Achieve(AT_SeeAllKnowAll);
            break;
    }

    if (m_arrFacilityProjects[iProject].Y >= 4)
    {
        Achieve(AT_DrumsInTheDeep);
    }

    Achieve(AT_UpAndRunning);
    STAT_AddStat(eRecap_FacilitiesBuilt, 1);
}

function string RecordFacilityBuilt(EFacilityType FacilityValue)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordFacilityBuilt);

    return "";
}

// #endregion

// #region Functions related to the Foundry

function AddFoundryProject(out TFoundryProject kProject)
{
    `LWCE_LOG_DEPRECATED_CLS(AddFoundryProject);
}

function LWCE_AddFoundryProject(out LWCE_TFoundryProject kProject)
{
    kProject.iIndex = m_arrCEFoundryProjects.Length;
    kProject.kOriginalCost = LWCE_GetFoundryProjectCost(kProject.ProjectName, kProject.bRush);
    m_arrCEFoundryProjects.AddItem(kProject);

    PayCost(kProject.kOriginalCost);
    LWCE_AddFoundryProjectToQueue(kProject);
    PRES().GetMgr(class'LWCE_XGFoundryUI').UpdateView();
    m_bStartedFoundryProject = true;

    // Notify mods of this project
    `LWCE_MOD_LOADER.OnFoundryProjectAddedToQueue(kProject, `LWCE_FTECH(kProject.ProjectName));
}

function AddFoundryProjectToQueue(out TFoundryProject kProject)
{
    `LWCE_LOG_DEPRECATED_CLS(AddFoundryProjectToQueue);
}

function LWCE_AddFoundryProjectToQueue(out LWCE_TFoundryProject kProject)
{
    local TEngQueueItem kQueueItem;

    kQueueItem.bFoundry = true;
    kQueueItem.iIndex = kProject.iIndex;
    m_arrQueue.AddItem(kQueueItem);
}

function bool CanAddFoundryProject()
{
    return HQ().m_arrBaseFacilities[eFacility_Foundry] > 0;
}

function CancelFoundryProject(int iIndex)
{
    local LWCE_TFoundryProject kProject;

    kProject = LWCE_GetFoundryProject(iIndex);

    if (kProject.kOriginalCost.iCash != 0 || kProject.kOriginalCost.iElerium != 0 || kProject.kOriginalCost.iAlloys != 0)
    {
        RefundCost(kProject.kOriginalCost);
    }
    else
    {
        RefundCost(LWCE_GetFoundryProjectCost(kProject.ProjectName, kProject.bRush));
    }

    RemoveFoundryProject(kProject.iIndex);

    // Notify mods that a project is canceled
    `LWCE_MOD_LOADER.OnFoundryProjectCanceled(kProject, `LWCE_FTECH(kProject.ProjectName));
}

function ChangeFoundryIndex(int iOldIndex, int iNewIndex)
{
    local int iQueue;

    for (iQueue = 0; iQueue < m_arrQueue.Length; iQueue++)
    {
        if (m_arrQueue[iQueue].bFoundry && m_arrQueue[iQueue].iIndex == iOldIndex)
        {
            m_arrQueue[iQueue].iIndex = iNewIndex;
            break;
        }
    }

    m_arrCEFoundryProjects[iNewIndex].iIndex = iNewIndex;
}

function int GetFoundryCounter(out TFoundryProject kProject)
{
    `LWCE_LOG_DEPRECATED_CLS(GetFoundryCounter);

    return -1;
}

function int LWCE_GetFoundryCounter(out LWCE_TFoundryProject kProject)
{
    local int iDays, iWork;

    iWork = GetWorkPerHour(kProject.iEngineers, kProject.bRush);

    if (iWork == 0)
    {
        return 999;
    }

    iDays = kProject.iHoursLeft / (24 * iWork);

    if ((kProject.iHoursLeft % (24 * iWork)) > 0)
    {
        iDays += 1;
    }

    return iDays;
}

function bool GetFoundryCostSummary(out TCostSummary kCostSummary, int iFoundryTech, bool Brush, optional bool bShowEng)
{
    `LWCE_LOG_DEPRECATED_CLS(GetFoundryCostSummary);

    return false;
}

function bool LWCE_GetFoundryCostSummary(out TCostSummary kCostSummary, name ProjectName, bool Brush, optional bool bShowEng)
{
    return GetCostSummary(kCostSummary, LWCE_GetFoundryProjectCost(ProjectName, Brush), !bShowEng);
}

function string GetFoundryETAString(TFoundryProject kProject)
{
    `LWCE_LOG_DEPRECATED_CLS(GetFoundryETAString);

    return "";
}

function string LWCE_GetFoundryETAString(LWCE_TFoundryProject kProject)
{
    local int iHours, iDays;
    local XGParamTag kTag;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    iHours = kProject.iHoursLeft / (GetWorkPerHour(kProject.iEngineers, kProject.bRush));

    if (iHours < 24)
    {
        kTag.IntValue0 = iHours;
        return class'XComLocalizer'.static.ExpandString(m_strETAHour);
    }
    else
    {
        iDays = iHours / 24;

        if ((iHours % 24) > 0)
        {
            iDays += 1;
        }

        kTag.IntValue0 = iDays;
        return class'XComLocalizer'.static.ExpandString(m_strETADay);
    }
}

function TFoundryProject GetFoundryProject(int iIndex)
{
    local TFoundryProject kProject;

    `LWCE_LOG_DEPRECATED_CLS(GetFoundryProject);

    return kProject;
}

function LWCE_TFoundryProject LWCE_GetFoundryProject(int iIndex)
{
    return m_arrCEFoundryProjects[iIndex];
}

function TProjectCost GetFoundryProjectCost(int iTech, bool bRushFoundry)
{
    local TProjectCost kCost;

    `LWCE_LOG_DEPRECATED_CLS(GetFoundryProjectCost);

    return kCost;
}

function TProjectCost LWCE_GetFoundryProjectCost(name ProjectName, bool bRushFoundry)
{
    local TProjectCost kCost;
    local LWCEFoundryProjectTemplate kTemplate;

    kTemplate = `LWCE_FTECH(ProjectName);

    if (kTemplate == none)
    {
        return kCost;
    }

    kCost = class'LWCETypes'.static.ConvertTCostToProjectCost(kTemplate.GetCost(bRushFoundry));
    kCost.iStaffTypeReq = eStaff_Engineer;
    kCost.iStaffNumReq = kTemplate.iEngineers;

    return kCost;
}

function XComNarrativeMoment GetMusing()
{
    local LWCE_XGFacility_Labs kLabs;

    kLabs = LWCE_XGFacility_Labs(LABS());

    if (m_arrMusingTracker[0] == 0 && AI().GetMonth() >= 1)
    {
        m_arrMusingTracker[0] = 1;
        return `XComNarrativeMoment("EngineeringMusingI");
    }
    else if (m_arrMusingTracker[2] == 0 && kLabs.HasInterrogatedCaptive())
    {
        m_arrMusingTracker[2] = 1;
        return `XComNarrativeMoment("EngineeringMusingIII");
    }
    else if (m_arrMusingTracker[3] == 0 && STORAGE().EverHadItem(`LW_ITEM_ID(FloaterCorpse)))
    {
        m_arrMusingTracker[3] = 1;
        return `XComNarrativeMomentEW("EngineeringMusingIV");
    }
    else if (m_arrMusingTracker[4] == 0 && STORAGE().EverHadItem(`LW_ITEM_ID(EtherealDevice)))
    {
        m_arrMusingTracker[4] = 1;
        return `XComNarrativeMoment("EngineeringMusingV");
    }
    else if (m_arrMusingTracker[5] == 0 && BARRACKS().GetNumPsiSoldiers() > 0)
    {
        m_arrMusingTracker[5] = 1;
        return `XComNarrativeMoment("EngineeringMusingVI");
    }
    else if (m_arrMusingTracker[6] == 0 && BARRACKS().m_iHighestMecRank >= 3)
    {
        m_arrMusingTracker[6] = 1;
        return `XComNarrativeMomentEW("EngineeringMusingVII");
    }
    else if (m_arrMusingTracker[7] == 0 && kLabs.LWCE_IsResearched('Tech_AlienBiocybernetics') && BARRACKS().m_iHighestMecRank == -1)
    {
        m_arrMusingTracker[7] = 1;
        return `XComNarrativeMomentEW("EngineeringMusingVIII");
    }
    else if (m_arrMusingTracker[8] == 0 && kLabs.LWCE_IsResearched('Tech_AlienBiocybernetics') && BARRACKS().m_iHighestMecRank == -1 && STORAGE().GetResource(eResource_Meld) > 200)
    {
        m_arrMusingTracker[8] = 1;
        return `XComNarrativeMomentEW("EngineeringMusingIX");
    }

    return none;
}

function bool LWCE_IsFoundryTechInQueue(name ProjectName)
{
    local int iProject;

    for (iProject = 0; iProject < m_arrCEFoundryProjects.Length; iProject++)
    {
        if (m_arrCEFoundryProjects[iProject].ProjectName == ProjectName)
        {
            return true;
        }
    }

    return false;
}

function bool IsFoundryTechResearched(int iTech)
{
    `LWCE_LOG_DEPRECATED_CLS(IsFoundryTechResearched);

    return false;
}

function bool LWCE_IsFoundryTechResearched(name ProjectName)
{
    return ProjectName == '' || m_arrCEFoundryHistory.Find(ProjectName) != INDEX_NONE;
}

function ModifyFoundryProject(TFoundryProject kProject)
{
    `LWCE_LOG_DEPRECATED_CLS(ModifyFoundryProject);
}

function LWCE_ModifyFoundryProject(LWCE_TFoundryProject kProject)
{
    m_arrCEFoundryProjects[kProject.iIndex].iEngineers = kProject.iEngineers;
    m_arrCEFoundryProjects[kProject.iIndex].bAdjusted = kProject.bAdjusted;
    PayCost(LWCE_GetFoundryProjectCost(kProject.ProjectName, kProject.bRush));
}

function OnFoundryProjectCompleted(int iProjectIndex)
{
    local LWCE_XGGeoscape kGeoscape;
    local name ProjectName;

    kGeoscape = LWCE_XGGeoscape(GEOSCAPE());
    ProjectName = m_arrCEFoundryProjects[iProjectIndex].ProjectName;

    if (m_arrCEFoundryProjects[iProjectIndex].bNotify)
    {
        m_arrOldRebates.AddItem(m_arrCEFoundryProjects[iProjectIndex].kRebate);

        // UE Explorer failed to decompile this line. I've put it together as best I could based on the bytecode and the alert handling code in
        // XGMissionControlUI.UpdateAlert. The decompilation failure seems to have messed up much of the remainder of the function as well, which
        // I have also worked to restore.
        kGeoscape.LWCE_Alert(`LWCE_ALERT('FoundryProjectCompleted').AddName(m_arrCEFoundryProjects[iProjectIndex].ProjectName).AddInt(m_arrOldRebates.Length - 1).Build());
    }

    if (ProjectName == 'Foundry_AlienGrenades')
    {
        BARRACKS().UpdateGrenades(`LW_ITEM_ID(AlienGrenade));
    }

    m_arrCEFoundryHistory.AddItem(ProjectName);

    STAT_AddStat(eRecap_FoundryTechs, 1);

    if (TECHTREE().CheckForSkunkworks())
    {
        Achieve(AT_Skunkworks);
    }

    // Notify mods that a project is complete
    `LWCE_MOD_LOADER.OnFoundryProjectCompleted(m_arrCEFoundryProjects[iProjectIndex], `LWCE_FTECH(m_arrCEFoundryProjects[iProjectIndex].ProjectName));

    // Do this afterwards because it can also contain a mod hook and this order makes the most sense from a modder's perspective
    BARRACKS().UpdateFoundryPerks();
}

function string RecordCanceledFoundryProject(TFoundryProject Project)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordCanceledFoundryProject);

    return "";
}

function string RecordFoundryProjectCompleted(TFoundryProject FinishedProject)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordFoundryProjectCompleted);

    return "";
}

function string RecordStartedFoundryProject(TFoundryProject Project)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordStartedFoundryProject);

    return "";
}

function RemoveFoundryProject(int iIndex)
{
    local int iProject;

    RemoveFoundryProjectFromQueue(iIndex);
    m_arrCEFoundryProjects.Remove(iIndex, 1);

    for (iProject = 0; iProject < m_arrCEFoundryProjects.Length; iProject++)
    {
        ChangeFoundryIndex(m_arrCEFoundryProjects[iProject].iIndex, iProject);
    }
}

function RestoreFoundryFunds(int iIndex)
{
    local TProjectCost kOrigCost;

    if (m_arrCEFoundryProjects[iIndex].kOriginalCost.iCash != 0 || m_arrCEFoundryProjects[iIndex].kOriginalCost.iElerium != 0 || m_arrCEFoundryProjects[iIndex].kOriginalCost.iAlloys != 0)
    {
        kOrigCost = m_arrCEFoundryProjects[iIndex].kOriginalCost;
    }
    else
    {
        kOrigCost = LWCE_GetFoundryProjectCost(m_arrCEFoundryProjects[iIndex].ProjectName, m_arrCEFoundryProjects[iIndex].Brush);
    }

    PayCost(kOrigCost);
}

function UpdateFoundryProjects()
{
    local bool bGeneratedAlert;
    local int iProject, iWorkDone;

    for (iProject = 0; iProject < m_arrCEFoundryProjects.Length; iProject++)
    {
        iWorkDone = GetWorkPerHour(m_arrCEFoundryProjects[iProject].iEngineers, m_arrCEFoundryProjects[iProject].bRush);

        if (m_arrCEFoundryProjects[iProject].iHoursLeft <= iWorkDone)
        {
            // LWCE: base game returns if the geoscape is busy, presumably to stop multiple alerts from stacking up at once.
            // We modify the logic to only do so for projects which will generate alerts. This generally doesn't matter, but
            // it will behave better in modded scenarios where multiple Foundry projects are completed manually via code.
            if ( (GEOSCAPE().IsBusy() || bGeneratedAlert) && m_arrCEFoundryProjects[iProject].bNotify)
            {
                return;
            }

            m_arrCEFoundryProjects[iProject].iHoursLeft = 0;
            OnFoundryProjectCompleted(iProject);
            ITEMTREE().UpdateShips();

            // TODO: put this in the template somehow
            if (m_arrCEFoundryProjects[iProject].ProjectName == 'Foundry_WingtipSparrowhawks')
            {
                for (iWorkDone = 0; iWorkDone < HANGAR().m_arrInts.Length; iWorkDone++)
                {
                    LWCE_XGShip_Interceptor(HANGAR().m_arrInts[iWorkDone]).LWCE_EquipWeapon(255);
                }
            }

            if (m_arrCEFoundryProjects[iProject].bNotify)
            {
                bGeneratedAlert = true;
            }

            RemoveFoundryProject(iProject);
            iProject--;
        }
        else
        {
            m_arrCEFoundryProjects[iProject].iHoursLeft -= iWorkDone;
        }
    }
}

// #endregion

// #region Functions related to items

function AddItemProject(out TItemProject kProject)
{
    `LWCE_LOG_DEPRECATED_CLS(AddItemProject);
}

function LWCE_AddItemProject(out LWCE_TItemProject kProject)
{
    kProject.iIndex = m_arrCEItemProjects.Length;
    kProject.kOriginalCost = LWCE_GetItemProjectCost(kProject.iItemId, kProject.iQuantityLeft, kProject.bRush);
    m_arrCEItemProjects.AddItem(kProject);
    PayCost(kProject.kOriginalCost);
    LWCE_AddItemProjectToQueue(kProject);

    if (kProject.iHoursLeft <= 0)
    {
        kProject.iHoursLeft = 0;
        OnItemProjectCompleted(kProject.iIndex, true);
        RemoveItemProject(kProject.iIndex);
    }
}

function AddItemProjectToQueue(out TItemProject kProject)
{
    `LWCE_LOG_DEPRECATED_CLS(AddItemProjectToQueue);
}

function LWCE_AddItemProjectToQueue(out LWCE_TItemProject kProject)
{
    local TEngQueueItem kQueueItem;

    kQueueItem.bItem = true;
    kQueueItem.iIndex = kProject.iIndex;
    m_arrQueue.AddItem(kQueueItem);
}

function CancelItemProject(int iIndex)
{
    local LWCE_TItemProject kProject;

    kProject = LWCE_GetItemProject(iIndex);

    if (kProject.kOriginalCost.iCash != 0 || kProject.kOriginalCost.iElerium != 0 || kProject.kOriginalCost.iAlloys != 0)
    {
        RefundCost(kProject.kOriginalCost);
    }
    else
    {
        RefundCost(LWCE_GetItemProjectCost(kProject.iItemId, kProject.iQuantityLeft, kProject.bRush));
    }

    RemoveItemProject(iIndex);
    SpillAvailableEngineers();
}

function ChangeItemIndex(int iOldIndex, int iNewIndex)
{
    local int iQueue;

    for (iQueue= 0; iQueue < m_arrQueue.Length; iQueue++)
    {
        if (m_arrQueue[iQueue].bItem && m_arrQueue[iQueue].iIndex == iOldIndex)
        {
            m_arrQueue[iQueue].iIndex = iNewIndex;
            break;
        }
    }

    m_arrCEItemProjects[iNewIndex].iIndex = iNewIndex;
}

function bool GetCostSummary(out TCostSummary kCostSummary, TProjectCost kCost, optional bool bOmitStaff)
{
    local TText txtCost;
    local bool bCanAfford;
    local int iItem, iBarracks;
    local bool bFreeBuild;
    local XGParamTag kTag;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

    if (XComCheatManager(GetALocalPlayerController().CheatManager) != none)
    {
        bFreeBuild = XComCheatManager(GetALocalPlayerController().CheatManager).m_bStrategyAllFacilitiesFree;
    }

    bCanAfford = true;

    if (kCost.iCash > 0 && !bFreeBuild)
    {
        txtCost.StrValue = class'XGScreenMgr'.static.ConvertCashToString(kCost.iCash);
        txtCost.iState = eUIState_Cash;

        if (kCost.iCash > GetResource(eResource_Money) && !bFreeBuild)
        {
            bCanAfford = false;
            txtCost.iState = eUIState_Bad;
            kCostSummary.strHelp = m_strErrInsufficientFunds;
        }

        kCostSummary.arrRequirements.AddItem(txtCost);
    }

    if (kCost.iElerium > 0 && !bFreeBuild)
    {
        txtCost.StrValue = (string(kCost.iElerium) $ "x") @ m_strCostElerium;
        txtCost.iState = eUIState_Elerium;

        if (kCost.iElerium > GetResource(eResource_Elerium) && !bFreeBuild)
        {
            bCanAfford = false;
            txtCost.iState = eUIState_Bad;
            kCostSummary.strHelp = m_strErrInsufficientElerium;
        }

        kCostSummary.arrRequirements.AddItem(txtCost);
    }

    if (kCost.iAlloys > 0 && !bFreeBuild)
    {
        txtCost.StrValue = (string(kCost.iAlloys) $ "x") @ m_strCostAlloys;
        txtCost.iState = eUIState_Alloys;

        if (kCost.iAlloys > GetResource(eResource_Alloys) && !bFreeBuild)
        {
            bCanAfford = false;
            txtCost.iState = eUIState_Bad;
            kCostSummary.strHelp = m_strErrInsufficientAlloys;
        }

        kCostSummary.arrRequirements.AddItem(txtCost);
    }

    if (kCost.arrItems.Length > 0 && !bFreeBuild)
    {
        for (iItem = 0; iItem < kCost.arrItems.Length; iItem++)
        {
            txtCost.StrValue = (string(kCost.arrItemQuantities[iItem]) $ "x") @ `LWCE_ITEM(kCost.arrItems[iItem]).strName;
            txtCost.iState = eUIState_Normal;

            if (kCost.arrItemQuantities[iItem] > STORAGE().GetNumItemsAvailable(kCost.arrItems[iItem]) && !bFreeBuild)
            {
                bCanAfford = false;
                txtCost.iState = eUIState_Bad;
                kCostSummary.strHelp = m_strErrInsufficientItems;
            }

            kCostSummary.arrRequirements.AddItem(txtCost);
        }
    }

    if (!bOmitStaff && kCost.iStaffNumReq > 0 && !bFreeBuild)
    {
        kTag.IntValue0 = kCost.iStaffNumReq;
        kTag.StrValue0 = m_strCostEngineers;
        txtCost.StrValue = class'XComLocalizer'.static.ExpandString(m_strCostLabel);
        txtCost.iState = eUIState_Normal;

        if (GetNumEngineersAvailable() < kCost.iStaffNumReq)
        {
            bCanAfford = false;
            txtCost.iState = eUIState_Bad;
            kCostSummary.strHelp = m_strErrInsufficientEngineers;
        }

        kCostSummary.arrRequirements.AddItem(txtCost);
    }

    if (kCost.iBarracksReq > 0)
    {
        iBarracks = BARRACKS().GetNumSoldiers() + HQ().GetStaffOnOrder(eStaff_Soldier) + GetNumShivsOrdered() + kCost.iBarracksReq;
        kTag.IntValue0 = kCost.iBarracksReq;
        txtCost.StrValue = class'XComLocalizer'.static.ExpandString(m_strCostBarracks);
        txtCost.iState = eUIState_Normal;

        if (iBarracks > HQ().GetSoldierCapacity())
        {
            bCanAfford = false;
            txtCost.iState = eUIState_Bad;
            kCostSummary.strHelp = m_strErrBarracksFull;
        }

        kCostSummary.arrRequirements.AddItem(txtCost);
    }

    return bCanAfford;
}

function string GetETAString(TItemProject kProject)
{
    `LWCE_LOG_DEPRECATED_CLS(GetETAString);
    return "";
}

function string LWCE_GetETAString(LWCE_TItemProject kProject)
{
    local int iHours, iDays;
    local XGParamTag kTag;

    if (kProject.iEngineers == 0)
    {
        return "--";
    }

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    iHours = LWCE_GetItemProjectHoursRemaining(kProject);

    if (iHours < 24)
    {
        kTag.IntValue0 = iHours;
        return class'XComLocalizer'.static.ExpandString(m_strETAHour);
    }

    iDays = iHours / 24;

    if ((iHours % 24) > 0)
    {
        iDays += 1;
    }

    kTag.IntValue0 = iDays;
    return class'XComLocalizer'.static.ExpandString(m_strETADay);
}

function GetEvents(out array<THQEvent> arrEvents)
{
    `LWCE_LOG_DEPRECATED_CLS(GetEvents);
}

function LWCE_GetEvents(out array<LWCE_THQEvent> arrEvents)
{
    LWCE_GetItemEvents(arrEvents);
    LWCE_GetFacilityEvents(arrEvents);
    LWCE_GetFoundryEvents(arrEvents);
}

function GetFacilityEvents(out array<THQEvent> arrEvents)
{
    `LWCE_LOG_DEPRECATED_CLS(GetFacilityEvents);
}

function LWCE_GetFacilityEvents(out array<LWCE_THQEvent> arrEvents)
{
    local int iFacilityProject, iEvent;
    local LWCE_TData kData;
    local LWCE_THQEvent kBlankEvent, kEvent;
    local bool bAdded;

    for (iFacilityProject = 0; iFacilityProject < m_arrFacilityProjects.Length; iFacilityProject++)
    {
        kEvent = kBlankEvent;
        kEvent.EventType = 'Facility';
        kEvent.iHours = m_arrFacilityProjects[iFacilityProject].iHoursLeft;

        if (m_arrFacilityProjects[iFacilityProject].bRush)
        {
            kEvent.iHours *= 0.50;
        }

        kData.eType = eDT_Int;
        kData.iData = m_arrFacilityProjects[iFacilityProject].eFacility;
        kEvent.arrData.AddItem(kData);

        bAdded = false;

        for (iEvent = 0; iEvent < arrEvents.Length; iEvent++)
        {
            if (arrEvents[iEvent].iHours > kEvent.iHours)
            {
                arrEvents.InsertItem(iEvent, kEvent);
                bAdded = true;
                break;
            }
        }

        if (!bAdded)
        {
            arrEvents.AddItem(kEvent);
        }
    }
}

function GetFoundryEvents(out array<THQEvent> arrEvents)
{
    `LWCE_LOG_DEPRECATED_CLS(GetFoundryEvents);
}

function LWCE_GetFoundryEvents(out array<LWCE_THQEvent> arrEvents)
{
    local int iFoundryProject, iEvent;
    local LWCE_TData kData;
    local LWCE_THQEvent kBlankEvent, kEvent;
    local bool bAdded;
    local int iWorkDone;

    for (iFoundryProject = 0; iFoundryProject < m_arrCEFoundryProjects.Length; iFoundryProject++)
    {
        if (!m_arrCEFoundryProjects[iFoundryProject].bNotify)
        {
            continue;
        }

        iWorkDone = GetWorkPerHour(m_arrCEFoundryProjects[iFoundryProject].iEngineers, m_arrCEFoundryProjects[iFoundryProject].bRush);

        kEvent = kBlankEvent;
        kEvent.EventType = 'Foundry';
        kEvent.iHours = m_arrCEFoundryProjects[iFoundryProject].iHoursLeft / iWorkDone;

        if ((m_arrCEFoundryProjects[iFoundryProject].iHoursLeft % iWorkDone) > 0)
        {
            kEvent.iHours += 1;
        }

        kData.eType = eDT_Name;
        kData.nmData = m_arrCEFoundryProjects[iFoundryProject].ProjectName;
        kEvent.arrData.AddItem(kData);

        bAdded = false;

        for (iEvent = 0; iEvent < arrEvents.Length; iEvent++)
        {
            if (arrEvents[iEvent].iHours > kEvent.iHours)
            {
                arrEvents.InsertItem(iEvent, kEvent);
                bAdded = true;
                break;
            }
        }

        if (!bAdded)
        {
            arrEvents.AddItem(kEvent);
        }
    }
}

function bool GetItemCostSummary(out TCostSummary kCostSummary, EItemType eItem, optional int iQuantity = 1, optional bool Brush, optional bool bShowEng, optional int iProjectIndex = -1)
{
    `LWCE_LOG_DEPRECATED_CLS(GetItemCostSummary);
    return false;
}

function bool LWCE_GetItemCostSummary(out TCostSummary kCostSummary, int iItemId, optional int iQuantity = 1, optional bool bRush, optional bool bShowEng, optional int iProjectIndex = -1)
{
    local bool bCanAfford;
    local TProjectCost kCost;

    if (iProjectIndex >= m_arrCEItemProjects.Length)
    {
        return false;
    }

    if (iProjectIndex != -1 && m_arrCEItemProjects[iProjectIndex].kOriginalCost.iCash != 0)
    {
        kCost = m_arrCEItemProjects[iProjectIndex].kOriginalCost;
    }
    else
    {
        kCost = LWCE_GetItemProjectCost(iItemId, iQuantity, bRush);
    }

    bCanAfford = GetCostSummary(kCostSummary, kCost, !bShowEng);
    return bCanAfford;
}

function GetItemEvents(out array<THQEvent> arrEvents)
{
    `LWCE_LOG_DEPRECATED_CLS(GetItemEvents);
}

function LWCE_GetItemEvents(out array<LWCE_THQEvent> arrEvents)
{
    local int iItemProject, iEvent;
    local LWCE_TData kData;
    local LWCE_THQEvent kBlankEvent, kEvent;
    local bool bAdded;

    for (iItemProject = 0; iItemProject < m_arrCEItemProjects.Length; iItemProject++)
    {
        if (m_arrCEItemProjects[iItemProject].iEngineers == 0 || !m_arrCEItemProjects[iItemProject].bNotify)
        {
            continue;
        }

        kEvent = kBlankEvent;
        kEvent.EventType = 'ItemProject';
        kEvent.iHours = LWCE_GetItemProjectHoursRemaining(m_arrCEItemProjects[iItemProject]);

        kData.eType = eDT_Int;
        kData.iData = m_arrCEItemProjects[iItemProject].iItemId;
        kEvent.arrData.AddItem(kData);

        kData.eType = eDT_Int;
        kData.iData = m_arrCEItemProjects[iItemProject].iQuantity;
        kEvent.arrData.AddItem(kData);

        bAdded = false;

        for (iEvent = 0; iEvent < arrEvents.Length; iEvent++)
        {
            if (arrEvents[iEvent].iHours > kEvent.iHours)
            {
                arrEvents.InsertItem(iEvent, kEvent);
                bAdded = true;
                break;
            }
        }

        if (!bAdded)
        {
            arrEvents.AddItem(kEvent);
        }
    }
}

function TItemProject GetItemProject(int iIndex)
{
    local TItemProject kProject;

    `LWCE_LOG_DEPRECATED_CLS(GetItemProject);

    return kProject;
}

function LWCE_TItemProject LWCE_GetItemProject(int iIndex)
{
    return m_arrCEItemProjects[iIndex];
}

function int GetItemProjectHoursRemaining(TItemProject kProject)
{
    `LWCE_LOG_DEPRECATED_CLS(GetItemProjectHoursRemaining);
    return 0;
}

function int LWCE_GetItemProjectHoursRemaining(LWCE_TItemProject kProject)
{
    local int iTotalHours, iHours, iNumEngineers, iWorkDone;

    iNumEngineers = kProject.iEngineers;

    if (iNumEngineers == 0)
    {
        return -1;
    }

    iWorkDone = GetWorkPerHour(iNumEngineers, kProject.bRush);
    iTotalHours = kProject.iHoursLeft;
    iHours = iTotalHours / iWorkDone;

    if ((iTotalHours % iWorkDone) > 0)
    {
        iHours += 1;
    }

    return iHours;
}

function TProjectCost GetItemProjectCost(EItemType eItem, int iQuantity, optional bool bRush)
{
    `LWCE_LOG_DEPRECATED_CLS(GetItemProjectCost);
    return super.GetItemProjectCost(eItem, iQuantity, bRush);
}

function TProjectCost LWCE_GetItemProjectCost(int iItemId, int iQuantity, optional bool bRush)
{
    local LWCE_TItem kItem;
    local LWCE_TCost kCECost;
    local TProjectCost kCost;
    local int iItemQuant;

    kItem = `LWCE_ITEM(iItemId);
    kCECost = kItem.kCost;

    // Do this while it's still an LWCE_TCost, for simplicity
    if (bRush)
    {
        kCECost.iMeld += 2 + (kCECost.iCash / 40);
    }

    kCost = class'LWCETypes'.static.ConvertTCostToProjectCost(kCECost);
    kCost.iStaffTypeReq = eStaff_Engineer;
    kCost.iStaffNumReq = kItem.iMaxEngineers;

    for (iItemQuant = 0; iItemQuant < kCost.arrItemQuantities.Length; iItemQuant++)
    {
        kCost.arrItemQuantities[iItemQuant] *= float(iQuantity);
    }

    kCost.iCash = kCost.iCash * iQuantity;
    kCost.iElerium = kCost.iElerium * iQuantity;
    kCost.iAlloys = kCost.iAlloys * iQuantity;

    if (bRush)
    {
        kCost.iCash    *= 1.5;
        kCost.iElerium *= 1.5;
        kCost.iAlloys  *= 1.5;
    }

    switch (iItemId)
    {
        case eItem_SHIV:
        case eItem_SHIV_Alloy:
        case eItem_SHIV_Hover:
            kCost.iBarracksReq = iQuantity;
            break;
        default:
            kCost.iBarracksReq = 0;
            break;
    }

    return kCost;
}

function array<TItem> GetItemsByCategory(int iCategory, int iTransactionType)
{
    local array<TItem> arrItems;
    arrItems.Add(0);

    `LWCE_LOG_DEPRECATED_CLS(GetItemsByCategory);

    return arrItems;
}

function array<LWCE_TItem> LWCE_GetItemsByCategory(int iCategory, int iTransactionType)
{
    if (iTransactionType == eTransaction_Build)
    {
        return `LWCE_ITEMTREE.LWCE_GetBuildItems(iCategory);
    }
    else
    {
        return `LWCE_STORAGE.LWCE_GetItemsInCategory(iCategory, iTransactionType);
    }
}

function GrantInitialStores()
{
    m_kStorage.AddItem(`LW_ITEM_ID(Interceptor), 4);   // Interceptor
    m_kStorage.AddItem(`LW_ITEM_ID(Skyranger), 1);   // Skyranger

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(AncientArtifact)) > 0)
    {
        m_kStorage.AddItem(HQ().HasBonus(`LW_HQ_BONUS_ID(AncientArtifact)), 1);
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(JaiJawan)) > 0)
    {
        m_kStorage.AddItem(`LW_ITEM_ID(Interceptor), 2);
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(GhostInTheMachine)) > 0)
    {
        m_kStorage.AddItem(`LW_ITEM_ID(SHIV), 2);
    }
}

function bool IsBuildingItem(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_CLS(IsBuildingItem);

    return false;
}

function bool LWCE_IsBuildingItem(int iItemId)
{
    local int iProject;

    for (iProject = 0; iProject < m_arrCEItemProjects.Length; iProject++)
    {
        if (m_arrCEItemProjects[iProject].iItemId == iItemId)
        {
            return true;
        }
    }

    return false;
}

function bool IsCorpseItem(int iItem)
{
    `LWCE_LOG_CLS("XGFacility_Engineering.IsCorpseItem is deprecated in LWCE. Use LWCE_XGItemTree.LWCE_IsCorpse instead. Stack trace follows.");
    ScriptTrace();

    return false;
}

function bool IsPriorityItem(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_CLS(IsPriorityItem);
    return false;
}

function bool LWCE_IsPriorityItem(int iItemId)
{
    // TODO add mod hook

    switch (iItemId)
    {
        case `LW_ITEM_ID(SkeletonKey):
            return true;
        case `LW_ITEM_ID(ArcThrower):
            if (STORAGE().EverHadItem(`LW_ITEM_ID(OutsiderShard)))
            {
                return false;
            }
            else if (STORAGE().GetNumItemsAvailable(`LW_ITEM_ID(ArcThrower)) <= 0)
            {
                return true;
            }

            break;
        case `LW_ITEM_ID(Firestorm):
            if (!STORAGE().EverHadItem(`LW_ITEM_ID(Firestorm)) && OBJECTIVES().m_eObjective == eObj_ShootDownOverseer)
            {
                return true;
            }

            break;
    }

    return false;
}

function ModifyItemProject(TItemProject kProject)
{
    `LWCE_LOG_DEPRECATED_CLS(ModifyItemProject);
}

function LWCE_ModifyItemProject(LWCE_TItemProject kProject)
{
    m_arrCEItemProjects[kProject.iIndex].iQuantityLeft = kProject.iQuantityLeft;
    m_arrCEItemProjects[kProject.iIndex].iQuantity = kProject.iQuantity;
    m_arrCEItemProjects[kProject.iIndex].iEngineers = kProject.iEngineers;
    m_arrCEItemProjects[kProject.iIndex].bAdjusted = kProject.bAdjusted;
    m_arrCEItemProjects[kProject.iIndex].bRush = kProject.bRush;

    PayCost(LWCE_GetItemProjectCost(m_arrCEItemProjects[kProject.iIndex].iItemId, m_arrCEItemProjects[kProject.iIndex].iQuantityLeft, m_arrCEItemProjects[kProject.iIndex].bRush));
}

function OnItemCompleted(int iItemProject, int iQuantity, optional bool bInstant)
{
    local TProjectCost kRebate, kOrigCost;

    kOrigCost = LWCE_GetItemProjectCost(m_arrCEItemProjects[iItemProject].iItemId, 1);

    if (!bInstant && HasRebate() && CalcWorkshopRebate(kOrigCost, kRebate))
    {
        m_arrCEItemProjects[iItemProject].kRebate.iCash += kRebate.iCash * iQuantity;
        m_arrCEItemProjects[iItemProject].kRebate.iAlloys += kRebate.iAlloys * iQuantity;
        m_arrCEItemProjects[iItemProject].kRebate.iElerium += kRebate.iElerium * iQuantity;

        // Seems like LW rerouted the cash rebates (which aren't used in LW) to add Meld instead,
        // but ultimately didn't end up doing Meld rebates after all
        AddResource(eResource_Meld, kRebate.iCash * iQuantity, true);
        AddResource(eResource_Alloys, kRebate.iAlloys * iQuantity, true);
        AddResource(eResource_Elerium, kRebate.iElerium * iQuantity, true);
    }

    if (!bInstant)
    {
        PRES().Notify(eGA_NewItemBuilt, m_arrCEItemProjects[iItemProject].iItemId, iQuantity);
    }

    STORAGE().AddItem(m_arrCEItemProjects[iItemProject].iItemId, iQuantity);

    if (m_arrCEItemProjects[iItemProject].iItemId == `LW_ITEM_ID(Firestorm))
    {
        HANGAR().PlayFirestormBuiltCinematic();
    }
    else if (m_arrCEItemProjects[iItemProject].iItemId == `LW_ITEM_ID(LaserRifle))
    {
        PRES().UINarrative(`XComNarrativeMoment("EngineeringLaser"));
    }
    else if (m_arrCEItemProjects[iItemProject].iItemId == `LW_ITEM_ID(PlasmaRifle))
    {
        PRES().UINarrative(`XComNarrativeMoment("EngineeringPlasma"));
    }

    switch (m_arrCEItemProjects[iItemProject].iItemId)
    {
        case `LW_ITEM_ID(PlasmaCarbine):
        case `LW_ITEM_ID(PlasmaRifle):
        case `LW_ITEM_ID(PlasmaNovagun):
        case `LW_ITEM_ID(PlasmaSniperRifle):
            if (STAT_GetStat(eRecap_FirstAlienWeapon) == 0)
            {
                STAT_SetStat(eRecap_FirstAlienWeapon, Game().GetDays());
            }

            break;
        case `LW_ITEM_ID(BlasterLauncher):
            if (STAT_GetStat(eRecap_FirstBlaster) == 0)
            {
                STAT_SetStat(eRecap_FirstBlaster, Game().GetDays());
            }

            break;
        case `LW_ITEM_ID(CarapaceArmor):
            if (STAT_GetStat(eRecap_FirstCarapace) == 0)
            {
                STAT_SetStat(eRecap_FirstCarapace, Game().GetDays());
            }

            break;
        case `LW_ITEM_ID(CorsairArmor):
            if (STAT_GetStat(eRecap_FirstSkeleton) == 0)
            {
                STAT_SetStat(eRecap_FirstSkeleton, Game().GetDays());
            }

            break;
        case `LW_ITEM_ID(SHIV):
            PRES().UINarrative(`XComNarrativeMoment("EngineeringSHIVI"),,,, HQ().m_kBase.GetFacility3DLocation(eFacility_Foundry));
            Achieve(AT_IsEveryoneOk);
            break;
        case `LW_ITEM_ID(AlloySHIV):
            PRES().UINarrative(`XComNarrativeMoment("EngineeringSHIVII"),,,, HQ().m_kBase.GetFacility3DLocation(eFacility_Foundry));
            Achieve(AT_IsEveryoneOk);
            break;
        case `LW_ITEM_ID(HoverSHIV):
            PRES().UINarrative(`XComNarrativeMoment("EngineeringSHIVIII"),,,, HQ().m_kBase.GetFacility3DLocation(eFacility_Foundry));
            Achieve(AT_IsEveryoneOk);
            break;
        case `LW_ITEM_ID(Firestorm):
            Achieve(AT_RideTheLightning);

            if (STAT_GetStat(eRecap_FirstFirestorm) == 0)
            {
                STAT_SetStat(eRecap_FirstFirestorm, Game().GetDays());
            }

            break;
        case `LW_ITEM_ID(TitanArmor):
            Achieve(AT_ManNoMore);

            if (STAT_GetStat(eRecap_FirstTitan) == 0)
            {
                STAT_SetStat(eRecap_FirstTitan, Game().GetDays());
            }

            break;
        case `LW_ITEM_ID(ArchangelArmor):
            Achieve(AT_ManNoMore);
            break;
        case `LW_ITEM_ID(VortexArmor):
            Achieve(AT_ManNoMore);

            if (STAT_GetStat(eRecap_FirstPsiArmor) == 0)
            {
                STAT_SetStat(eRecap_FirstPsiArmor, Game().GetDays());
            }

            break;
        case `LW_ITEM_ID(ShadowArmor):
            Achieve(AT_ManNoMore);

            if (STAT_GetStat(eRecap_FirstGhost) == 0)
            {
                STAT_SetStat(eRecap_FirstGhost, Game().GetDays());
            }

            break;
        case `LW_ITEM_ID(LaserCannon):
            if (STAT_GetStat(eRecap_FirstIntLaser) == 0)
            {
                STAT_SetStat(eRecap_FirstIntLaser, Game().GetDays());
            }

            break;
        case `LW_ITEM_ID(PlasmaCannon):
            if (STAT_GetStat(eRecap_FirstIntPlasma) == 0)
            {
                STAT_SetStat(eRecap_FirstIntPlasma, Game().GetDays());
            }

            break;
        case `LW_ITEM_ID(EMPCannon):
            if (STAT_GetStat(eRecap_FirstIntEMP) == 0)
            {
                STAT_SetStat(eRecap_FirstIntEMP, Game().GetDays());
            }

            break;
        case `LW_ITEM_ID(FusionLance):
            if (STAT_GetStat(eRecap_FirstIntFusion) == 0)
            {
                STAT_SetStat(eRecap_FirstIntFusion, Game().GetDays());
            }

            break;
    }

    STAT_AddStat(eRecap_ItemsBuilt, iQuantity);
    Achieve(AT_CombatReady);
}

function OnItemProjectCompleted(int iProject, optional bool bInstant)
{
    local LWCE_TGeoscapeAlert kAlert;

    if (bInstant)
    {
        OnItemCompleted(iProject, m_arrCEItemProjects[iProject].iQuantity, true);
    }
    else if (m_arrCEItemProjects[iProject].bNotify)
    {
        m_arrOldRebates.AddItem(m_arrCEItemProjects[iProject].kRebate);

        kAlert = `LWCE_ALERT('ItemProjectCompleted').AddInt(m_arrCEItemProjects[iProject].iItemId).AddInt(m_arrCEItemProjects[iProject].iQuantity).AddInt(m_arrOldRebates.Length - 1).Build();
        LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(kAlert);
    }

    `LWCE_MOD_LOADER.OnItemCompleted(m_arrCEItemProjects[iProject], m_arrCEItemProjects[iProject].iQuantity, bInstant);
}

function string RecordCanceledItemConstruction(TItemProject Project)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordCanceledItemConstruction);

    return "";
}

function string RecordItemsBuilt(EItemType ItemType, int ItemQuantity)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordItemsBuilt);

    return "";
}

function RemoveItemProject(int iIndex)
{
    local int iProject;

    `LWCE_LOG_CLS("Removing item project at index " $ iIndex);
    RemoveItemProjectFromQueue(iIndex);
    m_arrCEItemProjects.Remove(iIndex, 1);

    for (iProject = 0; iProject < m_arrCEItemProjects.Length; iProject++)
    {
        ChangeItemIndex(m_arrCEItemProjects[iProject].iIndex, iProject);
    }
}

function RestoreItemFunds(int iIndex)
{
    local TProjectCost kOrigCost;

    if (m_arrCEItemProjects[iIndex].kOriginalCost.iCash != 0 || m_arrCEItemProjects[iIndex].kOriginalCost.iElerium != 0 || m_arrCEItemProjects[iIndex].kOriginalCost.iAlloys != 0)
    {
        kOrigCost = m_arrCEItemProjects[iIndex].kOriginalCost;
    }
    else
    {
        kOrigCost = LWCE_GetItemProjectCost(m_arrCEItemProjects[iIndex].iItemId, m_arrCEItemProjects[iIndex].iQuantityLeft, m_arrCEItemProjects[iIndex].bRush);
    }

    PayCost(kOrigCost);
}

function string RecordStartedItemConstruction(TItemProject Project)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordStartedItemConstruction);

    return "";
}

function UpdateItemProject()
{
    local int iItemsProduced, iEngHours, iUnitHours, iProject;

    if (m_arrCEItemProjects.Length == 0)
    {
        return;
    }

    for (iProject = 0; iProject < m_arrCEItemProjects.Length; iProject++)
    {
        if (m_arrCEItemProjects[iProject].iEngineers == 0)
        {
            continue;
        }

        iEngHours = GetWorkPerHour(m_arrCEItemProjects[iProject].iEngineers, m_arrCEItemProjects[iProject].bRush);

        // TODO: a lot of the below seems to only apply to a system where items are built individually in an order,
        // so this can probably be cleaned up quite a bit
        if (m_arrCEItemProjects[iProject].iHoursLeft <= iEngHours)
        {
            if (GEOSCAPE().IsBusy())
            {
                return;
            }

            iEngHours -= m_arrCEItemProjects[iProject].iHoursLeft;
            iUnitHours = `LWCE_ITEM(m_arrCEItemProjects[iProject].iItemId).iHours;
            iItemsProduced = m_arrCEItemProjects[iProject].iQuantityLeft;
            iItemsProduced += (iEngHours / iUnitHours);
            m_arrCEItemProjects[iProject].iHoursLeft = iUnitHours - (iEngHours % iUnitHours);

            if (iItemsProduced > m_arrCEItemProjects[iProject].iQuantityLeft)
            {
                iItemsProduced = m_arrCEItemProjects[iProject].iQuantityLeft;
            }

            m_arrCEItemProjects[iProject].iQuantityLeft -= iItemsProduced;
            OnItemCompleted(iProject, iItemsProduced);

            if (m_arrCEItemProjects[iProject].iQuantityLeft == 0)
            {
                OnItemProjectCompleted(iProject);
                RemoveItemProject(iProject);
            }
            else
            {
                m_arrCEItemProjects[iProject].iMaxEngineers -= (iItemsProduced * `LWCE_ITEM(m_arrCEItemProjects[iProject].iItemId).iMaxEngineers);
            }
        }
        else
        {
            m_arrCEItemProjects[iProject].iHoursLeft -= iEngHours;
        }
    }

    SpillAvailableEngineers();
}

// #endregion

// #region Miscellaneous functions

function OnAlloyProjectCompleted(int iProject)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(OnAlloyProjectCompleted);
}

function bool UrgeBuildMEC()
{
    local LWCE_XGStorage kStorage;
    local array<LWCE_TItem> arrMecSuits;
    local XGStrategySoldier kSoldier;
    local int NumMecs;

    if (m_bUrgeBuildMEC)
    {
        return false;
    }

    kStorage = `LWCE_STORAGE;
    arrMecSuits = kStorage.LWCE_GetItemsInCategory(eItemCat_Armor, eTransaction_None, eSC_Mec);

    foreach BARRACKS().m_arrSoldiers(kSoldier)
    {
        if (kSoldier.IsAugmented())
        {
            NumMecs++;
        }
    }

    if (NumMecs > arrMecSuits.Length)
    {
        if (kStorage.GetResource(eResource_Meld) > 99)
        {
            m_bUrgeBuildMEC = true;
        }
    }

    return m_bUrgeBuildMEC;
}

// #endregion