class LWCE_XComHeadquartersCheatManager extends XComHeadquartersCheatManager
    dependson(LWCETypes, LWCE_XGFacility_Engineering);

`include(generators.uci)

`LWCE_GENERATOR_XCOMCHEATMANAGER

exec function CreateAlienBaseAlert()
{
    local XGMission_AlienBase kMission;

    kMission = Outer.Spawn(class'XGMission_AlienBase');
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
    local string enumName;
    local int Index, iItemId;
    local LWCE_TItem kItem;

    enumName = "eItem_" $ ItemType;
    iItemId = int(ItemType);

    // Start with base game items
    for (Index = 0; Index < 255; Index++)
    {
        if (GetEnum(enum'EItemType', Index) == name(enumName))
        {
            `HQGAME.GetGameCore().GetHQ().m_kEngineering.GetStorage().AddItem(Index, Amount);
            return;
        }
    }

    if (iItemId <= 0)
    {
        return;
    }

    // Validate that the requested item exists; if not, kItem.iItemId will be 0
    kItem = `LWCE_ITEM(iItemId);

    if (kItem.iItemId == iItemId)
    {
        `HQGAME.GetGameCore().GetHQ().m_kEngineering.GetStorage().AddItem(iItemId, Amount);
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
            kSoldierUI.m_kSoldier.GivePerk(iPerkId);
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