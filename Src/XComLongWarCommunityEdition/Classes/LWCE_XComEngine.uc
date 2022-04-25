class LWCE_XComEngine extends XComEngine;

var LWCE_XGLocalizeContext CELocalizeContext;

event BuildLocalization()
{
    local LWCE_XGLocalizeTag kTag;

    `LWCE_LOG_CLS("BuildLocalization");

    // Still need the base-game localization for places we haven't gotten to
    super.BuildLocalization();

    CELocalizeContext = new (self) class'LWCE_XGLocalizeContext';

    // TODO: mods almost certainly aren't loaded at this point, need a way for them to add tags too

    kTag = new (self) class'LWCE_XGAbilityTag';
    CELocalizeContext.arrLocalizeTags.AddItem(kTag);

    class'LWCE_XComLocalizer'.static.ExpandString("This is a string with <XGAbility:TacticalSenseDefenseBonusPerEnemy/> some tags <XGAbility:GeneModPupilsBonus/> and some text");
}

defaultproperties
{
    OnlineEventMgrClassName="XComLongWarCommunityEdition.LWCE_XComOnlineEventMgr"
}