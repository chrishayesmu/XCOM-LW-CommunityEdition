class XGChooseSquadUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

enum EChooseSquadView
{
    eCSView_Main,
    eCSView_ChooseSoldier,
    eCSView_MAX
};

struct TMissionHeader
{
    var TText txtOpName;
    var TText txtLocation;
    var TText txtMissionType;
    var TText txtTime;
};

struct TBarracksTable
{
    var TTableMenu mnuBarracks;
};

struct TSoldierLoadout
{
    var TText txtName;
    var TText txtNickname;
    var TText txtClass;
    var int ClassType;
    var int item1;
    var int item2;
    var TImage imgFlag;
    var int iUIStatus;
    var int iDropshipIndex;
    var bool bPromotable;
    var bool bIsPsiSoldier;
    var bool bHasGeneMod;
};

var TMissionHeader m_kHeader;
var TBarracksTable m_kBarracksTable;
var array<TSoldierLoadout> m_arrSoldiers;
var TButtonText m_txtLaunch;
var int m_iHighlightedSoldier;
var int m_iWorkingSlot;
var TButtonBar m_kButtonBar;
var TImage m_imgBG;
var XGShip_Dropship m_kSkyranger;
var TLabeledText m_ltxtObjective;
var XGMission m_kMission;
var bool m_bWarnedNoSoldiers;
var const localized string m_strLabelAim;
var const localized string m_strLabelHP;
var const localized string m_strLabelMove;
var const localized string m_strLabelLaunchMission;
var const localized string m_strChangeSoldier;
var const localized string m_strLabelEditLoadout;
var const localized string m_strLabelBackToBriefing;
var const localized string m_strLabelSimMission[13];
var const localized string m_strLabelLoadUnload;
var const localized string m_strLabelSquadSelection;
var const localized string m_strAddSoldier;
var const localized string m_strOTSHelp1;
var const localized string m_strOTSHelp2;
var const localized string m_strCurrObj;

function Init(int iView){}
function bool CanLaunchMisison(){}
function bool OnLaunchMission(){}
function CutToBlack(){}
function FadeBackIn(){}
function OnCancelSquadSelection(){}
function StripGearArmory(){}
function OnChangeSoldier(int SlotIdx){}
function OnNextSoldier(){}
function OnPrevSoldier(){}
function SetHighlightedSoldier(int iTargetSoldierIndex){}
function bool OnUnloadSoldier(int iSoldier, int SlotIdx){}
function bool OnLoadSoldier(int iSoldier){}
function OnCancelEdit(){}
function OnInventory(){}
function UpdateView(){}
function UpdateHeader(){}
function UpdateObjective(){}
function int GetSoldierInSlot(int iSquadSlot){}
function UpdateSquad(){}
function CheckSoldiersLoaded(){}
event Destroyed(){}
function TSoldierLoadout BuildLoadout(XGStrategySoldier kSoldier, int iDropshipIndex){}
function UpdateBarracksTable(){}
function TTableMenuOption BuildSoldierOption(XGStrategySoldier kSoldier, array<int> arrCategories){}
function bool AreAnyChosenMecsWearingCivvies(){}
function UpdateLaunchButton(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}

state LaunchingMission{}

defaultproperties
{
    m_iWorkingSlot=-1
}