class UITellMeMore extends UI_FxsShellScreen
    config(GameData)
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complet stub

enum ECategoryTMM
{
    Category_Barracks,
    Category_Science,
    Category_MissionControl,
    Category_SituationRoom,
    Category_Engineering,
    Category_Hangar,
    Category_MAX
};

struct TItemData
{
    var ECategoryTMM Category;
    var string Label;
    var string Desc;
    var string imgPath;
    var string Sound;
};

struct TSection
{
    var string Label;
    var string imgPath;
    var bool bClosed;
    var array<TItemData> Items;
};

struct UIOption
{
    var int iIndex;
    var string strLabel;
    var string strDesc;
    var string strImgPath;
    var string soundPath;
    var int iState;
    var string strHelp;
    var int sectionIdx;
};

var const localized string m_strTellMeMoreSelectTitle;
var int m_iCurrentSelection;
var int m_iPlayedSelection;
var array<UIOption> m_arrUIOptions;
var int m_iView;
var config array<config TItemData> TellMeMoreItems;
var config array<config TSection> Sections;
var XComHeadquartersInput HQINPUT;
var XComNarrativeMoment ItemNarrative;
var bool m_bOldDisableAccept;
var bool m_bOldDisableCancel;
var bool m_bOldDisableLeftStick;
var bool m_bOldDisableRightStick;
var bool m_bOldDisableDPad;
var bool m_bOldDisableBumpers;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateData(){}
simulated function UpdateLayout(){}
simulated function AS_AddOption(int iIndex, string sLabel, int iState){}
simulated function AS_ClearList(){}
simulated function GoToView(int iView){}
simulated function bool OnAccept(optional string Str){}
function OnLoadedItemAudio(Object LoadedArchetype){}
function OnNarrativeComplete(){}
simulated event ModifyHearSoundComponent(AudioComponent AC){}
simulated function bool OnCancel(optional string Str){}
simulated function SetCategory(ECategoryTMM eCategory, optional bool bCollapseAll){}
simulated function UpdateInfoPanelData(int iItemIndex){}
simulated function AS_UpdateInfo(string topicName, string descText, string imgPath){}
simulated function AS_SetTitle(string displayString){}
simulated function AS_SetBackButtonText(string buttonText){}
simulated function AS_SetAudioButtonText(string buttonText){}
simulated function RealizeSelected(){}
