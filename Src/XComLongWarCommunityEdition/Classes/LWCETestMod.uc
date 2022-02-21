class LWCETestMod extends LWCEModBase
    config(LWCETestMod);

var config array<LWCE_TTech> arrTechs;

function OnModLoaded()
{
    `LWCE_LOG_CLS("Mod loaded successfully");
}

defaultproperties
{
    ModFriendlyName="LWCE Test Mod"
    ModIDRange=(MinInclusive=180000, MaxInclusive=189999)
    VersionInfo=(Major=1, Minor=0, Revision=0)
    StrategyListenerClass=class'LWCETestMod_StrategyListener'
}