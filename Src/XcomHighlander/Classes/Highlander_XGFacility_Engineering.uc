class Highlander_XGFacility_Engineering extends XGFacility_Engineering
    dependson(HighlanderTypes);

struct CheckpointRecord_Highlander_XGFacility_Engineering extends CheckpointRecord_XGFacility_Engineering
{
    var array<HL_TItemProject> m_arrHLItemProjects;
    var array<int> m_arrHLFoundryHistory;
};

var array<HL_TItemProject> m_arrHLItemProjects;
var array<int> m_arrHLFoundryHistory;

function Init(bool bLoadingFromSave)
{
    BaseInit();

    m_kItems = Spawn(class'Highlander_XGItemTree');
    m_kItems.Init();

    if (m_arrMusingTracker.Length == 0)
    {
        m_arrMusingTracker.Add(9);
    }
}

function InitNewGame()
{
    m_iNumEngineers = class'XGTacticalGameCore'.default.NUM_STARTING_ENGINEERS;

    m_kStorage = Spawn(class'Highlander_XGStorage');
    m_kStorage.Init();
    GrantInitialStores();

    m_arrHLFoundryHistory.AddItem(0);

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(Resourceful)) > 0)
    {
        m_arrHLFoundryHistory.AddItem(HQ().HasBonus(`LW_HQ_BONUS_ID(Resourceful))); // Alien Metallurgy
        m_arrHLFoundryHistory.AddItem(39); // Improved Salvage
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(JaiJawan)) > 0)
    {
        m_arrHLFoundryHistory.AddItem(HQ().HasBonus(`LW_HQ_BONUS_ID(JaiJawan))); // Elerium Afterburners
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(SukhoiCompany)) > 0)
    {
        m_arrHLFoundryHistory.AddItem(HQ().HasBonus(`LW_HQ_BONUS_ID(SukhoiCompany))); // Improved Avionics
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(JungleScoutsOld)) > 0)
    {
        m_arrHLFoundryHistory.AddItem(HQ().HasBonus(`LW_HQ_BONUS_ID(JungleScoutsOld))); // Tactical Rigging
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(TheirFinestHour)) > 0)
    {
        m_arrHLFoundryHistory.AddItem(HQ().HasBonus(`LW_HQ_BONUS_ID(TheirFinestHour))); // Penetrator Weapons
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(ForTheSakeOfGlory)) > 0)
    {
        m_arrHLFoundryHistory.AddItem(HQ().HasBonus(`LW_HQ_BONUS_ID(ForTheSakeOfGlory))); // Advanced Repair
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
    PRES().GetMgr(class'Highlander_XGFoundryUI').UpdateView();
    m_bStartedFoundryProject = true;

    // Notify mods of this project
    `HL_MOD_LOADER.OnFoundryProjectAddedToQueue(kProject, `HL_FTECH(kProject.eTech));
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
    `HL_MOD_LOADER.OnFoundryProjectCanceled(kProject, `HL_FTECH(kProject.eTech));
}

function TProjectCost GetFoundryProjectCost(int iTech, bool bRushFoundry)
{
    local TProjectCost kCost;
    local HL_TFoundryTech kTech;

    kTech = `HL_FTECH(iTech);

    kCost = class'HighlanderTypes'.static.ConvertTCostToProjectCost(kTech.kCost);
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

function bool HL_IsFoundryTechInQueue(int iTechId)
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
    return iTech == 0 || m_arrHLFoundryHistory.Find(iTech) != INDEX_NONE;
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

    m_arrHLFoundryHistory.AddItem(iFoundryTechId);

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
    `HL_MOD_LOADER.OnFoundryProjectCompleted(m_arrFoundryProjects[iProject], `HL_FTECH(m_arrFoundryProjects[iProject].eTech));

    // Do this afterwards because it can also contain a mod hook and this order makes the most sense from a modder's perspective
    BARRACKS().UpdateFoundryPerks();
}

function string RecordCanceledFoundryProject(TFoundryProject Project)
{
    local HL_TFoundryTech kTech;
    local string OutputString;

    kTech = `HL_FTECH(Project.eTech);
    OutputString = GEOSCAPE().m_kDateTime.GetDateString() @ GEOSCAPE().m_kDateTime.GetTimeString() @ ": Canceled foundry project " $ kTech.strName $ "\\n";
    return OutputString;
}

function string RecordFoundryProjectCompleted(TFoundryProject FinishedProject)
{
    local HL_TFoundryTech kTech;
    local string OutputString;

    kTech = `HL_FTECH(FinishedProject.eTech);
    OutputString = GEOSCAPE().m_kDateTime.GetDateString() @ GEOSCAPE().m_kDateTime.GetTimeString() @ ": Finished foundry project for " $ kTech.strName $ "\\n";
    return OutputString;
}

function string RecordStartedFoundryProject(TFoundryProject Project)
{
    local HL_TFoundryTech kTech;
    local string OutputString;

    kTech = `HL_FTECH(Project.eTech);
    OutputString = GEOSCAPE().m_kDateTime.GetDateString() @ GEOSCAPE().m_kDateTime.GetTimeString() @ ": Started foundry project " $ kTech.strName $ "\\n";
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
    `HL_LOG_DEPRECATED_CLS(AddItemProject);
}

function HL_AddItemProject(out HL_TItemProject kProject)
{
    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(HL_RecordStartedItemConstruction(kProject));
    }

    kProject.iIndex = m_arrHLItemProjects.Length;
    kProject.kOriginalCost = HL_GetItemProjectCost(kProject.iItemId, kProject.iQuantityLeft, kProject.bRush);
    m_arrHLItemProjects.AddItem(kProject);
    PayCost(kProject.kOriginalCost);
    HL_AddItemProjectToQueue(kProject);

    if (kProject.iHoursLeft <= 0)
    {
        kProject.iHoursLeft = 0;
        OnItemProjectCompleted(kProject.iIndex, true);
        RemoveItemProject(kProject.iIndex);
    }
}

function AddItemProjectToQueue(out TItemProject kProject)
{
    `HL_LOG_DEPRECATED_CLS(AddItemProjectToQueue);
}

function HL_AddItemProjectToQueue(out HL_TItemProject kProject)
{
    local TEngQueueItem kQueueItem;

    kQueueItem.bItem = true;
    kQueueItem.iIndex = kProject.iIndex;
    m_arrQueue.AddItem(kQueueItem);
}

function CancelItemProject(int iIndex)
{
    local HL_TItemProject kProject;

    kProject = HL_GetItemProject(iIndex);

    if (kProject.kOriginalCost.iCash != 0 || kProject.kOriginalCost.iElerium != 0 || kProject.kOriginalCost.iAlloys != 0)
    {
        RefundCost(kProject.kOriginalCost);
    }
    else
    {
        RefundCost(HL_GetItemProjectCost(kProject.iItemId, kProject.iQuantityLeft, kProject.bRush));
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

    m_arrHLItemProjects[iNewIndex].iIndex = iNewIndex;
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
            txtCost.StrValue = (string(kCost.arrItemQuantities[iItem]) $ "x") @ `HL_ITEM(kCost.arrItems[iItem]).strName;
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
    `HL_LOG_DEPRECATED_CLS(GetETAString);
    return "";
}

function string HL_GetETAString(HL_TItemProject kProject)
{
    local int iHours, iDays;
    local XGParamTag kTag;

    if (kProject.iEngineers == 0)
    {
        return "--";
    }

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    iHours = HL_GetItemProjectHoursRemaining(kProject);

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
    `HL_LOG_DEPRECATED_CLS(GetItemCostSummary);
    return false;
}

function bool HL_GetItemCostSummary(out TCostSummary kCostSummary, int iItemId, optional int iQuantity = 1, optional bool bRush, optional bool bShowEng, optional int iProjectIndex = -1)
{
    local bool bCanAfford;
    local TProjectCost kCost;

    // TODO: possibly delete this, vanilla doesn't need a similar block
    if (iProjectIndex >= m_arrHLItemProjects.Length)
    {
        return false;
    }

    if (iProjectIndex != -1 && m_arrHLItemProjects[iProjectIndex].kOriginalCost.iCash != 0)
    {
        kCost = m_arrHLItemProjects[iProjectIndex].kOriginalCost;
    }
    else
    {
        kCost = HL_GetItemProjectCost(iItemId, iQuantity, bRush);
    }

    bCanAfford = GetCostSummary(kCostSummary, kCost, !bShowEng);
    return bCanAfford;
}

function TItemProject GetItemProject(int iIndex)
{
    local TItemProject kProject;

    `HL_LOG_DEPRECATED_CLS(GetItemProject);

    return kProject;
}

function HL_TItemProject HL_GetItemProject(int iIndex)
{
    return m_arrHLItemProjects[iIndex];
}

function int GetItemProjectHoursRemaining(TItemProject kProject)
{
    `HL_LOG_DEPRECATED_CLS(GetItemProjectHoursRemaining);
    return 0;
}

function int HL_GetItemProjectHoursRemaining(HL_TItemProject kProject)
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
    `HL_LOG_CLS("XGFacility_Engineering.IsCorpseItem is deprecated in the Highlander. Use Highlander_XGItemTree.HL_IsCorpse instead. Stack trace follows.");
    ScriptTrace();

    return false;
}

function TProjectCost GetItemProjectCost(EItemType eItem, int iQuantity, optional bool bRush)
{
    `HL_LOG_DEPRECATED_CLS(GetItemProjectCost);
    return super.GetItemProjectCost(eItem, iQuantity, bRush);
}

function TProjectCost HL_GetItemProjectCost(int iItemId, int iQuantity, optional bool bRush)
{
    local HL_TItem kItem;
    local HL_TCost kHLCost;
    local TProjectCost kCost;
    local int iItemQuant;

    kItem = `HL_ITEM(iItemId);
    kHLCost = kItem.kCost;

    // Do this while it's still an HL_TCost, for simplicity
    if (bRush)
    {
        kHLCost.iMeld += 2 + (kHLCost.iCash / 40);
    }

    kCost = class'HighlanderTypes'.static.ConvertTCostToProjectCost(kHLCost);
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

    `HL_LOG_DEPRECATED_CLS(GetItemsByCategory);

    return arrItems;
}

function array<HL_TItem> HL_GetItemsByCategory(int iCategory, int iTransactionType)
{
    if (iTransactionType == eTransaction_Build)
    {
        return `HL_ITEMTREE.HL_GetBuildItems(iCategory);
    }
    else
    {
        return `HL_STORAGE.HL_GetItemsInCategory(iCategory, iTransactionType);
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

function bool IsPriorityItem(EItemType eItem)
{
    `HL_LOG_DEPRECATED_CLS(IsPriorityItem);
    return false;
}

function bool HL_IsPriorityItem(int iItemId)
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
    `HL_LOG_DEPRECATED_CLS(ModifyItemProject);
}

function HL_ModifyItemProject(HL_TItemProject kProject)
{
    m_arrHLItemProjects[kProject.iIndex].iQuantityLeft = kProject.iQuantityLeft;
    m_arrHLItemProjects[kProject.iIndex].iQuantity = kProject.iQuantity;
    m_arrHLItemProjects[kProject.iIndex].iEngineers = kProject.iEngineers;
    m_arrHLItemProjects[kProject.iIndex].bAdjusted = kProject.bAdjusted;
    m_arrHLItemProjects[kProject.iIndex].bRush = kProject.bRush;

    PayCost(HL_GetItemProjectCost(m_arrHLItemProjects[kProject.iIndex].iItemId, m_arrHLItemProjects[kProject.iIndex].iQuantityLeft, m_arrHLItemProjects[kProject.iIndex].bRush));
}

function OnItemCompleted(int iItemProject, int iQuantity, optional bool bInstant)
{
    local TProjectCost kRebate, kOrigCost;

    kOrigCost = HL_GetItemProjectCost(m_arrHLItemProjects[iItemProject].iItemId, 1);

    if (!bInstant && HasRebate() && CalcWorkshopRebate(kOrigCost, kRebate))
    {
        m_arrHLItemProjects[iItemProject].kRebate.iCash += kRebate.iCash * iQuantity;
        m_arrHLItemProjects[iItemProject].kRebate.iAlloys += kRebate.iAlloys * iQuantity;
        m_arrItemProjects[iItemProject].kRebate.iElerium += kRebate.iElerium * iQuantity;

        // Seems like LW rerouted the cash rebates (which aren't used in LW) to add Meld instead,
        // but ultimately didn't end up doing Meld rebates after all
        AddResource(eResource_Meld, kRebate.iCash * iQuantity, true);
        AddResource(eResource_Alloys, kRebate.iAlloys * iQuantity, true);
        AddResource(eResource_Elerium, kRebate.iElerium * iQuantity, true);
    }

    if (!bInstant)
    {
        PRES().Notify(eGA_NewItemBuilt, m_arrHLItemProjects[iItemProject].iItemId, iQuantity);
    }

    STORAGE().AddItem(m_arrHLItemProjects[iItemProject].iItemId, iQuantity);

    if (m_arrHLItemProjects[iItemProject].iItemId == `LW_ITEM_ID(Firestorm))
    {
        HANGAR().PlayFirestormBuiltCinematic();
    }
    else if (m_arrHLItemProjects[iItemProject].iItemId == `LW_ITEM_ID(LaserRifle))
    {
        PRES().UINarrative(`XComNarrativeMoment("EngineeringLaser"));
    }
    else if (m_arrHLItemProjects[iItemProject].iItemId == `LW_ITEM_ID(PlasmaRifle))
    {
        PRES().UINarrative(`XComNarrativeMoment("EngineeringPlasma"));
    }

    switch (m_arrHLItemProjects[iItemProject].iItemId)
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
        GetRecapSaveData().RecordEvent(RecordItemsBuilt(m_arrItemProjects[iItemProject].eItem, iQuantity));
    }

    STAT_AddStat(eRecap_ItemsBuilt, iQuantity);
    Achieve(AT_CombatReady);
}

function OnItemProjectCompleted(int iProject, optional bool bInstant)
{
    if (bInstant)
    {
        OnItemCompleted(iProject, m_arrHLItemProjects[iProject].iQuantity, true);
    }
    else if (m_arrHLItemProjects[iProject].bNotify && !ISCONTROLLED())
    {
        m_arrOldRebates.AddItem(m_arrHLItemProjects[iProject].kRebate);
        GEOSCAPE().Alert(GEOSCAPE().MakeAlert(eGA_ItemProjectCompleted, m_arrHLItemProjects[iProject].iItemId, m_arrHLItemProjects[iProject].iQuantity, m_arrOldRebates.Length - 1));
    }
}

function string RecordCanceledItemConstruction(TItemProject Project)
{
    `HL_LOG_DEPRECATED_CLS(RecordCanceledItemConstruction);
    return "";
}

function string HL_RecordCanceledItemConstruction(HL_TItemProject Project)
{
    local string OutputString;

    OutputString = GEOSCAPE().m_kDateTime.GetDateString() @ GEOSCAPE().m_kDateTime.GetTimeString() @ ": Canceled construction of " $ `HL_ITEM(Project.iItemId).strName $ " x" $ string(Project.iQuantity) $ "\n";
    return OutputString;
}

function string RecordItemsBuilt(EItemType ItemType, int ItemQuantity)
{
    `HL_LOG_DEPRECATED_CLS(RecordItemsBuilt);
    return "";
}

function string HL_RecordItemsBuilt(int iItemId, int ItemQuantity)
{
    local string OutputString;

    OutputString = GEOSCAPE().m_kDateTime.GetDateString() @ GEOSCAPE().m_kDateTime.GetTimeString() @ ": Built " $ string(ItemQuantity) $ " items of type " $ `HL_ITEM(iItemId).strName $ "\n";
    return OutputString;
}

function RemoveItemProject(int iIndex)
{
    local int iProject;

    RemoveItemProjectFromQueue(iIndex);
    m_arrHLItemProjects.Remove(iIndex, 1);

    for (iProject = 0; iProject < m_arrHLItemProjects.Length; iProject++)
    {
        ChangeItemIndex(m_arrHLItemProjects[iProject].iIndex, iProject);
    }
}

function RestoreItemFunds(int iIndex)
{
    local TProjectCost kOrigCost;

    if (m_arrHLItemProjects[iIndex].kOriginalCost.iCash != 0 || m_arrHLItemProjects[iIndex].kOriginalCost.iElerium != 0 || m_arrHLItemProjects[iIndex].kOriginalCost.iAlloys != 0)
    {
        kOrigCost = m_arrHLItemProjects[iIndex].kOriginalCost;
    }
    else
    {
        kOrigCost = HL_GetItemProjectCost(m_arrHLItemProjects[iIndex].iItemId, m_arrHLItemProjects[iIndex].iQuantityLeft, m_arrHLItemProjects[iIndex].bRush);
    }

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(HL_RecordCanceledItemConstruction(m_arrHLItemProjects[iIndex]));
    }

    PayCost(kOrigCost);
}

function string RecordStartedItemConstruction(TItemProject Project)
{
    `HL_LOG_DEPRECATED_CLS(RecordStartedItemConstruction);
    return "";
}

function string HL_RecordStartedItemConstruction(HL_TItemProject Project)
{
    local string OutputString;

    if (Project.iHoursLeft > 0)
    {
        OutputString = GEOSCAPE().m_kDateTime.GetDateString() @ GEOSCAPE().m_kDateTime.GetTimeString() @ ": Started construction of " $ `HL_ITEM(Project.iItemId).strName $ " x" $ string(Project.iQuantity) $ "\n";
    }

    return OutputString;
}

function bool UrgeBuildMEC()
{
    local Highlander_XGStorage kStorage;
    local array<HL_TItem> arrMecSuits;
    local XGStrategySoldier kSoldier;
    local int NumMecs;

    if (m_bUrgeBuildMEC)
    {
        return false;
    }

    kStorage = `HL_STORAGE;
    arrMecSuits = kStorage.HL_GetItemsInCategory(eItemCat_Armor, eTransaction_None, eSC_Mec);

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