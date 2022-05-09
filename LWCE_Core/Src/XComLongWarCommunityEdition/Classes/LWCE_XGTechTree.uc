class LWCE_XGTechTree extends XGTechTree
    dependson(LWCETypes)
    config(LWCEBaseStrategyGame);

var config array<LWCE_TFoundryTech> arrBaseGameFoundryProjects;
var config array<LWCE_TTech> arrBaseGameTechs;

var privatewrite array<LWCE_TFoundryTech> m_arrCEFoundryTechs;
var privatewrite array<LWCE_TTech> m_arrCETechs;

function Init()
{
    `LWCE_LOG_CLS("Override successful");

    BuildTechs();
    BuildFoundryTechs();
    BuildOTSTechs();
    BuildObjectives();
    BuildResearchCredits();
    BuildGeneTechs();

    ScaleForDynamicWar();
}

function BuildFoundryTechs()
{
    local LWCE_TFoundryTech BaseTech;

    foreach arrBaseGameFoundryProjects(BaseTech)
    {
        BaseTech.strName = class'XGLocalizedData'.default.FoundryTechNames[BaseTech.iTechId];
        BaseTech.strSummary = class'XGLocalizedData'.default.FoundryTechSummary[BaseTech.iTechId];

        m_arrCEFoundryTechs.AddItem(BaseTech);
   }

    // Clear out the base game tech list to help identify instances where it's being used
    m_arrFoundryTechs.Remove(0, m_arrFoundryTechs.Length);

    `LWCE_LOG_CLS("m_arrCEFoundryTechs length from base game: " $ m_arrCEFoundryTechs.Length);

    // Now provide a chance for mods to change the project list
    `LWCE_MOD_LOADER.OnFoundryTechsBuilt(m_arrCEFoundryTechs);

    `LWCE_LOG_CLS("m_arrCEFoundryTechs length after mod processing: " $ m_arrCEFoundryTechs.Length);
}

function BuildTechs()
{
    local int Index;
    local LWCE_TTech BaseTech;

    foreach arrBaseGameTechs(BaseTech)
    {
        BaseTech.strName     = class'XGLocalizedData'.default.TechTypeNames[BaseTech.iTechId];
        BaseTech.strCodename = class'XGLocalizedData'.default.TechTypeCodeName[BaseTech.iTechId];
        BaseTech.strCustom   = class'XGLocalizedData'.default.TechTypeResults[BaseTech.iTechId];
        BaseTech.strReport   = class'XComLocalizer'.static.ExpandString(class'XGLocalizedData'.default.TechTypeReport[BaseTech.iTechId]);
        BaseTech.strSummary  = class'XGLocalizedData'.default.TechTypeSummary[BaseTech.iTechId];

        m_arrCETechs.AddItem(BaseTech);
    }

    // Clear out the base game tech list to help identify instances where it's being used
    m_arrTechs.Remove(0, m_arrTechs.Length);

    `LWCE_LOG_CLS("m_arrCETechs length from base game: " $ m_arrCETechs.Length);

    // Now provide a chance for mods to change the research list
    `LWCE_MOD_LOADER.OnResearchTechsBuilt(m_arrCETechs);

    `LWCE_LOG_CLS("m_arrCETechs length after mod processing: " $ m_arrCETechs.Length);

    for (Index = 0; Index < m_arrCETechs.Length; Index++)
    {
        m_arrCETechs[Index].iHours *= class'XGTacticalGameCore'.default.TECH_TIME_BALANCE;
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

function bool LWCE_CreditAppliesToFoundryTech(int iCredit, int iTechId)
{
    local LWCE_TFoundryTech kTech;

    kTech = LWCE_GetFoundryTech(iTechId);

    return kTech.arrCredits.Find(iCredit) != INDEX_NONE;
}

function bool LWCE_CreditAppliesToTech(int iCredit, int iTech)
{
    local LWCE_TTech kTech;

    kTech = LWCE_GetTech(iTech);

    return kTech.arrCredits.Find(iCredit) != INDEX_NONE;
}

function array<LWCE_TFoundryTech> LWCE_GetAvailableFoundryTechs()
{
    local array<LWCE_TFoundryTech> arrTechs;
    local LWCE_TFoundryTech kTech;
    local LWCE_XGfacility_Engineering kEngineering;

    kEngineering = `LWCE_ENGINEERING;

    foreach m_arrCEFoundryTechs(kTech)
    {
        if (kTech.bForceUnavailable)
        {
            continue;
        }

        if (kTech.iTechId != 0 && !kEngineering.IsFoundryTechResearched(kTech.iTechId) && HasFoundryPrereqs(kTech.iTechId))
        {
            if (!kEngineering.LWCE_IsFoundryTechInQueue(kTech.iTechId))
            {
                arrTechs.AddItem(kTech);
            }
        }
    }

    return arrTechs;
}

function array<LWCE_TFoundryTech> LWCE_GetCompletedFoundryTechs()
{
    local array<LWCE_TFoundryTech> arrTechs;
    local LWCE_TFoundryTech kTech;

    foreach m_arrCEFoundryTechs(kTech)
    {
        if (kTech.iTechId != 0 && ENGINEERING().IsFoundryTechResearched(kTech.iTechId))
        {
            arrTechs.AddItem(kTech);
        }
    }

    return arrTechs;
}

function int LWCE_GetCreditAdjustedTechHours(int iTech, int iHours, bool bFoundry)
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

        if ( (bFoundry && LWCE_CreditAppliesToFoundryTech(iCredit, iTech)) || LWCE_CreditAppliesToTech(eCredit, iTech))
        {
            fBonus = float(GetResearchCredit(eCredit).iBonus) / 100.0;

            if (HQ().HasBonus(`LW_HQ_BONUS_ID(Expertise)) > 0)
            {
                fBonus += (float(HQ().HasBonus(`LW_HQ_BONUS_ID(Expertise))) / float(100));
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

function array<int> LWCE_GetGeneResults(int iTechId)
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

function array<int> LWCE_GetFoundryResults(int iCompletedTechId)
{
    local array<int> arrResults;
    local int iItemReq, iTechReq;
    local LWCE_TFoundryTech kTech;

    if (iCompletedTechId == 0 || iCompletedTechId == eTech_MAX || !HQ().HasFacility(eFacility_Foundry))
    {
        return arrResults;
    }

    // Iterate all Foundry techs to find ones that will be available if iCompletedTechId is done
    foreach m_arrCEFoundryTechs(kTech)
    {
        // We only want newly-available techs, so anything that doesn't rely on the new research is out
        if (kTech.kPrereqs.arrTechReqs.Find(iCompletedTechId) == INDEX_NONE)
        {
            continue;
        }

        // TODO: need to rewrite this to use LWCE_TPrereqs somehow. This logic works for all base game Foundry techs,
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

function LWCE_TFoundryTech LWCE_GetFoundryTech(int iFoundryTechType, optional bool bRushResearch)
{
    local LWCE_TFoundryTech BlankTech, kTech;

    foreach m_arrCEFoundryTechs(kTech)
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
    if (HQ().HasBonus(`LW_HQ_BONUS_ID(NewWarfare)) > 0)
    {
        kTech.kCost.iCash *= (float(1) - (float(HQ().HasBonus(`LW_HQ_BONUS_ID(NewWarfare))) / float(100)));
        kTech.kCost.iAlloys *= (float(1) - (float(HQ().HasBonus(`LW_HQ_BONUS_ID(NewWarfare))) / float(100)));
        kTech.kCost.iElerium *= (float(1) - (float(HQ().HasBonus(`LW_HQ_BONUS_ID(NewWarfare))) / float(100)));
    }

    kTech.iHours = LWCE_GetCreditAdjustedTechHours(iFoundryTechType, kTech.iHours, true);

    return kTech;
}

function array<int> GetItemResults(int iTech)
{
    local array<int> arrResults;
    local LWCE_XGItemTree kItemTree;
    local LWCE_TItem kItem;

    kItemTree = `LWCE_ITEMTREE;

    if (iTech == 0)
    {
        return arrResults;
    }

    foreach kItemTree.m_arrCEItems(kItem)
    {
        if (kItem.kPrereqs.arrTechReqs.Find(iTech) != INDEX_NONE)
        {
            arrResults.AddItem(kItem.iItemId);
        }
    }

    return arrResults;
}

function ETechType GetResultingTech(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_CLS(GetResultingTech);
    return 0;
}

function int LWCE_GetResultingTech(int iItemId)
{
    local LWCE_XGFacility_Labs kLabs;
    local int iTech;

    kLabs = `LWCE_LABS;

    for (iTech = 0; iTech < m_arrCETechs.Length; iTech++)
    {
        if (m_arrCETechs[iTech].kPrereqs.arrItemReqs.Find(iItemId) != INDEX_NONE && !kLabs.IsResearched(m_arrCETechs[iTech].iTechId))
        {
            return m_arrCETechs[iTech].iTechId;
        }
    }

    return 0;
}

function TTech GetTech(int iTechType, optional bool bAdjustHours = true)
{
    local TTech kTech;

    `LWCE_LOG_DEPRECATED_CLS(GetTech);

    return kTech;
}

function LWCE_TTech LWCE_GetTech(int iTechType, optional bool bAdjustHours = true)
{
    local int iProgressIndex;
    local LWCE_TTech kTech, BlankTech;
    local LWCE_XGFacility_Labs kLabs;

    kLabs = `LWCE_LABS;

    foreach m_arrCETechs(kTech)
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

    if ( (kTech.bIsAutopsy || kTech.bIsInterrogation) && HQ().HasBonus(`LW_HQ_BONUS_ID(WeHaveWays)) > 0)
    {
        kTech.iHours *= (float(1) - (float(HQ().HasBonus(`LW_HQ_BONUS_ID(WeHaveWays))) / float(100)));
    }

    if (bAdjustHours)
    {
        iProgressIndex = kLabs.m_arrCEProgress.Find('iTechId', iTechType);

        if (iProgressIndex != INDEX_NONE)
        {
            kTech.iHours -= kLabs.m_arrCEProgress[iProgressIndex].iHoursCompleted;
        }
    }

    // Mod hook to modify project cost/time
    `LWCE_MOD_LOADER.Override_GetTech(kTech, bAdjustHours);

    return kTech;
}

function bool HasFoundryPrereqs(int iFoundryTech)
{
    local LWCE_TFoundryTech kTech;

    kTech = LWCE_GetFoundryTech(iFoundryTech);

    if (!`LWCE_HQ.ArePrereqsFulfilled(kTech.kPrereqs))
    {
        return false;
    }

    // Mod hook for custom prereqs
    if (!`LWCE_MOD_LOADER.Override_HasFoundryPrereqs(kTech))
    {
        return false;
    }

    return true;
}

function bool HasPrereqs(int iTech)
{
    local LWCE_TTech kTech;

    kTech = LWCE_GetTech(iTech);

    if (!`LWCE_HQ.ArePrereqsFulfilled(kTech.kPrereqs))
    {
        return false;
    }

    // Mod hook for custom prereqs
    if (!`LWCE_MOD_LOADER.Override_HasPrereqs(kTech))
    {
        return false;
    }

    return true;
}

protected function ScaleForDynamicWar()
{
    local int Index;

    if (!IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
    {
        return;
    }

    for (Index = 0; Index < m_arrCETechs.Length; Index++)
    {
        m_arrCETechs[Index].kCost = ScaleCost(m_arrCETechs[Index].kCost);
    }

    for (Index = 0; Index < m_arrCEFoundryTechs.Length; Index++)
    {
        m_arrCETechs[Index].kCost = ScaleCost(m_arrCEFoundryTechs[Index].kCost);
    }
}

protected function LWCE_TCost ScaleCost(LWCE_TCost kCost)
{
    local int Index;

    // Weapon fragments and items are adjusted for Dynamic War, but notably, alloys, elerium and meld are not
    if (kCost.iWeaponFragments > 0)
    {
        kCost.iWeaponFragments = ScaleDynamicWarAmount(kCost.iWeaponFragments);
    }

    for (Index = 0; Index < kCost.arrItems.Length; Index++)
    {
        kCost.arrItems[Index].iQuantity = ScaleDynamicWarAmount(kCost.arrItems[Index].iQuantity);
    }

    return kCost;
}

protected function int ScaleDynamicWarAmount(int iInput)
{
    return Max(1, int(float(iInput) * class'XGTacticalGameCore'.default.SW_MARATHON));
}