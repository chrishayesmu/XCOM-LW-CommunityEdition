class LWCE_XGTechTree extends XGTechTree
    dependson(LWCETypes)
    config(LWCEBaseStrategyGame);

var private LWCEFoundryProjectTemplateManager m_kFoundryTemplateMgr;
var private LWCETechTemplateManager m_kTechTemplateMgr;

function Init()
{
    m_kFoundryTemplateMgr = `LWCE_FOUNDRY_TEMPLATE_MGR;
    m_kTechTemplateMgr = `LWCE_TECH_TEMPLATE_MGR;

    BuildTechs();
    BuildFoundryTechs();
    BuildOTSTechs();
    BuildObjectives();
    BuildResearchCredits();
    BuildGeneTechs();
}

function BuildFoundryTechs()
{
    // Clear out the base game tech list to help identify instances where it's being used
    m_arrFoundryTechs.Remove(0, m_arrFoundryTechs.Length);
}

function BuildTechs()
{
    // Clear out the base game tech list to help identify instances where it's being used
    m_arrTechs.Remove(0, m_arrTechs.Length);
}

/// <summary>
/// Performs a check for the Skunkworks achievement, which is earned by completing all Foundry projects.
/// </summary>
function bool CheckForSkunkworks()
{
    local array<name> arrFoundryTemplateNames;
    local LWCE_XGFacility_Engineering kEngineering;
    local int Index;

    arrFoundryTemplateNames = m_kFoundryTemplateMgr.GetTemplateNames();
    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());

    for (Index = 0; Index < arrFoundryTemplateNames.Length; Index++)
    {
        if (!kEngineering.LWCE_IsFoundryTechResearched(arrFoundryTemplateNames[Index]))
        {
            return false;
        }
    }

    return true;
}

function bool LWCE_CreditAppliesToFoundryTech(name CreditName, name FoundryTechName)
{
    local LWCEFoundryProjectTemplate kTemplate;

    kTemplate = `LWCE_FTECH(FoundryTechName);

    if (kTemplate != none)
    {
        return kTemplate.BenefitsFromCredit(CreditName);
    }

    return false;
}

function bool LWCE_CreditAppliesToTech(name CreditName, name TechName)
{
    local LWCETechTemplate kTemplate;

    kTemplate = m_kTechTemplateMgr.FindTechTemplate(TechName);

    if (kTemplate != none)
    {
        return kTemplate.BenefitsFromCredit(CreditName);
    }

    return false;
}

function array<LWCEFoundryProjectTemplate> LWCE_GetAvailableFoundryTechs()
{
    local name ProjectName;
    local array<LWCEFoundryProjectTemplate> arrAvailableTechs, arrTemplates;
    local LWCEFoundryProjectTemplate kTemplate;
    local LWCE_XGfacility_Engineering kEngineering;

    kEngineering = `LWCE_ENGINEERING;
    arrTemplates = m_kFoundryTemplateMgr.GetAllProjectTemplates();

    foreach arrTemplates(kTemplate)
    {
        ProjectName = kTemplate.GetProjectName();

        if (kTemplate.bForceUnavailable)
        {
            continue;
        }

        if (ProjectName != '' && !kEngineering.LWCE_IsFoundryTechResearched(ProjectName) && LWCE_HasFoundryPrereqs(ProjectName))
        {
            if (!kEngineering.LWCE_IsFoundryTechInQueue(ProjectName))
            {
                arrAvailableTechs.AddItem(kTemplate);
            }
        }
    }

    return arrAvailableTechs;
}

function array<LWCEFoundryProjectTemplate> LWCE_GetCompletedFoundryTechs()
{
    local array<LWCEFoundryProjectTemplate> arrCompletedTechs, arrTemplates;
    local LWCEFoundryProjectTemplate kTemplate;
    local LWCE_XGfacility_Engineering kEngineering;

    kEngineering = `LWCE_ENGINEERING;
    arrTemplates = m_kFoundryTemplateMgr.GetAllProjectTemplates();

    foreach arrTemplates(kTemplate)
    {
        if (kTemplate.GetProjectName() != '' && kEngineering.LWCE_IsFoundryTechResearched(kTemplate.GetProjectName()))
        {
            arrCompletedTechs.AddItem(kTemplate);
        }
    }

    return arrCompletedTechs;
}

// TODO: split this into two functions
function int LWCE_GetCreditAdjustedTechHours(name TechName, int iHours, bool bFoundry)
{
    local LWCETechTemplate kTemplate;
    local LWCE_XGFacility_Labs kLabs;
    local name CreditName;
    local int Index;
    local float fBonus;

    if (iHours == 0)
    {
        return 0;
    }

    kLabs = LWCE_XGFacility_Labs(LABS());
    kTemplate = m_kTechTemplateMgr.FindTechTemplate(TechName);

    if (kTemplate == none)
    {
        return -1;
    }

    for (Index = 0; Index < kTemplate.arrCreditsApplied.Length; Index++)
    {
        CreditName = kTemplate.arrCreditsApplied[Index];

        if (!kLabs.LWCE_HasResearchCredit(CreditName))
        {
            continue;
        }

        if ( (bFoundry && LWCE_CreditAppliesToFoundryTech(CreditName, TechName)) || LWCE_CreditAppliesToTech(CreditName, TechName))
        {
            fBonus = float(LWCE_GetResearchCredit(CreditName).iBonus) / 100.0f;

            if (HQ().HasBonus(`LW_HQ_BONUS_ID(Expertise)) > 0)
            {
                fBonus += (float(HQ().HasBonus(`LW_HQ_BONUS_ID(Expertise))) / 100.0f);
            }

            fBonus *= iHours;

            if (fBonus < 24.0f)
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

function array<int> GetFacilityResults(int iTech)
{
    local array<int> arrFacilities;
    arrFacilities.Add(0);

    `LWCE_LOG_DEPRECATED_CLS(GetFacilityResults);

    return arrFacilities;
}

function array<int> LWCE_GetFacilityResults(name TechName)
{
    local array<int> arrResults;

    // TODO: these shouldn't be hardcoded, but facilities aren't converted to LWCE yet
    switch (TechName)
    {
        case 'Tech_AlienCommandAndControl':
            arrResults.AddItem(eFacility_DeusEx);
            break;
        case 'Tech_AlienCommunications':
            arrResults.AddItem(eFacility_HyperwaveRadar);
            break;
        case 'Tech_AlienComputers':
            arrResults.AddItem(eFacility_LargeRadar);
            break;
        case 'Tech_AlienPowerSystems':
            arrResults.AddItem(eFacility_EleriumGenerator);
            break;
        case 'Tech_Xenobiology':
            arrResults.AddItem(eFacility_AlienContain);
            break;
        case 'Tech_Xenogenetics':
            arrResults.AddItem(eFacility_GeneticsLab);
            break;
        case 'Tech_Xenopsionics':
            arrResults.AddItem(eFacility_PsiLabs);
            break;
    }

    return arrResults;
}

function array<int> LWCE_GetGeneResults(name TechName)
{
    local array<int> arrResults;
    local int iGeneMod;

    arrResults.Length = 0;

    if (TechName == '')
    {
        return arrResults;
    }

    if (!HQ().HasFacility(eFacility_GeneticsLab))
    {
        return arrResults;
    }

    for (iGeneMod = 0; iGeneMod < 11; iGeneMod++)
    {
        /*
        // TODO: rewrite the TGeneModTech struct to not use ETechType
        if (GetGeneTech(EGeneModTech(iGeneMod)).eTechReq == TechName)
        {
            arrResults.AddItem(iGeneMod);
        }
         */
    }

    return arrResults;
}

function array<name> LWCE_GetFoundryResults(name CompletedTechName)
{
    local array<LWCEFoundryProjectTemplate> arrTemplates;
    local array<name> arrResults;
    local bool bIsValid;
    local name nmItemReq, nmTechReq;
    local LWCEFoundryProjectTemplate kTemplate;
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGStorage kStorage;

    if (CompletedTechName == '' || !HQ().HasFacility(eFacility_Foundry))
    {
        return arrResults;
    }

    kLabs = LWCE_XGFacility_Labs(LABS());
    kStorage = LWCE_XGStorage(STORAGE());
    arrTemplates = m_kFoundryTemplateMgr.GetAllProjectTemplates();

    // Iterate all Foundry techs to find ones that will be available if iCompletedTechId is done
    foreach arrTemplates(kTemplate)
    {
        bIsValid = true;

        // We only want newly-available techs, so anything that doesn't rely on the new research is out
        if (kTemplate.kPrereqs.arrTechReqs.Find(CompletedTechName) == INDEX_NONE)
        {
            continue;
        }

        // TODO: need to rewrite this to use LWCE_TPrereqs somehow. This logic works for all base game Foundry techs,
        // but it will throw off any modded projects using other prereq fields

        // Validate item requirements
        foreach kTemplate.kPrereqs.arrItemReqs(nmItemReq)
        {
            if (!kStorage.LWCE_EverHadItem(nmItemReq))
            {
                bIsValid = false;
                break;
            }
        }

        // If there are other research requirements, check them
        foreach kTemplate.kPrereqs.arrTechReqs(nmTechReq)
        {
            if (nmTechReq != CompletedTechName && !kLabs.LWCE_IsResearched(nmTechReq))
            {
                bIsValid = false;
                break;
            }
        }

        if (bIsValid)
        {
            arrResults.AddItem(kTemplate.GetProjectName());
        }
    }

    return arrResults;
}

function TFoundryTech GetFoundryTech(int iFoundryTechType, optional bool bRushResearch)
{
    local TFoundryTech kTech;

    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetFoundryTech was called. This needs to be replaced with the macro LWCE_FTECH. Stack trace follows.");
    ScriptTrace();

    return kTech;
}

function array<int> GetItemResults(int iTech)
{
    local array<int> arrResults;

    `LWCE_LOG_DEPRECATED_CLS(GetItemResults);

    arrResults.Add(0);
    return arrResults;
}

function array<name> LWCE_GetItemResults(name TechName)
{
    local array<name> arrResults;
    local array<LWCEItemTemplate> arrTemplates;
    local LWCEItemTemplate kItem;

    if (TechName == '')
    {
        return arrResults;
    }

    arrTemplates = `LWCE_ITEM_TEMPLATE_MGR.GetAllItemTemplates();

    foreach arrTemplates(kItem)
    {
        if (kItem.kPrereqs.arrTechReqs.Find(TechName) != INDEX_NONE)
        {
            arrResults.AddItem(kItem.GetItemName());
        }
    }

    return arrResults;
}

function TResearchCredit GetResearchCredit(EResearchCredits eCredit)
{
    local TResearchCredit kCredit;

    `LWCE_LOG_DEPRECATED_CLS(GetResearchCredit);

    return kCredit;
}

function TResearchCredit LWCE_GetResearchCredit(name CreditName)
{
    local EResearchCredits eCredit;

    // TODO: make credits truly configurable

    switch (CreditName)
    {
        case 'Aerospace':
            eCredit = eResearchCredit_Armor_I;
            break;
        case 'All':
            eCredit = eResearchCredit_AllTech;
            break;
        case 'AllArmor':
            eCredit = eResearchCredit_AllArmor;
            break;
        case 'AllWeapons':
            eCredit = eResearchCredit_AllWeapons;
            break;
        case 'Cybernetics':
            eCredit = eResearchCredit_UFOTech;
            break;
        case 'GaussWeapons':
            eCredit = eResearchCredit_Flight;
            break;
        case 'LaserWeapons':
            eCredit = eResearchCredit_Weapons_I;
            break;
        case 'PlasmaWeapons':
            eCredit = eResearchCredit_PlasmaWeapons;
            break;
        case 'Psionics':
            eCredit = eResearchCredit_Psionics;
            break;
    }

    return m_arrResearchCredits[int(eCredit)];
}

function ETechType GetResultingTech(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_CLS(GetResultingTech);
    return 0;
}

// TODO: this should return an array
function name LWCE_GetResultingTech(name ItemName)
{
    local array<LWCETechTemplate> arrTemplates;
    local LWCE_XGFacility_Labs kLabs;
    local int Index;

    kLabs = `LWCE_LABS;
    arrTemplates = m_kTechTemplateMgr.GetAllTechTemplates();

    for (Index = 0; Index < arrTemplates.Length; Index++)
    {
        if (arrTemplates[Index].kPrereqs.arrItemReqs.Find(ItemName) != INDEX_NONE && !kLabs.LWCE_IsResearched(arrTemplates[Index].GetTechName()))
        {
            return arrTemplates[Index].GetTechName();
        }
    }

    return '';
}

function TTech GetTech(int iTechType, optional bool bAdjustHours = true)
{
    local TTech kTech;

    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetTech was called. This needs to be replaced with the macro LWCE_TECH. Stack trace follows.");
    ScriptTrace();

    return kTech;
}

function bool HasFoundryPrereqs(int ProjectName)
{
    `LWCE_LOG_DEPRECATED_CLS(HasFoundryPrereqs);

    return false;
}

function bool LWCE_HasFoundryPrereqs(name ProjectName)
{
    local LWCEFoundryProjectTemplate kTech;

    kTech = `LWCE_FTECH(ProjectName);

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
    `LWCE_LOG_DEPRECATED_CLS(HasPrereqs);

    return false;
}

function bool LWCE_HasPrereqs(name TechName)
{
    local LWCETechTemplate kTech;

    kTech = m_kTechTemplateMgr.FindTechTemplate(TechName);

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

/// <summary>
/// Maps from a base game tech ID to its LWCE template name. This is only intended for backwards
/// compatibility with certain parts of the game that are difficult to modify directly. Mods should
/// never invoke this function.
/// </summary>
static function name TechNameFromInteger(int iTechId)
{
    switch (iTechId)
    {
        case `LW_TECH_ID(AdvancedAerospaceConcepts):
            return 'Tech_AdvancedAerospaceConcepts';
        case `LW_TECH_ID(AdvancedBeamLasers):
            return 'Tech_AdvancedBeamLasers';
        case `LW_TECH_ID(AdvancedBodyArmor):
            return 'Tech_AdvancedBodyArmor';
        case `LW_TECH_ID(AdvancedGaussWeapons):
            return 'Tech_AdvancedGaussWeapons';
        case `LW_TECH_ID(AdvancedPlasmaWeapons):
            return 'Tech_AdvancedPlasmaWeapons';
        case `LW_TECH_ID(AdvancedPowerArmor):
            return 'Tech_AdvancedPowerArmor';
        case `LW_TECH_ID(AdvancedPulseLasers):
            return 'Tech_AdvancedPulseLasers';
        case `LW_TECH_ID(AlienBiocybernetics):
            return 'Tech_AlienBiocybernetics';
        case `LW_TECH_ID(AlienCommandAndControl):
            return 'Tech_AlienCommandAndControl';
        case `LW_TECH_ID(AlienCommunications):
            return 'Tech_AlienCommunications';
        case `LW_TECH_ID(AlienComputers):
            return 'Tech_AlienComputers';
        case `LW_TECH_ID(AlienMaterials):
            return 'Tech_AlienMaterials';
        case `LW_TECH_ID(AlienOperations):
            return 'Tech_AlienOperations';
        case `LW_TECH_ID(AlienPowerSystems):
            return 'Tech_AlienPowerSystems';
        case `LW_TECH_ID(AlienPropulsion):
            return 'Tech_AlienPropulsion';
        case `LW_TECH_ID(AlienWeaponry):
            return 'Tech_AlienWeaponry';
        case `LW_TECH_ID(AntigravSystems):
            return 'Tech_AntigravSystems';
        case `LW_TECH_ID(BeamLasers):
            return 'Tech_BeamLasers';
        case `LW_TECH_ID(BerserkerAutopsy):
            return 'Tech_AutopsyBerserker';
        case `LW_TECH_ID(ChryssalidAutopsy):
            return 'Tech_AutopsyChryssalid';
        case `LW_TECH_ID(CompactPlasmaWeapons):
            return 'Tech_CompactPlasmaWeapons';
        case `LW_TECH_ID(CyberdiscAutopsy):
            return 'Tech_AutopsyCyberdisc';
        case `LW_TECH_ID(DroneAutopsy):
            return 'Tech_AutopsyDrone';
        case `LW_TECH_ID(ElectromagneticPulseWeapons):
            return 'Tech_ElectromagneticPulseWeapons';
        case `LW_TECH_ID(Elerium):
            return 'Tech_Elerium';
        case `LW_TECH_ID(EtherealAutopsy):
            return 'Tech_AutopsyEthereal';
        case `LW_TECH_ID(ExperimentalWarfare):
            return 'Tech_ExperimentalWarfare';
        case `LW_TECH_ID(FloaterAutopsy):
            return 'Tech_AutopsyFloater';
        case `LW_TECH_ID(FusionWeapons):
            return 'Tech_FusionWeapons';
        case `LW_TECH_ID(GaussWeapons):
            return 'Tech_GaussWeapons';
        case `LW_TECH_ID(HeavyCombatExoskeletons):
            return 'Tech_HeavyCombatExoskeletons';
        case `LW_TECH_ID(HeavyFloaterAutopsy):
            return 'Tech_AutopsyHeavyFloater';
        case `LW_TECH_ID(HeavyPlasmaWeapons):
            return 'Tech_HeavyPlasmaWeapons';
        case `LW_TECH_ID(ImprovedBodyArmor):
            return 'Tech_ImprovedBodyArmor';
        case `LW_TECH_ID(ImprovedCombatExoskeletons):
            return 'Tech_ImprovedCombatExoskeletons';
        case `LW_TECH_ID(InterrogateBerserker):
            return 'Tech_InterrogateBerserker';
        case `LW_TECH_ID(InterrogateEthereal):
            return 'Tech_InterrogateEthereal';
        case `LW_TECH_ID(InterrogateFloater):
            return 'Tech_InterrogateFloater';
        case `LW_TECH_ID(InterrogateHeavyFloater):
            return 'Tech_InterrogateHeavyFloater';
        case `LW_TECH_ID(InterrogateMuton):
            return 'Tech_InterrogateMuton';
        case `LW_TECH_ID(InterrogateMutonElite):
            return 'Tech_InterrogateMutonElite';
        case `LW_TECH_ID(InterrogateSectoid):
            return 'Tech_InterrogateSectoid';
        case `LW_TECH_ID(InterrogateSectoidCommander):
            return 'Tech_InterrogateSectoidCommander';
        case `LW_TECH_ID(InterrogateThinMan):
            return 'Tech_InterrogateThinMan';
        case `LW_TECH_ID(MechtoidAutopsy):
            return 'Tech_AutopsyMechtoid';
        case `LW_TECH_ID(MindAndMachine):
            return 'Tech_MindAndMachine';
        case `LW_TECH_ID(MobileCombatExoskeletons):
            return 'Tech_MobileCombatExoskeletons';
        case `LW_TECH_ID(MobilePowerArmor):
            return 'Tech_MobilePowerArmor';
        case `LW_TECH_ID(MutonAutopsy):
            return 'Tech_AutopsyMuton';
        case `LW_TECH_ID(MutonEliteAutopsy):
            return 'Tech_AutopsyMutonElite';
        case `LW_TECH_ID(PlasmaWeapons):
            return 'Tech_PlasmaWeapons';
        case `LW_TECH_ID(PrecisionPlasmaWeapons):
            return 'Tech_PrecisionPlasmaWeapons';
        case `LW_TECH_ID(PulseLasers):
            return 'Tech_PulseLasers';
        case `LW_TECH_ID(SectoidAutopsy):
            return 'Tech_AutopsySectoid';
        case `LW_TECH_ID(SectoidCommanderAutopsy):
            return 'Tech_AutopsySectoidCommander';
        case `LW_TECH_ID(SectopodAutopsy):
            return 'Tech_AutopsySectopod';
        case `LW_TECH_ID(SeekerAutopsy):
            return 'Tech_AutopsySeeker';
        case `LW_TECH_ID(StealthSystems):
            return 'Tech_StealthSystems';
        case `LW_TECH_ID(ThinManAutopsy):
            return 'Tech_AutopsyThinMan';
        case `LW_TECH_ID(UFOAnalysisAbductor):
            return 'Tech_UFOAnalysis_Abductor';
        case `LW_TECH_ID(UFOAnalysisAssaultCarrier):
            return 'Tech_UFOAnalysis_AssaultCarrier';
        case `LW_TECH_ID(UFOAnalysisBattleship):
            return 'Tech_UFOAnalysis_Battleship';
        case `LW_TECH_ID(UFOAnalysisDestroyer):
            return 'Tech_UFOAnalysis_Destroyer';
        case `LW_TECH_ID(UFOAnalysisFighter):
            return 'Tech_UFOAnalysis_Fighter';
        case `LW_TECH_ID(UFOAnalysisHarvester):
            return 'Tech_UFOAnalysis_Harvester';
        case `LW_TECH_ID(UFOAnalysisOverseer):
            return 'Tech_UFOAnalysis_Overseer';
        case `LW_TECH_ID(UFOAnalysisRaider):
            return 'Tech_UFOAnalysis_Raider';
        case `LW_TECH_ID(UFOAnalysisScout):
            return 'Tech_UFOAnalysis_Scout';
        case `LW_TECH_ID(UFOAnalysisTerrorShip):
            return 'Tech_UFOAnalysis_TerrorShip';
        case `LW_TECH_ID(UFOAnalysisTransport):
            return 'Tech_UFOAnalysis_Transport';
        case `LW_TECH_ID(VehicularPlasmaWeapons):
            return 'Tech_VehicularPlasmaWeapons';
        case `LW_TECH_ID(Xenobiology):
            return 'Tech_Xenobiology';
        case `LW_TECH_ID(Xenogenetics):
            return 'Tech_Xenogenetics';
        case `LW_TECH_ID(Xenoneurology):
            return 'Tech_Xenoneurology';
        case `LW_TECH_ID(Xenopsionics):
            return 'Tech_Xenopsionics';
        default:
            `LWCE_LOG_CLS("ERROR: TechNameFromInteger is only intended for base game techs. Tech ID " $ iTechId $ " is not valid!");
            return '';
    }
}