class Highlander_XGTechTree extends XGTechTree
    dependson(HighlanderTypes)
    config(HighlanderBaseStrategyGame);

var config array<HL_TTech> arrBaseGameTechs;

var privatewrite array<HL_TFoundryTech> m_arrHLFoundryTechs;
var privatewrite array<HL_TTech> m_arrHLTechs;

function Init()
{
    `HL_LOG_CLS("Override successful");

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
    // TODO: recreate these in our own config so we can get rid of some custom logic for them
    foreach m_arrFoundryTechs(BaseTech)
    {
        HighlanderTech = BlankHLTech;

        HighlanderTech.strName = BaseTech.strName;
        HighlanderTech.strSummary = BaseTech.strSummary;
        HighlanderTech.iTechId = BaseTech.iFoundryTech;
        HighlanderTech.iHours = BaseTech.iHours;
        HighlanderTech.iEngineers = BaseTech.iEngineers;
        HighlanderTech.kCost = class'HighlanderTypes'.static.ConvertTResearchCostToTCost(BaseTech.kCost);

        // For some reason vanilla techs have these in both the cost and the tech itself, and don't populate the fields in the cost
        HighlanderTech.kCost.iCash = BaseTech.iCash;
        HighlanderTech.kCost.iAlloys = BaseTech.iAlloys;
        HighlanderTech.kCost.iElerium = BaseTech.iElerium;

        if (BaseTech.iItemReq != 0)
        {
            HighlanderTech.kPrereqs.arrItemReqs.AddItem(BaseTech.iItemReq);
        }

        if (BaseTech.iTechReq != 0)
        {
            HighlanderTech.kPrereqs.arrTechReqs.AddItem(BaseTech.iTechReq);
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

function BuildTechs()
{
    local int Index;
    local HL_TTech BaseTech;

    foreach arrBaseGameTechs(BaseTech)
    {
        BaseTech.strName     = class'XGLocalizedData'.default.TechTypeNames[BaseTech.iTechId];
        BaseTech.strCodename = class'XGLocalizedData'.default.TechTypeCodeName[BaseTech.iTechId];
        BaseTech.strCustom   = class'XGLocalizedData'.default.TechTypeResults[BaseTech.iTechId];
        BaseTech.strReport   = class'XComLocalizer'.static.ExpandString(class'XGLocalizedData'.default.TechTypeReport[BaseTech.iTechId]);
        BaseTech.strSummary  = class'XGLocalizedData'.default.TechTypeSummary[BaseTech.iTechId];

        m_arrHLTechs.AddItem(BaseTech);
    }

    // Clear out the base game tech list to help identify instances where it's being used
    m_arrTechs.Remove(0, m_arrTechs.Length);

    `HL_LOG_CLS("m_arrHLTechs length from base game: " $ m_arrHLTechs.Length);

    // Now provide a chance for mods to change the research list
    `HL_MOD_LOADER.OnResearchTechsBuilt(m_arrHLTechs);

    `HL_LOG_CLS("m_arrHLTechs length after mod processing: " $ m_arrHLTechs.Length);

    for (Index = 0; Index < m_arrHLTechs.Length; Index++)
    {
        m_arrHLTechs[Index].iHours *= class'XGTacticalGameCore'.default.TECH_TIME_BALANCE;
    }
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
    local HL_TFoundryTech kTech;

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

    kTech = `HL_FTECH(iTechId);

    if (kTech.arrCredits.Find(iCredit) != INDEX_NONE)
    {
        return true;
    }

    return false;
}

function bool HL_CreditAppliesToTech(int iCredit, int iTech)
{
    local HL_TTech kTech;

    kTech = HL_GetTech(iTech);

    return kTech.arrCredits.Find(iCredit) != INDEX_NONE;
}

function array<HL_TFoundryTech> HL_GetAvailableFoundryTechs()
{
    local array<HL_TFoundryTech> arrTechs;
    local HL_TFoundryTech kTech;
    local Highlander_XGfacility_Engineering kEngineering;

    kEngineering = `HL_ENGINEERING;

    foreach m_arrHLFoundryTechs(kTech)
    {
        if (kTech.bForceUnavailable)
        {
            continue;
        }

        if (kTech.iTechId != 0 && !kEngineering.IsFoundryTechResearched(kTech.iTechId) && HasFoundryPrereqs(kTech.iTechId))
        {
            if (!kEngineering.HL_IsFoundryTechInQueue(kTech.iTechId))
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

        if ( (bFoundry && HL_CreditAppliesToFoundryTech(iCredit, iTech)) || HL_CreditAppliesToTech(eCredit, iTech))
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

function array<int> HL_GetGeneResults(int iTechId)
{
    local array<int> arrResults;
    local int iGeneMod;

    if (iTechId == 0 || iTechId == 76)
    {
        return arrResults;
    }

    if (!HQ().HasFacility(eFacility_GeneticsLab))
    {
        return arrResults;
    }

    for (iGeneMod = 0; iGeneMod < 11; iGeneMod++)
    {
        // TODO: rewrite the TGeneModTech struct to not use ETechType
        if (GetGeneTech(EGeneModTech(iGeneMod)).eTechReq == iTechId)
        {
            arrResults.AddItem(iGeneMod);
        }
    }

    return arrResults;
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
        if (kTech.kPrereqs.arrTechReqs.Find(iCompletedTechId) == INDEX_NONE)
        {
            continue;
        }

        // TODO: need to rewrite this to use HL_TPrereqs somehow. This logic works for all base game Foundry techs,
        // but it will throw off any modded projects using other prereq fields

        // Validate item requirements
        foreach kTech.kPrereqs.arrItemReqs(iItemReq)
        {
            if (!STORAGE().EverHadItem(iItemReq))
            {
                continue;
            }
        }

        // If there are other research requirements, check them
        foreach kTech.kPrereqs.arrTechReqs(iTechReq)
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
        kTech.kCost.iCash *= 1.50;
        kTech.kCost.iAlloys *= 1.50;
        kTech.kCost.iElerium *= 1.50;
    }

    // TODO: may want to add a hook for mods to modify the cost/continent bonus
    if (HQ().HasBonus(4) > 0) // New Warfare
    {
        kTech.kCost.iCash *= (float(1) - (float(HQ().HasBonus(4)) / float(100)));
        kTech.kCost.iAlloys *= (float(1) - (float(HQ().HasBonus(4)) / float(100)));
        kTech.kCost.iElerium *= (float(1) - (float(HQ().HasBonus(4)) / float(100)));
    }

    kTech.iHours = HL_GetCreditAdjustedTechHours(iFoundryTechType, kTech.iHours, true);

    return kTech;
}

function TTech GetTech(int iTechType, optional bool bAdjustHours = true)
{
    local TTech kTech;

    `HL_LOG_DEPRECATED_CLS(GetTech);

    return kTech;
}

function HL_TTech HL_GetTech(int iTechType, optional bool bAdjustHours = true)
{
    local int iProgressIndex;
    local HL_TTech kTech, BlankTech;
    local Highlander_XGFacility_Labs kLabs;

    kLabs = `HL_LABS;

    foreach m_arrHLTechs(kTech)
    {
        if (kTech.iTechId == iTechType)
        {
            break;
        }
    }

    if (kTech.iTechId != iTechType)
    {
        return BlankTech;
    }

    kTech.iHours = GetCreditAdjustedTechHours(iTechType, kTech.iHours, false);

    if (HQ().HasBonus(57) > 0) // We Have Ways
    {
        if (kTech.bIsAutopsy || kTech.bIsInterrogation)
        {
            kTech.iHours *= (float(1) - (float(HQ().HasBonus(57)) / float(100)));
        }
    }

    if (bAdjustHours)
    {
        iProgressIndex = kLabs.m_arrHLProgress.Find('iTechId', iTechType);

        if (iProgressIndex != INDEX_NONE)
        {
            kTech.iHours -= kLabs.m_arrHLProgress[iProgressIndex].iHoursCompleted;
        }
    }

    // Mod hook to modify project cost/time
    `HL_MOD_LOADER.Override_GetTech(kTech, bAdjustHours);

    return kTech;
}

function bool HasFoundryPrereqs(int iFoundryTech)
{
    local HL_TFoundryTech kTech;

    kTech = HL_GetFoundryTech(iFoundryTech);

    if (!`HL_HQ.ArePrereqsFulfilled(kTech.kPrereqs))
    {
        return false;
    }

    // Mod hook for custom prereqs
    if (!`HL_MOD_LOADER.Override_HasFoundryPrereqs(kTech))
    {
        return false;
    }

    return true;
}

function bool HasPrereqs(int iTech)
{
    local HL_TTech kTech;

    kTech = HL_GetTech(iTech);

    if (!`HL_HQ.ArePrereqsFulfilled(kTech.kPrereqs))
    {
        return false;
    }

    // Mod hook for custom prereqs
    if (!`HL_MOD_LOADER.Override_HasPrereqs(kTech))
    {
        return false;
    }

    return true;
}