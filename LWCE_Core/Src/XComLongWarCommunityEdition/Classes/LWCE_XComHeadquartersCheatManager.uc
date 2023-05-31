class LWCE_XComHeadquartersCheatManager extends XComHeadquartersCheatManager
    dependson(LWCETypes, LWCE_XGFacility_Engineering);

`include(generators.uci)

`LWCE_GENERATOR_XCOMCHEATMANAGER

exec function BaseNext()
{
    ChangeFocusedBase(1);
}

exec function BasePrevious()
{
    ChangeFocusedBase(-1);
}

exec function CreateAlienBaseAlert()
{
    local XGMission_AlienBase kMission;

    kMission = Outer.Spawn(class'LWCE_XGMission_AlienBase');
    kMission.m_kDesc = Outer.Spawn(class'LWCE_XGBattleDesc').Init();
    kMission.m_iContinent = 0;
    kMission.m_v2Coords = vect2d(0.3020, 0.3940);
    kMission.m_iDetectedBy = 0;
    kMission.m_kDesc.m_kAlienSquad = AI().DetermineAlienBaseSquad();
    GEOSCAPE().AddMission(kMission);
}

exec function GiveAllTech()
{
    GiveTech();
}

/**
 * Completes the specified Foundry project, or all uncompleted Foundry projects if no argument is supplied.
 *
 * If techType is supplied and matches an EFoundryTech enum name, that project is completed; otherwise it is assumed
 * to be an integer ID of a Foundry project (either base game or from a mod).
 */
exec function GiveFoundry(optional string ProjectName)
{
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCEFoundryProjectTemplate kProject;
    local LWCEFoundryProjectTemplateManager kTemplateMgr;
    local array<LWCEFoundryProjectTemplate> arrTemplates;

    kEngineering = `LWCE_ENGINEERING;
    kTemplateMgr = `LWCE_FOUNDRY_TEMPLATE_MGR;
    arrTemplates = kTemplateMgr.GetAllProjectTemplates();

    if (ProjectName != "")
    {
        kProject = kTemplateMgr.FindProjectTemplate(name(ProjectName));

        if (kProject != none)
        {
            GetConsole().OutputTextLine("Found foundry template with name " $ ProjectName $ ". Granting foundry project to player.");
            GiveFoundryTemplate(kProject, kEngineering);
        }
        else
        {
            GetConsole().OutputTextLine("Did not find foundry project with name " $ ProjectName);
        }

        kEngineering.UpdateFoundryProjects();
        return;
    }

    GetConsole().OutputTextLine("Attempting to grant all unfinished foundry projects (out of " $ arrTemplates.Length $ " total projects)");

    foreach arrTemplates(kProject)
    {
        GiveFoundryTemplate(kProject, kEngineering);
    }

    kEngineering.UpdateFoundryProjects();
}

exec function GiveItem(string ItemType, optional int Amount = 1)
{
    local LWCEItemTemplate kItem;

    kItem = `LWCE_ITEM(name(ItemType));

    if (kItem != none)
    {
        `LWCE_STORAGE.LWCE_AddItem(name(ItemType), Amount);
        return;
    }

    `LWCE_LOG_CLS("GiveItem: Couldn't find requested item type " $ ItemType);
}

exec function GivePerk(string strName)
{
    local XGSoldierUI kSoldierUI;
    local XComHQPresentationLayer kPres;
    local XComPlayerController PC;
    local int iPerkId;
    local LWCE_XComPerkManager kPerksMgr;

    kPerksMgr = LWCE_XComPerkManager(`HQGAME.GetGameCore().GetHQ().GetBarracks().m_kPerkManager);

    iPerkId = class'LWCE_XComCheatManager_Extensions'.static.FindPerkByString(strName, kPerksMgr);

    if (iPerkId <= 0)
    {
        GetConsole().OutputTextLine("Could not find perk " $ strName);
        return;
    }

    PC = XComPlayerController(Outer.GetALocalPlayerController());

    if (XGFacility_Barracks(`HQGAME.GetGameCore().GetHQ().CurrentFacility()) != none)
    {
        kPres = XComHQPresentationLayer(PC.m_Pres);
        kSoldierUI = XGSoldierUI(kPres.GetMgr(class'XGSoldierUI',,, true));

        if (kSoldierUI != none && kSoldierUI.m_kSoldier != none)
        {
            GetConsole().OutputTextLine("Giving perk " $ iPerkId);
            LWCE_XGStrategySoldier(kSoldierUI.m_kSoldier).LWCE_GivePerk(iPerkId, 'Innate');
        }
    }
}

/**
 * Completes the specified research tech, or all uncompleted research if no argument is supplied.
 *
 * If TechName is supplied and matches a tech template name, that project is completed.
 */
exec function GiveTech(optional string TechName, optional int deprecated = 1, optional bool bDoResearch = false)
{
    local LWCE_XGFacility_Labs kLabs;
    local LWCETechTemplate kTech;
    local LWCETechTemplateManager kTemplateMgr;
    local array<LWCETechTemplate> arrTemplates;

    kLabs = LWCE_XGFacility_Labs(`HQGAME.GetGameCore().GetHQ().m_kLabs);
    kTemplateMgr = `LWCE_TECH_TEMPLATE_MGR;
    arrTemplates = kTemplateMgr.GetAllTechTemplates();

    if (TechName != "")
    {
        kTech = kTemplateMgr.FindTechTemplate(name(TechName));

        if (kTech != none)
        {
            GetConsole().OutputTextLine("Found tech template with name " $ TechName $ ". Granting tech to player.");
            GiveTechTemplate(kTech, kLabs, bDoResearch);
        }
        else
        {
            GetConsole().OutputTextLine("Did not find technology with name " $ TechName);
        }

        return;
    }

    GetConsole().OutputTextLine("Attempting to grant all unfinished research (out of " $ arrTemplates.Length $ " total techs)");

    foreach arrTemplates(kTech)
    {
        GiveTechTemplate(kTech, kLabs, bDoResearch);
    }
}

exec function LevelUpBarracks(optional int iTimes = 1)
{
    local XGFacility_Barracks kBarracks;
    local XGStrategySoldier kSoldier;
    local int I;

    kBarracks = `HQGAME.GetGameCore().GetHQ().m_kBarracks;

    foreach kBarracks.m_arrSoldiers(kSoldier)
    {
        for (I = 0; I < iTimes; I++)
        {
            if (!kSoldier.IsATank())
            {
                LWCE_XGStrategySoldier(kSoldier).LWCE_LevelUp();
            }
        }
    }
}

exec function LevelUpPsi(optional int iTimes = 1)
{
    local XGSoldierUI kSoldierUI;
    local XComHQPresentationLayer kPres;

    if (XGFacility_Barracks(`HQGAME.GetGameCore().GetHQ().CurrentFacility()) != none)
    {
        kPres = `HQPRES;
        kSoldierUI = XGSoldierUI(kPres.GetMgr(class'LWCE_XGSoldierUI',,, true));

        if (kSoldierUI != none && kSoldierUI.m_kSoldier != none)
        {
            kSoldierUI.m_kSoldier.m_kSoldier.iPsiXP = `GAMECORE.GetPsiXPRequired(kSoldierUI.m_kSoldier.GetPsiRank() + iTimes);
            kSoldierUI.UpdateView();
        }
    }
}

exec function PlayFacilityBuiltNarrative(name FacilityName)
{
    local LWCEFacilityTemplate kTemplate;

    kTemplate = `LWCE_FACILITY(FacilityName);

    if (kTemplate == none)
    {
        GetConsole().OutputTextLine("Couldn't find facility with name " $ FacilityName);
        return;
    }

    PlayNarrative(kTemplate.strPostBuildNarrative);
}

exec function PlayNarrative(string strNarrative)
{
    local XComNarrativeMoment kNarrative;

    kNarrative = XComNarrativeMoment(DynamicLoadObject(strNarrative, class'XComNarrativeMoment'));

    if (kNarrative == none)
    {
        GetConsole().OutputTextLine("Couldn't find narrative moment at path " $ strNarrative);
        return;
    }

    `LWCE_HQPRES.UINarrative(kNarrative);
}

/// <summary>
/// Sets the alien research to the given level. Since the alien baseline research will always be
/// set according to how many days have passed, this command instead modifies the alien bonus research
/// such that the correct total research is accomplished at the moment the command is run. If TotalResearch
/// is non-positive then this function will do nothing.
/// </summary>
exec function SetAlienResearch(int TotalResearch)
{
    local int iBaseResearch, iBonusResearch;

    if (TotalResearch <= 0)
    {
        return;
    }

    iBaseResearch = `HQGAME.GetGameCore().GetDays();
    iBonusResearch = TotalResearch - iBaseResearch;

    if (TotalResearch < iBaseResearch)
    {
        GetConsole().OutputTextLine("Cannot set research to " $ TotalResearch $ " because base research is already " $ iBaseResearch $ " and cannot be overridden.");
        return;
    }

    `HQGAME.GetGameCore().STAT_SetStat(1, iBaseResearch);
    `HQGAME.GetGameCore().STAT_SetStat(2, iBonusResearch);

    GetConsole().OutputTextLine("Alien base research is " $ iBaseResearch $ " and bonus research is now " $ iBonusResearch);
}


/// <summary>
/// Sets a specific base tile to the given facility type. Note that X and Y start at 1, such that (1, 1)
/// is the upper-left corner of the base.
///
/// Very little validation is performed as part of this command. Use at your own risk.
///
/// TODO: using this to remove facilities is pretty buggy still.
/// </summary>
exec function SetFacility(int X, int Y, optional name FacilityName = '', optional int iBaseId = -1)
{
    local LWCE_XGBase kBase;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XComHQPresentationLayer kPres;

    kHQ = `LWCE_HQ;
    kPres = `LWCE_HQPRES;

    if (iBaseId < 0)
    {
        kBase = LWCE_XGBase(kHQ.m_kBase);
    }
    else
    {
        kBase = kHQ.GetBaseById(iBaseId);
    }

    // User-provided X starts at 1, but the real X starts at 0. We don't do the same for Y,
    // because bases have a hidden row at Y=0, so the user's idea of Y matches the reality.
    X--;

    if (X == kBase.GetAccessX() && FacilityName != 'Facility_AccessLift' && FacilityName != '')
    {
        GetConsole().OutputTextLine("Can't put a non-access-lift facility at X = " $ (X + 1));
        return;
    }
    else if (X != kBase.GetAccessX() && FacilityName == 'Facility_AccessLift')
    {
        GetConsole().OutputTextLine("Can't put an access lift at X = " $ (X + 1) $ "; X must be " $ (kBase.GetAccessX() + 1));
        return;
    }

    kBase.LWCE_PerformAction(FacilityName != '' ? eBCS_BuildFacility : eBCS_RemoveFacility, X, Y, FacilityName);

    // Update the UI if we're on the facilities screen
    if (kPres.m_kBuildFacilities != none)
    {
        kPres.m_kBuildFacilities.OnReceiveFocus();
    }
}

exec function ShowAlienStats()
{
    local LWCE_Console kConsole;
    local XGStrategy kStrategy;

    kConsole = GetConsole();

    if (kConsole == none)
    {
        return;
    }

    kStrategy = `HQGAME.GetGameCore();

    kConsole.OutputTextLine("Alien Research (Total): " $ kStrategy.STAT_GetStat(1));
    kConsole.OutputTextLine("Alien Research (Bonus Only): " $ kStrategy.STAT_GetStat(2));
    kConsole.OutputTextLine("Alien Resources: " $ kStrategy.STAT_GetStat(19));
    kConsole.OutputTextLine("XCOM Threat Level: " $ kStrategy.STAT_GetStat(21));
}

exec function ToggleStrategyHUD()
{
    `LWCE_LOG_CLS("ToggleStrategyHUD: b_IsVisible = " $ `LWCE_HQPRES.m_kStrategyHUD.b_IsVisible);
    if (`LWCE_HQPRES.m_kStrategyHUD.b_IsVisible)
    {
        `LWCE_HQPRES.m_kStrategyHUD.Hide();
    }
    else
    {
        `LWCE_HQPRES.m_kStrategyHUD.Show();
    }
}

protected function GiveFoundryTemplate(LWCEFoundryProjectTemplate kTemplate, LWCE_XGFacility_Engineering kEngineering)
{
    local LWCE_TFoundryProject kProject;

    if (!kEngineering.LWCE_IsFoundryTechResearched(kTemplate.GetProjectName()))
    {
        kEngineering.m_arrCEFoundryHistory.AddItem(kTemplate.GetProjectName());

        kProject.ProjectName = kTemplate.GetProjectName();
        kProject.iHoursLeft = 1;

        kEngineering.m_arrCEFoundryProjects.AddItem(kProject);
        kEngineering.OnFoundryProjectCompleted(kEngineering.m_arrCEFoundryProjects.Length - 1);
    }
}

protected function GiveTechTemplate(LWCETechTemplate kTech, LWCE_XGFacility_Labs kLabs, bool bDoResearch)
{
    if (kLabs.LWCE_IsResearched(kTech.GetTechName()))
    {
        return;
    }

    if (bDoResearch)
    {
        kLabs.LWCE_SetNewProject(kTech.GetTechName());
        kLabs.OnResearchCompleted();
    }
    else
    {
        kLabs.m_arrCEResearched.AddItem(kTech.GetTechName());
    }
}

protected function ChangeFocusedBase(int iDirection)
{
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XComHQPresentationLayer kPres;
    local LWCE_XGBuildUI kBuildUI;
    local int Index;

    kHQ = `LWCE_HQ;
    kPres = `LWCE_HQPRES;

    if (kPres.m_kBuildFacilities == none)
    {
        GetConsole().OutputTextLine("This command can only be used on the build facilities screen.");
        return;
    }

    kBuildUI = LWCE_XGBuildUI(kPres.m_kBuildFacilities.GetMgr());

    Index = kHQ.m_arrBases.Find(kBuildUI.GetTargetBase());

    if (Index == INDEX_NONE)
    {
        GetConsole().OutputTextLine("ERROR: current base could not be found. This indicates a coding or game data error.");
        return;
    }

    Index += iDirection;

    if (Index < 0)
    {
        Index = kHQ.m_arrBases.Length - 1;
    }
    else
    {
        Index = Index % kHQ.m_arrBases.Length;
    }

    GetConsole().OutputTextLine("Changing UI's base index to " $ Index $ ". Base ID will be " $ kHQ.m_arrBases[Index].m_iId);
    kBuildUI.SetTargetBaseId(kHQ.m_arrBases[Index].m_iId);

    kPres.PopState();
    kPres.LWCE_UIBuildBase(kHQ.m_arrBases[Index].m_iId);
    kPres.m_kBuildFacilities.OnReceiveFocus();
}