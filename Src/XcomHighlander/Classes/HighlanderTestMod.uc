class HighlanderTestMod extends HighlanderModBase
    config(HighlanderTestMod);

var config array<HL_TTech> arrTechs;

function OnModLoaded()
{
    `HL_LOG_CLS("Mod loaded successfully");
}

defaultproperties
{
    ModFriendlyName="Highlander Test Mod"
    ModIDRange=(MinInclusive=180000, MaxInclusive=189999)
    VersionInfo=(Major=1, Minor=0, Revision=0)
    StrategyListenerClass=class'HighlanderTestMod_StrategyListener'
}