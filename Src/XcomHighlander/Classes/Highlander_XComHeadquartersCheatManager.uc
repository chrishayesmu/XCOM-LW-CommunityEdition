class Highlander_XComHeadquartersCheatManager extends XComHeadquartersCheatManager
    dependson(HighlanderTypes);

exec function CreateAlienBaseAlert()
{
    local XGMission_AlienBase kMission;

    kMission = Outer.Spawn(class'XGMission_AlienBase');
    kMission.m_kDesc = Outer.Spawn(class'Highlander_XGBattleDesc');
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
exec function GiveFoundry(optional string techType)
{
    local string enumName;
    local int iProjectId;
    local Highlander_XGFacility_Engineering kEngineering;
    local Highlander_XGTechTree kTechTree;
    local TFoundryProject kProject;
    local HL_TFoundryTech kTech;

    enumName = "eFoundry_" $ techType;
    iProjectId = int(techType);
    kEngineering = Highlander_XGFacility_Engineering(`HQGAME.GetGameCore().GetHQ().m_kEngineering);
    kTechTree = Highlander_XGTechTree(kEngineering.TECHTREE());

    foreach kTechTree.m_arrHLFoundryTechs(kTech)
    {
        if (techType != "")
        {
            if ( kTech.iTechId == iProjectId || (kTech.iTechId <= eFoundry_MAX && GetEnum(enum'EFoundryTech', kTech.iTechId) == name(enumName)) )
            {
                if (!kEngineering.IsFoundryTechResearched(kTech.iTechId))
                {
                    `HL_LOG_CLS("GiveFoundry: Found matching Foundry project " $ kTech.strName $ ", completing it");

                    kEngineering.m_arrHLFoundryHistory.AddItem(kTech.iTechId);

                    kProject.eTech = kTech.iTechId;
                    kEngineering.m_arrFoundryProjects.AddItem(kProject);
                    kEngineering.OnFoundryProjectCompleted(kEngineering.m_arrFoundryProjects.Length - 1);
                }
                else
                {
                    `HL_LOG_CLS("GiveFoundry: Found matching Foundry project " $ kTech.strName $ ", but it has already been completed");
                }

                return;
            }
        }
        else if (kTech.iTechId != 0)
        {
            kEngineering.m_arrHLFoundryHistory.AddItem(kTech.iTechId);

            kProject.eTech = kTech.iTechId;
            kEngineering.m_arrFoundryProjects.AddItem(kProject);
            kEngineering.OnFoundryProjectCompleted(kEngineering.m_arrFoundryProjects.Length - 1);
        }
    }
}

/**
 * Completes the specified research tech, or all uncompleted research if no argument is supplied.
 *
 * If techType is supplied and matches an ETechType enum name, that project is completed; otherwise it is assumed
 * to be an integer ID of a research tech (either base game or from a mod).
 */
exec function GiveTech(optional string techType, optional int forceTechValueTo = 1, optional bool actuallyDoResearch = false)
{
    local string enumName;
    local int iTechId;
    local Highlander_XGFacility_Labs kLabs;
    local Highlander_XGTechTree kTechTree;
    local HL_TTech kTech;

    kLabs = Highlander_XGFacility_Labs(`HQGAME.GetGameCore().GetHQ().m_kLabs);
    kTechTree = Highlander_XGTechTree(kLabs.m_kTree);

    enumName = "eTech_" $ techType;
    iTechId = int(techType);

    foreach kTechTree.m_arrHLTechs(kTech)
    {
        if (techType != "")
        {
            if ( kTech.iTechId == iTechId || (kTech.iTechId < eTech_MAX && GetEnum(enum'ETechType', kTech.iTechId) == name(enumName)) )
            {
                if (kLabs.IsResearched(kTech.iTechId))
                {
                    continue;
                }

                if (actuallyDoResearch)
                {
                    kLabs.SetNewProject(kTech.iTechId);
                    kLabs.OnResearchCompleted();
                }
                else
                {
                    kLabs.m_arrResearched.AddItem(kTech.iTechId);
                }

                return;
            }
        }
        else if (!kLabs.IsResearched(kTech.iTechId))
        {
            kLabs.m_arrResearched.AddItem(kTech.iTechId);
        }
    }
}
