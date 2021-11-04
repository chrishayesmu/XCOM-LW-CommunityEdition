class Highlander_XComHeadquartersCheatManager extends XComHeadquartersCheatManager
    dependson(HighlanderTypes);

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
            if (kTech.iTechId == iProjectId || (kTech.iTechId <= eFoundry_MAX && GetEnum(enum'EFoundryTech', kTech.iTechId) == name(enumName)) )
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