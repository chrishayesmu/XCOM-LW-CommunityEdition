class LWCE_XComHeadquartersCheatManager extends XComHeadquartersCheatManager
    dependson(LWCETypes);

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
exec function GiveFoundry(optional string techType)
{
    local string enumName;
    local int iProjectId;
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGTechTree kTechTree;
    local TFoundryProject kProject;
    local LWCE_TFoundryTech kTech;

    enumName = "eFoundry_" $ techType;
    iProjectId = int(techType);
    kEngineering = LWCE_XGFacility_Engineering(`HQGAME.GetGameCore().GetHQ().m_kEngineering);
    kTechTree = LWCE_XGTechTree(kEngineering.TECHTREE());

    foreach kTechTree.m_arrCEFoundryTechs(kTech)
    {
        if (techType != "")
        {
            if ( kTech.iTechId == iProjectId || (kTech.iTechId <= eFoundry_MAX && GetEnum(enum'EFoundryTech', kTech.iTechId) == name(enumName)) )
            {
                if (!kEngineering.IsFoundryTechResearched(kTech.iTechId))
                {
                    `LWCE_LOG_CLS("GiveFoundry: Found matching Foundry project " $ kTech.strName $ ", completing it");

                    kEngineering.m_arrCEFoundryHistory.AddItem(kTech.iTechId);

                    kProject.eTech = kTech.iTechId;
                    kEngineering.m_arrFoundryProjects.AddItem(kProject);
                    kEngineering.OnFoundryProjectCompleted(kEngineering.m_arrFoundryProjects.Length - 1);
                }
                else
                {
                    `LWCE_LOG_CLS("GiveFoundry: Found matching Foundry project " $ kTech.strName $ ", but it has already been completed");
                }

                return;
            }
        }
        else if (kTech.iTechId != 0)
        {
            kEngineering.m_arrCEFoundryHistory.AddItem(kTech.iTechId);

            kProject.eTech = kTech.iTechId;
            kEngineering.m_arrFoundryProjects.AddItem(kProject);
            kEngineering.OnFoundryProjectCompleted(kEngineering.m_arrFoundryProjects.Length - 1);
        }
    }
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
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGTechTree kTechTree;
    local LWCE_TTech kTech;

    kLabs = LWCE_XGFacility_Labs(`HQGAME.GetGameCore().GetHQ().m_kLabs);
    kTechTree = LWCE_XGTechTree(kLabs.m_kTree);

    enumName = "eTech_" $ techType;
    iTechId = int(techType);

    foreach kTechTree.m_arrCETechs(kTech)
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
