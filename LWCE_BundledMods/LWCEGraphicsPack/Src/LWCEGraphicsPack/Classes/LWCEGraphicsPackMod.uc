class LWCEGraphicsPackMod extends LWCEModBase
    config(LWCEGraphicsPack);

var config bool bEnableDynamicLighting;
var config bool bMeldLightingAlwaysActive;

defaultproperties
{
    ModFriendlyName="LW:CE Enhanced Graphics Pack"
    ModIDRange=(MinInclusive=1703070000, MaxInclusive=1703079999)
    VersionInfo=(Major=0, Minor=1, Revision=0)
    StrategyListenerClass=none
    TacticalListenerClass=class'LWCEGraphicsPackTacticalListener'
}