class XGInterceptionUI extends XGScreenMgr
    config(GameData);
//complete stub

enum EIView
{
    eIntView_JetSelection,
    eIntView_MAX
};

struct TIntHeader
{
    var TText txtTitle;
};

struct TIntTarget
{
    var TText txtTitle;
    var TText txtDescription;
    var TLabeledText txtSize;
    var TImage imgTarget;
    var TLabeledText txtSpeed;
};

struct TIntJet
{
    var EShipType EShipType;
    var TText txtJetName;
    var TText txtPilotCallsign;
    var TLabeledText txtMissions;
    var TLabeledText txtOffense;
    var TLabeledText txtDefense;
    var TLabeledText txtSpeed;
    var TText txtDistance;
    var TText txtStatus;
    var int iState;
    var bool bHighlighted;
    var int iIndex;

};

struct TIntLaunchButton
{
    var int iState;
    var TButtonText txtTitle;

};

struct TIntSquadron
{
    var array<TIntJet> arrJets;
    var TText txtTitle;
};

struct TIntDistance
{
    var XGShip_Interceptor kInterceptor;
    var int iMiles;
    var bool bOutOfRange;

};

var TIntHeader m_kHeader;
var TIntSquadron m_kSquadron;
var TIntLaunchButton m_kLaunch;
var TButtonBar m_kButtonBar;
var array<TIntDistance> m_akIntDistance;
var XGInterception m_kInterception;
var TIntTarget m_kTarget;
var int m_iCurrentJet;
var TImage m_imgBG;
var XGShip_UFO m_kUFO;
var const localized string m_strLabelSize;
var const localized string m_strLabelSpeed;
var const localized string m_strLabelShipOverRegion;
var const localized string m_strLabelChooseInterceptors;
var const localized string m_strLabelLoadout;
var const localized string m_strLabelMaxSpeed;
var const localized string m_strLabelOutOfRange;
var const localized string m_strLabelThinkMilesAway;
var const localized string m_strLabelLaunchFighters;
var const localized string m_strLabelLaunchFightersPC;
var const localized string m_strLabelSelDeselFighter;
var const localized string m_strLabelCancelInterception;

function int IntDistanceSort(TIntDistance A, TIntDistance B){}
function BuildInterceptorList(){}
function Init(int iView){}
function UpdateView(){}
function OnCursorLeft(){}
function OnCursorRight(){}
function OnChooseJet(){}
function OnLeaveJetSelection(){}
function OnLaunch(){}
function UpdateHeader(){}
function UpdateCurrentTarget(){}
function UpdateSquadron(){}
function UpdateLaunchButton(){}
function UpdateButtonHelp(){}
