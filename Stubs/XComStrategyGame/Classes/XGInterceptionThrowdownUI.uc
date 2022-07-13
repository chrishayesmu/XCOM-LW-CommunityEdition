class XGInterceptionThrowdownUI extends XGScreenMgr
    config(GameData);

enum EThrowdownView
{
    eThrowdownView_MainMenu,
    eThrowdownView_Throwdown,
    eThrowdownView_MAX
};

var TText m_txtTitle;
var TButtonText m_buttonFight;
var TButtonText m_buttonChangeUFO;
var array<TButtonText> m_abuttonInterceptors;
var array<TButtonText> m_abuttonInterceptorWeapons;
var int m_iUFO;
var array<int> m_aiInterceptors;
var array<int> m_aiInterceptorWeapon;
var int m_iSelectedInterceptor;
var array<int> m_aiPrevConsumables;
var XGInterception m_kInterception;
var const localized string m_strInterceptionThrowDown;
var const localized string m_strLabelFight;
var const localized string m_strLabelNone;
var const localized string m_strShipInterceptor;
var const localized string m_strShipFirestorm;

function Init(int iView){}
function name GetViewState(int iView){}
function UpdateView(){}
function UpdateInterceptorRow(int iRow){}
function UpdateInterceptorRows(){}
function UpdateMainMenu(){}
function UpdateThrowdown(){}
function SetupInterception(){}
function NextUFO(){}
function CycleInterceptor(){}
function CycleWeapon(){}
function int GetNumInterceptors(){}
function int GetNumInterceptorSlots(){}
function StartThrowdown(){}
function OnLeaveThrowdown(){}
function OnNextUFO(){}
function OnNextInterceptor(){}
function OnPrevInterceptor(){}
function OnCycleInterceptor(){}
function OnCycleWeapon(){}
simulated function OnDeactivate(){}