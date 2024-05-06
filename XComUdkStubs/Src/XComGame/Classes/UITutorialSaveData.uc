class UITutorialSaveData extends Actor
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord_UITutorialSaveData
{
    var array<int> m_arrHelpMessages_AbilityTypes;
    var bool m_bShownHowToMoveSoldiers;
    var bool m_bShownHowToSwitchSoldiers;
    var bool m_bShownHowToEndTurn;
    var string DEBUG_testString1;
    var string DEBUG_testString2;
};

var array<int> m_arrHelpMessages_AbilityTypes;
var bool m_bShownHowToMoveSoldiers;
var bool m_bShownHowToSwitchSoldiers;
var bool m_bShownHowToEndTurn;
var string DEBUG_testString1;
var string DEBUG_testString2;

defaultproperties
{
    DEBUG_testString1="default1"
    DEBUG_testString2="default2"
}