class XComTacticalGame extends XComGameInfo
    config(Game)
    hidecategories(Navigation, Movement, Collision);

var bool bDebugCombatRequested;
var bool bNoVictory;
var bool m_bLoadingFromShell;
var bool m_bDisableLoadingScreen;
var name ForcedSpawnGroupTag;
var int ForcedSpawnGroupIndex;
var string strSaveFile;
var XComProfileGrid m_kProfileGrid;

defaultproperties
{
    m_bLoadingFromShell=true
    bUseSeamlessTravel=true
    HUDType=class'XComTacticalHUD'
    AutoTestManagerClass=class'XComAutoTestManager'
    GameReplicationInfoClass=class'XComTacticalGRI'
}