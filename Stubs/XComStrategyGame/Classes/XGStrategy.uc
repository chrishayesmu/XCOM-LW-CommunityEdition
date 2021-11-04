class XGStrategy extends XGStrategyActor
    config(GameData)
	notplaceable;

struct CheckpointRecord
{
    var XGHeadQuarters m_kHQ;
    var XGGeoscape m_kGeoscape;
    var XGWorld m_kWorld;
    var XGStrategyAI m_kAI;
    var XGRecapSaveData m_kRecapSaveData;
    var XGSetupPhaseManager m_kSetupPhaseManager;
    var XGExaltSimulation m_kExaltSimulation;
    var int m_iDifficulty;
    var int m_iLowestDifficulty;
    var bool m_bDebugStart;
    var array<int> m_arrMissionTotals;
    var XGNarrative m_kNarrative;
    var array<int> m_arrItemUnlocks;
    var array<int> m_arrFacilityUnlocks;
    var array<int> m_arrFoundryUnlocks;
    var bool m_bTutorial;
    var bool m_bMeldTutorial;
    var bool m_bLost;
    var bool m_bOvermindEnabled;
    var bool m_bIronMan;
    var bool m_bControlledStart;
    var XGMission_FundingCouncil m_kTutorialMission;
    var float m_fGameDuration;
    var bool m_bPlayedTutorial;
    var bool m_bCompletedFirstMec;
    var bool m_bUsedEEC;
    var array<int> m_arrSecondWave;
};

var const localized string m_strNewItemAvailable;
var const localized string m_strNewItemHelp;
var const localized string m_strNewFacilityAvailable;
var const localized string m_strNewFacilityHelp;
var const localized string m_strNewFoundryAvailable;
var const localized string m_strNewFoundryHelp;
var XGHeadQuarters m_kHQ;
var XGGeoscape m_kGeoscape;
var XGWorld m_kWorld;
var XGStrategyAI m_kAI;
var XGRecapSaveData m_kRecapSaveData;
var XGSetupPhaseManager m_kSetupPhaseManager;
var XGExaltSimulation m_kExaltSimulation;
var int m_iDifficulty;
var int m_iLowestDifficulty;
var bool m_bDebugStart;
var bool m_bTutorial;
var bool m_bMeldTutorial;
var bool m_bLost;
var bool m_bGameOver;
var bool m_bOvermindEnabled;
var bool m_bIronMan;
var bool m_bControlledStart;
var bool m_bShowRecommendations;
var bool m_bPlayedTutorial;
var bool m_bCompletedFirstMec;
var bool m_bUsedEEC;
var bool m_bLoadedFromSave;
var array<int> m_arrMissionTotals;
var XGNarrative m_kNarrative;
var array<int> m_arrItemUnlocks;
var array<int> m_arrGeneModUnlocks;
var array<int> m_arrFacilityUnlocks;
var array<int> m_arrFoundryUnlocks;
var XGMission_FundingCouncil m_kTutorialMission;
var float m_fGameDuration;
var array<int> m_arrSecondWave;
var StrategyGameTransport m_kStrategyTransport;

function NewGame(){}
function XGRecapSaveData GetRecapSaveData(){}
function Init(bool bLoadingFromSave){}
function OnLoadedGame(){}
function PostLoadSaveGame(){}
function NotifyUserOfInvalidSave(){}
function Uninit(){}
function XGHeadQuarters GetHQ(){}
function XGGeoscape GetGeoscape(){}
function XGStrategyAI GetAI(){}
function XGWorld GetWorld(){}
function StartNewGame(){}
function int CheckForLoseGame(){}
function InitDifficulty(int iDifficulty){}
function ChangeDifficulty(int iNewDifficulty){}
function int GetDifficulty(){}
function int GetDiffBalance(){}
function GoToHQ(){}
function bool AreDropshipSoldiersStillLoading(){}
function GoToTutorial(){}
function PostTutorial(XGMission_FundingCouncil kTutorial){}
function string RecordMissionResult(){}
function bool PostCombat(XGMission kMission){}
function PlayFinalCinematic(){}
function SendSoldierToFinalCinematic(){}
function PostFinalCinematic(){}
function PostMatinee(){}
function int GetNumMissionsTaken(optional int iMissionType){}
function BeginCombat(XGMission kMission){}
function DeferredLaunchCommand(){}
function bool UnlockItem(EItemType eItem, out TItemUnlock kUnlock){}
function bool UnlockFacility(EFacilityType eFacility, out TItemUnlock kUnlock){}
function bool UnlockFoundryProject(EFoundryTech eProject, out TItemUnlock kUnlock){}
function bool UnlockGeneMod(EGeneModTech eGene, out TItemUnlock kUnlock){}
function bool UnlockMechArmor(EItemType eArmor, out TItemUnlock kUnlock){}
function int GetAct(){}
function EMusicCue GetActMusic(){}
function int GetDays(){}
function YouLose(){}
function YouWin(){}
function int CalcTotalScore(){}
function int CalcCombatScore(){}
function int CalcScienceScore(){}
function int CalcEngineeringScore(){}
function int CalcResourcesScore(){}
function int CalcInterceptionScore(){}
function string GetTip(ETipTypes eTip){}

state Initing{}
state Headquarters{
    event BeginState(name nmPrevState){}
    event EndState(name nmNextState){}
}
state StartingNewGame{
    function CheckForSecondWave(){}
    function DebugStuff(){}
}
state AlienBaseVictory{}
state AlienBaseVictoryPostMatinee{}
state LoadingFromCombat{
	function LoadCombatResults();
}

