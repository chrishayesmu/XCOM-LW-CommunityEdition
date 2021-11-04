class Highlander_XGFacility_Engineering extends XGFacility_Engineering
    dependson(HighlanderTypes);

struct CheckpointRecord_Highlander_XGFacility_Engineering extends CheckpointRecord_XGFacility_Engineering
{
    var array<int> m_arrHLFoundryHistory;
};

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

    if (HQ().HasBonus(9) > 0) // Resourceful
    {
        m_arrHLFoundryHistory.AddItem(HQ().HasBonus(9));
        m_arrHLFoundryHistory.AddItem(39); // Improved Salvage
    }

    if (HQ().HasBonus(11) > 0) // Jai Jawan
    {
        m_arrHLFoundryHistory.AddItem(HQ().HasBonus(11)); // Elerium Afterburners
    }

    if (HQ().HasBonus(14) > 0) // Sukhoi Company
    {
        m_arrHLFoundryHistory.AddItem(HQ().HasBonus(14)); // Improved Avionics
    }

    if (HQ().HasBonus(22) > 0) // Jungle Scouts
    {
        m_arrHLFoundryHistory.AddItem(HQ().HasBonus(22)); // Tactical Rigging
    }

    if (HQ().HasBonus(26) > 0) // Their Finest Hour
    {
        m_arrHLFoundryHistory.AddItem(HQ().HasBonus(26)); // Penetrator Weapons
    }

    if (HQ().HasBonus(28) > 0) // For the Sake of Glory
    {
        m_arrHLFoundryHistory.AddItem(HQ().HasBonus(28)); // Advanced Repair
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
    kCost.arrItems = kTech.kCost.arrItems;
    kCost.arrItemQuantities = kTech.kCost.arrItemQuantities;
    kCost.iCash = kTech.iCash;
    kCost.iElerium = kTech.iElerium;
    kCost.iAlloys = kTech.iAlloys;
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
    local int FoundryTechId;

    FoundryTechId = m_arrFoundryProjects[iProject].eTech;

    if (m_arrFoundryProjects[iProject].bNotify)
    {
        // TODO: remove rebates entirely from Foundry projects and related code
        m_arrOldRebates.AddItem(m_arrFoundryProjects[iProject].kRebate);

        // UE Explorer failed to decompile this line. I've put it together as best I could based on the bytecode and the alert handling code in
        // XGMissionControlUI.UpdateAlert. The decompilation failure seems to have messed up much of the remainder of the function as well, which
        // I have also worked to restore.
        GEOSCAPE().Alert(GEOSCAPE().MakeAlert(eGA_FoundryProjectCompleted, m_arrFoundryProjects[iProject].eTech, m_arrOldRebates.Length - 1));
    }

    if (FoundryTechId == eFoundry_AlienGrenades)
    {
        STORAGE().m_arrInfiniteItems.AddItem(eItem_AlienGrenade);
        BARRACKS().UpdateGrenades(eItem_AlienGrenade);
    }

    m_arrHLFoundryHistory.AddItem(FoundryTechId);

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