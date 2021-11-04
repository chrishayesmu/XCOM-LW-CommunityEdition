class UIBriefing extends UI_FxsScreen
    hidecategories(Navigation);

struct TBriefingInfo
{
    var string strOpName;
    var string strLocation;
    var string strMissionType;
    var string strSituation;
    var string strObjective;
    var string strTip;
    var string strMapName;

    structdefaultproperties
    {
        strOpName=""
        strLocation=""
        strMissionType=""
        strSituation=""
        strObjective=""
        strTip=""
        strMapName=""
    }
};

var string m_strCameraTag;
var name DisplayTag;
var private bool bMapLoaded;
var private XGMission m_kMission;
var const localized string m_strLabelObjectives;
var const localized string m_strLabelSituation;
var const localized string m_strLabelLoading;
var const localized string m_strToLaunchMission;
var const localized string m_strToLaunchMissionPC;
var TextureMovie TutorialMovie;
var XComDropshipAudioMgr MissionAudioMgr;
var XGSetupPhaseManager kPhaseManager;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, XGMission kMission){}
simulated function OnInit(){}
simulated function CheckForStartBriefing(){}
simulated function StartBriefing(){}
function PlayCountryNarrativeMoment(){}
function OnCountryNarrativeMomentFinished(){}
function PlayMissionNarrativeMoment(){}
function RefSetupPhaseMgr(){}
function SetupIntroBink(){}
function OnLoadedMaterial(Object LoadedArchetype){}
function OnMovieLoaded(Object LoadedArchetype){}
function CheckLoadingMovieDone(){}
function MovieDone(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool OnAccept(optional string Str){}
final simulated function AS_SetMissionInfo(string operationName, string locDesc){}
final simulated function AS_SetIntel(string Label, string Desc){}
final simulated function AS_SetObjectives(string Label, string Desc){}
final simulated function AS_SetLoadingMessage(string Label, int State){}
simulated function SetTip(string Label){}
final simulated function AS_SetTip(string Label){}
final simulated function AS_SetImage(string Path){}
simulated function OnMapLoaded(){}


DefaultProperties
{
}
