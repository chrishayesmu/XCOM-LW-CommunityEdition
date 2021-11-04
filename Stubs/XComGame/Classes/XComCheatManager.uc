class XComCheatManager extends CheatManager within XComPlayerControllerNativeBase
    native(Core)
	dependson(XComMCPTypes);
//complete stub (1 minor missing)

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
var delegate<OSSFindDelegate> __OSSFindDelegate__Delegate;
var delegate<OSSJoinDelegate> __OSSJoinDelegate__Delegate;
var delegate<OSSInfoDelegate> __OSSInfoDelegate__Delegate;

delegate OSSFindDelegate();
delegate OSSJoinDelegate(int iGameIndex);
delegate OSSInfoDelegate();

native simulated function LoadCommandSets();

exec function RunCommandSet(string CommandSetName){}
exec function DisableNarrative(){}
exec function DoAutoTest(){}
exec function TestMe(){}
exec function ClearNarrativeHistory(){}
exec function PreloadNarrative(XComNarrativeMoment Moment){}
exec function TestNarrativeClearing(){}
exec function TestNarrativeClearing2(){}
exec function DoNarrative(XComNarrativeMoment Moment){}
exec function ValidateNarratives(){}
exec function AchieveEasyGame(){}
exec function AchieveNormalGame(){}
exec function AchieveHardGame(){}
exec function AchieveClassicGame(){}
exec function ClearGamesCompleted(){}
exec function DumpMapCounts(){}
exec function ResetMapCounts(){}
exec function MuffleVO(){}
exec function UnMuffleVO(){}
exec function DumpUnusedNarratives(){}
exec function DumpNarrativesNotInHistory(){}
exec function DebugVis(bool bDebugVis){}
exec function DebugIK(bool bDebugIK){}
exec function DebugHandIK(){}
exec function DebugFracDestruction(){}
exec function Help(optional string tok){}
exec function WhereIs(string ActorName){}
exec function RebuildBVs(){}
// Export UXComCheatManager::execSetFOWFVBlurKernel(FFrame&, void* const)
native exec function SetFOWFVBlurKernel(int iBlurKernelSize);

// Export UXComCheatManager::execSetPPIgnoreIndex(FFrame&, void* const)
native exec function SetPPIgnoreIndex(int iIndex);

// Export UXComCheatManager::execSetDisplayGamma(FFrame&, void* const)
native exec function SetDisplayGamma(float fGamma);

// Export UXComCheatManager::execSetGammaColorOverlay(FFrame&, void* const)
native exec function SetGammaColorOverlay(float R, float G, float B);

// Export UXComCheatManager::execSetGammaColorScale(FFrame&, void* const)
native exec function SetGammaColorScale(float R, float G, float B);

// Export UXComCheatManager::execToggleDynamicColorSwitch(FFrame&, void* const)
native exec function ToggleDynamicColorSwitch();

// Export UXComCheatManager::execDumpSkelPoseUpdaters(FFrame&, void* const)
native exec function DumpSkelPoseUpdaters();

exec function SetFOWHaveSeen(float X){}
exec function SetFOWNeverSeen(float X){}
exec function SpawnWeather(){}
exec function ToggleCascadeRestriction();
exec function ParticleInfo(){}
exec function ToggleLightDebug(){}
exec function TogglePostProcess(optional int iIndex){}
exec function SetMLAAMode(int ModeIndex){}
exec function debugglamcam(){}
exec function showcamcage(optional string strCommand){}
exec function forceglamcam(string strGlamCamName){}
exec function setglamblend(bool bUseGlamBlend){}
exec function SetCinematicMode(optional string strCommand){}
exec function setglamcam(optional string strCommand){}
exec function setaiglamcam(optional string strCommand){}
exec function superspree(optional string strCommand){}
exec function setstrategyfacilitiessuperspree(optional string strCommand){}
exec function setstrategyfacilitiesunlockall(optional string strCommand){}
exec function setstrategyfacilitiesfree(optional string strCommand){}
exec function setstrategyfacilitiesinstantbuild(optional string strCommand){}
exec function setnoweaponsclass(optional string strCommand){}
exec function setnoweaponstech(optional string strCommand){}
exec function SetPPVignette(string strCommand){}
exec function MedScoutRevealBink(){}
exec function SetWeapon(class<XGWeapon> WeaponClass, optional int UnitIndex){}
function FunctionToGetRidOfCompilerWarning(bool bHide);
exec function DebugBuilding(optional string Cmd, optional int Floor){}
exec function WhatsOnMyFloors(optional int FloorWeCareAbout, optional class<Actor> ActorClass){}
exec function WhatAreMyFloors(){}
function Vector GetCursorLoc(optional bool bValidate){}
function TeleportTo(Vector vLoc){}
exec function TeleportToCursor(){}
exec function TTC(){}
exec function TATC(){}
exec function TeleportAllToCursor(){}
function HelpDESC(string func, string Description){}
function OutputMsg(string msg){}
exec function ToggleDebugMenu(){}
exec function CheckDebugMenu(){}
exec function EnableDebugMenu(){}
exec function DisableDebugMenu(){}
exec function ToggleVisDebug(){}
exec function PrintDebugInfo(class<Actor> ActorClass);
exec function PDI(class<Actor> ActorClass){}
exec function ToggleUnitOutline(){}
exec function ToggleFOW(optional string strCommand){}
exec function SetFOW(bool Value){}
exec function TriggerFlash(){}
exec function ToggleRain(){}
exec function RainRateScale(float fScale){}
exec function SetStormIntensity(int iLvl){}
exec function TimeOfDaySet(){}
exec function ToggleWet(bool bWet){}

// Export UXComCheatManager::execGlobalMemUsage(FFrame&, void* const)
native exec function GlobalMemUsage();

// Export UXComCheatManager::execGetChangelists(FFrame&, void* const)
native exec function string GetChangelists();

// Export UXComCheatManager::execSingleStep(FFrame&, void* const)
native exec function SingleStep(float fDeltaTime);

// Export UXComCheatManager::execSingleStepAdvance(FFrame&, void* const)
native exec function SingleStepAdvance();

// Export UXComCheatManager::execCursorModeToggle(FFrame&, void* const)
native exec function CursorModeToggle();

exec function Changelist(){}
exec function PlayBink(string MovieName){}
exec function ForceDLEOnDestructibleActors(){}
exec function DebugTileCache(bool bShow){}
exec function KillSquad(){}
exec function killaliens(optional bool bAllButOne, optional string AlienName){}
exec function CaptureAndKillAliens(int iNumCapture){}
exec function WinHQAssault(){}
exec function WinCovertOps(){}
exec function EnablePostProcessEffect(name EffectName, bool bEnable){}
exec function SimCombat(){}
function XGUnit GetUnitByName(name unitName){}
exec function ToggleDebugVisibilityToCursor(optional name unitName){}
function TestGenericVisibilityCallback(){}
exec function TestGenericVisibility(){}
exec function UIListScreens(){}
exec function UIToggleVisibility(){}
exec function UIToggleHardHide(){}
exec function UIToggleAnchors(){}
exec function UIToggleSafearea(){}
exec function UIToggleMouseHitDebugging(){}
exec function UIStatus(){}
exec function UIToggleMouseCursor(){}
exec function UIToggleShields(){}
exec function UIToggleAbortBox(){}
exec function UIToggleTether(){}
exec function UIPrintStateStack(){}
exec function UIPrintInputStack(){}
exec function UIForceClearAllUIToHUD(){}
exec function gfx(string Cmd, optional string Value){}
exec function SetGrenadePrevisTimeStep(float fTimeStep){}
exec function SetPathPrevisTimeStep(float fTimeStep){}
exec function SetPathHeightOffset(float fHeight){}
exec function SetPathLengthOffset(int iOffset){}
exec function resetammo(){}
exec function emptyammo(){}
exec function halfammo(){}
exec function criticallywound(){}
exec function resetactions(){}
exec function resetUnitMovement(){}
exec function UITestScreen(){}
exec function Jetpack(){}
exec function DebugCC(){}
exec function DebugPrintMPData(){}
exec function DebugPrintLastMatchInfo();
exec function DebugPrintLocalPRI();
exec function OSSReadFriends(){}
function OSSOnFriendsReadComplete(bool bWasSuccessful){}
exec function OSSCreatePrivateVersusGame(){}
function OSSOnCreatePrivateVersusGameComplete(name SessionName, bool bWasSuccessful){}
function OnDestroyOnlineGameCompleteCreatePrivateVersusGame(name SessionName, bool bWasSuccessful){}
exec function OSSCreateLANVersusGame(){}
function OSSOnCreateLANVersusGameComplete(name SessionName, bool bWasSuccessful){}
function OnDestroyOnlineGameCompleteCreateLANGame(name SessionName, bool bWasSuccessful){}
exec function OSSInviteFriendToGame(string strFriendName){}
exec function OSSJoinInviteGame(string strFriendName){}
exec function OSSFind(){}
exec function OSSJoin(int iGameIndex){}
exec function OSSInfo(){}
exec function OSSGetGameSettings(string strSessionName){}
exec function OSSUpdateGameSettingsToPrivate(){}
function OnUpdateOnlineSettingsToPrivateComplete(name SessionName, bool bWasSuccessful){}
exec function OSSUpdateGameSettingsToPublic(){}
function OnUpdateOnlineSettingsToPublicComplete(name SessionName, bool bWasSuccessful){}
exec function StatsTestWrite(int iTestInt, int iTestRating){}
exec function StatsTestRead(){}
private final function StatsTestOnReadComplete(bool bWasSuccessful){}

// Export UXComCheatManager::execIsInMarketingMode(FFrame&, void* const)
native function bool IsInMarketingMode();

// Export UXComCheatManager::execSetMarketingMode(FFrame&, void* const)
native function SetMarketingMode(bool bEnable);

// Export UXComCheatManager::execSetOverallTextureStreamingBias(FFrame&, void* const)
native exec function SetOverallTextureStreamingBias(optional float Bias);

exec function marketing(){}
exec function marketingAltr(){}
exec function PingMCP(){}
function OnPingMCPComplete(bool bWasSuccessful, EOnlineEventType EventType){}

native exec function SetSeedOverride(int iSeed);

exec function SetAnimLODRate(int FrameRate){}
exec function SetAnimLODDist(float DistFactor){}
exec function TickAnimNodesWhenNotRendered(bool bValue){}
exec function UpdateSkelWhenNotRendered(bool bValue){}
exec function SkelMeshesIgnoreControllersWhenNotRendered(bool bValue){}
exec function AllowSetAnimPositionWhenNotRendered(bool bValue){}
