class Highlander_XGTechTree extends XGTechTree
    dependson(HighlanderTypes);

var privatewrite array<HL_TFoundryTech> m_arrHLFoundryTechs;

function Init()
{
    `HL_LOG_CLS("Override successful");

    m_arrTechs.Add(76);
    BuildTechs();
    BuildFoundryTechs();
    BuildOTSTechs();
    BuildObjectives();
    BuildResearchCredits();
    BuildGeneTechs();
}

function BuildFoundryTechs()
{
    local TFoundryTech BaseTech;
    local HL_TFoundryTech BlankHLTech, HighlanderTech;

    super.BuildFoundryTechs();

    // Map all of the base game Foundry techs into our new structure
    foreach m_arrFoundryTechs(BaseTech)
    {
        HighlanderTech = BlankHLTech;

        HighlanderTech.strName = BaseTech.strName;
        HighlanderTech.strSummary = BaseTech.strSummary;
        HighlanderTech.iTechId = BaseTech.iFoundryTech;
        HighlanderTech.iHours = BaseTech.iHours;
        HighlanderTech.iEngineers = BaseTech.iEngineers;
        HighlanderTech.iCash = BaseTech.iCash;
        HighlanderTech.iElerium = BaseTech.iElerium;
        HighlanderTech.iAlloys = BaseTech.iAlloys;
        HighlanderTech.kCost = BaseTech.kCost;

        if (BaseTech.iItemReq != 0)
        {
            HighlanderTech.arrItemReqs.AddItem(BaseTech.iItemReq);
        }

        if (BaseTech.iTechReq != 0)
        {
            HighlanderTech.arrTechReqs.AddItem(BaseTech.iTechReq);
        }

        HighlanderTech.ImagePath = class'UIUtilities'.static.GetFoundryImagePath(BaseTech.iImage);

        m_arrHLFoundryTechs.AddItem(HighlanderTech);
   }

    // Clear out the base game tech list to help identify instances where it's being used
    m_arrFoundryTechs.Remove(0, m_arrFoundryTechs.Length);

    `HL_LOG_CLS("m_arrHLFoundryTechs length from base game: " $ m_arrHLFoundryTechs.Length);

    // Now provide a chance for mods to change the project list
    `HL_MOD_LOADER.OnFoundryTechsBuilt(m_arrHLFoundryTechs);

    `HL_LOG_CLS("m_arrHLFoundryTechs length after mod processing: " $ m_arrHLFoundryTechs.Length);
}

function bool CheckForSkunkworks()
{
    local int iTech;

    for (iTech = 1; iTech < 25; iTech++)
    {
        if (!ENGINEERING().IsFoundryTechResearched(iTech))
        {
            return false;
        }
    }

    return true;
}

// TODO: include mod credit data
function bool HL_CreditAppliesToFoundryTech(int iCredit, int iTechId)
{
    switch (iCredit)
    {
        case 1: // Laser Weaponry
            switch (iTechId)
            {
                case 6:  // Enhanced Lasers
                case 34: // Supercapacitors
                    return true;
                default:
                    break;
            }
        case 2: // Plasma Weaponry
            switch (iTechId)
            {
                case 7:  // Enhanced Plasma
                case 15: // Reflex Pistols
                    return true;
                default:
                    break;
            }
        case 3: // Weapons Technology
            switch (iTechId)
            {
                case 1:  // Enhanced Ballistics
                case 2:  // Alien Grenades
                case 6:  // Enhanced Lasers
                case 7:  // Enhanced Plasma
                case 10: // Ammo Conservation
                case 13: // Mag Pistols
                case 14: // Rail Pistols
                case 15: // Reflex Pistols
                case 16: // SHIV Suppression
                case 18: // SCOPE Upgrade
                case 46: // Quenchguns
                    return true;
                default:
                    break;
            }
        case 4: // Aerospace Technology
            switch (iTechId)
            {
                case 11: // Advanced Flight
                case 12: // Armored Fighters
                case 26: // Aircraft Boosters
                case 27: // Wingtip Sparrowhawks
                case 28: // Penetrator Weapons
                case 31: // Improved Avionics
                case 32: // UFO Countermeasures
                case 33: // Elerium Afterburners
                case 35: // UFO Tracking
                case 37: // Super Skyranger
                case 45: // UFO Scanners
                    return true;
                default:
                    break;
            }
        case 5: // Armor Technology
            switch (iTechId)
            {
                case 12: // Armored Fighters
                case 22: // Shaped Armor
                case 24: // Tactical Rigging
                case 29: // Mechanized Unit Defenses
                    return true;
                default:
                    break;
            }
        case 6: // Cybernetics
            switch (iTechId)
            {
                case 3:  // Improved Medikit
                case 5:  // Advanced Repair
                case 9:  // Drone Capture
                case 19: // Jellied Elerium
                case 20: // MEC Close Combat
                case 21: // Advanced Servomotors
                case 30: // Advanced Surgery
                case 36: // MEC Warfare Systems
                    return true;
                default:
                    break;
            }
        case 7: // Gauss Weaponry
            switch (iTechId)
            {
                case 13: // Mag Pistols
                case 14: // Rail Pistols
                case 44: // Phoenix Coilguns
                case 46: // Quenchguns
                    return true;
                default:
                    break;
            }
        case 8: // Psionics
            switch (iTechId)
            {
                case 41: // Psi Warfare Systems
                    return true;
                default:
                    break;
            }
        case 9: // All Technology
            return true;
    }

    return false;
}

function array<HL_TFoundryTech> HL_GetAvailableFoundryTechs()
{
    local array<HL_TFoundryTech> arrTechs;
    local HL_TFoundryTech kTech;

    foreach m_arrHLFoundryTechs(kTech)
    {
        if (kTech.bForceUnavailable)
        {
            continue;
        }

        if (kTech.iTechId != 0 && !ENGINEERING().IsFoundryTechResearched(kTech.iTechId) && HasFoundryPrereqs(kTech.iTechId))
        {
            if (!Highlander_XGFacility_Engineering(ENGINEERING()).HL_IsFoundryTechInQueue(kTech.iTechId))
            {
                arrTechs.AddItem(kTech);
            }
        }
    }

    return arrTechs;
}

function array<HL_TFoundryTech> HL_GetCompletedFoundryTechs()
{
    local array<HL_TFoundryTech> arrTechs;
    local HL_TFoundryTech kTech;

    foreach m_arrHLFoundryTechs(kTech)
    {
        if (kTech.iTechId != 0 && ENGINEERING().IsFoundryTechResearched(kTech.iTechId))
        {
            arrTechs.AddItem(kTech);
        }
    }

    return arrTechs;
}

function int HL_GetCreditAdjustedTechHours(int iTech, int iHours, bool bFoundry)
{
    local EResearchCredits eCredit;
    local int iCredit;
    local float fBonus;

    if (iHours == 0)
    {
        return 0;
    }

    for (iCredit = 1; iCredit < 10; iCredit++)
    {
        eCredit = EResearchCredits(iCredit);

        if (!LABS().HasResearchCredit(eCredit))
        {
            continue;
        }

        if ( (bFoundry && HL_CreditAppliesToFoundryTech(iCredit, iTech)) || CreditAppliesToTech(eCredit, ETechType(iTech)))
        {
            fBonus = float(GetResearchCredit(eCredit).iBonus) / 100.0;

            if (HQ().HasBonus(54) > 0) // Expertise
            {
                fBonus += (float(HQ().HasBonus(54)) / float(100));
            }

            fBonus *= float(iHours);

            if (fBonus < float(24))
            {
                fBonus = 24.0;
            }

            iHours -= int(fBonus);

            if (!bFoundry && iHours < 24)
            {
                iHours = 24;
            }
        }
    }

    return iHours;
}

function array<int> HL_GetFoundryResults(int iCompletedTechId)
{
    local array<int> arrResults;
    local int iItemReq, iTechReq;
    local HL_TFoundryTech kTech;

    if (iCompletedTechId == eTech_None || iCompletedTechId == eTech_MAX || !HQ().HasFacility(eFacility_Foundry))
    {
        return arrResults;
    }

    // Iterate all Foundry techs to find ones that will be available if iCompletedTechId is done
    foreach m_arrHLFoundryTechs(kTech)
    {
        // We only want newly-available techs, so anything that doesn't rely on the new research is out
        if (kTech.arrTechReqs.Find(iCompletedTechId) == INDEX_NONE)
        {
            continue;
        }

        // Validate item requirements
        foreach kTech.arrItemReqs(iItemReq)
        {
            if (!STORAGE().EverHadItem(iItemReq))
            {
                continue;
            }
        }

        // If there are other research requirements, check them
        foreach kTech.arrTechReqs(iTechReq)
        {
            if (iTechReq != iCompletedTechId && !LABS().IsResearched(iTechReq))
            {
                continue;
            }
        }

        arrResults.AddItem(kTech.iTechId);
    }

    return arrResults;
}

function HL_TFoundryTech HL_GetFoundryTech(int iFoundryTechType, optional bool bRushResearch)
{
    local HL_TFoundryTech BlankTech, kTech;

    foreach m_arrHLFoundryTechs(kTech)
    {
        if (kTech.iTechId == iFoundryTechType)
        {
            break;
        }
    }

    if (kTech.iTechId != iFoundryTechType)
    {
        kTech = BlankTech;
        kTech.iTechId = 0;
        return kTech;
    }

    if (bRushResearch)
    {
        kTech.iEngineers *= 1.50;
        kTech.iCash *= 1.50;
        kTech.iAlloys *= 1.50;
        kTech.iElerium *= 1.50;
    }

    // TODO: may want to add a hook for mods to modify the cost/continent bonus
    if (HQ().HasBonus(4) > 0) // New Warfare
    {
        kTech.iCash *= (float(1) - (float(HQ().HasBonus(4)) / float(100)));
        kTech.iAlloys *= (float(1) - (float(HQ().HasBonus(4)) / float(100)));
        kTech.iElerium *= (float(1) - (float(HQ().HasBonus(4)) / float(100)));
    }

    kTech.iHours = HL_GetCreditAdjustedTechHours(iFoundryTechType, kTech.iHours, true);

    return kTech;
}

function bool HasFoundryPrereqs(int iFoundryTech)
{
    local int iItemReq, iTechReq;
    local HL_TFoundryTech kTech;

    kTech = HL_GetFoundryTech(iFoundryTech);

    foreach kTech.arrItemReqs(iItemReq)
    {
        if (!STORAGE().EverHadItem(iItemReq))
        {
            return false;
        }
    }

    foreach kTech.arrTechReqs(iTechReq)
    {
        if (!LABS().IsResearched(iTechReq))
        {
            return false;
        }
    }

    return true;
}