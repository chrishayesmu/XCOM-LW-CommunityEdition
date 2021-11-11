class HighlanderTestMod extends HighlanderModBase
    config(HighlanderTestMod);

var config array<HL_TTech> arrTechs;

function OnModLoaded()
{
    `HL_LOG_CLS("Mod loaded successfully");
}

function OnFoundryTechsBuilt(out array<HL_TFoundryTech> Techs)
{
    local int Index;
    local HL_TFoundryTech kNewTech;

    // For testing: get rid of the Enhanced Ballistics project
    Index = Techs.Find('iTechId', 1);

    if (Index != INDEX_NONE)
    {
        `HL_LOG_CLS("Found Enhanced Ballistics at index " $ Index $ ". Removing it.");
        Techs.Remove(Index, 1);
    }

    kNewTech.iTechId = 180000;
    kNewTech.strName = "HL: Test Project";
    kNewTech.strSummary = "This is a test project for the Highlander's modding capabilities.<br>This shouldn't be visible unless you've had an Alien Surgery, and have researched both Xenobiology and Elerium. "
                        $ "It benefits from Armor and Psionics research credits. The image is from laser research.";
    kNewTech.iHours = 24 * 7;
    kNewTech.iEngineers = 50;

    kNewTech.iCash = 150;
    kNewTech.iElerium = 10;
    kNewTech.iAlloys = 5;
    kNewTech.kCost.iCash = kNewTech.iCash;
    kNewTech.kCost.iElerium = kNewTech.iElerium;
    kNewTech.kCost.iAlloys = kNewTech.iAlloys;

    kNewTech.arrItemReqs.AddItem(169); // Alien Surgery

    kNewTech.arrTechReqs.AddItem(1);  // Xenobiology
    kNewTech.arrTechReqs.AddItem(12); // Elerium

    kNewTech.arrCredits.AddItem(5); // Armor credit
    kNewTech.arrCredits.AddItem(8); // Psionics credit

    kNewTech.ImagePath = "img:///UILibrary_StrategyImages.ScienceIcons.IC_LaserCannon";

    `HL_LOG_CLS("Adding new Foundry tech named '" $ kNewTech.strName $ "' with tech ID " $ kNewTech.iTechId);
    Techs.AddItem(kNewTech);
}

function OnResearchTechsBuilt(out array<HL_TTech> Techs)
{
    local HL_TTech kTech;

    `HL_LOG_CLS("Adding " $ arrTechs.Length $ " research techs");

    foreach arrTechs(kTech)
    {
        Techs.AddItem(kTech);
    }
}

defaultproperties
{
    ModFriendlyName="Highlander Test Mod"
    ModIDRange=(MinInclusive=180000, MaxInclusive=189999)
    VersionInfo=(Major=1, Minor=0, Revision=0)
}