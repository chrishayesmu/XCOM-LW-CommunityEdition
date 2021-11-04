class UIContinentSelect extends UI_FxsScreen
    implements(IScreenMgrInterface);
//complete stub
var const localized string m_strAccept;
var XGContinentUI m_kLocalMgr;
var int m_iContinent;
var int maxContinents;
var int m_iView;
var array<UIOption> m_arrUIOptions;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, int iView){}
simulated function XGContinentUI GetMgr(){}
simulated function OnInit(){}
function OnMusicLoaded(Object LoadedObject){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateData(){}
simulated function UpdateLayout(){}
simulated function AS_AddOption(int iIndex, string sLabel, int iState){}
simulated function GoToView(int iView){}
simulated function bool OnAccept(optional string Str){}
simulated function bool OnCancel(optional string Str){}
function RequestExit(){}
simulated function UpdateInfoPanelData(int iContinent){}
simulated function AS_SetBar(int Index, string frameLabel, float Percent, string Title, string Val){}
simulated function AS_UpdateInfo(string continentName, string bonusName, string infoText){}
simulated function AS_SetTitle(string displayString){}
simulated function AS_SetAcceptButton(string Text, string iconLabel){}
simulated function AS_SetBackButton(string Text, string iconLabel){}
simulated function RealizeSelected(){}
function UnlockItems(array<TItemUnlock> arrUnlocks);
function UnlockItem(TItemUnlock kUnlock);

