class LWCE_XGFacility_Engineering extends XGFacility_Engineering
    dependson(LWCETypes);

struct CheckpointRecord_LWCE_XGFacility_Engineering extends CheckpointRecord_XGFacility_Engineering
{
    var array<LWCE_TItemProject> m_arrCEItemProjects;
    var array<int> m_arrCEFoundryHistory;
};

var array<LWCE_TItemProject> m_arrCEItemProjects;
var array<int> m_arrCEFoundryHistory;

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

    m_arrCEFoundryHistory.AddItem(0);

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(Resourceful)) > 0)
    {
        m_arrCEFoundryHistory.AddItem(HQ().HasBonus(`LW_HQ_BONUS_ID(Resourceful))); // Alien Metallurgy
        m_arrCEFoundryHistory.AddItem(39); // Improved Salvage
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(JaiJawan)) > 0)
    {
        m_arrCEFoundryHistory.AddItem(HQ().HasBonus(`LW_HQ_BONUS_ID(JaiJawan))); // Elerium Afterburners
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(SukhoiCompany)) > 0)
    {
        m_arrCEFoundryHistory.AddItem(HQ().HasBonus(`LW_HQ_BONUS_ID(SukhoiCompany))); // Improved Avionics
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(JungleScoutsOld)) > 0)
    {
        m_arrCEFoundryHistory.AddItem(HQ().HasBonus(`LW_HQ_BONUS_ID(JungleScoutsOld))); // Tactical Rigging
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(TheirFinestHour)) > 0)
    {
        m_arrCEFoundryHistory.AddItem(HQ().HasBonus(`LW_HQ_BONUS_ID(TheirFinestHour))); // Penetrator Weapons
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(ForTheSakeOfGlory)) > 0)
    {
        m_arrCEFoundryHistory.AddItem(HQ().HasBonus(`LW_HQ_BONUS_ID(ForTheSakeOfGlory))); // Advanced Repair
    }

    m_bRequiresAttention = true;
    m_bCanBuildFacilities = true;
    m_bCanBuildItems = true;
    m_iEngineerReminder = 45 * 24;
    m_iEleriumHalfLife = int(class'XGTacticalGameCore'.default.SW_ELERIUM_HALFLIFE);
}

// #region Functions related to the Foundry

function AddFoundryProject(out TFoundryProject kProject)
{
    kProject.iIndex = m_arrFoundryProjects.Length;
    kProject.kOriginalCost = GetFoundryProjectCost(kProject.eTech, kProject.Brush);
    m_arrFoundryProjects.AddItem(kProject);

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(RecordStartedFoundryProject(kProject));
    }

    PayCost(kProject.kOriginalCost);
    AddFoundryProjectToQueue(kProject);
    PRES().GetMgr(class'LWCE_XGFoundryUI').UpdateView();
    m_bStartedFoundryProject = true;

    // Notify mods of this project
    `LWCE_MOD_LOADER.OnFoundryProjectAddedToQueue(kProject, `LWCE_FTECH(kProject.eTech));
}

function bool CanAddFoundryProject()
{
    return HQ().m_arrBaseFacilities[eFacility_Foundry] > 0;
}

function CancelFoundryProject(int iIndex)
{
    local TFoundryProject kProject;

    kProject = GetFoundryProject(iIndex);

    if (kProject.kOriginalCost.iCash != 0 || kProject.kOriginalCost.iElerium != 0 || kProject.kOriginalCost.iAlloys != 0)
    {
        RefundCost(kProject.kOriginalCost);
    }
    else
    {
        RefundCost(GetFoundryProjectCost(kProject.eTech, kProject.Brush));
    }

    RemoveFoundryProject(kProject.iIndex);

    // Notify mods that a project is canceled
    `LWCE_MOD_LOADER.OnFoundryProjectCanceled(kProject, `LWCE_FTECH(kProject.eTech));
}

function TProjectCost GetFoundryProjectCost(int iTech, bool bRushFoundry)
{
    local TProjectCost kCost;
    local LWCE_TFoundryTech kTech;

    kTech = `LWCE_FTECH(iTech);

    kCost = class'LWCETypes'.static.ConvertTCostToProjectCost(kTech.kCost);
    kCost.iStaffTypeReq = eStaff_Engineer;
    kCost.iStaffNumReq = kTech.iEngineers;

    if (bRushFoundry)
    {
        kCost.iCash *= 1.50;
        kCost.iElerium *= 1.50;
        kCost.iAlloys *= 1.50;
        kCost.arrItems.AddItem(eItem_Meld);
        kCost.arrItemQuantities.AddItem(16);
    }

    return kCost;
}

function bool LWCE_IsFoundryTechInQueue(int iTechId)
{
    local int iProject;

    for (iProject = 0; iProject < m_arrFoundryProjects.Length; iProject++)
    {
        if (m_arrFoundryProjects[iProject].eTech == iTechId)
        {
            return true;
        }
    }

    return false;
}

function bool IsFoundryTechResearched(int iTech)
{
    return iTech == 0 || m_arrCEFoundryHistory.Find(iTech) != INDEX_NONE;
}

function OnFoundryProjectCompleted(int iProject)
{
    local int iFoundryTechId;

    iFoundryTechId = m_arrFoundryProjects[iProject].eTech;

    if (m_arrFoundryProjects[iProject].bNotify)
    {
        // TODO: remove rebates entirely from Foundry projects and related code
        m_arrOldRebates.AddItem(m_arrFoundryProjects[iProject].kRebate);

        // UE Explorer failed to decompile this line. I've put it together as best I could based on the bytecode and the alert handling code in
        // XGMissionControlUI.UpdateAlert. The decompilation failure seems to have messed up much of the remainder of the function as well, which
        // I have also worked to restore.
        GEOSCAPE().Alert(GEOSCAPE().MakeAlert(eGA_FoundryProjectCompleted, m_arrFoundryProjects[iProject].eTech, m_arrOldRebates.Length - 1));
    }

    if (iFoundryTechId == `LW_FOUNDRY_ID(AlienGrenades))
    {
        BARRACKS().UpdateGrenades(`LW_ITEM_ID(AlienGrenade));
    }

    m_arrCEFoundryHistory.AddItem(iFoundryTechId);

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(RecordFoundryProjectCompleted(m_arrFoundryProjects[iProject]));
    }

    STAT_AddStat(eRecap_FoundryTechs, 1);

    if (TECHTREE().CheckForSkunkworks())
    {
        Achieve(AT_Skunkworks);
    }

    // Notify mods that a project is complete
    `LWCE_MOD_LOADER.OnFoundryProjectCompleted(m_arrFoundryProjects[iProject], `LWCE_FTECH(m_arrFoundryProjects[iProject].eTech));

    // Do this afterwards because it can also contain a mod hook and this order makes the most sense from a modder's perspective
    BARRACKS().UpdateFoundryPerks();
}

function string RecordCanceledFoundryProject(TFoundryProject Project)
{
    local LWCE_TFoundryTech kTech;
    local string OutputString;

    kTech = `LWCE_FTECH(Project.eTech);
    OutputString = GEOSCAPE().m_kDateTime.GetDateString() @ GEOSCAPE().m_kDateTime.GetTimeString() @ ": Canceled foundry project " $ kTech.strName $ "\n";
    return OutputString;
}

function string RecordFoundryProjectCompleted(TFoundryProject FinishedProject)
{
    local LWCE_TFoundryTech kTech;
    local string OutputString;

    kTech = `LWCE_FTECH(FinishedProject.eTech);
    OutputString = GEOSCAPE().m_kDateTime.GetDateString() @ GEOSCAPE().m_kDateTime.GetTimeString() @ ": Finished foundry project for " $ kTech.strName $ "\n";
    return OutputString;
}

function string RecordStartedFoundryProject(TFoundryProject Project)
{
    local LWCE_TFoundryTech kTech;
    local string OutputString;

    kTech = `LWCE_FTECH(Project.eTech);
    OutputString = GEOSCAPE().m_kDateTime.GetDateString() @ GEOSCAPE().m_kDateTime.GetTimeString() @ ": Started foundry project " $ kTech.strName $ "\n";
    return OutputString;
}

function UpdateFoundryProjects()
{
    local int iProject, iWorkDone;

    for (iProject = 0; iProject < m_arrFoundryProjects.Length; iProject++)
    {
        iWorkDone = GetWorkPerHour(m_arrFoundryProjects[iProject].iEngineers, m_arrFoundryProjects[iProject].Brush);

        if (m_arrFoundryProjects[iProject].iHoursLeft <= iWorkDone)
        {
            if (GEOSCAPE().IsBusy())
            {
                return;
            }

            m_arrFoundryProjects[iProject].iHoursLeft = 0;
            OnFoundryProjectCompleted(iProject);
            ITEMTREE().UpdateShips();

            if (m_arrFoundryProjects[iProject].eTech == 27) // Wingtip Sparrowhawks
            {
                for (iWorkDone = 0; iWorkDone < HANGAR().m_arrInts.Length; iWorkDone++)
                {
                    HANGAR().m_arrInts[iWorkDone].EquipWeapon(255);
                }
            }

            RemoveFoundryProject(iProject);
            return;
        }
        else
        {
            m_arrFoundryProjects[iProject].iHoursLeft -= iWorkDone;
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
    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(LWCE_RecordStartedItemConstruction(kProject));
    }

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

function bool GetItemCostSummary(out TCostSummary kCostSummary, EItemType eItem, optional int iQuantity = 1, optional bool Brush, optional bool bShowEng, optional int iProjectIndex = -1)
{
    `LWCE_LOG_DEPRECATED_CLS(GetItemCostSummary);
    return false;
}

function bool LWCE_GetItemCostSummary(out TCostSummary kCostSummary, int iItemId, optional int iQuantity = 1, optional bool bRush, optional bool bShowEng, optional int iProjectIndex = -1)
{
    local bool bCanAfford;
    local TProjectCost kCost;

    // TODO: possibly delete this, vanilla doesn't need a similar block
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

function bool IsCorpseItem(int iItem)
{
    `LWCE_LOG_CLS("XGFacility_Engineering.IsCorpseItem is deprecated in LWCE. Use LWCE_XGItemTree.LWCE_IsCorpse instead. Stack trace follows.");
    ScriptTrace();

    return false;
}

function GetItemEvents(out array<THQEvent> arrEvents)
{
    local int iItemProject, iEvent;
    local THQEvent kEvent;
    local bool bAdded;

    for (iItemProject = 0; iItemProject < m_arrCEItemProjects.Length; iItemProject++)
    {
        if (m_arrCEItemProjects[iItemProject].iEngineers == 0)
        {
            continue;
        }

        kEvent.EEvent = eHQEvent_ItemProject;
        kEvent.iData = m_arrCEItemProjects[iItemProject].iItemId;
        kEvent.iData2 = m_arrCEItemProjects[iItemProject].iQuantity;
        kEvent.iHours = LWCE_GetItemProjectHoursRemaining(m_arrCEItemProjects[iItemProject]);
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
        case `LW_ITEM_ID(PlasmaCarbine): // Plasma Carbine
        case `LW_ITEM_ID(PlasmaRifle): // Plasma Rifle
        case `LW_ITEM_ID(PlasmaNovagun): // Plasma Novagun
        case `LW_ITEM_ID(PlasmaSniperRifle): // Plasma Sniper Rifle
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

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(LWCE_RecordItemsBuilt(m_arrCEItemProjects[iItemProject].iItemId, iQuantity));
    }

    STAT_AddStat(eRecap_ItemsBuilt, iQuantity);
    Achieve(AT_CombatReady);
}

function OnItemProjectCompleted(int iProject, optional bool bInstant)
{
    if (bInstant)
    {
        OnItemCompleted(iProject, m_arrCEItemProjects[iProject].iQuantity, true);
    }
    else if (m_arrCEItemProjects[iProject].bNotify && !ISCONTROLLED())
    {
        m_arrOldRebates.AddItem(m_arrCEItemProjects[iProject].kRebate);
        GEOSCAPE().Alert(GEOSCAPE().MakeAlert(eGA_ItemProjectCompleted, m_arrCEItemProjects[iProject].iItemId, m_arrCEItemProjects[iProject].iQuantity, m_arrOldRebates.Length - 1));
    }

    `LWCE_MOD_LOADER.OnItemCompleted(m_arrCEItemProjects[iProject], m_arrCEItemProjects[iProject].iQuantity, bInstant);
}

function string RecordCanceledItemConstruction(TItemProject Project)
{
    `LWCE_LOG_DEPRECATED_CLS(RecordCanceledItemConstruction);
    return "";
}

function string LWCE_RecordCanceledItemConstruction(LWCE_TItemProject Project)
{
    local string OutputString;

    OutputString = GEOSCAPE().m_kDateTime.GetDateString() @ GEOSCAPE().m_kDateTime.GetTimeString() @ ": Canceled construction of " $ `LWCE_ITEM(Project.iItemId).strName $ " x" $ string(Project.iQuantity) $ "\n";
    return OutputString;
}

function string RecordItemsBuilt(EItemType ItemType, int ItemQuantity)
{
    `LWCE_LOG_DEPRECATED_CLS(RecordItemsBuilt);
    return "";
}

function string LWCE_RecordItemsBuilt(int iItemId, int ItemQuantity)
{
    local string OutputString;

    OutputString = GEOSCAPE().m_kDateTime.GetDateString() @ GEOSCAPE().m_kDateTime.GetTimeString() @ ": Built " $ string(ItemQuantity) $ " items of type " $ `LWCE_ITEM(iItemId).strName $ "\n";
    return OutputString;
}

function RemoveItemProject(int iIndex)
{
    local int iProject;

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

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(LWCE_RecordCanceledItemConstruction(m_arrCEItemProjects[iIndex]));
    }

    PayCost(kOrigCost);
}

function string RecordStartedItemConstruction(TItemProject Project)
{
    `LWCE_LOG_DEPRECATED_CLS(RecordStartedItemConstruction);
    return "";
}

function string LWCE_RecordStartedItemConstruction(LWCE_TItemProject Project)
{
    local string OutputString;

    if (Project.iHoursLeft > 0)
    {
        OutputString = GEOSCAPE().m_kDateTime.GetDateString() @ GEOSCAPE().m_kDateTime.GetTimeString() @ ": Started construction of " $ `LWCE_ITEM(Project.iItemId).strName $ " x" $ string(Project.iQuantity) $ "\n";
    }

    return OutputString;
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