class XComCheatManager extends CheatManager within XComPlayerControllerNativeBase
    native(Core);

struct native CommandSet
{
    var string Name;
    var array<string> Commands;
};

var UIDebugMenu DebugMenu;
var bool bLightDebugMode;
var bool bUseGlamCam;
var bool bUseAIGlamCam;
var bool bShowCamCage;
var bool m_bUseGlamBlend;
var bool m_bDebugVis;
var bool m_bDebugIK;
var bool bDebugHandIK;
var bool m_bStrategyAllFacilitiesAvailable;
var bool m_bStrategyAllFacilitiesFree;
var bool m_bStrategyAllFacilitiesInstaBuild;
var bool m_bNoWeaponsClass;
var bool m_bNoWeaponsTech;
var bool bDebuggingVisibilityToCursor;
var bool m_bAllowDebugMenu;
var bool m_bAllowShields;
var bool m_bAllowAbortBox;
var bool m_bAllowTether;
var bool bDebugFracDestruction;
var bool bSimulatingCombat;
var bool bNarrativeDisabled;
var bool bGhostMode;
var bool bDebugVisibility;
var bool bDebugFOW;
var XComTacticalController m_kPlayerControllerOwner;
var XComPresentationLayer m_kPres;
var XGCameraView m_kSavedView;
var string m_strGlamCamName;
var array<OnlineFriend> m_arrFriendsList;
var XGUnit m_kVisDebug;
var XComOnlineStatsRead m_kStatsRead;
var array<CommandSet> CommandSets;

delegate OSSFindDelegate()
{
}

delegate OSSJoinDelegate(int iGameIndex)
{
}

delegate OSSInfoDelegate()
{
}

defaultproperties
{
    bUseGlamCam=true
    bUseAIGlamCam=true
    m_bUseGlamBlend=true
    m_bAllowShields=true
    m_bAllowAbortBox=true
    m_bAllowTether=true
    m_strGlamCamName="NONE"
}